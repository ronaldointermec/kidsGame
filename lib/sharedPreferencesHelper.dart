import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final SharedPreferences _preferences;

  SharedPreferencesHelper(this._preferences);

  // Methods for storing and retrieving data

  // Store a String value
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  // Retrieve a String value
  String getString(String key) {
    return _preferences.getString(key) ?? '';
  }

  // Store an integer value
  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  // Retrieve an integer value
  int getInt(String key) {
    return _preferences.getInt(key) ?? 0;
  }

  // Store a boolean value
  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  // Retrieve a boolean value
  bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }

  // Remove a key from SharedPreferences
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  // Check if a key exists in SharedPreferences
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}