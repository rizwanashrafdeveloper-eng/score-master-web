import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/registration_model.dart';
import '../api_urls.dart';

class RegistrationController extends GetxController {
  var isLoading = false.obs;

  /// Register a new user and save token if provided
  Future<bool> register(RegistrationModel user, {bool isAdmin = true}) async {
    // === Initialization ===
    try {
      isLoading.value = true;
      print("🔄 [RegistrationController] Starting registration for ${user.email}");

      // === API Request ===
      final response = await http.post(
        Uri.parse(ApiEndpoints.register),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      print("✅ [RegistrationController] Response received: ${response.statusCode}");
      print("📦 [RegistrationController] Response body: ${response.body}");

      // === Handle Success Response ===
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // === Save Token to SharedPreferences ===
        if (data['token'] != null) {
          await SharedPrefServices.setAuthToken(data['token']);
          print("💾 [RegistrationController] Saved token: ${data['token']}");
        }

        // === Handle Admin Registration ===
        if (isAdmin) {
          Get.snackbar("Success", "User created successfully");
          print("✅ [RegistrationController] Admin created user successfully");
          return true;
        }

        // === Handle Self-Registration Navigation ===
        print("➡️ [RegistrationController] Navigating based on role: ${user.role}");
        if (user.role.toLowerCase() == 'admin') {
          Get.offAllNamed(RouteName.adminLoginScreen);
        } else if (user.role.toLowerCase() == 'facilitator') {
          Get.offAllNamed(RouteName.facilLoginScreen);
        } else if (user.role.toLowerCase() == 'player') {
          Get.offAllNamed(RouteName.playerLoginScreen);
        }

        return true;
      } else {
        // === Handle Failed Response ===
        print("❌ [RegistrationController] Registration failed with status: ${response.statusCode}");
        Get.snackbar("Error", "Registration failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // === Handle Exceptions ===
      print("🔥 [RegistrationController] Exception during registration: $e");
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      // === Final Cleanup ===
      isLoading.value = false;
      print("✅ [RegistrationController] Registration process finished");
    }
  }
}










// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../shared_preferences/shared_preferences.dart';
// import '../../constants/routename.dart';
// import '../api_models/registration_model.dart';
// import '../api_urls.dart';
//
// class RegistrationController extends GetxController {
//   var isLoading = false.obs;
//
//   /// Returns true if registration was successful
//   Future<bool> register(RegistrationModel user, {bool isAdmin = true}) async {
//     try {
//       isLoading.value = true;
//
//       final response = await http.post(
//         Uri.parse(ApiEndpoints.register),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(user.toJson()),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//
//         if (data['token'] != null) {
//           await SharedPrefServices.setAuthToken(data['token']);
//         }
//
//         // ✅ Just show snackbar if Admin creates user
//         if (isAdmin) {
//           Get.snackbar("Success", "User created successfully");
//           return true;
//         }
//
//         // ✅ If user is self-registering → navigate
//         if (user.role.toLowerCase() == 'admin') {
//           Get.offAllNamed(RouteName.adminLoginScreen);
//         } else if (user.role.toLowerCase() == 'facilitator') {
//           Get.offAllNamed(RouteName.facilLoginScreen);
//         } else if (user.role.toLowerCase() == 'player') {
//           Get.offAllNamed(RouteName.playerLoginScreen);
//         }
//
//         return true;
//       } else {
//         Get.snackbar("Error", "Registration failed: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
