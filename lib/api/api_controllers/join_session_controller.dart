

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';

class JoinSessionController extends GetxController {
  var isLoading = false.obs;
  var codeController = ''.obs;

  Future<void> joinSession(int playerId, String joinCode) async {
    if (joinCode.trim().isEmpty) {
      Get.snackbar("Error", "Please enter a valid code");
      print('⚠️ [JoinSessionController] Attempted to join with empty code');
      return;
    }

    isLoading.value = true;
    final url = Uri.parse("https://score-master-backend.onrender.com/sessions/join");
    final body = jsonEncode({
      "playerId": playerId,
      "joinCode": joinCode,
    });

    print('📡 [JoinSessionController] Sending POST request to $url');
    print('📌 [JoinSessionController] Request body: $body');

    final token = await SharedPrefServices.getAuthToken();
    if (token == null) {
      Get.snackbar("Error", "No token found. Please login first.");
      print('⚠️ [JoinSessionController] No auth token found');
      isLoading.value = false;
      return;
    }
    print('🔑 [JoinSessionController] Using token: $token');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print('📥 [JoinSessionController] Response status: ${response.statusCode}');
      print('📥 [JoinSessionController] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        final sessionId = responseData['sessionId'];
        final teamId = responseData['teamId'];
        final gameFormatId = responseData['gameFormatId']; // correctly fetch

        if (sessionId != null) {
          await SharedPrefServices.saveSessionId(sessionId);
          print("💾 [JoinSessionController] Saved sessionId: $sessionId");
        }
        if (teamId != null) {
          await SharedPrefServices.saveTeamId(teamId);
          print("💾 [JoinSessionController] Saved teamId: $teamId");
        }
        if (gameFormatId != null) {
          await SharedPrefServices.saveGameId(gameFormatId);
          print("💾 [JoinSessionController] Saved gameFormatId: $gameFormatId");
        }

        Get.snackbar("Success", "Joined session successfully!");
        print('✅ [JoinSessionController] Successfully joined session, navigating to playerLoginPlaySide');
        Get.toNamed(RouteName.playerLoginPlaySide);
      } else {
        print('❌ [JoinSessionController] Failed to join session: ${response.statusCode} ${response.body}');
        Get.snackbar(
          "Error",
          "Failed to join session: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      print('⚠️ [JoinSessionController] Error joining session: $e');
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
      print('⏹️ [JoinSessionController] isLoading set to false');
    }
  }
}
