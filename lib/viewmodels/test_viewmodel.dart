import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

class TestViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoading = false;
  bool _rateLimitEnabled = true;
  int _callCount = 10;
  String _response = '';

  bool get isLoading => _isLoading;
  bool get rateLimitEnabled => _rateLimitEnabled;
  int get callCount => _callCount;
  String get response => _response;

  void toggleRateLimit(bool value) {
    if (_isLoading) return;  // ✅ Don't allow toggle while loading
    _rateLimitEnabled = value;
    _response = '';  // ✅ Clear response on toggle
    notifyListeners();
  }

  void setCallCount(int value) {
    if (_isLoading) return;  // ✅ Don't allow change while loading
    _callCount = value;
    _response = '';  // ✅ Clear response on change
    notifyListeners();
  }

  void clearResponse() {
    if (_isLoading) return;
    _response = '';
    notifyListeners();
  }

  Future<void> callApi() async {
    if (_isLoading) return;

    _setLoading(true);
    _response = '⏳ Calling $_callCount API calls...';

    try {
      final result = await _api.testHttpApi(
        _callCount,
        bypass: !_rateLimitEnabled,
      );

      final logs = (result['logs'] as List<String>).join('\n');
      _response = '''
✅ Success: ${result['success']}
❌ Failure: ${result['failure']}
⏱️ Avg: ${result['avgResponseTime']}ms
📊 Total Time: ${result['totalTime']}ms
📈 Total: ${result['total']}

--- Logs ---
$logs
''';
    } catch (e) {
      _response = '❌ Error: $e';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}