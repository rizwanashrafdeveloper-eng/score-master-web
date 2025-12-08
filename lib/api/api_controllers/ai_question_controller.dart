// // lib/api/api_controllers/ai_question_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../api_models/ai_questions_model.dart';
// import '../api_services/ai_question_services.dart';
//
// class AIQuestionController extends GetxController {
//   var isGenerating = false.obs;
//   var generatedQuestion = Rxn<AIQuestionResponse>();
//   var errorMessage = ''.obs;
//
//   Future<void> generateAIQuestion({
//     required String topic,
//     required String type,
//     required String gameName,
//     required String phaseName,
//   }) async {
//     try {
//       isGenerating.value = true;
//       errorMessage.value = '';
//       generatedQuestion.value = null;
//
//       final request = AIQuestionRequest(
//         topic: topic,
//         type: type,
//         gameName: gameName,
//         phaseName: phaseName,
//       );
//
//       final response = await AIQuestionService.generateQuestion(request);
//       generatedQuestion.value = response;
//
//       Get.snackbar(
//         '✅ AI Question Generated',
//         'Successfully generated ${type.toUpperCase()} question',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } catch (e) {
//       errorMessage.value = 'Failed to generate question: $e';
//       Get.snackbar(
//         '❌ AI Generation Failed',
//         errorMessage.value,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 5),
//       );
//     } finally {
//       isGenerating.value = false;
//     }
//   }
//
//   void clearGeneratedQuestion() {
//     generatedQuestion.value = null;
//     errorMessage.value = '';
//   }
// }