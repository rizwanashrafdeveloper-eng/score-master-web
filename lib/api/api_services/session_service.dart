import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_models/session_detail_model.dart';
import '../api_urls.dart';


class SessionService {
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        developer.log('No auth token found in SharedPreferences', name: 'SessionService');
      } else {
        developer.log('Retrieved token: $token', name: 'SessionService');
      }
      return token;
    } catch (e) {
      developer.log('Error getting token: $e', name: 'SessionService');
      return null;
    }
  }

  Future<SessionModel?> fetchSessionDetail(int sessionId) async {
    final url = ApiEndpoints.sessionDetail(sessionId);
    developer.log('Fetching session detail from URL: $url', name: 'SessionService');
    try {
      final token = await _getToken();

      if (token == null) {
        developer.log('No auth token found, cannot fetch session', name: 'SessionService');
        throw Exception('Authentication token is missing');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      developer.log('API Response Status: ${response.statusCode}', name: 'SessionService');
      developer.log('API Response Body: ${response.body}', name: 'SessionService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        developer.log('Parsed JSON: $jsonData', name: 'SessionService'); // Log JSON
        return SessionModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        developer.log('Unauthorized - token may be invalid or expired', name: 'SessionService');
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 404) {
        developer.log('Session not found for ID: $sessionId', name: 'SessionService');
        throw Exception('Session not found');
      } else {
        developer.log('Failed to load session detail: ${response.statusCode} - ${response.reasonPhrase}', name: 'SessionService');
        throw Exception('Failed to load session: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching session detail: $e', name: 'SessionService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }}