import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_endpoints/api_end_points.dart';
import '../api_models/session_detail_model.dart';
import '../api_services/session_service.dart';

class SessionController extends GetxController {
  final SessionService _sessionService = SessionService();

  var isLoading = false.obs;
  var session = Rxn<SessionModel>();
  var errorMessage = ''.obs;
  var sessionId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSession();
  }

  Future<void> initializeSession() async {
    developer.log('[SessionController] Initializing session...', name: 'SessionController');
    try {
      // First try Get.arguments
      final argSessionId = Get.arguments?['sessionId'];

      if (argSessionId != null && argSessionId > 0) {
        sessionId.value = argSessionId;
        developer.log('[SessionController] Using sessionId from arguments: $argSessionId', name: 'SessionController');
        await fetchSession(argSessionId);
        return;
      }

      // Then try SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storedSessionId = prefs.getInt('session_id');

      if (storedSessionId != null && storedSessionId > 0) {
        sessionId.value = storedSessionId;
        developer.log('[SessionController] Using sessionId from SharedPref: $storedSessionId', name: 'SessionController');
        await fetchSession(storedSessionId);
        return;
      }

      developer.log('[SessionController] ❌ No valid session ID found', name: 'SessionController');
      errorMessage.value = "No active session found.";
    } catch (e, stack) {
      developer.log('[SessionController] ⚠️ Error: $e', name: 'SessionController', error: e);
      errorMessage.value = 'Failed to initialize session: $e';
    }
  }

  Future<void> fetchSession(int sessionId) async {
    developer.log('[SessionController] Fetching session: $sessionId', name: 'SessionController');

    if (sessionId <= 0) {
      errorMessage.value = "Invalid session ID";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _sessionService.fetchSessionDetail(sessionId);

      if (result != null) {
        session.value = result;
        developer.log('[SessionController] ✅ Session loaded: ${result.sessiontitle ?? "No title"}', name: 'SessionController');
      } else {
        errorMessage.value = "Session not found";
        developer.log('[SessionController] ❌ Session not found', name: 'SessionController');
      }
    } catch (e, stack) {
      developer.log('[SessionController] 🔥 Exception: $e', name: 'SessionController', error: e);
      errorMessage.value = e.toString();
      session.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearSession() async {
    developer.log('[SessionController] Clearing session', name: 'SessionController');
    session.value = null;
    errorMessage.value = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
  }
}