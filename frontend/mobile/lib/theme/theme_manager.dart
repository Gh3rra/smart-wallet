import 'package:flutter/material.dart';
import 'package:mobile/common/services/db.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode themeMode;
  bool capsLock;

  ThemeManager({required this.themeMode, required this.capsLock});

  toggleTheme(bool isDark) async {
    themeMode = await Db().setDarkTheme(isDark);
    notifyListeners();
  }

  toggleCapsLock(bool isCapsLock) async {
    capsLock = await Db().setCapsLock(isCapsLock);
    notifyListeners();
  }

  getThemeAfterLogin() async {
    print("getThemeAfterLogin start");
    themeMode = await Db().getInitialTheme();
    capsLock = await Db().getInitialCapsLock();
    notifyListeners();
    print("getThemeAfterLogin end");


  }
}
