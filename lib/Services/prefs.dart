import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static setInt(String name, int value) async {
    (await SharedPreferences.getInstance()).setInt(name, value);
  }

  static setBool(String name, bool value) async {
    (await SharedPreferences.getInstance()).setBool(name, value);
  }

  static setDouble(String name, double value) async {
    (await SharedPreferences.getInstance()).setDouble(name, value);
  }

  static setString(String name, String value) async {
    (await SharedPreferences.getInstance()).setString(name, value);
  }

  static setStringList(String name, List<String> values) async {
    (await SharedPreferences.getInstance()).setStringList(name, values);
  }
}
