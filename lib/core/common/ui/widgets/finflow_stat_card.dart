import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';

/// Metric stat card matching Figma design
class FinFlowStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final Widget? icon;

  const FinFlowStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    this.isPositive = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? FinFlowColors.darkCardBg : FinFlowColors.lightCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? FinFlowColors.glassStrokeDark
              : FinFlowColors.glassStroke,
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                const BoxShadow(
                  color: FinFlowColors.borderAccent,
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? FinFlowColors.textMuted
                      : FinFlowColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? FinFlowColors.textWhite
                    : FinFlowColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? (isDark ? const Color(0x3322C55E) : const Color(0xFFF0FDF4))
                  : (isDark
                      ? const Color(0x33EF4444)
                      : const Color(0xFFFEF2F2)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 10,
                  color: isPositive
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isPositive
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
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
