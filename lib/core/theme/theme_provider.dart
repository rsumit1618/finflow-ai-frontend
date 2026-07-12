import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = const Color(0xFF6200EE); // Modern Vibrant Purple
  String _fontFamily = 'Roboto';

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  String get fontFamily => _fontFamily;

  ThemeProvider() {
    _loadFromPrefs();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveToPrefs();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _saveToPrefs();
    notifyListeners();
  }

  void setFontFamily(String font) {
    _fontFamily = font;
    _saveToPrefs();
    notifyListeners();
  }

  ThemeData getThemeData(bool isDark) {
    // Premium Dark Palette: Deep Navy/Grey
    const darkBackground = Color(0xFF0F111A);
    const darkSurface = Color(0xFF1A1D2D);
    const darkVariant = Color(0xFF25293D);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: _primaryColor,
      background: isDark ? darkBackground : const Color(0xFFF8F9FE),
      surface: isDark ? darkSurface : Colors.white,
      surfaceVariant: isDark ? darkVariant : const Color(0xFFF1F2F9),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: colorScheme.background,
      
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.1 : 0.5),
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(isDark ? 0.5 : 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: colorScheme.outlineVariant.withOpacity(0.3),
      ),
    );
  }

  _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    final colorVal = prefs.getInt('primaryColor');
    if (colorVal != null) {
      _primaryColor = Color(colorVal);
    }
    _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    notifyListeners();
  }

  _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _themeMode == ThemeMode.dark);
    prefs.setInt('primaryColor', _primaryColor.value);
    prefs.setString('fontFamily', _fontFamily);
  }
}
