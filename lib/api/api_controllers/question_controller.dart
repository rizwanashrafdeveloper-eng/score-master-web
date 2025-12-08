// File: lib/api/api_controllers/question_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_models/ai_questions_model.dart';
import '../api_models/questions_model.dart';

import '../api_services/ai_question_services.dart';
import '../api_services/question_api_service.dart';


class QuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = false.obs;
  var isAdding = false.obs;
  var isGeneratingAI = false.obs;
  var aiGeneratedQuestion = Rxn<AIQuestionResponse>();
  var aiErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions(); // Call once when controller is created
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final result = await QuestionApiService.getQuestions();
      questions.assignAll(result);
    } catch (e) {
      print("❌ Error fetching questions: $e");
      Get.snackbar('Error', 'Failed to fetch questions');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addQuestion(Question question) async {
    try {
      isAdding.value = true;
      final newQ = await QuestionApiService.createQuestion(question);
      questions.add(newQ);

      Get.snackbar(
        'Success',
        'Question added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ Error adding question: $e");
      Get.snackbar(
        'Error',
        'Failed to add question: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isAdding.value = false;
    }
  }

  // AI Question Generation Methods
  Future<void> generateAIQuestion({
    required String topic,
    required String type,
    required String gameName,
    required String phaseName,
  }) async {
    try {
      isGeneratingAI.value = true;
      aiErrorMessage.value = '';
      aiGeneratedQuestion.value = null;

      final request = AIQuestionRequest(
        topic: topic,
        type: type,
        gameName: gameName,
        phaseName: phaseName,
      );

      final response = await AIQuestionService.generateQuestion(request);
      aiGeneratedQuestion.value = response;

      Get.snackbar(
        '✅ AI Question Generated',
        'Successfully generated ${type.toUpperCase()} question',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

    } catch (e) {
      aiErrorMessage.value = 'Failed to generate question: $e';
      Get.snackbar(
        '❌ AI Generation Failed',
        aiErrorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      print("❌ AI Generation Error: $e");
    } finally {
      isGeneratingAI.value = false;
    }
  }

  Future<void> addAIGeneratedQuestion(AIQuestionResponse aiResponse, int phaseId, int order) async {
    try {
      isAdding.value = true;

      // Convert AI response to Question model
      final question = aiResponse.toQuestion(phaseId, order);

      // Add to local list immediately for better UX
      questions.add(question);

      // Also save to backend
      final newQ = await QuestionApiService.createQuestion(question);

      // Update the question with server response if needed
      final index = questions.indexWhere((q) => q.questionText == question.questionText);
      if (index != -1) {
        questions[index] = newQ;
      }

      Get.snackbar(
        '✅ Question Added',
        'AI-generated question added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      // Remove from local list if API call fails
      questions.removeWhere((q) => q.questionText == aiResponse.questionText);
      Get.snackbar(
        '❌ Error',
        'Failed to save AI question: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isAdding.value = false;
    }
  }

  void clearAIGeneratedQuestion() {
    aiGeneratedQuestion.value = null;
    aiErrorMessage.value = '';
  }

  // Helper methods
  List<Question> getQuestionsForPhase(int phaseId) {
    return questions.where((q) => q.phaseId == phaseId).toList();
  }

  int getNextOrderForPhase(int phaseId) {
    final phaseQuestions = getQuestionsForPhase(phaseId);
    if (phaseQuestions.isEmpty) return 1;
    return (phaseQuestions.map((q) => q.order).reduce((a, b) => a > b ? a : b)) + 1;
  }

  // Update question
  Future<void> updateQuestion(Question updatedQuestion) async {
    try {
      isAdding.value = true;
      // Here you would typically call an update API endpoint
      // For now, we'll just update locally
      final index = questions.indexWhere((q) =>
      q.phaseId == updatedQuestion.phaseId &&
          q.order == updatedQuestion.order);

      if (index != -1) {
        questions[index] = updatedQuestion;
      }

      Get.snackbar(
        'Success',
        'Question updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update question: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isAdding.value = false;
    }
  }

  // Delete question
  Future<void> deleteQuestion(Question question) async {
    try {
      isAdding.value = true;
      // Here you would typically call a delete API endpoint
      // For now, we'll just remove locally
      questions.removeWhere((q) =>
      q.phaseId == question.phaseId &&
          q.order == question.order);

      Get.snackbar(
        'Success',
        'Question deleted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete question: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isAdding.value = false;
    }
  }

  // Get questions by type for a phase
  List<Question> getQuestionsByTypeForPhase(int phaseId, QuestionType type) {
    return questions.where((q) =>
    q.phaseId == phaseId &&
        q.type == type).toList();
  }

  // Check if phase has questions
  bool hasQuestionsForPhase(int phaseId) {
    return questions.any((q) => q.phaseId == phaseId);
  }

  // Get total points for a phase
  int getTotalPointsForPhase(int phaseId) {
    return getQuestionsForPhase(phaseId)
        .fold(0, (sum, question) => sum + question.point);
  }

  // Refresh questions
  Future<void> refreshQuestions() async {
    await fetchQuestions();
  }

  // Clear all questions (useful for testing)
  void clearAllQuestions() {
    questions.clear();
  }
}