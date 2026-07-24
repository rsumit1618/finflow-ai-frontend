import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';

/// Sidebar navigation matching Figma design (Web)
class FinFlowSidebar extends StatelessWidget {
  final bool isCollapsed;
  final String activeRoute;
  final Function(String)? onNavigate;

  const FinFlowSidebar({
    super.key,
    this.isCollapsed = false,
    this.activeRoute = 'dashboard',
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: isCollapsed ? 72 : 256,
      decoration: BoxDecoration(
        color: isDark ? FinFlowColors.darkSurface : FinFlowColors.lightCardBg,
        border: Border(
          right: BorderSide(
            color: isDark
                ? FinFlowColors.glassStrokeDark
                : FinFlowColors.glassStroke,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Brand
          Container(
            padding: EdgeInsets.fromLTRB(
                isCollapsed ? 8 : 24, 24, isCollapsed ? 8 : 24, 32),
            child: _Brand(isCollapsed: isCollapsed),
          ),

          // Workspace selector
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: FinFlowColors.lightSurfaceSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: FinFlowColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'FinFlow AI',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: FinFlowColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: FinFlowColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Navigation items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _NavItem(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Dashboard',
                    isActive: activeRoute == 'dashboard',
                    isCollapsed: isCollapsed,
                    onTap: () => onNavigate?.call('dashboard'),
                  ),
                  const SizedBox(height: 4),
                  _NavItem(
                    icon: Icons.video_library_outlined,
                    activeIcon: Icons.video_library,
                    label: 'Content',
                    isActive: activeRoute == 'content',
                    isCollapsed: isCollapsed,
                    onTap: () => onNavigate?.call('content'),
                  ),
                  const SizedBox(height: 4),
                  _NavItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    label: 'Community',
                    isActive: activeRoute == 'community',
                    isCollapsed: isCollapsed,
                    onTap: () => onNavigate?.call('community'),
                  ),
                  const SizedBox(height: 4),
                  _NavItem(
                    icon: Icons.trending_up_outlined,
                    activeIcon: Icons.trending_up,
                    label: 'Analytics',
                    isActive: activeRoute == 'analytics',
                    isCollapsed: isCollapsed,
                    onTap: () => onNavigate?.call('analytics'),
                  ),
                  const SizedBox(height: 4),
                  _NavItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Settings',
                    isActive: activeRoute == 'settings',
                    isCollapsed: isCollapsed,
                    onTap: () => onNavigate?.call('settings'),
                  ),
                ],
              ),
            ),
          ),

          // Upgrade button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: FinFlowColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      size: isCollapsed ? 20 : 16,
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'Upgrade',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
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
            color: FinFlowColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 20,
          ),
        ),
        if (!isCollapsed) ...[
          const SizedBox(width: 12),
          const Text(
            'Studio',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: FinFlowColors.primaryDark,
              letterSpacing: -0.5,
            ),
          ),
          const Text(
            '.',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: FinFlowColors.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isActive = false,
    required this.isCollapsed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? FinFlowColors.primaryLight_15 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment:
              isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? FinFlowColors.primary : FinFlowColors.textMuted,
              size: 20,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? FinFlowColors.primary
                      : FinFlowColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
