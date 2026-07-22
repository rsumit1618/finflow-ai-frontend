import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A custom Interceptor that logs network requests and responses in a beautified JSON format.
/// 
/// Shows only essential details: URL, Method, Request Data, and Response Data.
class PrettyDioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('\n--- 🚀 API REQUEST ---');
    debugPrint('URL: [${options.method}] ${options.uri}');
    if (options.data != null) {
      debugPrint('Request Data: ${_beautifyJson(options.data)}');
    }
    debugPrint('----------------------\n');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('\n--- ✅ API RESPONSE ---');
    debugPrint('URL: [${response.requestOptions.method}] ${response.requestOptions.uri}');
    debugPrint('Status: ${response.statusCode} ${response.statusMessage}');
    debugPrint('Response Data: ${_beautifyJson(response.data)}');
    debugPrint('-----------------------\n');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('\n--- ❌ API ERROR ---');
    debugPrint('URL: [${err.requestOptions.method}] ${err.requestOptions.uri}');
    debugPrint('Status: ${err.response?.statusCode} ${err.response?.statusMessage}');
    if (err.response?.data != null) {
      debugPrint('Error Data: ${_beautifyJson(err.response?.data)}');
    } else {
      debugPrint('Message: ${err.message}');
    }
    debugPrint('--------------------\n');
    return handler.next(err);
  }

  String _beautifyJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (e) {
      return data.toString();
    }
  }
}
