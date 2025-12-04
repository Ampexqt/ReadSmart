import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontFamily { lora, merriweather, crimsonText }

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  FontFamily _fontFamily = FontFamily.lora;

  static const String _themeKey = 'theme_mode';
  static const String _fontFamilyKey = 'font_family';

  bool get isDarkMode => _isDarkMode;
  FontFamily get fontFamily => _fontFamily;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;

    // Load font family preference
    final fontFamilyIndex = prefs.getInt(_fontFamilyKey) ?? 0;
    _fontFamily = FontFamily.values[fontFamilyIndex];

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setFontFamily(FontFamily fontFamily) async {
    _fontFamily = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontFamilyKey, fontFamily.index);
    notifyListeners();
  }

  String getFontFamilyName() {
    switch (_fontFamily) {
      case FontFamily.lora:
        return 'Lora';
      case FontFamily.merriweather:
        return 'Merriweather';
      case FontFamily.crimsonText:
        return 'Crimson Text';
    }
  }
}
