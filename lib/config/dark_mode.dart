import 'package:flutter/material.dart';

class DarkMode with ChangeNotifier {
  bool darkMode = false;
  changemode() {
    darkMode = !darkMode;
    notifyListeners();
  }
}