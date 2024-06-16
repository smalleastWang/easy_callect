
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  late SharedPreferences _prefs;

  // 私有构造函数，确保只能在类内部实例化
  SharedPreferencesManager._internal();

  // 工厂构造函数，返回单例实例
  factory SharedPreferencesManager() {
    _instance ??= SharedPreferencesManager._internal();
    return _instance!;
  }

  // 初始化SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String prefsKey) {
    return _prefs.getString(prefsKey);
  }

  Future<bool> setString(String prefsKey, String value) {
    return _prefs.setString(prefsKey, value);
  }

  int? getInt(String prefsKey) {
    return _prefs.getInt(prefsKey);
  }
  Future<bool> setInt(String prefsKey, int val) {
    return _prefs.setInt(prefsKey, val);
  }

  bool? getBool(String prefsKey) {
    return _prefs.getBool(prefsKey);
  }
  Future<bool> setBool(String prefsKey, bool val) {
    return _prefs.setBool(prefsKey, val);
  }

  double? getDouble(String prefsKey) {
    return _prefs.getDouble(prefsKey);
  }
  Future<bool> setDouble(String prefsKey, double val) {
    return _prefs.setDouble(prefsKey, val);
  }

  // 删除token
  Future<void> remove(String prefsKey) async {
    await _prefs.remove(prefsKey);
  }
}
