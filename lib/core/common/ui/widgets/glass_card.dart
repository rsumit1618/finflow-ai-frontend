import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';

/// Reusable frosted glass card matching Figma design
/// Uses backdrop blur and semi-transparent backgrounds
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Alignment? alignment;
  final Decoration? decoration;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.alignment,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor ??
                (isDark ? FinFlowColors.darkCardBg : FinFlowColors.lightCardBg),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ??
                  (isDark
                      ? FinFlowColors.glassStrokeDark
                      : FinFlowColors.glassStroke),
              width: 1,
            ),
            boxShadow: boxShadow ??
                [
                  if (!isDark)
                    const BoxShadow(
                      color: FinFlowColors.borderAccent,
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  BoxShadow(
                    color: isDark
                        ? Colors.transparent
                        : FinFlowColors.primary.withValues(alpha: 0.05),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
          ),
      child: alignment != null
          ? Align(
              alignment: alignment!,
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(24),
              child: child,
            ),
    );
  }
}

/// Glass card with backdrop blur effect
class BlurGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blurIntensity;

  const BlurGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
    this.blurIntensity = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter:
            ui.ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
        child: GlassCard(
          padding: padding,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
