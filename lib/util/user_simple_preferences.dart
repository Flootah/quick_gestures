import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyPath = "imagepath";
  static const _keyShuffle = "shuffle";
  static const _keyGrid = "grid";
  static const _keyFlip_h = "flip_h";
  static const _keyFlip_v = "flip_v";


  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  // generic bool getter and setter
  static Future setBool(String k, bool b) async =>
    await _preferences.setBool(k, b);


  static bool? getBool(String k) =>
      _preferences.getBool(k);

  // String getter and setter
  static Future setString(String k, String s) async =>
    await _preferences.setString(k, s);

  static String? getString(String k) =>
    _preferences.getString(k);

  ////////// soon to be deprecated //////////
  static Future setShuffle(bool b) async =>
      await _preferences.setBool(_keyShuffle, b);

  static bool? getShuffle() =>
      _preferences.getBool(_keyShuffle);
}