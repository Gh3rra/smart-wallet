import 'package:flutter/material.dart';
import 'package:mobile/services/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool isCapsLock = false;

  toggleTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkTheme", isDark);
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  toggleCapsLock(bool isCapsLock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("titleCapsLock", isCapsLock);
    this.isCapsLock = isCapsLock;
    notifyListeners();
  }

  void initialize() async {
    print("INTIALIZE THEME MANAGER");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkTheme = prefs.getBool("darkTheme") ?? false;
    isCapsLock = prefs.getBool("titleCapsLock") ?? false;
    themeMode = darkTheme == true ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
