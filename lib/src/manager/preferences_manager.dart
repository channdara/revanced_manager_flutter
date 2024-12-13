import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  factory PreferencesManager() => _instance;

  PreferencesManager._();

  static final PreferencesManager _instance = PreferencesManager._();

  static const String _darkMode = 'darkMode';
  static const String _accentColor = 'accentColor';

  Future<ThemeMode> themeMode([Brightness? brightness]) async {
    final pref = await SharedPreferences.getInstance();
    if (brightness != null) {
      pref.setBool(_darkMode, brightness == Brightness.dark);
    }
    return switch (pref.getBool(_darkMode)) {
      true => ThemeMode.dark,
      false => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<Color> accentColor([Color? color]) async {
    final pref = await SharedPreferences.getInstance();
    if (color != null) {
      pref.setInt(_accentColor, color.value);
      return color;
    }
    final value = pref.getInt(_accentColor);
    return value == null ? Colors.blue : Color(value);
  }
}
