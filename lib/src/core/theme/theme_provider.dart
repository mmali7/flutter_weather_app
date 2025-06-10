import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final SharedPreferences prefs;

  ThemeProvider(this.prefs);

  ThemeMode get themeMode => _themeMode;

  static const String _themePreferenceKey = 'theme_preference';

  void loadTheme() {
    final themePreference = prefs.getString(_themePreferenceKey);
    if (themePreference == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themePreference == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;

    String themePreference;
    if (themeMode == ThemeMode.light) {
      themePreference = 'light';
    } else if (themeMode == ThemeMode.dark) {
      themePreference = 'dark';
    } else {
      themePreference = 'system';
    }
    prefs.setString(_themePreferenceKey, themePreference);
    notifyListeners();
  }
}
