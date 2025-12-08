import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/player_team_model.dart';
import '../api_urls.dart';

class PlayerTeamService {
  /// Create a team
  static Future<PlayerTeamModel?> createTeam(PlayerTeamModel team) async {
    final url = Uri.parse(ApiEndpoints.createTeam);

    try {
      print("📡 [PlayerTeamService] Sending POST request to $url");
      final body = jsonEncode(team.toJson());
      print("📌 Request body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PlayerTeamModel.fromJson(data);
      } else {
        print("❌ Failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 Exception in createTeam: $e");
      return null;
    }
  }
}
