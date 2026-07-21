import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:finflow_app/core/common/constants/api_constants.dart';
import 'package:finflow_app/core/infrastructure/storage/secure_storage.dart';
import 'package:finflow_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:finflow_app/features/auth/data/models/auth_response_model.dart';
import 'package:finflow_app/features/video/data/models/video_model.dart';

/// Legacy API service. Deprecated in favor of feature-specific repositories/datasources.
@Deprecated('Use feature-specific repositories and datasources instead')
class ApiService {
  final Dio _dio = Dio();
  bool _isRefreshing = false;
  final List<QueuedRequest> _pendingRequests = [];
  final AuthLocalDataSource _localDataSource =
      AuthLocalDataSourceImpl(secureStorage: SecureStorage());

  ApiService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _localDataSource.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          if (_isRefreshing) {
            _pendingRequests.add(QueuedRequest(
              requestOptions: error.requestOptions,
              resolve: handler.resolve,
              reject: handler.reject,
            ));
            return;
          }

          _isRefreshing = true;
          _pendingRequests.add(QueuedRequest(
            requestOptions: error.requestOptions,
            resolve: handler.resolve,
            reject: handler.reject,
          ));

          try {
            final refreshToken = await _localDataSource.getRefreshToken();
            if (refreshToken != null) {
              final refreshDio =
                  Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
              final response = await refreshDio.post(
                ApiConstants.refreshToken,
                data: {'refreshToken': refreshToken},
              );

              if (response.statusCode == 200) {
                final newAccessToken = response.data['data']['accessToken'];
                final newRefreshToken = response.data['data']['refreshToken'];
                await _localDataSource.cacheTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );
                _isRefreshing = false;
                _processPendingRequests(newAccessToken);
                return;
              }
            }
          } catch (e) {
            debugPrint('Token refresh failed: $e');
          }

          await _localDataSource.clearTokens();
          _isRefreshing = false;
          _rejectAllPending('Session expired. Please login again.');
          return;
        }

        return handler.next(error);
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

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {'email': email, 'password': password},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      if (response.data['success'] == true) {
        final authData = AuthResponseModel.fromJson(response.data['data']);
        await _localDataSource.cacheTokens(
          accessToken: authData.accessToken,
          refreshToken: authData.refreshToken,
        );
      }
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    }
  }

  Future<void> logout() async {
    await _localDataSource.clearTokens();
  }

  // ============================================================
  // VIDEO UPLOAD
  // ============================================================

  Future<Map<String, dynamic>> uploadVideos(List<String> filePaths) async {
    try {
      final formData = FormData();
      for (var path in filePaths) {
        formData.files.add(MapEntry(
          'videos',
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }

      final response = await _dio.post(
        ApiConstants.videos,
        data: formData,
      );

      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchVideos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.videos,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final body = response.data;
      List<VideoModel> videos = (body['data']['videos'] as List)
          .map((item) => VideoModel.fromJson(item))
          .toList();

      return {
        'success': true,
        'videos': videos,
        'pagination': body['data']['pagination'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteVideo(String id) async {
    try {
      final response = await _dio.delete(ApiConstants.videoById(id));
      return {'success': true, 'message': response.data['message']};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================================
  // HTTP TEST
  // ============================================================

  Future<Map<String, dynamic>> testHttpApi(int count,
      {bool bypass = false}) async {
    int success = 0;
    int failure = 0;
    List<int> responseTimes = [];
    List<String> logs = [];

    final startTime = DateTime.now();

    for (int i = 0; i < count; i++) {
      try {
        final start = DateTime.now();

        final response = await _dio.get(
          ApiConstants.health,
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
