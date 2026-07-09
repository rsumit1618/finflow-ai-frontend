import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/test_viewmodel.dart';
import '../core/constants/app_constants.dart';

class HttpTestScreen extends StatefulWidget {
  const HttpTestScreen({Key? key}) : super(key: key);

  @override
  State<HttpTestScreen> createState() => _HttpTestScreenState();
}

class _HttpTestScreenState extends State<HttpTestScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TestViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌐 HTTP Test'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.cloud_upload,
                          color: Colors.deepPurple,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'API Test',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${AppConstants.baseUrl}/api/health',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: viewModel.isLoading ? Colors.orange : Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          viewModel.isLoading ? '⏳ Running' : '⚡ Ready',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Call Count Slider
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '📊 Call Count',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${viewModel.callCount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: viewModel.callCount.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: Colors.deepPurple,
                        inactiveColor: Colors.grey.shade300,
                        onChanged: viewModel.isLoading
                            ? null
                            : (value) {
                          viewModel.setCallCount(value.round());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Rate Limit Toggle
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  title: const Text(
                    '🛡️ Rate Limit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    viewModel.rateLimitEnabled
                        ? 'Limited (${viewModel.callCount < 3 ? viewModel.callCount : 2} success expected)'
                        : 'Unlimited (all ${viewModel.callCount} calls pass)',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  value: viewModel.rateLimitEnabled,
                  onChanged: viewModel.isLoading ? null : (value) {
                    viewModel.toggleRateLimit(value);
                  },
                  activeColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.callApi(),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        viewModel.rateLimitEnabled ? 'Test Limited' : 'Test Bypass',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: viewModel.rateLimitEnabled
                            ? Colors.orange
                            : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.clearResponse(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Indicator
              if (viewModel.isLoading) ...[
                const LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 8),
                Text(
                  '⏳ Running ${viewModel.callCount} calls... Please wait',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Response Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: SingleChildScrollView(
                    child: Text(
                      viewModel.response.isEmpty
                          ? '🔽 Press the button above to call API'
                          : viewModel.response,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 12,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${viewModel.callCount} calls · ${viewModel.rateLimitEnabled ? "Limited" : "Bypass"}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}