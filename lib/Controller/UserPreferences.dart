import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> setExpToken(String fechaExpiracion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fechaExpiracion', fechaExpiracion);
  }

  static Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id_user', userId);
  }

  static Future<String?> getFechaExpiracion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fechaExpiracion');
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_user');
  }
}
