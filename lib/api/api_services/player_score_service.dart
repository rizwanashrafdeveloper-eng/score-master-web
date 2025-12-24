// lib/api/api_services/player_score_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_endpoints/api_end_points.dart';
import '../api_models/player_score_model.dart';

class PlayerScoreService {
  static Future<List<PlayerScoreModel>?> fetchPlayerScores({
    required int playerId,
    required int questionId,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.playerScore(playerId, questionId));
      print('📡 Fetching scores from $url');

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      print('🔍 Response status: ${response.statusCode}');
      print('🔍 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) return [];
        return jsonList.map((e) => PlayerScoreModel.fromJson(e)).toList();
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🔥 Exception in fetchPlayerScores: $e');
      return [];
    }
  }
}
