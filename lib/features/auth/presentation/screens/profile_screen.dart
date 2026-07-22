import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/common/utils/routing/app_router.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.updateProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                    child: user.profileImage == null
                        ? Text(
                            user.email[0].toUpperCase(),
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim().isEmpty ? 'Complete Your Profile' : '${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildSection('Personal Details', [
              _buildInfoRow(Icons.cake_outlined, 'Age', '${user.age ?? 'Not set'}'),
              _buildInfoRow(Icons.location_on_outlined, 'Address', user.address ?? 'Not set'),
            ]),
            const SizedBox(height: 12),
            _buildSection('Education', [
              _buildInfoRow(Icons.school_outlined, 'College', user.college ?? 'Not set'),
              _buildInfoRow(Icons.workspace_premium_outlined, 'Highest Qualification', user.highestQualification ?? 'Not set'),
              _buildInfoRow(Icons.calendar_today_outlined, 'Graduation Year', '${user.qualificationYear ?? 'Not set'}'),
            ]),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
