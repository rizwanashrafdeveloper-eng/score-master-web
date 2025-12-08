import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';

// Import your user model
import '../api_models/login_response.dart';

class LoginControllerWeb extends GetxController {
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var user = Rxn<User>(); // ✅ ADD THIS - Same as mobile controller
  var token = ''.obs; // ✅ ADD THIS

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login({String? expectedRole}) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print('📩 [WebLogin] Email: $email');
    print('🔑 [WebLogin] Password: $password');

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password are required.');
      print('❗ [WebLogin] Missing credentials.');
      return;
    }

    try {
      isLoading.value = true;

      final url = Uri.parse('https://score-master-backend.onrender.com/auth/login');
      print('🌐 [WebLogin] Sending login request to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('📦 [WebLogin] Response status: ${response.statusCode}');
      print('📨 [WebLogin] Raw response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ [WebLogin] Decoded data: $data');

        final userData = data['user'];
        final authToken = data['token'];

        if (userData == null || authToken == null) {
          print('🚨 [WebLogin] Missing user or token in response.');
          Get.snackbar('Error', 'Invalid server response.');
          return;
        }

        // ✅ CREATE USER OBJECT - Same as mobile
        final loginResponse = LoginResponse.fromJson(data);
        user.value = loginResponse.user; // ✅ SET USER OBSERVABLE
        token.value = authToken; // ✅ SET TOKEN OBSERVABLE

        print('👤 [WebLogin] User role: ${user.value?.role}');
        print('🎫 [WebLogin] Token: $authToken');

        if (expectedRole != null && user.value?.role != expectedRole) {
          print('⛔ [WebLogin] Role mismatch: expected=$expectedRole, got=${user.value?.role}');
          Get.snackbar(
            'Access Denied',
            'You are not authorized to log in as $expectedRole.',
          );
          return;
        }

        await SharedPrefServices.setAuthToken(authToken);
        await SharedPrefServices.saveUserId(user.value!.id.toString());
        await SharedPrefServices.setUserRole(user.value!.role);
        await SharedPrefServices.setUserName(user.value!.name);

        // ✅ CRITICAL FIX: Save facilitator ID when role is facilitator
        if (user.value!.role == 'facilitator') {
          await SharedPrefServices.saveFacilitatorId(user.value!.id);
          print('💾 [WebLogin] Saved facilitator ID: ${user.value!.id}');
        }

        // Also save admin ID if needed
        if (user.value!.role == 'admin') {
          await SharedPrefServices.saveUserId(user.value!.id.toString());
          print(' [WebLogin] Saved admin ID: ${user.value!.id}');
        }

        //  Also save admin ID if needed
        if (user.value!.role == 'player') {
          await SharedPrefServices.savePlayerId(user.value!.id.toString());
          print(' [WebLogin] Saved player ID: ${user.value!.id}');
        }

        if (rememberMe.value) {
          await SharedPrefServices.saveUserProfile(userData);
          print(' [WebLogin] User profile saved (Remember Me).');
        }

        print('➡ [WebLogin] Navigating to dashboard for role: ${user.value!.role}');

        switch (user.value!.role) {
          case 'admin':
            Get.offAllNamed(RouteName.adminDashboard);
            break;
          case 'facilitator':
            Get.offAllNamed(RouteName.facilitatorDashboard);
            break;
          case 'player':
            Get.offAllNamed(RouteName.playerDashboard);
            break;
          default:
            print(' [WebLogin] Unknown role: ${user.value!.role}');
            Get.snackbar('Error', 'Unknown role.');
        }
      } else {
        print(' [WebLogin] Server responded with status ${response.statusCode}');
        String msg = '';
        try {
          msg = jsonDecode(response.body)['message'] ?? 'Login failed';
        } catch (err) {
          msg = 'Invalid response format';
        }
        Get.snackbar('Login Failed', msg);
      }
    } catch (e) {
      print('🔥 [WebLogin] Exception: $e');
      Get.snackbar('Error', 'Network or server error.');
    } finally {
      isLoading.value = false;
      print('🔁 [WebLogin] Login process finished.');
    }
  }
}


// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../constants/route_name.dart';
// import '../../shared_preference/shared_preference.dart';
//
// class LoginControllerWeb extends GetxController {
//   var isLoading = false.obs;
//   var rememberMe = false.obs;
//
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   Future<void> login({String? expectedRole}) async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     print('📩 [WebLogin] Email: $email');
//     print('🔑 [WebLogin] Password: $password');
//
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar('Error', 'Email and password are required.');
//       print('❗ [WebLogin] Missing credentials.');
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final url = Uri.parse('https://score-master-backend.onrender.com/auth/login');
//       print('🌐 [WebLogin] Sending login request to: $url');
//
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );
//
//       print('📦 [WebLogin] Response status: ${response.statusCode}');
//       print('📨 [WebLogin] Raw response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         print('✅ [WebLogin] Decoded data: $data');
//
//         final user = data['user'];
//         final token = data['token'];
//
//         if (user == null || token == null) {
//           print('🚨 [WebLogin] Missing user or token in response.');
//           Get.snackbar('Error', 'Invalid server response.');
//           return;
//         }
//
//         print('👤 [WebLogin] User role: ${user['role']}');
//         print('🎫 [WebLogin] Token: $token');
//
//         if (expectedRole != null && user['role'] != expectedRole) {
//           print(
//               '⛔ [WebLogin] Role mismatch: expected=$expectedRole, got=${user['role']}');
//           Get.snackbar(
//             'Access Denied',
//             'You are not authorized to log in as $expectedRole.',
//           );
//           return;
//         }
//
//         await SharedPrefServices.setAuthToken(token);
//         await SharedPrefServices.saveUserId(user['id'].toString());
//         await SharedPrefServices.setUserRole(user['role']);
//         await SharedPrefServices.setUserName(user['name']);
//
//         // ✅ CRITICAL FIX: Save facilitator ID when role is facilitator
//         if (user['role'] == 'facilitator') {
//           await SharedPrefServices.saveFacilitatorId(user['id']);
//           print('💾 [WebLogin] Saved facilitator ID: ${user['id']}');
//         }
//
//         // ✅ Also save admin ID if needed
//         if (user['role'] == 'admin') {
//           // You can create a similar method for admin ID if needed
//           await SharedPrefServices.saveUserId(user['id'].toString());
//           print('💾 [WebLogin] Saved admin ID: ${user['id']}');
//         }
//
//         if (rememberMe.value) {
//           await SharedPrefServices.saveUserProfile(user);
//           print('💾 [WebLogin] User profile saved (Remember Me).');
//         }
//
//         print('➡️ [WebLogin] Navigating to dashboard for role: ${user['role']}');
//
//         switch (user['role']) {
//           case 'admin':
//             Get.offAllNamed(RouteName.adminDashboard);
//             break;
//           case 'facilitator':
//             Get.offAllNamed(RouteName.facilitatorDashboard);
//             break;
//           case 'player':
//             Get.offAllNamed(RouteName.playerDashboard);
//             break;
//           default:
//             print('❓ [WebLogin] Unknown role: ${user['role']}');
//             Get.snackbar('Error', 'Unknown role.');
//         }
//       } else {
//         print('❌ [WebLogin] Server responded with status ${response.statusCode}');
//         String msg = '';
//         try {
//           msg = jsonDecode(response.body)['message'] ?? 'Login failed';
//         } catch (err) {
//           msg = 'Invalid response format';
//         }
//         Get.snackbar('Login Failed', msg);
//       }
//     } catch (e) {
//       print('🔥 [WebLogin] Exception: $e');
//       Get.snackbar('Error', 'Network or server error.');
//     } finally {
//       isLoading.value = false;
//       print('🔁 [WebLogin] Login process finished.');
//     }
//   }
// }