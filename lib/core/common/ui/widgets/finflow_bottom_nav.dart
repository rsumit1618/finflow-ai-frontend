import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';

/// Bottom navigation bar matching Figma Mobile Dashboard design
class FinFlowBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final VoidCallback? onFabPressed;

  const FinFlowBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      decoration: BoxDecoration(
        color: FinFlowColors.textWhite.withValues(alpha: 0.8),
        border: const Border(
          top: BorderSide(
            color: FinFlowColors.glassStroke,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0066FF),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Tab items
          Positioned.fill(
            child: Row(
              children: [
                _NavTab(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: 'Dashboard',
                  isActive: currentIndex == 0,
                  onTap: () => onTap?.call(0),
                ),
                _NavTab(
                  icon: Icons.trending_up_outlined,
                  activeIcon: Icons.trending_up,
                  label: 'Analytics',
                  isActive: currentIndex == 1,
                  onTap: () => onTap?.call(1),
                ),
                const Spacer(),
                _NavTab(
                  icon: Icons.video_library_outlined,
                  activeIcon: Icons.video_library,
                  label: 'Content',
                  isActive: currentIndex == 3,
                  onTap: () => onTap?.call(3),
                ),
                _NavTab(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  isActive: currentIndex == 4,
                  onTap: () => onTap?.call(4),
                ),
              ],
            ),
          ),

          // Center FAB
          Positioned(
            top: -19,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onFabPressed,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: FinFlowColors.primaryDark,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4D0050CB),
                        blurRadius: 10,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Color(0x4D0050CB),
                        blurRadius: 25,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 20,
              color: isActive
                  ? FinFlowColors.primaryDark
                  : FinFlowColors.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? FinFlowColors.primaryDark
                    : FinFlowColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
