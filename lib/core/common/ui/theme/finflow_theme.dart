import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';

/// FinFlow AI Design System Theme
/// Based on Figma design: Light theme #FAF8FF, Dark theme #101415
class FinFlowTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: FinFlowColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: FinFlowColors.primary,
        onPrimary: Colors.white,
        primaryContainer: FinFlowColors.primaryLight_15,
        secondary: FinFlowColors.primaryDark,
        surface: FinFlowColors.lightSurface,
        onSurface: FinFlowColors.textPrimary,
        outline: FinFlowColors.strokeLight,
      ),
      fontFamily: 'PlusJakartaSans',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: FinFlowColors.lightCardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: FinFlowColors.glassStroke, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: FinFlowColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: FinFlowColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FinFlowColors.lightSurfaceSoft,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: FinFlowColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        hintStyle: const TextStyle(
          color: FinFlowColors.textMuted,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        labelStyle: const TextStyle(
          color: FinFlowColors.textSecondary,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: FinFlowColors.dividerLight,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: FinFlowColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: FinFlowColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: FinFlowColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: FinFlowColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: FinFlowColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: FinFlowColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: FinFlowColors.textMuted,
          letterSpacing: 0.05,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FinFlowColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: FinFlowColors.primaryGlow,
        onPrimary: Colors.white,
        primaryContainer: Color(0x262563EB), // rgba(37,99,235,0.15)
        secondary: FinFlowColors.primaryDark,
        surface: FinFlowColors.darkSurface,
        onSurface: FinFlowColors.textWhite,
        outline: FinFlowColors.borderDark,
      ),
      fontFamily: 'PlusJakartaSans',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: FinFlowColors.darkCardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: FinFlowColors.glassStrokeDark,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: FinFlowColors.primaryGlow,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              FinFlowColors.primaryGlow.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FinFlowColors.darkCardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: FinFlowColors.primaryGlow, width: 2),
        ),
        hintStyle: const TextStyle(
          color: FinFlowColors.textMuted,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 14,
          fontFamily: 'Inter',
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: FinFlowColors.borderDark,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: FinFlowColors.textWhite,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: FinFlowColors.textWhite,
        ),
        titleLarge: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: FinFlowColors.textWhite,
        ),
        titleMedium: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: FinFlowColors.textWhite,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF94A3B8),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF94A3B8),
        ),
        labelSmall: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF727687),
          letterSpacing: 0.05,
        ),
      ),
    );
  }
}
