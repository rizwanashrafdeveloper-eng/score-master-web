import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared_preference/shared_preference.dart';
import '../api_endpoints/api_end_points.dart'; // Import your API endpoints
import '../api_models/end-session_model.dart';

class EndSessionController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<EndSessionModel?> sessionData = Rx<EndSessionModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  Future<bool> completeSession() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      print('🎯 [END SESSION] Starting session completion...');

      // Get session ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getInt('session_id');

      print('📋 [END SESSION] Session ID from storage: $sessionId');

      if (sessionId == null || sessionId <= 0) {
        errorMessage.value = 'Session ID not found or invalid';
        print('❌ [END SESSION] Invalid session ID: $sessionId');

        Get.snackbar(
          'Error',
          'No active session found. Please select a session first.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }

      // Get auth token
      final token = await SharedPrefServices.getAuthToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication required';
        print('❌ [END SESSION] No auth token found');

        Get.snackbar(
          'Authentication Error',
          'Please login again to continue',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      }

      print('✅ [END SESSION] Auth token validated');

      // Make API call using your existing endpoint structure
      final url = ApiEndpoints.endSession(sessionId);
      print('🌐 [END SESSION] Calling endpoint: $url');
      print('🔑 [END SESSION] Using token: ${token.substring(0, 20)}...');

      final response = await http.patch( // Changed from POST to PATCH if that's what your API expects
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': 'COMPLETED', // or whatever your API expects
          'endedAt': DateTime.now().toIso8601String(),
        }),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - server not responding');
        },
      );

      print('📥 [END SESSION] Response Status: ${response.statusCode}');
      print('📦 [END SESSION] Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // Parse response
          final jsonData = json.decode(response.body);
          sessionData.value = EndSessionModel.fromJson(jsonData);

          successMessage.value = 'Session ended successfully';
          print('✅ [END SESSION] Session completed successfully');

          // Clear session ID from shared preferences
          await prefs.remove('session_id');
          await prefs.remove('gameFormatId');
          await prefs.remove('team_id');
          print('🗑️ [END SESSION] Cleared session data from storage');

          // Show success message
          Get.snackbar(
            'Success',
            'Session ended successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            icon: Icon(Icons.check_circle, color: Colors.white),
          );

          return true;
        } catch (parseError) {
          errorMessage.value = 'Failed to parse response: $parseError';
          print('❌ [END SESSION] Parse error: $parseError');

          Get.snackbar(
            'Success',
            'Session ended (with parsing error)',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
          return true; // Still consider it successful if API returned 200
        }
      } else if (response.statusCode == 400) {
        errorMessage.value = 'Bad request - session may already be ended';
        print('❌ [END SESSION] Bad request: ${response.body}');

        Get.snackbar(
          'Already Ended',
          'This session may already be completed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Unauthorized - please login again';
        print('❌ [END SESSION] Unauthorized');

        Get.snackbar(
          'Session Expired',
          'Please login again to continue',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      } else if (response.statusCode == 404) {
        errorMessage.value = 'Session not found';
        print('❌ [END SESSION] Session not found');

        Get.snackbar(
          'Not Found',
          'Session not found or already removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      } else if (response.statusCode == 409) {
        errorMessage.value = 'Session conflict - may be in progress';
        print('❌ [END SESSION] Conflict: ${response.body}');

        Get.snackbar(
          'Conflict',
          'Cannot end session while active. Please pause first.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return false;
      } else {
        errorMessage.value = 'Failed to end session: ${response.statusCode}';
        print('❌ [END SESSION] HTTP Error ${response.statusCode}: ${response.body}');

        try {
          final errorJson = json.decode(response.body);
          final errorMsg = errorJson['message'] ?? errorJson['error'] ?? 'Unknown error';

          Get.snackbar(
            'Error ${response.statusCode}',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        } catch (e) {
          Get.snackbar(
            'Error ${response.statusCode}',
            'Failed to end session. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
        return false;
      }
    } on http.ClientException catch (e) {
      errorMessage.value = 'Network error: ${e.message}';
      print('❌ [END SESSION] Network error: $e');

      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } on Exception catch (e) {
      errorMessage.value = 'Error: $e';
      print('❌ [END SESSION] Exception: $e');

      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
      print('🏁 [END SESSION] Process completed');
    }
  }

  // Alternative method: End session with specific ID (not from storage)
  Future<bool> completeSessionById(int sessionId) async {
    try {
      print('🎯 [END SESSION BY ID] Ending session $sessionId');

      // Save the session ID temporarily
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('session_id', sessionId);

      // Call the main method
      return await completeSession();
    } catch (e) {
      print('❌ [END SESSION BY ID] Error: $e');
      return false;
    }
  }

  // Check if a session can be ended (not already ended)
  Future<bool> canEndSession(int sessionId) async {
    try {
      final token = await SharedPrefServices.getAuthToken();
      if (token == null) return false;

      final url = '${ApiEndpoints.baseUrl}/sessions/$sessionId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final status = jsonData['status']?.toString().toUpperCase() ?? '';

        // Can only end ACTIVE or PAUSED sessions
        return status == 'ACTIVE' || status == 'PAUSED';
      }
      return false;
    } catch (e) {
      print('❌ [CAN END SESSION] Error: $e');
      return false;
    }
  }

  // Clear all session data
  Future<void> clearSessionData() async {
    sessionData.value = null;
    errorMessage.value = '';
    successMessage.value = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
    await prefs.remove('gameFormatId');
    await prefs.remove('team_id');
    await prefs.remove('current_session_id');
    await prefs.remove('current_phase_id');
    await prefs.remove('current_facilitator_id');

    print('🗑️ [CLEAR SESSION] All session data cleared');
  }

  // Get current session status
  Future<String?> getSessionStatus(int sessionId) async {
    try {
      final token = await SharedPrefServices.getAuthToken();
      if (token == null) return null;

      final url = '${ApiEndpoints.baseUrl}/sessions/$sessionId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData['status']?.toString();
      }
      return null;
    } catch (e) {
      print('❌ [GET STATUS] Error: $e');
      return null;
    }
  }
}



// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../api_models/end-session_model.dart';
//
//
// class EndSessionController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final Rx<EndSessionModel?> sessionData = Rx<EndSessionModel?>(null);
//   final RxString errorMessage = ''.obs;
//
//   // Base URL - update this to your actual base URL
//   static const String baseUrl = 'https://score-master-backend.onrender.com';
//
//   Future<void> completeSession() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Get session ID from shared preferences
//       final prefs = await SharedPreferences.getInstance();
//       final sessionId = prefs.getInt('session_id');
//
//       if (sessionId == null) {
//         errorMessage.value = 'Session ID not found';
//         Get.snackbar(
//           'Error',
//           'Session ID not found in storage',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: Duration(seconds: 3),
//         );
//         return;
//       }
//
//       // Make API call
//       final response = await http.post(
//         Uri.parse('$baseUrl/sessions/$sessionId/complete'),
//         headers: {
//           'Content-Type': 'application/json',
//           // Add authorization header if needed
//           // 'Authorization': 'Bearer $token',
//         },
//       ).timeout(
//         Duration(seconds: 30),
//         onTimeout: () {
//           throw Exception('Request timeout');
//         },
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Parse response
//         final jsonData = json.decode(response.body);
//         sessionData.value = EndSessionModel.fromJson(jsonData);
//
//         // Show success message
//         Get.snackbar(
//           'Success',
//           'Session ended successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: Duration(seconds: 3),
//         );
//
//         // Optional: Clear session ID from shared preferences
//         await prefs.remove('session_id');
//
//         // Optional: Navigate to another screen
//         // Get.offAllNamed('/home');
//       } else {
//         errorMessage.value = 'Failed to end session: ${response.statusCode}';
//         Get.snackbar(
//           'Error',
//           'Failed to end session. Please try again.',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar(
//         'Error',
//         'An error occurred: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Optional: Get session ID from shared preferences
//   Future<int?> getSessionId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('session_id');
//   }
//
//   // Optional: Clear session data
//   void clearSessionData() {
//     sessionData.value = null;
//     errorMessage.value = '';
//   }
// }