import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<void> setLoginData({required String email , required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('username', username);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
  }

  static Future<void> getLoginData({required String email, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.getBool('isLoggedIn');
    await prefs.getString('userEmail')?? '';
    await prefs.getString('username')?? '';
  }
}
