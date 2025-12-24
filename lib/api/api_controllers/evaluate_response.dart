// lib/api/api_controllers/evaluate_response.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_models/evaluate_response.dart';
import '../api_endpoints/api_end_points.dart';

class ScoreController extends GetxController {
  var scoreResponse = Rxn<ScoreResponse>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var answerData = ''.obs;
  var questionText = ''.obs;
  var playerName = ''.obs;

  Future<void> fetchScore({
    String? answerData,
    String? questionText,
    String? playerName,
  }) async {
    try {
      if (answerData != null) this.answerData.value = answerData;
      if (questionText != null) this.questionText.value = questionText;
      if (playerName != null) this.playerName.value = playerName;

      isLoading(true);
      errorMessage.value = '';

      print('🎯 Fetching AI evaluation score...');
      print('   - Question: ${this.questionText.value}');
      print('   - Answer: ${this.answerData.value}');
      print('   - Player: ${this.playerName.value}');

      // Prepare request body with real data
      final requestBody = {
        'questionText': this.questionText.value.isNotEmpty
            ? this.questionText.value
            : "Define your team's primary objective for the next quarter and identify three key strategies to achieve it.",
        'answerText': this.answerData.value.isNotEmpty
            ? this.answerData.value
            : "Primary Objective: Increase customer satisfaction by 25% through improved service delivery. Key Strategies: 1. Implement real-time feedback system, 2. Reduce response time to under 2 hours, 3. Enhance self-service capabilities.",
        'playerName': this.playerName.value.isNotEmpty
            ? this.playerName.value
            : "Sarah Johnson",
      };

      print('📤 Request body: $requestBody');

      final response = await http.post(
        Uri.parse(ApiEndpoints.submitScore),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Decoded data: $data');

        scoreResponse.value = ScoreResponse.fromJson(data);

        print('✅ Parsed successfully!');
        print('   Final Score: ${scoreResponse.value?.finalScore}');
        print('   Feedback: ${scoreResponse.value?.feedback}');
        print('   Relevance: ${scoreResponse.value?.relevanceScore}');
        print('   Suggestion: ${scoreResponse.value?.suggestion}');

      } else {
        errorMessage.value = 'Failed to fetch score: ${response.statusCode}';
        print('❌ Error: ${errorMessage.value}');

        // Fallback to mock data for development
        _createMockScore();
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error: $e';
      print('❌ Exception: $e');
      print('Stack trace: $stackTrace');

      // Fallback to mock data for development
      _createMockScore();
    } finally {
      isLoading(false);
    }
  }

  void _createMockScore() {
    print('⚠️ Using mock score data (API failed)');

    scoreResponse.value = ScoreResponse(
      finalScore: 89,
      relevanceScore: 95,
      suggestion: "Excellent strategic thinking with a comprehensive digital transformation approach. The timeline is realistic and the three-phase implementation shows strong project management skills.",
      qualityAssessment: "Excellent",
      description: "The response demonstrates thorough understanding of customer service improvement strategies. The three-phase implementation plan shows strong project management capabilities.",
      scoreBreakdown: ScoreBreakdown(
        charity: "22/25",
        strategicThinking: "20/25",
        feasibility: "23/25",
        innovation: "24/25",
      ),
      feedback: "Provide more detailed steps on how you would check and resolve the billing issue. Consider adding specific metrics for measuring success and contingency plans for potential challenges.",
    );

    print('✅ Mock score created: ${scoreResponse.value?.finalScore}');
  }

  void refreshScore() {
    fetchScore(
      answerData: answerData.value,
      questionText: questionText.value,
      playerName: playerName.value,
    );
  }
}



// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../api_models/evaluate_response.dart';
// import '../api_urls.dart';
//
// class ScoreController extends GetxController {
//   var scoreResponse = Rxn<ScoreResponse>();
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//
//   // Enhanced fetchScore method with parameters
//   Future<void> fetchScore({
//     String? answerData,
//     String? questionText,
//     String? playerName,
//   }) async {
//     try {
//       isLoading(true);
//       errorMessage.value = '';
//
//       print('🔄 [Web] Fetching score with parameters:');
//       print('   - Answer: $answerData');
//       print('   - Question: $questionText');
//       print('   - Player: $playerName');
//
//       final Map<String, dynamic> requestBody = {
//         'answer': answerData ?? '',
//         'question': questionText ?? '',
//         'playerName': playerName ?? '',
//         'timestamp': DateTime.now().toIso8601String(),
//       };
//
//       final response = await http.post(
//         Uri.parse(ApiEndpoints.evaluateResponse), // Use your actual endpoint
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode(requestBody),
//       );
//
//       print('📡 [Web] Response status: ${response.statusCode}');
//       print('📡 [Web] Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         print('✅ [Web] Decoded data: $data');
//
//         scoreResponse.value = ScoreResponse.fromJson(data);
//
//         print('✅ [Web] Parsed successfully!');
//         print('   - Final Score: ${scoreResponse.value?.finalScore}');
//         print('   - Feedback: ${scoreResponse.value?.feedback}');
//         print('   - Relevance Score: ${scoreResponse.value?.relevanceScore}');
//         print('   - Suggestion: ${scoreResponse.value?.suggestion}');
//       } else {
//         errorMessage.value = 'Failed to fetch score: ${response.statusCode} - ${response.reasonPhrase}';
//         print('❌ [Web] Error: $errorMessage');
//       }
//     } catch (e, stackTrace) {
//       errorMessage.value = 'Error: ${e.toString()}';
//       print('❌ [Web] Exception: $e');
//       print('❌ [Web] Stack trace: $stackTrace');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // Refresh method
//   void refreshScore() {
//     fetchScore();
//   }
//
//   // Clear score data
//   void clearScore() {
//     scoreResponse.value = null;
//     errorMessage.value = '';
//   }
// }