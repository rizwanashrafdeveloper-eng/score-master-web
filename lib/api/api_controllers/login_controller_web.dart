import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';

// Import your user model
import '../api_models/login_response.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var user = Rxn<User>(); // ✅ ADD THIS - Same as mobile controller
  var token = ''.obs; // ✅ ADD THIS

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();
    await loadUserFromStorage();
  }
  Future<void> loadUserFromStorage() async {
    try {
      // Load token
      final token = await SharedPrefServices.getAuthToken();
      if (token != null && token.isNotEmpty) {
        this.token.value = token;
        print('🔑 [AuthController] Loaded token from storage');
      }

      // Load user profile
      final userProfile = await SharedPrefServices.getUserProfile();
      if (userProfile != null) {
        // Convert Map to User object
        final loginResponse = LoginResponse.fromJson({
          'user': userProfile,
          'token': token ?? ''
        });
        user.value = loginResponse.user;
        print('👤 [AuthController] Loaded user from storage: ${user.value?.name}');
      }
    } catch (e) {
      print('⚠️ [AuthController] Error loading user from storage: $e');
    }
  }
  Future<void> login({String? expectedRole}) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print('📩 [WebLogin] Email: $email');
    print('🔑 [WebLogin] Password: $password');

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error',  'email_password_required'.tr);
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
          Get.snackbar('Error', 'invalid_server_response'.tr);
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
            'access_denied'.tr,
            'not_authorized'.tr.replaceFirst('%s', expectedRole),
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
            Get.snackbar('error'.tr, 'unknown_role'.tr);
        }
      } else {
        print(' [WebLogin] Server responded with status ${response.statusCode}');
        String msg = '';
        try {
          msg = jsonDecode(response.body)['message'] ?? 'Login failed';
        } catch (err) {
          msg = 'Invalid response format';
        }
        Get.snackbar('login_failed'.tr, msg);
      }
    } catch (e) {
      print('🔥 [WebLogin] Exception: $e');
      Get.snackbar('error'.tr, 'network_error'.tr);
    } finally {
      isLoading.value = false;
      print('🔁 [WebLogin] Login process finished.');
    }
  }
}

