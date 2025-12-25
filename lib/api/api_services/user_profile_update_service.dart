import 'dart:convert';
import 'package:http/http.dart' as http;

class UserUpdateService {
  static const String baseUrl = "https://score-master-backend.onrender.com";

  /// Update user profile (name and phone)
  /// PATCH /user/{userId}
  static Future<Map<String, dynamic>?> updateUserProfile({
    required int userId,
    String? name,
    String? phone,
  }) async {
    final url = Uri.parse('$baseUrl/user/$userId');

    try {
      print("🔄 Updating user profile: $url");

      // Build request body with only provided fields
      final Map<String, dynamic> body = {};
      if (name != null && name.isNotEmpty) body['name'] = name;
      if (phone != null && phone.isNotEmpty) body['phone'] = phone;

      print("📦 Update body: $body");

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("📡 Response Status: ${response.statusCode}");
      print("📨 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        print("✅ User profile updated successfully");
        return jsonData;
      } else {
        print("❌ Failed to update profile: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 Exception during profile update: $e");
      return null;
    }
  }
}