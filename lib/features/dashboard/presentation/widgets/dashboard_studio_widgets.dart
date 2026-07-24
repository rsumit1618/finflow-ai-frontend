import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';

// ── Color Palette (Tailwind-inspired, clean & light) ──
class AppColors {
  static const Color bg = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEF2F2);
  static const Color sidebarBg = Color(0xFFFFFFFF);
  static const Color sidebarHover = Color(0xFFF1F5F9);
  static const Color sidebarActive = Color(0xFFEFF6FF);
  static const Color thumbnailBg = Color(0xFFF1F5F9);
}

// ── Sidebar ──
class CreatorStudioSidebar extends StatelessWidget {
  final bool isCollapsed;
  const CreatorStudioSidebar({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: isCollapsed ? 72 : 240,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: isCollapsed ? 8 : 16,
      ),
      child: Column(
        crossAxisAlignment:
            isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _Brand(isCollapsed: isCollapsed),
          const SizedBox(height: 32),
          _NavItem(
            icon: Icons.dashboard_outlined,
            label: l10n?.translate('dashboard') ?? 'Dashboard',
            isActive: true,
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.video_library_outlined,
            label: l10n?.translate('studio') ?? 'Studio',
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.people_outline,
            label: l10n?.translate('community') ?? 'Community',
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.trending_up_outlined,
            label: l10n?.translate('analytics') ?? 'Analytics',
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: l10n?.translate('settings') ?? 'Settings',
            isCollapsed: isCollapsed,
          ),
          const Spacer(),
          if (!isCollapsed) const _SubscriberBadge(),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  final bool isCollapsed;
  const _Brand({required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.workspace_premium,
              color: AppColors.primary, size: 20),
        ),
        if (!isCollapsed) ...[
          const SizedBox(width: 10),
          const Text(
            'CreatorHub',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCollapsed;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.sidebarActive : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment:
            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textMuted,
            size: 20,
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriberBadge extends StatelessWidget {
  const _SubscriberBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.warning, size: 16),
          const SizedBox(width: 8),
          Text(
            l10n?.translate('followers_count') ?? '14.2k followers',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ──
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color:
                  isPositive ? AppColors.successLight : AppColors.borderLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPositive)
                  const Icon(Icons.arrow_upward,
                      size: 9, color: AppColors.success),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    change,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color:
                          isPositive ? AppColors.success : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Video Data (dummy) ──
class VideoData {
  final String titleKey;
  final String views;
  final String time;
  final String duration;
  final bool isPublic;

  const VideoData({
    required this.titleKey,
    required this.views,
    required this.time,
    required this.duration,
    this.isPublic = true,
  });
}

List<VideoData> getDummyVideos() {
  return List.generate(40, (index) {
    final keys = [
      'morning_routine_vlog',
      'podcast_episode_seven',
      'book_review_analysis',
      'productivity_hacks',
      'travel_diary_italy',
    ];
    return VideoData(
      titleKey: keys[index % keys.length],
      views: '${(index + 1) * 1.5}k views',
      time: '${index + 1} days ago',
      duration: '${10 + (index % 50)}:22',
      isPublic: index % 3 != 0,
    );
  });
}
