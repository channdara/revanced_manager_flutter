import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  factory PreferencesManager() => _instance;

  PreferencesManager._();

  static final PreferencesManager _instance = PreferencesManager._();

  static const String _darkMode = 'darkMode';

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
}
