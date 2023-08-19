import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoflutter/Themes/theme_share_preferences.dart';

class ThemeModal extends ChangeNotifier {
  bool _isDark = false;
  ThemeSharedPreferences _preferences = ThemeSharedPreferences();
  bool get isDark => _isDark;

  ThemeModal() {
    _isDark = false;
    _preferences = ThemeSharedPreferences();
    getPreferences();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }
}
