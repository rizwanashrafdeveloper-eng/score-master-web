import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_endpoints/api_end_points.dart';
import '../api_models/team_leaderboard_model.dart';

class TeamLeaderboardService {
  Future<TeamLeaderboardModel?> fetchLeaderboard(int sessionId) async {
    final url = Uri.parse(ApiEndpoints.teamLeaderboard(sessionId));
    print("🌍 [TeamLeaderboardService] Fetching team leaderboard from: $url");

    try {
      final response = await http.get(url);
      print("📩 [TeamLeaderboardService] Response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ [TeamLeaderboardService] Successfully fetched team leaderboard data.");

        final data = jsonDecode(response.body);

        // Optional preview for large responses
        final preview = response.body.length > 200
            ? response.body.substring(0, 200) + "..."
            : response.body;
        print("🧾 [TeamLeaderboardService] Response preview: $preview");

        return TeamLeaderboardModel.fromJson(data);
      } else {
        print("⚠️ [TeamLeaderboardService] Failed to load leaderboard. Status: ${response.statusCode}");
        print("   └─ Response body: ${response.body}");
      }
    } catch (e) {
      print("❌ [TeamLeaderboardService] Error fetching leaderboard: $e");
    }

    print("🔻 [TeamLeaderboardService] Returning null due to failure.");
    return null;
  }
}
