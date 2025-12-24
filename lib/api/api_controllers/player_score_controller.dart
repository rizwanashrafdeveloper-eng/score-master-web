// api/api_controllers/player_score_controller_web.dart
import 'package:get/get.dart';
import '../api_models/player_score_model.dart';
import '../api_services/player_score_service.dart';

class PlayerScoreController extends GetxController {
  var isLoading = false.obs;
  var scores = <PlayerScoreModel>[].obs;
  var errorMessage = ''.obs;
  PlayerScoreModel? get analysisData => scores.isNotEmpty ? scores.first : null;

  Future<void> loadPlayerScores({
    required int playerId,
    required int questionId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 [PlayerScoreController] Loading scores for player $playerId, question $questionId');

      final result = await PlayerScoreService.fetchPlayerScores(
        playerId: playerId,
        questionId: questionId,
      );

      if (result != null && result.isNotEmpty) {
        scores.assignAll(result);
        print('✅ [PlayerScoreController] Loaded ${result.length} scores');
      } else {
        errorMessage.value = "No score data available yet";
        scores.clear();
        print('⚠️ [PlayerScoreController] No scores found');
      }
    } catch (e) {
      errorMessage.value = "Error loading scores: $e";
      print('❌ [PlayerScoreController] Error: $e');
      scores.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get the first score (most recent)
  PlayerScoreModel? get currentScore => scores.isNotEmpty ? scores.first : null;
}