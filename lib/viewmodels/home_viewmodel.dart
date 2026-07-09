import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import 'dart:convert';

class HomeViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoading = false;
  int _successCount = 0;
  int _failureCount = 0;
  int _avgTime = 0;
  String _result = '';
  String _debugInfo = '';
  String _fullLogs = '';

  bool _rateLimitEnabled = true;

  bool get isLoading => _isLoading;
  int get successCount => _successCount;
  int get failureCount => _failureCount;
  int get avgTime => _avgTime;
  String get result => _result;
  String get debugInfo => _debugInfo;
  String get fullLogs => _fullLogs;
  bool get rateLimitEnabled => _rateLimitEnabled;

  void clearStats() {
    _successCount = 0;
    _failureCount = 0;
    _avgTime = 0;
    _result = '';
    _debugInfo = '';
    notifyListeners();
  }

  void clearLogs() {
    _fullLogs = '';
    notifyListeners();
  }

  void toggleRateLimit(bool value) {
    _rateLimitEnabled = value;
    notifyListeners();
  }

  void _addLog(String log) {
    _fullLogs += '\n$log';
    notifyListeners();
  }

  Future<void> callSingleApi() async {
    _reset();
    _setLoading(true);
    _addLog('📡 GET /api/auth/profile (Single API)');
    _addLog('⏳ Calling...');

    final result = await _api.callApi();

    if (result['success']) {
      _successCount = 1;
      _result = '✅ Response:\n${_formatJson(result['data'])}';
      _avgTime = result['duration'] ?? 0;
      _addLog('✅ Success | ${result['duration']}ms');
      _addLog('📦 ${_formatJson(result['data'])}');
    } else {
      _failureCount = 1;
      _result = '❌ Error: ${result['message']}';
      _addLog('❌ Error: ${result['message']}');
    }
    _debugInfo = result.toString();
    _setLoading(false);
  }

  Future<void> testPerformance(int count) async {
    _reset();
    _setLoading(true);
    _addLog('🔥 Sequential $count API calls (Rate Limit: ${_rateLimitEnabled ? "ON" : "OFF"})');
    _addLog('⏳ Running...');

    try {
      // ✅ FIX: Use testPerformanceParallel with bypass
      final result = await _api.testPerformanceParallel(count, bypass: !_rateLimitEnabled).timeout(
        const Duration(seconds: 300),
        onTimeout: () {
          return {
            'success': 0,
            'failure': count,
            'avgResponseTime': 0,
            'total': count,
            'errors': ['Timeout after 300 seconds']
          };
        },
      );

      _successCount = result['success'] ?? 0;
      _failureCount = result['failure'] ?? 0;
      _avgTime = result['avgResponseTime'] ?? 0;
      _result = '✅ Success: ${result['success']}\n'
          '❌ Failure: ${result['failure']}\n'
          '⏱️ Avg: ${result['avgResponseTime']}ms\n'
          '📊 Total: ${result['total']}';
      _debugInfo = result['errors']?.join('\n') ?? '';

      _addLog('✅ Done | Success: ${result['success']} | Fail: ${result['failure']} | Avg: ${result['avgResponseTime']}ms');
    } catch (e) {
      _result = '❌ Error: $e';
      _failureCount = count;
      _debugInfo = e.toString();
      _addLog('❌ Error: $e');
    }

    _setLoading(false);
  }

  Future<void> testPerformanceParallel(int count, {bool bypass = false}) async {
    _reset();
    _setLoading(true);
    _addLog('⚡ Parallel $count API calls (Bypass: ${bypass ? "YES" : "NO"})');
    _addLog('⏳ Running...');

    try {
      final result = await _api.testPerformanceParallel(count, bypass: bypass).timeout(
        const Duration(seconds: 300),
        onTimeout: () {
          return {
            'success': 0,
            'failure': count,
            'avgResponseTime': 0,
            'total': count,
            'errors': ['Timeout after 300 seconds']
          };
        },
      );

      _successCount = result['success'] ?? 0;
      _failureCount = result['failure'] ?? 0;
      _avgTime = result['avgResponseTime'] ?? 0;
      _result = '✅ Success: ${result['success']}\n'
          '❌ Failure: ${result['failure']}\n'
          '⏱️ Avg: ${result['avgResponseTime']}ms\n'
          '📊 Total: ${result['total']}';
      _debugInfo = result['errors']?.join('\n') ?? '';

      _addLog('✅ Done | Success: ${result['success']} | Fail: ${result['failure']} | Avg: ${result['avgResponseTime']}ms');
    } catch (e) {
      _result = '❌ Error: $e';
      _failureCount = count;
      _debugInfo = e.toString();
      _addLog('❌ Error: $e');
    }

    _setLoading(false);
  }

  Future<void> test500Error() async {
    _reset();
    _setLoading(true);
    _addLog('💥 Testing 500 Error (Sentry)');
    _addLog('⏳ Calling /force-error...');

    try {
      final result = await _api.test500Error();
      if (result['success']) {
        _result = '✅ Response:\n${_formatJson(result['data'])}';
        _addLog('✅ Success | Status: ${result['statusCode']}');
        _addLog('📦 ${_formatJson(result['data'])}');
      } else {
        _result = '❌ 500 Error: ${result['message']}\n'
            'Status Code: ${result['statusCode']}';
        _addLog('❌ Error | Status: ${result['statusCode']} | ${result['message']}');
      }
      _debugInfo = result.toString();
    } catch (e) {
      _result = '❌ Error: $e';
      _addLog('❌ Error: $e');
    }

    _setLoading(false);
  }

  String _formatJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  void _reset() {
    _successCount = 0;
    _failureCount = 0;
    _avgTime = 0;
    _result = '';
    _debugInfo = '';
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}