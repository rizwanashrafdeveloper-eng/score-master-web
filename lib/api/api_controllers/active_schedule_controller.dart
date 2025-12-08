import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/schedule_and_active_session_model.dart';
import '../api_urls.dart';

class ActiveAndSessionController extends GetxController {
  final isLoading = false.obs;
  final scheduleAndActiveSession = ScheduleAndActiveSessionModel().obs;
  final selectedIndex = 0.obs;

  // ✅ NEW: Search query
  final searchQuery = ''.obs;
  /// ✅ Fetch all sessions (Admin)
  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      log("🚀 [fetchSessions] Fetching all sessions for Admin...");

      final token = await SharedPrefServices.getAuthToken() ?? '';
      final url = Uri.parse('${ApiEndpoints.baseUrl}/sessions/all');

      log("🌐 Fetching from $url");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log("📥 Response [${response.statusCode}] => ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        scheduleAndActiveSession.value =
            ScheduleAndActiveSessionModel.fromJson(jsonData);
        log("✅ Sessions parsed successfully");
      } else {
        log("⚠️ Failed to load sessions (${response.statusCode})");
        Get.snackbar(
          'Error',
          'Failed to load sessions (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, s) {
      log("❌ Exception in fetchSessions: $e");
      log("Stacktrace: $s");
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      log("✅ [fetchSessions] Done loading");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }
  // ✅ Get filtered active sessions based on search
  List<ActiveSessions> get filteredActiveSessions {
    final sessions = scheduleAndActiveSession.value.activeSessions ?? [];
    if (searchQuery.value.isEmpty) return sessions;

    final query = searchQuery.value.toLowerCase();
    return sessions.where((session) {
      final title = (session.teamTitle ?? '').toLowerCase();
      final description = (session.description ?? '').toLowerCase();
      final status = (session.status ?? '').toLowerCase();
      return title.contains(query) ||
          description.contains(query) ||
          status.contains(query);
    }).toList();
  }

  // ✅ Get filtered scheduled sessions based on search
  List<ScheduledSessions> get filteredScheduledSessions {
    final sessions = scheduleAndActiveSession.value.scheduledSessions ?? [];
    if (searchQuery.value.isEmpty) return sessions;

    final query = searchQuery.value.toLowerCase();
    return sessions.where((session) {
      final title = (session.teamTitle ?? '').toLowerCase();
      final description = (session.description ?? '').toLowerCase();
      final startTime = (session.startTime ?? '').toLowerCase();
      return title.contains(query) ||
          description.contains(query) ||
          startTime.contains(query);
    }).toList();
  }

  Future<void> fetchScheduleAndActiveSessions() async {
    print("[fetchScheduleAndActiveSessions] Started fetching sessions...");
    try {
      isLoading.value = true;
      print("[fetchScheduleAndActiveSessions] Loading state set to true");

      final token = await SharedPrefServices.getAuthToken() ?? '';
      final url = ApiEndpoints.scheduleAndActiveSession;
      print("[fetchScheduleAndActiveSessions] API URL -> $url");

      final response = await http.get(
        Uri.parse(ApiEndpoints.scheduleAndActiveSession),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );
      print("[fetchScheduleAndActiveSessions] Response status: ${response.statusCode}");
      print("[fetchScheduleAndActiveSessions] Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("[fetchScheduleAndActiveSessions] API Response Body: $jsonData");

        scheduleAndActiveSession.value = ScheduleAndActiveSessionModel.fromJson(jsonData);
        print("[fetchScheduleAndActiveSessions] Parsed Model: ${scheduleAndActiveSession.value}");
      } else {
        print("[fetchScheduleAndActiveSessions] Error: Status Code -> ${response.statusCode}");
        Get.snackbar(
          'Error',
          'Failed to fetch sessions: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("[fetchScheduleAndActiveSessions] Exception occurred: $e");
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print("[fetchScheduleAndActiveSessions] Loading state set to false ✅");
    }
  }

  void changeTabIndex(int index) {
    print("[changeTabIndex] Changing index from ${selectedIndex.value} → $index");
    selectedIndex.value = index;
  }

  void updateSessionStatus(int sessionId, String newStatus) {
    // Find the session in the list and update status locally
    final index = scheduleAndActiveSession.value.activeSessions
        ?.indexWhere((s) => s.id == sessionId);

    if (index != null && index != -1) {
      scheduleAndActiveSession.value.activeSessions![index].status = newStatus;
      scheduleAndActiveSession.refresh(); // Trigger UI update
      print("🔄 Updated session $sessionId status to $newStatus locally.");
    }
  }


}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../shared_preferences/shared_preferences.dart';
// import '../api_models/schedule_and_active_session_model.dart';
//
// import '../api_urls.dart';
// import 'session_action_controller.dart';
//
// class ActiveAndSessionController extends GetxController {
//   final isLoading = false.obs;
//   final scheduleAndActiveSession = ScheduleAndActiveSessionModel().obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchScheduleAndActiveSessions();
//   }
//
//   /// Fetch all scheduled and active sessions for the admin
//   Future<void> fetchScheduleAndActiveSessions() async {
//     try {
//       isLoading.value = true;
//       final token = await SharedPrefServices.getAuthToken() ?? '';
//
//       final url = ApiEndpoints.scheduleAndActiveSession;
//       print('[ActiveAndSessionController] Fetching sessions from: $url');
//       print('[ActiveAndSessionController] Using token: ${token.isNotEmpty ? "YES" : "NO"}');
//
//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//       };
//
//       final response = await http.get(Uri.parse(url), headers: headers);
//
//       print('[ActiveAndSessionController] Status: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         scheduleAndActiveSession.value = ScheduleAndActiveSessionModel.fromJson(jsonData);
//
//         // ✅ sync session statuses to SessionActionController
//         updateSessionStatuses();
//
//         print('[ActiveAndSessionController] ✅ Sessions fetched successfully');
//       } else {
//         print('[ActiveAndSessionController] ❌ Failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('[ActiveAndSessionController] ⚠️ Exception: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Sync session statuses with SessionActionController
//   void updateSessionStatuses() {
//     if (Get.isRegistered<SessionActionController>()) {
//       final sessionController = Get.find<SessionActionController>();
//       sessionController.sessionStatusMap.clear();
//
//       // Add active sessions
//       scheduleAndActiveSession.value.activeSessions?.forEach((session) {
//         if (session.id != null) {
//           sessionController.sessionStatusMap[session.id!] = session.status ?? 'ACTIVE';
//         }
//       });
//
//       // Add scheduled sessions
//       scheduleAndActiveSession.value.scheduledSessions?.forEach((session) {
//         if (session.id != null) {
//           sessionController.sessionStatusMap[session.id!] = session.status ?? 'SCHEDULED';
//         }
//       });
//
//       sessionController.update();
//       print('[ActiveAndSessionController] 🔄 Session statuses synced');
//     }
//   }
// }
