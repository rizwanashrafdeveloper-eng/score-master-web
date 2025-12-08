import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import '../../shared_preference/shared_preference.dart';
import '../api_models/session_list_model.dart';
import '../api_urls.dart';

class SessionsListService {
  Future<SessionsListResponse?> fetchAllSessions() async {
    final url = ApiEndpoints.allSessions;
    developer.log('Fetching all sessions from URL: $url', name: 'SessionsListService');

    try {
      final token = await SharedPrefServices.getAuthToken();

      if (token == null) {
        developer.log('No auth token found', name: 'SessionsListService');
        return null;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      developer.log('API Response Status: ${response.statusCode}', name: 'SessionsListService');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SessionsListResponse.fromJson(jsonData);
      } else {
        developer.log('Failed to load sessions: ${response.statusCode}', name: 'SessionsListService');
        return null;
      }
    } catch (e) {
      developer.log('Error fetching sessions: $e', name: 'SessionsListService');
      return null;
    }
  }
}
