// session_action_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../shared_preference/shared_preference.dart';
import '../api_endpoints/api_end_points.dart';
import '../api_models/resume_model.dart';
import 'facilitator_schedule_and_active_controller.dart';
import 'active_schedule_controller.dart';

class SessionActionController extends GetxController {
  final isLoading = false.obs;
  final sessionStatuses = <int, String>{}.obs;
  final currentSession = Rxn<StartSessionModel>();
  final joinCode = ''.obs;
  final gameFormatId = 0.obs;
  final currentPhaseId = 1.obs;
  final phases = <Map<String, dynamic>>[].obs;

  // ✅ NEW: Track which sessions are currently processing
  final processingSessions = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print("[SessionActionController] Controller initialized");
    loadSavedSessionData();
  }

  Future<void> loadSavedSessionData() async {
    try {
      final sessionId = await SharedPrefServices.getSessionId();
      final gameId = await SharedPrefServices.getGameId();

      if (sessionId != null) print("📖 Loaded session ID: $sessionId");
      if (gameId != null) gameFormatId.value = gameId;
    } catch (e) {
      print("Error loading saved data: $e");
    }
  }

  /// ✅ Start session with proper loading state
  Future<bool> startSession(int sessionId) async {
    // Prevent rapid clicks
    if (processingSessions[sessionId] == true) return false;

    try {
      processingSessions[sessionId] = true;
      update();

      await SharedPrefServices.saveSessionId(sessionId);

      final url = ApiEndpoints.getStartSessionUrl(sessionId);
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print("Start response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final model = StartSessionModel.fromJson(data);

        // Update local state
        sessionStatuses[sessionId] = 'ACTIVE';
        await SharedPrefServices.saveGameId(model.gameFormatId ?? 0);
        await SharedPrefServices.setAuthToken(model.joinCode ?? '');
        await _fetchPhases(sessionId);

        // Refresh sessions list quietly
        _refreshSessionsQuietly();

        return true;
      } else {
        print("Failed to start session: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error starting session: $e");
      return false;
    } finally {
      processingSessions.remove(sessionId);
      update();
    }
  }

  /// ✅ Pause session with immediate UI feedback
  Future<bool> pauseSession(int sessionId) async {
    // Prevent rapid clicks
    if (processingSessions[sessionId] == true) return false;

    try {
      processingSessions[sessionId] = true;
      update();

      final token = await SharedPrefServices.getAuthToken();
      if (token == null) return false;

      final url = ApiEndpoints.getPauseSessionUrl(sessionId);

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': 'PAUSED'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Immediate local update
        sessionStatuses[sessionId] = 'PAUSED';
        update();

        // Refresh in background
        _refreshSessionsQuietly();

        return true;
      } else {
        print("Failed to pause session: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error pausing session: $e");
      return false;
    } finally {
      processingSessions.remove(sessionId);
      update();
    }
  }

  /// ✅ Resume session with immediate UI feedback
  Future<bool> resumeSession(int sessionId) async {
    // Prevent rapid clicks
    if (processingSessions[sessionId] == true) return false;

    try {
      processingSessions[sessionId] = true;
      update();

      await SharedPrefServices.saveSessionId(sessionId);

      final url = ApiEndpoints.getResumeSessionUrl(sessionId);
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Immediate local update
        sessionStatuses[sessionId] = 'ACTIVE';
        update();

        // Refresh in background
        _refreshSessionsQuietly();

        return true;
      } else {
        print("Failed to resume session: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error resuming session: $e");
      return false;
    } finally {
      processingSessions.remove(sessionId);
      update();
    }
  }

  /// ✅ Check if session is being processed
  bool isProcessing(int sessionId) {
    return processingSessions[sessionId] == true;
  }

  /// ✅ Helper to refresh sessions quietly (no UI indication)
  Future<void> _refreshSessionsQuietly() async {
    try {
      if (Get.isRegistered<ActiveAndSessionController>()) {
        final controller = Get.find<ActiveAndSessionController>();
        await controller.fetchScheduleAndActiveSessions(showLoading: false);
      }
    } catch (e) {
      print("Error refreshing sessions: $e");
    }
  }


  // Add this method to fetch phases for active sessions
  Future<void> fetchPhasesForSession(int sessionId) async {
    try {
      final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Extract current phase ID from response
        if (data['currentPhase']?['id'] != null) {
          currentPhaseId.value = data['currentPhase']['id'];
        } else if (data['currentPhaseId'] != null) {
          currentPhaseId.value = data['currentPhaseId'];
        }

        // Extract phases list
        List<dynamic> phasesList = [];
        if (data['gameFormat']?['phases'] != null) {
          phasesList = data['gameFormat']['phases'];
        } else if (data['phases'] != null) {
          phasesList = data['phases'];
        }

        final formatted = phasesList
            .map((p) => {
          'phaseId': p['id'],
          'name': p['name'],
          'order': p['order'],
          'description': p['description'],
          'isCurrent': (currentPhaseId.value == p['id']), // Mark current phase
        })
            .where((p) => p['phaseId'] != null)
            .toList()
          ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));

        phases.assignAll(formatted);
        print("✅ Loaded ${phases.length} phases for session $sessionId");
      }
    } catch (e) {
      print("Error fetching phases for session $sessionId: $e");
    }
  }

  /// ✅ Helper to fetch phases
  Future<void> _fetchPhases(int sessionId) async {
    try {
      final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> phasesList = [];

        if (data['gameFormat']?['phases'] != null) {
          phasesList = data['gameFormat']['phases'];
        } else if (data['phases'] != null) {
          phasesList = data['phases'];
        }

        final formatted = phasesList
            .map((p) => {
          'phaseId': p['id'],
          'name': p['name'],
          'order': p['order'],
          'description': p['description'],
        })
            .where((p) => p['phaseId'] != null)
            .toList()
          ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));

        phases.assignAll(formatted);
      }
    } catch (e) {
      print("Error fetching phases: $e");
    }
  }

  bool isSessionActive(int id) => (sessionStatuses[id] ?? '').toUpperCase() == 'ACTIVE';
  bool isSessionPaused(int id) => (sessionStatuses[id] ?? '').toUpperCase() == 'PAUSED';
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../shared_preference/shared_preference.dart';
// import '../api_endpoints/api_end_points.dart';
// import '../api_models/resume_model.dart';
// import 'facilitator_schedule_and_active_controller.dart'; // Add this import
// import 'active_schedule_controller.dart'; // Keep this for admin
//
// class SessionActionController extends GetxController {
//   final isLoading = false.obs;
//   final sessionStatuses = <int, String>{}.obs;
//
//   final currentSession = Rxn<StartSessionModel>();
//   final sessionStatus = ''.obs;
//   final elapsedTime = 0.obs;
//   final remainingTime = 0.obs;
//   final totalDuration = 0.obs;
//   final joinCode = ''.obs;
//   final joiningLink = ''.obs;
//   final gameFormatId = 0.obs;
//   final currentPhaseId = 1.obs;
//   final phases = <Map<String, dynamic>>[].obs;
//   final isProcessingMap = <int, bool>{}.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     print("[SessionActionController] 🎮 Controller initialized");
//     loadSavedSessionData();
//   }
//
//   Future<void> loadSavedSessionData() async {
//     try {
//       final sessionId = await SharedPrefServices.getSessionId();
//       final gameId = await SharedPrefServices.getGameId();
//       final code = await SharedPrefServices.getAuthToken();
//       final userId = await SharedPrefServices.getUserId();
//
//       if (sessionId != null) print("📖 Loaded session ID: $sessionId");
//       if (gameId != null) gameFormatId.value = gameId;
//       if (code != null) joinCode.value = code;
//       if (userId != null) print("📖 Loaded user ID: $userId");
//     } catch (e) {
//       _showErrorSnackbar('Error loading data', e.toString());
//     }
//   }
//
//   /// ✅ UPDATED: Sync session statuses from BOTH facilitator and admin APIs
//   Future<void> syncSessionStatusesFromAPI() async {
//     try {
//       // Try facilitator controller first
//       if (Get.isRegistered<FacilitatorScheduleAndActiveSessionController>()) {
//         final facilitatorController = Get.find<FacilitatorScheduleAndActiveSessionController>();
//         await facilitatorController.fetchFacilitatorSessions();
//
//         final activeSessions = facilitatorController.facilitatorScheduleAndActiveSession.value.activeSessions ?? [];
//         for (var session in activeSessions) {
//           if (session.id != null && session.status != null) {
//             sessionStatuses[session.id!] = session.status!;
//             print("[SessionActionController] 🔄 Synced facilitator session ${session.id}: ${session.status}");
//           }
//         }
//
//         final scheduledSessions = facilitatorController.facilitatorScheduleAndActiveSession.value.scheduledSessions ?? [];
//         for (var session in scheduledSessions) {
//           if (session.id != null) {
//             sessionStatuses[session.id!] = 'SCHEDULED';
//           }
//         }
//       }
//       // Fall back to admin controller
//       else if (Get.isRegistered<ActiveAndSessionController>()) {
//         final activeController = Get.find<ActiveAndSessionController>();
//         await activeController.fetchScheduleAndActiveSessions();
//
//         final activeSessions = activeController.scheduleAndActiveSession.value.activeSessions ?? [];
//         for (var session in activeSessions) {
//           if (session.id != null && session.status != null) {
//             sessionStatuses[session.id!] = session.status!;
//             print("[SessionActionController] 🔄 Synced admin session ${session.id}: ${session.status}");
//           }
//         }
//
//         final scheduledSessions = activeController.scheduleAndActiveSession.value.scheduledSessions ?? [];
//         for (var session in scheduledSessions) {
//           if (session.id != null) {
//             sessionStatuses[session.id!] = 'SCHEDULED';
//           }
//         }
//       } else {
//         print("[SessionActionController] ⚠️ No session controller found for sync");
//       }
//     } catch (e) {
//       print("[SessionActionController] ❌ Error syncing session statuses: $e");
//     }
//   }
//
//   Future<bool> startSession(int sessionId) async {
//     final current = sessionStatuses[sessionId] ?? '';
//     if (current == 'ACTIVE') {
//       _showErrorSnackbar('Cannot Start', 'The session is already active.');
//       return false;
//     }
//
//     try {
//       isLoading.value = true;
//       await SharedPrefServices.saveSessionId(sessionId);
//
//       final url = ApiEndpoints.getStartSessionUrl(sessionId);
//       final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//
//       print("🚀 Start response: ${response.statusCode}, ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final model = StartSessionModel.fromJson(data);
//         _updateSessionState(model);
//
//         sessionStatuses[sessionId] = 'ACTIVE';
//         await SharedPrefServices.saveGameId(model.gameFormatId ?? 0);
//         await SharedPrefServices.setAuthToken(model.joinCode ?? '');
//         await _fetchPhases(sessionId);
//
//         Get.snackbar('✅ Success', 'Session started successfully!',
//             backgroundColor: Colors.green, colorText: Colors.white);
//
//         await syncSessionStatusesFromAPI();
//         return true;
//       } else {
//         _showErrorSnackbar('Failed to start session', 'Status: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       _showErrorSnackbar('Error starting session', e.toString());
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> pauseSession(int sessionId) async {
//     print("⏸️ [pauseSession] Starting pause for session $sessionId");
//
//     try {
//       isLoading.value = true;
//
//       final token = await SharedPrefServices.getAuthToken();
//       if (token == null) {
//         _showErrorSnackbar('Authentication Error', 'Please login again');
//         return false;
//       }
//
//       final url = ApiEndpoints.getPauseSessionUrl(sessionId);
//       print("⏸️ [pauseSession] URL: $url");
//
//       final response = await http.patch(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'status': 'PAUSED'}),
//       );
//
//       print("⏸️ [pauseSession] Response status: ${response.statusCode}");
//       print("⏸️ [pauseSession] Response body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final model = PauseSessionModel.fromJson(data);
//
//         // Update local state
//         sessionStatuses[sessionId] = 'PAUSED';
//
//         // ✅ Update session state
//         _updateSessionState(model);
//
//         Get.snackbar(
//           '⏸️ Paused',
//           'Session paused successfully.',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//
//         // ✅ Sync from API to refresh all data
//         await syncSessionStatusesFromAPI();
//
//         return true;
//       } else {
//         final errorBody = jsonDecode(response.body);
//         _showErrorSnackbar(
//             'Failed to pause session',
//             errorBody['message'] ?? 'Status: ${response.statusCode}'
//         );
//         return false;
//       }
//     } catch (e) {
//       _showErrorSnackbar('Error pausing session', e.toString());
//       print("⏸️ [pauseSession] Error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> resumeSession(int sessionId) async {
//     final current = sessionStatuses[sessionId] ?? 'PAUSED';
//     print("[resumeSession] Session $sessionId current status: $current");
//
//     if (current.toUpperCase() != 'PAUSED') {
//       _showErrorSnackbar('Cannot Resume', 'Session $sessionId is not paused.');
//       return false;
//     }
//
//     try {
//       isLoading.value = true;
//       await SharedPrefServices.saveSessionId(sessionId);
//
//       final url = ApiEndpoints.getResumeSessionUrl(sessionId);
//       final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//
//       print("▶️ Resume response: ${response.statusCode}, ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final model = ResumeSessionModel.fromJson(data);
//         _updateSessionState(model);
//
//         // ✅ Update immediately
//         sessionStatuses[sessionId] = 'ACTIVE';
//         print("[resumeSession] ✅ Updated session $sessionId to ACTIVE");
//
//         Get.snackbar('▶️ Resumed', 'Session resumed successfully!',
//             backgroundColor: Colors.green, colorText: Colors.white);
//
//         // ✅ Sync from API
//         await syncSessionStatusesFromAPI();
//
//         return true;
//       } else {
//         _showErrorSnackbar('Failed to resume session', 'Status: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       _showErrorSnackbar('Error resuming session', e.toString());
//       print("[resumeSession] ❌ Error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> nextPhase(int sessionId) async {
//     if (!isSessionActive(sessionId)) {
//       _showErrorSnackbar('Cannot Advance Phase', 'The session is not active.');
//       return false;
//     }
//
//     try {
//       isLoading.value = true;
//       await SharedPrefServices.saveSessionId(sessionId);
//
//       final currentIndex = phases.indexWhere((p) => p['phaseId'] == currentPhaseId.value);
//       if (currentIndex == -1 || currentIndex == phases.length - 1) {
//         _showErrorSnackbar('No Next Phase', 'No more phases available.');
//         return false;
//       }
//
//       final next = phases[currentIndex + 1];
//       final url = ApiEndpoints.phaseSession;
//       final response = await http.patch(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'sessionId': sessionId, 'phaseId': next['phaseId']}),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         currentPhaseId.value = next['phaseId'];
//         Get.snackbar('⏭️ Next Phase', 'Moved to next phase',
//             backgroundColor: Colors.green, colorText: Colors.white);
//         await syncSessionStatusesFromAPI();
//         return true;
//       } else {
//         _showErrorSnackbar('Failed to advance phase', 'Status: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       _showErrorSnackbar('Error advancing phase', e.toString());
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> _fetchPhases(int sessionId) async {
//     try {
//       final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
//       final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         List<dynamic> phasesList = [];
//
//         if (data['gameFormat']?['phases'] != null) {
//           phasesList = data['gameFormat']['phases'];
//         } else if (data['phases'] != null) {
//           phasesList = data['phases'];
//         }
//
//         final formatted = phasesList
//             .map((p) => {
//           'phaseId': p['id'],
//           'name': p['name'],
//           'order': p['order'],
//           'description': p['description'],
//         })
//             .where((p) => p['phaseId'] != null)
//             .toList()
//           ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));
//
//         phases.assignAll(formatted);
//         print("✅ Loaded ${phases.length} phases");
//       } else {
//         _showErrorSnackbar('Failed to fetch phases', 'Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       _showErrorSnackbar('Error fetching phases', e.toString());
//     }
//   }
//
//   bool isSessionActive(int id) => (sessionStatuses[id] ?? '').toUpperCase() == 'ACTIVE';
//   bool isSessionPaused(int id) => (sessionStatuses[id] ?? '').toUpperCase() == 'PAUSED';
//
//   void _updateSessionState(dynamic model) {
//     if (model is StartSessionModel || model is ResumeSessionModel) {
//       sessionStatus.value = 'ACTIVE';
//     } else if (model is PauseSessionModel) {
//       sessionStatus.value = 'PAUSED';
//     }
//
//     elapsedTime.value = model.elapsedTime ?? 0;
//     totalDuration.value = model.duration ?? 0;
//     remainingTime.value = (model.duration ?? 0) - (model.elapsedTime ?? 0);
//     joinCode.value = model.joinCode ?? '';
//     joiningLink.value = model.joiningLink ?? '';
//     gameFormatId.value = model.gameFormatId ?? 0;
//   }
//
//   void _showErrorSnackbar(String title, String message) {
//     Get.snackbar('❌ $title', message,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3));
//   }
//
//
// }
//
//
//
