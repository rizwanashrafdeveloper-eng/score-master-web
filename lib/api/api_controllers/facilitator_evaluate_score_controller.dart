import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scorer_web/api/api_controllers/view_response_controller.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';

class FacilitatorEvaluateScoreController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;

  Future<bool> submitScore({
    required int questionId,
    required int playerId,
    required int sessionId,
    required int phaseId,
    required int finalScore,
    required int relevanceScore,
    required String suggestion,
    required String qualityAssessment,
    required String description,
    required int charityScore,
    required int strategicThinking,
    required int feasibilityScore,
    required int innovationScore,
    required int points,
  }) async {
    try {
      print('═══════════════════════════════════════════════');
      print('🎯 [SUBMIT SCORE] Submitting evaluation...');
      print('═══════════════════════════════════════════════');
      print('📊 [SUBMIT SCORE] Details:');
      print('   - Question ID: $questionId');
      print('   - Player ID: $playerId');
      print('   - Session ID: $sessionId');
      print('   - Phase ID: $phaseId');
      print('   - Final Score: $finalScore');
      print('   - Relevance: $relevanceScore');
      print('   - Points: $points');

      isLoading(true);
      errorMessage('');
      isSuccess(false);

      final token = await SharedPrefServices.getAuthToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication required';
        isLoading(false);
        print('❌ [SUBMIT SCORE] No auth token');
        return false;
      }

      print('✅ [SUBMIT SCORE] Auth token validated');

      final url = 'https://score-master-backend.onrender.com/scores';
      print('🌐 [SUBMIT SCORE] API URL: $url');

      final body = {
        'questionId': questionId,
        'playerId': playerId,
        'sessionId': sessionId,
        'phaseId': phaseId,
        'finalScore': finalScore,
        'relevanceScore': relevanceScore,
        'suggestion': suggestion,
        'qualityAssessment': qualityAssessment,
        'description': description,
        'charityScore': charityScore,
        'strategicThinking': strategicThinking,
        'feasibilityScore': feasibilityScore,
        'innovationScore': innovationScore,
        'points': points,
      };

      print('📤 [SUBMIT SCORE] Request body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      print('📥 [SUBMIT SCORE] Response status: ${response.statusCode}');
      print('📥 [SUBMIT SCORE] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ [SUBMIT SCORE] SUCCESS!');
        print('   Response data: $data');
        isSuccess(true);

        // ✅ CRITICAL: Refresh responses to show updated score
        print('🔄 [SUBMIT SCORE] Refreshing responses...');
        await _refreshResponses(playerId, questionId, finalScore);

        print('═══════════════════════════════════════════════');
        print('✅ [SUBMIT SCORE] Complete - returning true');
        print('═══════════════════════════════════════════════');

        return true;
      } else {
        errorMessage.value = 'Failed to submit score: ${response.statusCode}';
        print('❌ [SUBMIT SCORE] HTTP Error: ${response.statusCode}');
        print('   Error body: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error submitting score: $e';
      print('❌ [SUBMIT SCORE] EXCEPTION: $e');
      print('Stack trace: $stackTrace');
      return false;
    } finally {
      isLoading(false);
      print('🏁 [SUBMIT SCORE] Finished (loading=false)');
    }
  }

  Future<void> _refreshResponses(int playerId, int questionId, int score) async {
    try {
      print('═══════════════════════════════════════════════');
      print('🔄 [REFRESH RESPONSES] Starting refresh...');
      print('═══════════════════════════════════════════════');

      // Try to find and use the ViewResponsesController
      if (Get.isRegistered<ViewResponsesController>()) {
        final responsesController = Get.find<ViewResponsesController>();
        print('✅ [REFRESH RESPONSES] Found ViewResponsesController');

        // Mark as evaluated
        responsesController.markAsEvaluated(playerId, questionId, score);

        // Wait a bit for the API to update
        await Future.delayed(Duration(milliseconds: 500));

        // Fetch fresh data
        await responsesController.fetchResponses();
        print('✅ [REFRESH RESPONSES] Responses refreshed successfully');
      } else {
        print('⚠️ [REFRESH RESPONSES] ViewResponsesController not registered');
      }

      print('═══════════════════════════════════════════════');
    } catch (e) {
      print('⚠️ [REFRESH RESPONSES] Error: $e');
      // Don't fail the whole operation if refresh fails
    }
  }
}





// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:scorer_web/api/api_controllers/view_response_controller.dart';
// import 'package:scorer_web/shared_preference/shared_preference.dart';
//
// class FacilitatorEvaluateScoreController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//   final RxBool isSuccess = false.obs;
//
//   Future<bool> submitScore({
//     required int questionId,
//     required int playerId,
//     required int sessionId,
//     required int phaseId,
//     required int finalScore,
//     required int relevanceScore,
//     required String suggestion,
//     required String qualityAssessment,
//     required String description,
//     required int charityScore,
//     required int strategicThinking,
//     required int feasibilityScore,
//     required int innovationScore,
//     required int points,
//   }) async {
//     try {
//       print('🎯 Submitting evaluation score...');
//       print('   - Question ID: $questionId');
//       print('   - Player ID: $playerId');
//       print('   - Session ID: $sessionId');
//       print('   - Phase ID: $phaseId');
//       print('   - Final Score: $finalScore');
//
//       isLoading(true);
//       errorMessage('');
//       isSuccess(false);
//
//       final token = await SharedPrefServices.getAuthToken();
//       if (token == null || token.isEmpty) {
//         errorMessage.value = 'Authentication required';
//         isLoading(false);
//         return false;
//       }
//
//       final url = 'https://score-master-backend.onrender.com/scores';
//       print('🌐 API URL: $url');
//
//       final body = {
//         'questionId': questionId,
//         'playerId': playerId,
//         'sessionId': sessionId,
//         'phaseId': phaseId,
//         'finalScore': finalScore,
//         'relevanceScore': relevanceScore,
//         'suggestion': suggestion,
//         'qualityAssessment': qualityAssessment,
//         'description': description,
//         'charityScore': charityScore,
//         'strategicThinking': strategicThinking,
//         'feasibilityScore': feasibilityScore,
//         'innovationScore': innovationScore,
//         'points': points,
//       };
//
//       print('📤 Request body: ${json.encode(body)}');
//
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(body),
//       );
//
//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         print('✅ Score submitted successfully: $data');
//         isSuccess(true);
//
//         // Refresh responses after successful submission
//         await _refreshResponses();
//
//         return true;
//       } else {
//         errorMessage.value = 'Failed to submit score: ${response.statusCode}';
//         print('❌ Error: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'Error submitting score: $e';
//       print('❌ Exception: $e');
//       return false;
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> _refreshResponses() async {
//     try {
//       // Get the responses controller and refresh
//       final responsesController = Get.put(ViewResponsesController());
//       await responsesController.fetchResponses();
//       print('🔄 Responses refreshed after score submission');
//     } catch (e) {
//       print('⚠️ Could not refresh responses: $e');
//     }
//   }
// }