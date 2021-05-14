import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier{

  final String key = "theme";
  bool _isDarkMode;
  SharedPreferences prefs;

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
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }
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

