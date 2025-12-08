// import 'package:get/get.dart';
// import '../api_models/question_for_session_model.dart';
// import '../api_services/question_for_sessions_service.dart';
//
// class QuestionForSessionsController extends GetxController {
//   var isLoading = false.obs;
//   var questionData = Rxn<QuestionForSessionModel>();
//   var errorMessage = ''.obs;
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
//
//
// // import 'package:get/get.dart';
// // import '../api_models/question_for_session_model.dart';
// // import '../api_services/question_for_sessions_service.dart';
// //
// // class QuestionForSessionsController extends GetxController {
// //   var isLoading = false.obs;
// //   var questionData = Rxn<QuestionForSessionModel>();
// //   var errorMessage = ''.obs;
// //
// //   Future<void> loadQuestions({
// //     required int sessionId,
// //     required int gameFormatId,
// //   }) async {
// //     try {
// //       isLoading.value = true;
// //       errorMessage.value = '';
// //
// //       final result = await QuestionForSessionsService.fetchQuestions(
// //         sessionId: sessionId,
// //         gameFormatId: gameFormatId,
// //       );
// //
// //       if (result != null) {
// //         questionData.value = result;
// //         print("✅ Questions loaded: ${result.phases.length} phases");
// //       } else {
// //         errorMessage.value = "Failed to load questions.";
// //         print("❌ [Controller] No data returned");
// //       }
// //     } catch (e) {
// //       errorMessage.value = e.toString();
// //       print("🔥 [Controller] Exception: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }
