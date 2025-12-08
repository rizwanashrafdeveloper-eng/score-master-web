import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api_endpoints/api_end_points.dart';


class ApiService {


  // GET facilitators
  static Future<List<dynamic>> getFacilitators() async {
    final url = Uri.parse(ApiEndpoints.getFacilitators);
    print("🌍 GET request: $url");

    try {
      final response = await http.get(url);
      print("📥 Status: ${response.statusCode}");
      print("📥 Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("✅ Decoded: $decoded");

        // If API returns { "data": [...] }
        if (decoded is Map<String, dynamic> && decoded.containsKey("data")) {
          return decoded["data"];
        }

        // If API returns a direct list
        if (decoded is List) {
          return decoded;
        }

        throw Exception("Unexpected response format: $decoded");
      } else {
        throw Exception("Failed to fetch facilitators (Status: ${response.statusCode})");
      }
    } catch (e) {
      print("❌ Error in getFacilitators: $e");
      rethrow;
    }
  }


  // Generic POST
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.body}');
    }
  }
}
