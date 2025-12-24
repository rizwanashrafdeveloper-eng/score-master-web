import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scorer_web/constants/app_routes.dart';
import 'dart:convert';

import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';
import 'login_controller_web.dart';
import 'package:flutter/material.dart';

class JoinSessionController extends GetxController {
  var isLoading = false.obs;
  var codeController = ''.obs;
  final authController = Get.find<AuthController>();

  Future<void> joinSession(int playerId, String joinCode) async {
    // ✅ FIX 1: Validate inputs first
    if (joinCode.isEmpty) {
      Get.snackbar(
        "error".tr,
        "please_enter_session_code".tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (playerId == 0) {
      Get.snackbar(
        "error".tr,
        "invalid_player_id".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // ✅ FIX 2: Get AuthController and ensure user is loaded

    print('🔐 [JoinSessionController] Checking auth state...');
    print('👤 [JoinSessionController] Current user: ${authController.user.value?.name}');
    print('🎫 [JoinSessionController] Current token: ${authController.token.value.isNotEmpty ? "Present" : "Missing"}');

    // ✅ FIX 3: If no user or token, try loading from storage
    if (authController.user.value == null || authController.token.value.isEmpty) {
      print('⚠️ [JoinSessionController] Auth state invalid, loading from storage...');
      await authController.loadUserFromStorage();

      // ✅ FIX 4: After loading, check again
      if (authController.user.value == null || authController.token.value.isEmpty) {
        print('❌ [JoinSessionController] Still no valid auth after loading from storage');
        Get.snackbar(
          "authentication_error".tr,
          "session_expired_login_again".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // ✅ Redirect to login after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          Get.offAllNamed(RouteName.chooseYourRoleScreen);
        });
        return;
      }
    }

    // ✅ FIX 5: Use token from AuthController (not SharedPreferences)
    final token = authController.token.value;
    print('🔑 [JoinSessionController] Using token: ${token.substring(0, 20)}...');

    isLoading.value = true;
    final url = Uri.parse("https://score-master-backend.onrender.com/sessions/join");
    final body = jsonEncode({
      "playerId": playerId,
      "joinCode": joinCode,
    });

    print('📡 [JoinSessionController] Sending POST request to $url');
    print('📌 [JoinSessionController] Request body: $body');

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
        final gameFormatId = responseData['gameFormatId'];

        // ✅ Save all IDs
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

        Get.snackbar(
          "success".tr,
          "joined_session_successfully".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        print('✅ [JoinSessionController] Successfully joined session, navigating...');

        // ✅ Clear the code field
        codeController.value = '';

        // ✅ Navigate to player game screen
        Get.toNamed(RouteName.playerLoginPlaySide);
      } else {
        print('❌ [JoinSessionController] Failed to join session: ${response.statusCode}');

        // ✅ Parse error message
        String errorMessage = "failed_join_session".tr;
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          // Use default message if parsing fails
        }

        Get.snackbar(
          "error".tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('⚠️ [JoinSessionController] Error joining session: $e');
      Get.snackbar(
        "error".tr,
        "something_went_wrong".tr + ": $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      print('⏹️ [JoinSessionController] isLoading set to false');
    }
  }
}


//
//
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:scorer_web/constants/app_routes.dart';
// import 'dart:convert';
//
// import '../../constants/route_name.dart';
// import '../../shared_preference/shared_preference.dart';
// import 'login_controller_web.dart';
// import 'package:flutter/material.dart';
// class JoinSessionController extends GetxController {
//   var isLoading = false.obs;
//   var codeController = ''.obs;
//
//
//
//   Future<void> joinSession(int playerId, String joinCode) async {
//     final authController = Get.find<AuthController>();
//     if (authController.user.value == null || authController.token.value.isEmpty) {
//       print('⚠️ [JoinSessionController] Auth state invalid, loading from storage...');
//       await authController.loadUserFromStorage();
//
//       if (authController.user.value == null) {
//         Get.snackbar(
//           "Authentication Error",
//           "Please login again",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//     }
//
//     // ✅ Use token from AuthController
//     final token = authController.token.value;
//     if (token.isEmpty) {
//       Get.snackbar("Error", "No token found. Please login first.");
//       print('⚠️ [JoinSessionController] No auth token found');
//       isLoading.value = false;
//       return;
//     }
//
//     isLoading.value = true;
//     final url = Uri.parse("https://score-master-backend.onrender.com/sessions/join");
//     final body = jsonEncode({
//       "playerId": playerId,
//       "joinCode": joinCode,
//     });
//
//     print('📡 [JoinSessionController] Sending POST request to $url');
//     print('📌 [JoinSessionController] Request body: $body');
//
//     // final token = await SharedPrefServices.getAuthToken();
//     // if (token == null) {
//     //   Get.snackbar("Error", "No token found. Please login first.");
//     //   print('⚠️ [JoinSessionController] No auth token found');
//     //   isLoading.value = false;
//     //   return;
//     // }
//     print('🔑 [JoinSessionController] Using token: $token');
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: body,
//       );
//
//       print('📥 [JoinSessionController] Response status: ${response.statusCode}');
//       print('📥 [JoinSessionController] Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//
//         final sessionId = responseData['sessionId'];
//         final teamId = responseData['teamId'];
//         final gameFormatId = responseData['gameFormatId']; // correctly fetch
//
//         if (sessionId != null) {
//           await SharedPrefServices.saveSessionId(sessionId);
//           print("💾 [JoinSessionController] Saved sessionId: $sessionId");
//         }
//         if (teamId != null) {
//           await SharedPrefServices.saveTeamId(teamId);
//           print("💾 [JoinSessionController] Saved teamId: $teamId");
//         }
//         if (gameFormatId != null) {
//           await SharedPrefServices.saveGameId(gameFormatId);
//           print("💾 [JoinSessionController] Saved gameFormatId: $gameFormatId");
//         }
//
//         Get.snackbar("Success", "Joined session successfully!");
//         print('✅ [JoinSessionController] Successfully joined session, navigating to playerLoginPlaySide');
//         Get.toNamed(RouteName.playerLoginPlaySide);
//       } else {
//         print('❌ [JoinSessionController] Failed to join session: ${response.statusCode} ${response.body}');
//         Get.snackbar(
//           "Error",
//           "Failed to join session: ${response.statusCode} ${response.body}",
//         );
//       }
//     } catch (e) {
//       print('⚠️ [JoinSessionController] Error joining session: $e');
//       Get.snackbar("Error", "Something went wrong: $e");
//     } finally {
//       isLoading.value = false;
//       print('⏹️ [JoinSessionController] isLoading set to false');
//     }
//   }
// }
