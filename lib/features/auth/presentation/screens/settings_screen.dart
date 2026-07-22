import 'package:flutter/material.dart';
import 'package:finflow_app/features/auth/presentation/widgets/settings_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: const SettingsWidget(),
    );
  }
}
