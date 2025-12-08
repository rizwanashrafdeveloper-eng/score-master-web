import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scorer_web/api/api_urls.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/facilitator_schedule_and_active_model.dart';


class FacilitatorScheduleAndActiveSessionController extends GetxController {
  final isLoading = false.obs;
  final facilitatorScheduleAndActiveSession =
      FacilitatorScheduleAndActiveSessionModel().obs;

  /// Fetch facilitator sessions by user ID (fallback to facilitator ID)
  Future<void> fetchFacilitatorSessions() async {
    try {
      isLoading.value = true;

      // ✅ FIRST TRY: Get facilitator ID
      var facilitatorId = await SharedPrefServices.getFacilitatorId();

      // ✅ FALLBACK: If facilitator ID is null, try user ID
      if (facilitatorId == null) {
        final userId = await SharedPrefServices.getUserId();
        if (userId != null) {
          facilitatorId = int.tryParse(userId);
          print('🔄 [WebFacilitator] Using user ID as facilitator ID: $facilitatorId');
        }
      }

      if (facilitatorId == null) {
        log("❌ Facilitator ID and User ID not found in shared preferences");
        Get.snackbar('Error', 'User information not found. Please login again.');
        return;
      }

      final url = Uri.parse(
          '${ApiEndpoints.baseUrl}/sessions/facilitator?facilitatorId=$facilitatorId');
      log("🌐 [WebFacilitator] Fetching Facilitator Sessions from $url");

      final token = await SharedPrefServices.getAuthToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      log("📥 [WebFacilitator] API Response [${response.statusCode}] => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        facilitatorScheduleAndActiveSession.value =
            FacilitatorScheduleAndActiveSessionModel.fromJson(jsonData);
        log("✅ [WebFacilitator] Facilitator sessions parsed successfully");

        // Debug: Print session counts
        final activeCount = facilitatorScheduleAndActiveSession.value.activeSessions?.length ?? 0;
        final scheduledCount = facilitatorScheduleAndActiveSession.value.scheduledSessions?.length ?? 0;
        log("📊 [WebFacilitator] Loaded: $activeCount active, $scheduledCount scheduled sessions");

      } else {
        log("⚠️ [WebFacilitator] Failed to load facilitator sessions (${response.statusCode})");
        Get.snackbar(
          'Error',
          'Failed to load sessions (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, s) {
      log("❌ [WebFacilitator] Exception in fetchFacilitatorSessions: $e");
      log("Stacktrace: $s");
      Get.snackbar(
        'Error',
        'Failed to load sessions: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Debug: Check what IDs are available
    _debugCheckIds();

    fetchFacilitatorSessions();
  }

  // Helper method to debug available IDs
  Future<void> _debugCheckIds() async {
    final facilitatorId = await SharedPrefServices.getFacilitatorId();
    final userId = await SharedPrefServices.getUserId();
    final userRole = await SharedPrefServices.getUserRole();

    log("🔍 [WebFacilitator] Debug IDs - FacilitatorID: $facilitatorId, UserID: $userId, Role: $userRole");
  }

  void updateSessionStatus(int sessionId, String newStatus) {
    // Find the session in the list and update status locally
    final index = facilitatorScheduleAndActiveSession.value.activeSessions
        ?.indexWhere((s) => s.id == sessionId);

    if (index != null && index != -1) {
      facilitatorScheduleAndActiveSession.value.activeSessions![index].status = newStatus;
      facilitatorScheduleAndActiveSession.refresh(); // Trigger UI update
      print("🔄 [WebFacilitator] Updated session $sessionId status to $newStatus locally.");
    }
  }
}