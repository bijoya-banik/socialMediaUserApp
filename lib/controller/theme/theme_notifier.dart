import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  bool themeData;

  ThemeNotifier(this.themeData);

  setTheme(_themeData) async {
    AppMode.darkMode = _themeData;

    notifyListeners();

    if (_themeData) {
      KColor.setDark();
    } else {
      KColor.setLight();
    }
  }
}

class CallingStateClass with ChangeNotifier {
  static int myNumber = 10;

  void changeNumber() {
    myNumber = 1;
    notifyListeners();
  }
}
