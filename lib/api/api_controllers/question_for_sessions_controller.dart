import 'package:get/get.dart';
import '../api_models/question_for_session_model.dart';
import '../api_services/question_for_sessions_service.dart';

class QuestionForSessionsController extends GetxController {
  var isLoading = false.obs;
  var questionData = Rxn<QuestionForSessionModel>();
  var errorMessage = ''.obs;
  var errorType = ''.obs; // To distinguish error types
  final timeProgress = 0.0.obs;

  Future<void> loadQuestions({
    required int sessionId,
    required int gameFormatId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      errorType.value = '';

      final result = await QuestionForSessionsService.fetchQuestions(
        sessionId: sessionId,
        gameFormatId: gameFormatId,
      );

      if (result != null) {
        questionData.value = result;
        print("✅ Questions loaded: ${result.phases.length} phases");
      }
    } on SessionException catch (e) {
      // Handle session-specific errors
      print("❌ [Controller] Session Error: ${e.message}");

      if (e.message == 'session_not_active') {
        errorType.value = 'not_active';
        errorMessage.value = 'session_not_active'.tr;
      } else if (e.message == 'session_paused') {
        errorType.value = 'paused';
        errorMessage.value = 'session_paused'.tr;
      } else if (e.message == 'session_not_found') {
        errorType.value = 'not_found';
        errorMessage.value = 'session_not_found'.tr;
      } else {
        errorType.value = 'unknown';
        errorMessage.value = e.message;
      }
    } catch (e) {
      errorType.value = 'unknown';
      errorMessage.value = e.toString();
      print("🔥 [Controller] Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}



// import 'package:get/get.dart';
// import '../api_models/question_for_session_model.dart';
// import '../api_services/question_for_sessions_service.dart';
//
// class QuestionForSessionsController extends GetxController {
//   var isLoading = false.obs;
//   var questionData = Rxn<QuestionForSessionModel>();
//   var errorMessage = ''.obs;
//   final timeProgress = 0.0.obs;
//
//   Future<void> loadQuestions({
//     required int sessionId,
//     required int gameFormatId,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final result = await QuestionForSessionsService.fetchQuestions(
//         sessionId: sessionId,
//         gameFormatId: gameFormatId,
//       );
//
//       if (result != null) {
//         questionData.value = result;
//         print("✅ Questions loaded: ${result.phases.length} phases");
//       } else {
//         errorMessage.value = "Failed to load questions.";
//         print("❌ [Controller] No data returned");
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("🔥 [Controller] Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
