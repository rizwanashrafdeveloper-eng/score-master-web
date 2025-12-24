import 'package:get/get.dart';


import '../api_models/player_q_submit_model.dart';
import '../api_services/player_q_submit_service.dart';

class PlayerQSubmitController extends GetxController {
  final PlayerQSubmitService _service = PlayerQSubmitService();

  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  Future<void> submitPlayerAnswer({
    required int playerId,
    required int facilitatorId,
    required int sessionId,
    required int phaseId,
    required int questionId,
    required Map<String, dynamic> answerData,
  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    try {
      final requestModel = PlayerQSubmitModel(
        id: 0,
        playerId: playerId,
        facilitatorId: facilitatorId,
        sessionId: sessionId,
        phaseId: phaseId,
        questionId: questionId,
        answerData: answerData,
      );

      final response = await _service.submitAnswer(requestModel);

      if (response != null) {
        successMessage.value = "Answer submitted successfully!";
        print("✅ Response: ${response.toJson()}");
      } else {
        errorMessage.value = "Failed to submit answer.";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading(false);
    }
  }
}
