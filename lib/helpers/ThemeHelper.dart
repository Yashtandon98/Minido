import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier{

  final String key = "theme";
  late bool _isDarkMode;
  late SharedPreferences prefs;

  bool get darktheme => _isDarkMode;

  ThemeNotifier() {
    _isDarkMode = true;
    _loadFromprefs();
  }

  toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async{
    
  }

  _loadFromprefs() async{
    await _initPrefs();
    _isDarkMode = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async{
    await _initPrefs();
    prefs.setBool(key, _isDarkMode);
  }
}

