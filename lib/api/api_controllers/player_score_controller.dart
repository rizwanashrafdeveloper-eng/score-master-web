// import 'package:get/get.dart';
// import '../api_models/player_score_model.dart';
// import '../api_services/player_score_service.dart';
//
// class PlayerScoreController extends GetxController {
//   var isLoading = false.obs;
//   var scores = <PlayerScoreModel>[].obs;
//   var errorMessage = ''.obs;
//
//   // Get first analysis item safely
//   PlayerScoreModel? get analysisData =>
//       scores.isNotEmpty ? scores.first : null;
//
//   Future<void> loadPlayerScores({
//     required int playerId,
//     required int questionId,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final result = await PlayerScoreService.fetchPlayerScores(
//         playerId: playerId,
//         questionId: questionId,
//       );
//
//       // ✅ Handle null / empty safely
//       if (result != null && result.isNotEmpty) {
//         scores.assignAll(result);
//         print("✅ Loaded ${result.length} scores");
//       } else {
//         errorMessage.value = "No analysis data found.";
//         print("❌ No data found in API");
//       }
//     } catch (e) {
//       errorMessage.value = "Error: $e";
//       print("🔥 Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
