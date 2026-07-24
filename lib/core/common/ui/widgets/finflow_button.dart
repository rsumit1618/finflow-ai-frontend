import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';

/// Primary FinFlow button with Figma styles
class FinFlowButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? height;
  final double? borderRadius;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final List<BoxShadow>? boxShadow;

  const FinFlowButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height,
    this.borderRadius = 12,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.boxShadow,
  });

  factory FinFlowButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return FinFlowButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: FinFlowColors.primary,
      foregroundColor: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color(0x330050CB),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0x330050CB),
          blurRadius: 15,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  factory FinFlowButton.social({
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
  }) {
    return FinFlowButton(
      text: text,
      onPressed: onPressed,
      icon: null, // We'll use leadingIcon instead
      backgroundColor: FinFlowColors.socialBg,
      foregroundColor: FinFlowColors.textSecondary,
      height: 56,
      borderRadius: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? FinFlowColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor:
              (backgroundColor ?? FinFlowColors.primary).withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shadowColor: Colors.transparent,
        ).copyWith(
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'PlusJakartaSans',
                      color: foregroundColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Social login button with icon
class SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: FinFlowColors.socialBg,
            foregroundColor: FinFlowColors.textSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: FinFlowColors.glassStroke,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: icon,
        ),
      ),
    );
  }
}
