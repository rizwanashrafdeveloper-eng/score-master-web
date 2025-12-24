// lib/shared_preference/auth_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdStr = prefs.getString('userId');
    return userIdStr != null ? int.tryParse(userIdStr) : null;
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  static Future<bool> isFacilitator() async {
    final role = await getUserRole();
    return role == 'facilitator';
  }
}