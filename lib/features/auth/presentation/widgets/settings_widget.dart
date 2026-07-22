import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';

class SettingsWidget extends ConsumerWidget {
  final bool isSidebar;
  final VoidCallback? onClose;

  const SettingsWidget({
    super.key,
    this.isSidebar = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: isSidebar ? 320 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: isSidebar ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(-5, 0),
          )
        ] : null,
        border: isSidebar ? Border(left: BorderSide(color: Colors.grey.shade100)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 12, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue.shade900,
                    letterSpacing: -0.5,
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
                    tooltip: 'Close Settings',
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          const Divider(indent: 24, endIndent: 24),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                _buildSectionHeader('Preferences'),
                _buildMenuTile(
                  context,
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: 'Theme & Customization',
                  onTap: () {},
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Email & Push alerts',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('Security'),
                _buildMenuTile(
                  context,
                  icon: Icons.lock_person_outlined,
                  title: 'Privacy',
                  subtitle: 'Change Password',
                  onTap: () {},
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Account',
                  subtitle: 'User profile data',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('Help & Support'),
                _buildMenuTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'About us',
                  subtitle: 'v1.0.0 (Stable)',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue.shade700, size: 20),
      ),
      title: Text(
        title, 
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
