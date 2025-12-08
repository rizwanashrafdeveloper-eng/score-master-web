import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/join_session_model.dart';
import '../api_urls.dart';

class JoinSessionService {
  Future<JoinSessionResponse> joinSession({
    required int playerId,
    required String joinCode,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/sessions/join');

    print('📡 [JoinSessionService] Sending POST request to $url');
    print('📌 Request body: ${jsonEncode({'playerId': playerId, 'joinCode': joinCode})}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'playerId': playerId,
          'joinCode': joinCode,
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Successfully joined session');
        return JoinSessionResponse.fromJson(data);
      } else {
        print('❌ Failed to join session: ${response.statusCode}');
        return JoinSessionResponse(
          success: false,
          message: 'Failed to join session: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('⚠️ Error joining session: $e');
      return JoinSessionResponse(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
