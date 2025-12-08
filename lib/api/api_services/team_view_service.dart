import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/team_view_model.dart';

class TeamViewService {
  static const String baseUrl = "https://score-master-backend.onrender.com";

  /// Fetch all teams for a session
  static Future<TeamViewModel?> fetchTeams(int sessionId) async {
    final url = Uri.parse('$baseUrl/team/session/$sessionId/members');

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return TeamViewModel.fromJson(jsonData);
      } else {
        print("❌ [TeamViewService] Failed to fetch teams: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 [TeamViewService] Exception: $e");
      return null;
    }
  }
}
