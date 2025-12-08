// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:scorer/api/api_models/player_leaderboard_model.dart';
// import '../api_urls.dart';
//
// class PlayerLeaderboardService {
//   Future<PlayerLeaderboardModel?> fetchLeaderboard(int sessionId) async {
//     final url = Uri.parse(ApiEndpoints.playerLeaderboard(sessionId));
//     print("🌍 [PlayerLeaderboardService] Fetching leaderboard from: $url");
//
//     try {
//       final response = await http.get(url);
//       print("📩 [PlayerLeaderboardService] Response status: ${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         print("✅ [PlayerLeaderboardService] Successfully fetched leaderboard data.");
//         final data = jsonDecode(response.body);
//
//         // Optional: print truncated JSON for clarity
//         final preview = response.body.length > 200
//             ? response.body.substring(0, 200) + "..."
//             : response.body;
//         print("🧾 [PlayerLeaderboardService] Response preview: $preview");
//
//         return PlayerLeaderboardModel.fromJson(data);
//       } else {
//         print("⚠️ [PlayerLeaderboardService] Failed to load leaderboard. Status: ${response.statusCode}");
//         print("   └─ Response body: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ [PlayerLeaderboardService] Error fetching leaderboard: $e");
//     }
//
//     print("🔻 [PlayerLeaderboardService] Returning null due to failure.");
//     return null;
//   }
// }
