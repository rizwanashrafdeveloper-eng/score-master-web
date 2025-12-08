import 'dart:developer' as developer;
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../api_endpoints/api_end_points.dart';
import '../api_models/session_detail_model.dart';
import '../api_services/session_service.dart';
import 'package:http/http.dart'as http;

class SessionController extends GetxController {
  final SessionService _sessionService = SessionService();

  // Reactive variables
  var isLoading = false.obs;
  var session = Rxn<SessionModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSession();
  }

  /// Initialize session from stored session ID
  Future<void> initializeSession() async {
    final response = await http.get(Uri.parse(ApiEndpoints.sessionDetail(1)));
    developer.log('[SessionController] Initializing session...', name: 'SessionController');
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedSessionId = prefs.getInt('session_id');

      if (storedSessionId == null || storedSessionId <= 0) {
        developer.log('[SessionController] ❌ No valid session ID found in SharedPreferences.', name: 'SessionController');
        errorMessage.value = "No active session found.";
        return;
      }

      developer.log('[SessionController] Found stored sessionId: $storedSessionId', name: 'SessionController');
      await fetchSession(storedSessionId);
    } catch (e, stack) {
      developer.log('[SessionController] ⚠️ Error during initialization: $e', name: 'SessionController', error: e);
      developer.log(stack.toString(), name: 'SessionController');
      errorMessage.value = 'Failed to initialize session: $e';
    }
  }

  /// Fetch session details by ID
  Future<void> fetchSession(int sessionId) async {
    developer.log('[SessionController] Fetching session with ID: $sessionId', name: 'SessionController');

    if (sessionId <= 0) {
      errorMessage.value = "Invalid session ID";
      developer.log('[SessionController] ⚠️ Invalid session ID: $sessionId', name: 'SessionController');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _sessionService.fetchSessionDetail(sessionId);

      if (result != null) {
        session.value = result;
        developer.log('[SessionController] ✅ Session loaded successfully: ${result.sessiontitle ?? "No title"}', name: 'SessionController');
      } else {
        session.value = null;
        errorMessage.value = "Session not found";
        developer.log('[SessionController] ❌ Session not found or API returned null', name: 'SessionController');
      }
    } catch (e, stack) {
      developer.log('[SessionController] 🔥 Exception: $e', name: 'SessionController', error: e);
      developer.log(stack.toString(), name: 'SessionController');
      errorMessage.value = e.toString();
      session.value = null; // Clear session on error
    } finally {
      isLoading.value = false;
      developer.log('[SessionController] 🔄 Fetching process finished.', name: 'SessionController');
    }
  }
  /// Clears the session data
  Future<void> clearSession() async {
    developer.log('[SessionController] Clearing session data', name: 'SessionController');
    session.value = null;
    errorMessage.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
    developer.log('[SessionController] Session ID removed from SharedPreferences', name: 'SessionController');
  }
}