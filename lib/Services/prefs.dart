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

  static Future<int?> getInt(String name) async {
    return (await SharedPreferences.getInstance()).getInt(name);
  }

  static Future<bool?> getBool(String name) async {
    return (await SharedPreferences.getInstance()).getBool(name);
  }

  static Future<double?> getDouble(String name) async {
    return (await SharedPreferences.getInstance()).getDouble(name);
  }

  static Future<String?> getString(String name) async {
    return (await SharedPreferences.getInstance()).getString(name);
  }

  static Future<List<String>?> getStringList(String name) async {
    return (await SharedPreferences.getInstance()).getStringList(name);
  }

  static Future<bool> remove(String name) async {
    return (await SharedPreferences.getInstance()).remove(name);
  }
}
