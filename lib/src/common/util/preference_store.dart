import 'package:shared_preferences/shared_preferences.dart';

class PreferenceStore {
  /// We creates a [SharedPreferences] class instance.
  /// It will use to set and get the data.
  late SharedPreferences _sharedPreferences;

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return;
  }

  T getValue<T>(String key, T defaultValue) {
    dynamic value = _sharedPreferences.get(key) ?? defaultValue;
    if (value is List) {
      return List<String>.from(value) as T;
    }
    return value as T;
  }

  void setValue(String key, Object value) {
    if (value is int) {
      _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      _sharedPreferences.setDouble(key, value);
    } else if (value is String) {
      _sharedPreferences.setString(key, value);
    } else if (value is List<String>) {
      _sharedPreferences.setStringList(key, value);
    } else {
      throw Exception('${value.runtimeType} type is not supported by SharedPreferences');
    }
  }

  bool containsKey(final String key) {
    return _sharedPreferences.containsKey(key);
  }

  Future<void> removeKey(String key) async {
    await _sharedPreferences.remove(key);
  }
}
