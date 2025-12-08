import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_models/end-session_model.dart';


class EndSessionController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<EndSessionModel?> sessionData = Rx<EndSessionModel?>(null);
  final RxString errorMessage = ''.obs;

  // Base URL - update this to your actual base URL
  static const String baseUrl = 'https://score-master-backend.onrender.com';

  Future<void> completeSession() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get session ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getInt('session_id');

      if (sessionId == null) {
        errorMessage.value = 'Session ID not found';
        Get.snackbar(
          'Error',
          'Session ID not found in storage',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        return;
      }

      // Make API call
      final response = await http.post(
        Uri.parse('$baseUrl/sessions/$sessionId/complete'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        // Parse response
        final jsonData = json.decode(response.body);
        sessionData.value = EndSessionModel.fromJson(jsonData);

        // Show success message
        Get.snackbar(
          'Success',
          'Session ended successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );

        // Optional: Clear session ID from shared preferences
        await prefs.remove('session_id');

        // Optional: Navigate to another screen
        // Get.offAllNamed('/home');
      } else {
        errorMessage.value = 'Failed to end session: ${response.statusCode}';
        Get.snackbar(
          'Error',
          'Failed to end session. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Get session ID from shared preferences
  Future<int?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('session_id');
  }

  // Optional: Clear session data
  void clearSessionData() {
    sessionData.value = null;
    errorMessage.value = '';
  }
}