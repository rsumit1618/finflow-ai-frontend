import 'package:flutter/material.dart';

/// FinFlow AI Figma Design System Colors
/// Matches the Figma design: Light (#FAF8FF) and Dark (#101415) themes
class FinFlowColors {
  // ── Light Theme ──
  static const Color lightBg = Color(0xFFFAF8FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFF2F3FF);
  static const Color lightCardBg = Color(0xB3FFFFFF); // rgba(255,255,255,0.7)

  // ── Dark Theme ──
  static const Color darkBg = Color(0xFF101415);
  static const Color darkSurface = Color(0xFF0B0F10);
  static const Color darkCardBg = Color(0x990F172A); // rgba(15,23,42,0.6)

  // ── Brand Colors ──
  static const Color primary = Color(0xFF0066FF);
  static const Color primaryDark = Color(0xFF0050CB);
  static const Color primaryGlow = Color(0xFF2563EB);
  static const Color primaryLight_15 =
      Color(0x260066FF); // rgba(0,102,255,0.15)

  // ── Text Colors ──
  static const Color textPrimary = Color(0xFF131B2E);
  static const Color textSecondary = Color(0xFF424656);
  static const Color textMuted = Color(0xFF727687);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMutedDark = Color(0xFFB4C5FF);

  // ── Border Colors ──
  static const Color borderLight = Color(0x66FFFFFF); // rgba(255,255,255,0.4)
  static const Color borderSoft = Color(0x33C2C6D8); // rgba(194,198,216,0.2)
  static const Color borderDark = Color(0x0DFFFFFF); // rgba(255,255,255,0.05)
  static const Color borderAccent = Color(0x33B4C5FF); // rgba(180,197,255,0.2)
  static const Color strokeLight = Color(0x80C2C6D8); // rgba(194,198,216,0.5)

  // ── Effects ──
  static const Color glassStroke =
      Color(0x66FFFFFF); // rgba(255,255,255,0.4) stroke
  static const Color glassStrokeDark =
      Color(0x14FFFFFF); // rgba(255,255,255,0.08) stroke

  // ── Utility ──
  static const Color dividerLight = Color(0x33C2C6D8); // rgba(194,198,216,0.2)
  static const Color dashedBorder = Color(0x330050CB); // rgba(0,80,203,0.2)
  static const Color dashedBg = Color(0x0D0050CB); // rgba(0,80,203,0.05)
  static const Color socialBg = Color(0xB3FFFFFF); // rgba(255,255,255,0.7)
  static const Color fabShadow1 = Color(0x4D0050CB); // rgba(0,80,203,0.3)
  static const Color fabShadow2 = Color(0x4D0050CB); // rgba(0,80,203,0.3)
}
