import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final String _key = 'mode';

  //saving the mode after changing it by user when opening the app.
  _saveTheme(bool mode) {
    _box.write(
        _key, mode); //after sending the value of isDarkMode it been saved.
  }

  bool _loadTheme() {
    return _box.read<bool>(_key) ??
        false; //reading value of isDarkMode that saved.
  }

//return the saved mode that been read.
  ThemeMode get theme => _loadTheme() ? ThemeMode.light : ThemeMode.dark;

  switchTheme() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.dark : ThemeMode.light);
    _saveTheme(
        !_loadTheme()); //every time i change theme i save it in the storage.
  }
}
