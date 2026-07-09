import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/auth_model.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  bool _isRefreshing = false;
  final List<QueuedRequest> _pendingRequests = [];

  ApiService() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: AppConstants.connectTimeout);
    _dio.options.receiveTimeout = Duration(seconds: AppConstants.receiveTimeout);

    if (!kIsWeb) {
      _dio.options.sendTimeout = Duration(seconds: AppConstants.receiveTimeout);
    }

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;

          _pendingRequests.add(QueuedRequest(
            requestOptions: error.requestOptions,
            resolve: handler.resolve,
            reject: handler.next,
          ));

          try {
            final refreshToken = await SecureStorage.getRefreshToken();
            if (refreshToken != null) {
              final response = await _dio.post(
                AppConstants.refresh,
                data: {'refreshToken': refreshToken},
              );
              if (response.statusCode == 200) {
                final newToken = response.data['data']['accessToken'];
                await SecureStorage.saveAccessToken(newToken);

                _isRefreshing = false;
                _processPendingRequests(newToken);
                return;
              }
            }
            await SecureStorage.clearTokens();
            _isRefreshing = false;
            _rejectAllPending('Session expired. Please login again.');
            return handler.next(error);
          } catch (e) {
            await SecureStorage.clearTokens();
            _isRefreshing = false;
            _rejectAllPending('Session expired. Please login again.');
            return handler.next(error);
          }
        }
        _isRefreshing = false;
        return handler.next(error);
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        response.extra['duration'] = DateTime.now().millisecondsSinceEpoch;
        return handler.next(response);
      },
    ));
  }

  void _processPendingRequests(String newToken) {
    for (final request in _pendingRequests) {
      request.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      _dio.fetch(request.requestOptions).then(
            (response) => request.resolve(response),
        onError: (error) => request.reject(error as DioException),
      );
    }
    _pendingRequests.clear();
  }

  void _rejectAllPending(String message) {
    for (final request in _pendingRequests) {
      request.reject(DioException(
        requestOptions: request.requestOptions,
        error: message,
        type: DioExceptionType.unknown,
      ));
    }
    _pendingRequests.clear();
  }

  // ============================================================
  // AUTH
  // ============================================================

  Future<AuthResponse> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data['message'] ?? e.message,
      );
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.login,
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.success && authResponse.tokens != null) {
        await SecureStorage.saveAccessToken(authResponse.tokens!.accessToken);
        await SecureStorage.saveRefreshToken(authResponse.tokens!.refreshToken);
      }
      return authResponse;
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data['message'] ?? e.message,
      );
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(AppConstants.profile);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearTokens();
  }

  // ============================================================
  // HTTP TEST (Used in HttpTestScreen)
  // ============================================================

  Future<Map<String, dynamic>> testHttpApi(int count, {bool bypass = false}) async {
    int success = 0;
    int failure = 0;
    List<int> responseTimes = [];
    List<String> logs = [];

    final startTime = DateTime.now();

    for (int i = 0; i < count; i++) {
      try {
        final start = DateTime.now();

        final response = await _dio.get(
          '/api/health',
          options: Options(
            headers: bypass ? {'x-bypass-rate-limit': 'true'} : {},
          ),
        );

        final end = DateTime.now();
        final duration = end.difference(start).inMilliseconds;
        responseTimes.add(duration);

        if (response.statusCode == 200) {
          success++;
          logs.add('✅ $i: ${response.statusCode} (${duration}ms)');
        } else {
          failure++;
          logs.add('❌ $i: ${response.statusCode} (${duration}ms)');
        }
      } catch (e) {
        failure++;
        logs.add('❌ $i: Error - $e');
      }
    }

    final totalTime = DateTime.now().difference(startTime).inMilliseconds;
    final avgTime = responseTimes.isNotEmpty
        ? responseTimes.reduce((a, b) => a + b) ~/ responseTimes.length
        : 0;

    return {
      'total': count,
      'success': success,
      'failure': failure,
      'avgResponseTime': avgTime,
      'totalTime': totalTime,
      'logs': logs,
    };
  }
}

// ✅ Request queue model
class QueuedRequest {
  final RequestOptions requestOptions;
  final void Function(Response<dynamic>) resolve;
  final void Function(DioException) reject;

  QueuedRequest({
    required this.requestOptions,
    required this.resolve,
    required this.reject,
  });
}