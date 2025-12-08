// // lib/api/api_controllers/score_controller.dart
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
//   @override
//   void onInit() {
//     super.onInit();
//     fetchScore(); // Auto-fetch on init
//   }
//
//   // Simple GET request - no parameters needed
//   Future<void> fetchScore() async {
//     try {
//       isLoading(true);
//       errorMessage.value = '';
//
//       print('Fetching score data...');
//
//       final response = await http.post(
//         Uri.parse(ApiEndpoints.submitScore), // Simple GET endpoint
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );
//
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         print('Decoded data: $data');
//
//         scoreResponse.value = ScoreResponse.fromJson(data);
//
//         print('✅ Parsed successfully!');
//         print('Final Score: ${scoreResponse.value?.finalScore}');
//         print('Feedback: ${scoreResponse.value?.feedback}');
//         print('Charity: ${scoreResponse.value?.scoreBreakdown.charity}');
//         print('Strategic: ${scoreResponse.value?.scoreBreakdown.strategicThinking}');
//         print('Feasibility: ${scoreResponse.value?.scoreBreakdown.feasibility}');
//         print('Innovation: ${scoreResponse.value?.scoreBreakdown.innovation}');
//
//       } else {
//         errorMessage.value = 'Failed to fetch score: ${response.statusCode}';
//       }
//     } catch (e, stackTrace) {
//       errorMessage.value = 'Error: $e';
//       print('Exception: $e');
//       print('Stack trace: $stackTrace');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // Refresh method
//   void refreshScore() {
//     fetchScore();
//   }
// }