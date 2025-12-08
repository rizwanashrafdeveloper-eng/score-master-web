import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../shared_preference/shared_preference.dart';
import '../api_endpoints/api_end_points.dart';
import '../api_models/resume_model.dart';
import 'facilitator_schedule_and_active_controller.dart'; // Add this import
import 'active_schedule_controller.dart'; // Keep this for admin

class SessionActionController extends GetxController {
  final isLoading = false.obs;
  final sessionStatuses = <int, String>{}.obs;

  final currentSession = Rxn<StartSessionModel>();
  final sessionStatus = ''.obs;
  final elapsedTime = 0.obs;
  final remainingTime = 0.obs;
  final totalDuration = 0.obs;
  final joinCode = ''.obs;
  final joiningLink = ''.obs;
  final gameFormatId = 0.obs;
  final currentPhaseId = 1.obs;
  final phases = <Map<String, dynamic>>[].obs;
  final isProcessingMap = <int, bool>{}.obs;
  @override
  void onInit() {
    super.onInit();
    print("[SessionActionController] 🎮 Controller initialized");
    loadSavedSessionData();
  }

  Future<void> loadSavedSessionData() async {
    try {
      final sessionId = await SharedPrefServices.getSessionId();
      final gameId = await SharedPrefServices.getGameId();
      final code = await SharedPrefServices.getAuthToken();
      final userId = await SharedPrefServices.getUserId();

      if (sessionId != null) print("📖 Loaded session ID: $sessionId");
      if (gameId != null) gameFormatId.value = gameId;
      if (code != null) joinCode.value = code;
      if (userId != null) print("📖 Loaded user ID: $userId");
    } catch (e) {
      _showErrorSnackbar('Error loading data', e.toString());
    }
  }

  /// ✅ UPDATED: Sync session statuses from BOTH facilitator and admin APIs
  Future<void> syncSessionStatusesFromAPI() async {
    try {
      // Try facilitator controller first
      if (Get.isRegistered<FacilitatorScheduleAndActiveSessionController>()) {
        final facilitatorController = Get.find<FacilitatorScheduleAndActiveSessionController>();
        await facilitatorController.fetchFacilitatorSessions();

        final activeSessions = facilitatorController.facilitatorScheduleAndActiveSession.value.activeSessions ?? [];
        for (var session in activeSessions) {
          if (session.id != null && session.status != null) {
            sessionStatuses[session.id!] = session.status!;
            print("[SessionActionController] 🔄 Synced facilitator session ${session.id}: ${session.status}");
          }
        }

        final scheduledSessions = facilitatorController.facilitatorScheduleAndActiveSession.value.scheduledSessions ?? [];
        for (var session in scheduledSessions) {
          if (session.id != null) {
            sessionStatuses[session.id!] = 'SCHEDULED';
          }
        }
      }
      // Fall back to admin controller
      else if (Get.isRegistered<ActiveAndSessionController>()) {
        final activeController = Get.find<ActiveAndSessionController>();
        await activeController.fetchScheduleAndActiveSessions();

        final activeSessions = activeController.scheduleAndActiveSession.value.activeSessions ?? [];
        for (var session in activeSessions) {
          if (session.id != null && session.status != null) {
            sessionStatuses[session.id!] = session.status!;
            print("[SessionActionController] 🔄 Synced admin session ${session.id}: ${session.status}");
          }
        }

        final scheduledSessions = activeController.scheduleAndActiveSession.value.scheduledSessions ?? [];
        for (var session in scheduledSessions) {
          if (session.id != null) {
            sessionStatuses[session.id!] = 'SCHEDULED';
          }
        }
      } else {
        print("[SessionActionController] ⚠️ No session controller found for sync");
      }
    } catch (e) {
      print("[SessionActionController] ❌ Error syncing session statuses: $e");
    }
  }

  Future<bool> startSession(int sessionId) async {
    final current = sessionStatuses[sessionId] ?? '';
    if (current == 'ACTIVE') {
      _showErrorSnackbar('Cannot Start', 'The session is already active.');
      return false;
    }

    try {
      isLoading.value = true;
      await SharedPrefServices.saveSessionId(sessionId);

      final url = ApiEndpoints.getStartSessionUrl(sessionId);
      final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});

      print("🚀 Start response: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final model = StartSessionModel.fromJson(data);
        _updateSessionState(model);

        sessionStatuses[sessionId] = 'ACTIVE';
        await SharedPrefServices.saveGameId(model.gameFormatId ?? 0);
        await SharedPrefServices.setAuthToken(model.joinCode ?? '');
        await _fetchPhases(sessionId);

        Get.snackbar('✅ Success', 'Session started successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);

        await syncSessionStatusesFromAPI();
        return true;
      } else {
        _showErrorSnackbar('Failed to start session', 'Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Error starting session', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> pauseSession(int sessionId) async {
    print("⏸️ [pauseSession] Starting pause for session $sessionId");

    try {
      isLoading.value = true;

      final token = await SharedPrefServices.getAuthToken();
      if (token == null) {
        _showErrorSnackbar('Authentication Error', 'Please login again');
        return false;
      }

      final url = ApiEndpoints.getPauseSessionUrl(sessionId);
      print("⏸️ [pauseSession] URL: $url");

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': 'PAUSED'}),
      );

      print("⏸️ [pauseSession] Response status: ${response.statusCode}");
      print("⏸️ [pauseSession] Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final model = PauseSessionModel.fromJson(data);

        // Update local state
        sessionStatuses[sessionId] = 'PAUSED';

        // ✅ Update session state
        _updateSessionState(model);

        Get.snackbar(
          '⏸️ Paused',
          'Session paused successfully.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        // ✅ Sync from API to refresh all data
        await syncSessionStatusesFromAPI();

        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        _showErrorSnackbar(
            'Failed to pause session',
            errorBody['message'] ?? 'Status: ${response.statusCode}'
        );
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Error pausing session', e.toString());
      print("⏸️ [pauseSession] Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resumeSession(int sessionId) async {
    final current = sessionStatuses[sessionId] ?? 'PAUSED';
    print("[resumeSession] Session $sessionId current status: $current");

    if (current.toUpperCase() != 'PAUSED') {
      _showErrorSnackbar('Cannot Resume', 'Session $sessionId is not paused.');
      return false;
    }

    try {
      isLoading.value = true;
      await SharedPrefServices.saveSessionId(sessionId);

      final url = ApiEndpoints.getResumeSessionUrl(sessionId);
      final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});

      print("▶️ Resume response: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final model = ResumeSessionModel.fromJson(data);
        _updateSessionState(model);

        // ✅ Update immediately
        sessionStatuses[sessionId] = 'ACTIVE';
        print("[resumeSession] ✅ Updated session $sessionId to ACTIVE");

        Get.snackbar('▶️ Resumed', 'Session resumed successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);

        // ✅ Sync from API
        await syncSessionStatusesFromAPI();

        return true;
      } else {
        _showErrorSnackbar('Failed to resume session', 'Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Error resuming session', e.toString());
      print("[resumeSession] ❌ Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> nextPhase(int sessionId) async {
    if (!isSessionActive(sessionId)) {
      _showErrorSnackbar('Cannot Advance Phase', 'The session is not active.');
      return false;
    }

    try {
      isLoading.value = true;
      await SharedPrefServices.saveSessionId(sessionId);

      final currentIndex = phases.indexWhere((p) => p['phaseId'] == currentPhaseId.value);
      if (currentIndex == -1 || currentIndex == phases.length - 1) {
        _showErrorSnackbar('No Next Phase', 'No more phases available.');
        return false;
      }

      final next = phases[currentIndex + 1];
      final url = ApiEndpoints.phaseSession;
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sessionId': sessionId, 'phaseId': next['phaseId']}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        currentPhaseId.value = next['phaseId'];
        Get.snackbar('⏭️ Next Phase', 'Moved to next phase',
            backgroundColor: Colors.green, colorText: Colors.white);
        await syncSessionStatusesFromAPI();
        return true;
      } else {
        _showErrorSnackbar('Failed to advance phase', 'Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Error advancing phase', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchPhases(int sessionId) async {
    try {
      final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
      final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

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
        print("✅ Loaded ${phases.length} phases");
      } else {
        _showErrorSnackbar('Failed to fetch phases', 'Status: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Error fetching phases', e.toString());
    }
  }

  bool isSessionActive(int id) => (sessionStatuses[id] ?? '').toUpperCase() == 'ACTIVE';
  bool isSessionPaused(int id) => (sessionStatuses[id] ?? '').toUpperCase() == 'PAUSED';

  void _updateSessionState(dynamic model) {
    if (model is StartSessionModel || model is ResumeSessionModel) {
      sessionStatus.value = 'ACTIVE';
    } else if (model is PauseSessionModel) {
      sessionStatus.value = 'PAUSED';
    }

    elapsedTime.value = model.elapsedTime ?? 0;
    totalDuration.value = model.duration ?? 0;
    remainingTime.value = (model.duration ?? 0) - (model.elapsedTime ?? 0);
    joinCode.value = model.joinCode ?? '';
    joiningLink.value = model.joiningLink ?? '';
    gameFormatId.value = model.gameFormatId ?? 0;
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar('❌ $title', message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3));
  }


}






// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:scorer/api/api_urls.dart';
// import 'package:scorer/shared_preferences/shared_preferences.dart';
// import '../api_models/resume_model.dart';
// import 'active_schedule_controller.dart';
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
//
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
//   /// ✅ NEW: Sync session statuses from API
//   Future<void> syncSessionStatusesFromAPI() async {
//     if (Get.isRegistered<ActiveAndSessionController>()) {
//       final activeController = Get.find<ActiveAndSessionController>();
//
//       await activeController.fetchScheduleAndActiveSessions();
//
//       final activeSessions = activeController.scheduleAndActiveSession.value.activeSessions ?? [];
//       for (var session in activeSessions) {
//         if (session.id != null && session.status != null) {
//           sessionStatuses[session.id!] = session.status!;
//           print("[SessionActionController] 🔄 Synced session ${session.id}: ${session.status}");
//         }
//       }
//
//       final scheduledSessions = activeController.scheduleAndActiveSession.value.scheduledSessions ?? [];
//       for (var session in scheduledSessions) {
//         if (session.id != null) {
//           sessionStatuses[session.id!] = 'SCHEDULED';
//         }
//       }
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
//         Get.snackbar(
//           '⏸️ Paused',
//           'Session paused successfully.',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
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
//   //
//   // Future<bool> pauseSession(int sessionId) async {
//   //   final current = sessionStatuses[sessionId] ?? 'ACTIVE';
//   //   print("[pauseSession] Session $sessionId current status: $current");
//   //
//   //   if (current.toUpperCase() != 'ACTIVE') {
//   //     _showErrorSnackbar('Cannot Pause', 'Session $sessionId is not active.');
//   //     return false;
//   //   }
//   //
//   //   try {
//   //     isLoading.value = true;
//   //     await SharedPrefServices.saveSessionId(sessionId);
//   //
//   //     final url = ApiEndpoints.getPauseSessionUrl(sessionId);
//   //     final response = await http.patch(
//   //       Uri.parse(url),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({'status': 'PAUSED'}),
//   //     );
//   //
//   //     print("⏸️ Pause response: ${response.statusCode}, ${response.body}");
//   //
//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       final data = jsonDecode(response.body);
//   //       final model = PauseSessionModel.fromJson(data);
//   //       _updateSessionState(model);
//   //
//   //       // ✅ Update immediately
//   //       sessionStatuses[sessionId] = 'PAUSED';
//   //       print("[pauseSession] ✅ Updated session $sessionId to PAUSED");
//   //
//   //       Get.snackbar('⏸️ Paused', 'Session paused successfully.',
//   //           backgroundColor: Colors.orange, colorText: Colors.white);
//   //
//   //       // ✅ Sync from API
//   //       await syncSessionStatusesFromAPI();
//   //
//   //       return true;
//   //     } else {
//   //       _showErrorSnackbar('Failed to pause session', 'Status: ${response.statusCode}');
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     _showErrorSnackbar('Error pausing session', e.toString());
//   //     print("[pauseSession] ❌ Error: $e");
//   //     return false;
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
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
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:scorer/api/api_urls.dart';
// // import 'package:scorer/shared_preferences/shared_preferences.dart';
// // import '../api_models/resume_model.dart';
// // import 'active_schedule_controller.dart';
// //
// // class SessionActionController extends GetxController {
// //   final isLoading = false.obs;
// //   final sessionStatuses = <int, String>{}.obs;
// //   final currentSession = Rxn<StartSessionModel>();
// //   final sessionStatus = ''.obs;
// //   final elapsedTime = 0.obs;
// //   final remainingTime = 0.obs;
// //   final totalDuration = 0.obs;
// //   final joinCode = ''.obs;
// //   final joiningLink = ''.obs;
// //   final gameFormatId = 0.obs;
// //   final currentPhaseId = 1.obs;
// //   final phases = <Map<String, dynamic>>[].obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     print("[SessionActionController] 🎮 Controller initialized");
// //     loadSavedSessionData();
// //   }
// //
// //   // ==================== LOAD SAVED SESSION DATA ====================
// //   Future<void> loadSavedSessionData() async {
// //     try {
// //       final sessionId = await SharedPrefServices.getSessionId();
// //       final gameId = await SharedPrefServices.getGameId();
// //       final code = await SharedPrefServices.getAuthToken();
// //       final userId = await SharedPrefServices.getUserId();
// //
// //       if (sessionId != null) {
// //         print("[SessionActionController] 📖 Loaded saved session ID: $sessionId");
// //       }
// //       if (gameId != null) {
// //         gameFormatId.value = gameId;
// //         print("[SessionActionController] 📖 Loaded saved game ID: $gameId");
// //       }
// //       if (code != null) {
// //         joinCode.value = code;
// //         print("[SessionActionController] 📖 Loaded saved join code: $code");
// //       }
// //       if (userId != null) {
// //         print("[SessionActionController] 📖 Loaded saved user ID: $userId");
// //       }
// //     } catch (e) {
// //       print("[SessionActionController] ⚠️ Error loading saved data: $e");
// //       _showErrorSnackbar('Error loading data', e.toString());
// //     }
// //   }
// //
// //   // ==================== START SESSION ====================
// //   Future<bool> startSession(int sessionId) async {
// //     final current = sessionStatuses[sessionId] ?? '';
// //     print("[SessionActionController] 🚀 Attempting to start session ID $sessionId, current status: $current");
// //
// //     if (current == 'ACTIVE') {
// //       _showErrorSnackbar('Cannot Start', 'The session is already active.');
// //       return false;
// //     }
// //
// //     try {
// //       isLoading.value = true;
// //       await SharedPrefServices.saveSessionId(sessionId);
// //
// //       final url = ApiEndpoints.getStartSessionUrl(sessionId);
// //       final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});
// //
// //       print("[SessionActionController] 📥 Start response: ${response.statusCode}, body: ${response.body}");
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final jsonData = jsonDecode(response.body);
// //         StartSessionModel startModel = StartSessionModel.fromJson(jsonData);
// //
// //         _updateSessionState(startModel);
// //         sessionStatuses[sessionId] = 'ACTIVE';
// //
// //         if (startModel.createdById != null) await SharedPrefServices.saveUserId(startModel.createdById!);
// //         if (startModel.joinCode != null && startModel.joinCode!.isNotEmpty) await SharedPrefServices.setAuthToken(startModel.joinCode!);
// //         if (startModel.gameFormatId != null) await SharedPrefServices.saveGameId(startModel.gameFormatId!);
// //
// //         await _fetchPhases(sessionId);
// //         currentPhaseId.value = phases.isNotEmpty ? (phases.first['phaseId'] ?? 1) : 1;
// //
// //         Get.snackbar('✅ Success', 'Session started successfully!', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// //         await _refreshSessionsList();
// //         return true;
// //       } else {
// //         _showErrorSnackbar('Failed to start session', 'Status: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Error starting session', e.toString());
// //       print("[SessionActionController] ⚠️ Exception starting session ID $sessionId: $e");
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   Future<bool> pauseSession(int sessionId) async {
// //     final current = sessionStatuses[sessionId] ?? 'ACTIVE';
// //     print("[SessionActionController] ⏸️ Attempting to pause session ID $sessionId, current status: $current");
// //
// //     if (current != 'ACTIVE') {
// //       _showErrorSnackbar('Cannot Pause', 'Session ID $sessionId is not active (current: $current).');
// //       return false;
// //     }
// //
// //     try {
// //       isLoading.value = true;
// //       await SharedPrefServices.saveSessionId(sessionId);
// //
// //       final url = ApiEndpoints.getPauseSessionUrl(sessionId);
// //       final body = jsonEncode({'status': 'PAUSED'}); // send minimal valid body
// //
// //       final response = await http.patch(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //         body: body,
// //       );
// //
// //       print("[SessionActionController] 📥 Pause response for session $sessionId: ${response.statusCode}, body: ${response.body}");
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final jsonData = jsonDecode(response.body);
// //         final pauseModel = PauseSessionModel.fromJson(jsonData);
// //
// //         _updateSessionState(pauseModel);
// //         sessionStatuses[sessionId] = 'PAUSED';
// //
// //         print("[SessionActionController] ⏸️ Session ID $sessionId PAUSED ✅");
// //         Get.snackbar(
// //           '⏸️ Paused',
// //           'Session paused successfully.',
// //           snackPosition: SnackPosition.TOP,
// //           backgroundColor: Colors.orange,
// //           colorText: Colors.white,
// //         );
// //
// //         await _refreshSessionsList();
// //         return true;
// //       } else {
// //         _showErrorSnackbar('Failed to pause session', 'Status: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Error pausing session', e.toString());
// //       print("[SessionActionController] ⚠️ Exception pausing session ID $sessionId: $e");
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //
// //   // // ==================== PAUSE SESSION ====================
// //   // Future<bool> pauseSession(int sessionId) async {
// //   //   final current = sessionStatuses[sessionId] ?? 'ACTIVE';
// //   //   print("[SessionActionController] ⏸️ Attempting to pause session ID $sessionId, current status: $current");
// //   //
// //   //   if (current != 'ACTIVE') {
// //   //     _showErrorSnackbar('Cannot Pause', 'Session ID $sessionId is not active (current: $current).');
// //   //     return false;
// //   //   }
// //   //
// //   //   try {
// //   //     isLoading.value = true;
// //   //     await SharedPrefServices.saveSessionId(sessionId);
// //   //
// //   //     final url = ApiEndpoints.getPauseSessionUrl(sessionId);
// //   //     final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});
// //   //
// //   //     print("[SessionActionController] 📥 Pause response for session $sessionId: ${response.statusCode}, body: ${response.body}");
// //   //
// //   //     if (response.statusCode == 200 || response.statusCode == 201) {
// //   //       final jsonData = jsonDecode(response.body);
// //   //       PauseSessionModel pauseModel = PauseSessionModel.fromJson(jsonData);
// //   //
// //   //       _updateSessionState(pauseModel);
// //   //       sessionStatuses[sessionId] = 'PAUSED';
// //   //
// //   //       print("[SessionActionController] ⏸️ Session ID $sessionId PAUSED ✅");
// //   //       Get.snackbar('⏸️ Pause', 'Session pause successfully.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white);
// //   //
// //   //       await _refreshSessionsList();
// //   //       return true;
// //   //     } else {
// //   //       _showErrorSnackbar('Failed to pause session', 'Status: ${response.statusCode}');
// //   //       return false;
// //   //     }
// //   //   } catch (e) {
// //   //     _showErrorSnackbar('Error pausing session', e.toString());
// //   //     print("[SessionActionController] ⚠️ Exception pausing session ID $sessionId: $e");
// //   //     return false;
// //   //   } finally {
// //   //     isLoading.value = false;
// //   //   }
// //   // }
// //
// //   // ==================== RESUME SESSION ====================
// //   Future<bool> resumeSession(int sessionId) async {
// //     final current = sessionStatuses[sessionId] ?? 'PAUSED';
// //     print("[SessionActionController] ▶️ Attempting to resume session ID $sessionId, current status: $current");
// //
// //     if (current != 'PAUSED') {
// //       _showErrorSnackbar('Cannot Resume', 'Session ID $sessionId is not paused (current: $current).');
// //       return false;
// //     }
// //
// //     try {
// //       isLoading.value = true;
// //       await SharedPrefServices.saveSessionId(sessionId);
// //
// //       final url = ApiEndpoints.getResumeSessionUrl(sessionId);
// //       final response = await http.patch(Uri.parse(url), headers: {'Content-Type': 'application/json'});
// //
// //       print("[SessionActionController] 📥 Resume response for session $sessionId: ${response.statusCode}, body: ${response.body}");
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final jsonData = jsonDecode(response.body);
// //         ResumeSessionModel resumeModel = ResumeSessionModel.fromJson(jsonData);
// //
// //         _updateSessionState(resumeModel);
// //         sessionStatuses[sessionId] = 'ACTIVE';
// //
// //         print("[SessionActionController] ▶️ Session ID $sessionId resumed ✅");
// //         Get.snackbar('▶️ Resumed', 'Session resumed successfully!', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// //
// //         await _refreshSessionsList();
// //         return true;
// //       } else {
// //         _showErrorSnackbar('Failed to resume session', 'Status: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Error resuming session', e.toString());
// //       print("[SessionActionController] ⚠️ Exception resuming session ID $sessionId: $e");
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   // ==================== PER-SESSION STATUS CHECKS ====================
// //   bool isSessionActive(int sessionId) => (sessionStatuses[sessionId] ?? '').toUpperCase() == 'ACTIVE';
// //   bool isSessionPause(int sessionId) => (sessionStatuses[sessionId] ?? '').toUpperCase() == 'PAUSED';
// //
// //   // ==================== NEXT PHASE ====================
// //   Future<bool> nextPhase(int sessionId) async {
// //     if (!isSessionActive(sessionId)) {
// //       _showErrorSnackbar('Cannot Advance Phase', 'The session is not active.');
// //       return false;
// //     }
// //
// //     print("[SessionActionController] ⏭️ Advancing to next phase for session ID: $sessionId");
// //     try {
// //       isLoading.value = true;
// //       await SharedPrefServices.saveSessionId(sessionId);
// //
// //       final currentIndex = phases.indexWhere((p) => p['phaseId'] == currentPhaseId.value);
// //       if (currentIndex == -1 || currentIndex == phases.length - 1) {
// //         _showErrorSnackbar('No Next Phase', 'No more phases available.');
// //         return false;
// //       }
// //
// //       final nextPhase = phases[currentIndex + 1];
// //       final url = ApiEndpoints.phaseSession;
// //       final response = await http.patch(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'sessionId': sessionId, 'phaseId': nextPhase['phaseId']}),
// //       );
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final jsonData = jsonDecode(response.body);
// //         phases[currentIndex + 1] = jsonData;
// //         currentPhaseId.value = jsonData['phaseId'] ?? currentPhaseId.value + 1;
// //
// //         Get.snackbar('⏭️ Next Phase', 'Moved to Phase ${currentPhaseId.value}', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
// //         await _refreshSessionsList();
// //         return true;
// //       } else {
// //         _showErrorSnackbar('Failed to advance phase', 'Status: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Error advancing phase', e.toString());
// //       return false;
// //     } finally {
// //       isLoading.value = false;
// //     }
// //
// //   }
// //
// //
// //
// //
// //   // ==================== FETCH PHASES ====================
// //   Future<void> _fetchPhases(int sessionId) async {
// //     try {
// //       final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
// //       print("[SessionActionController] 🔄 Fetching phases from: $url");
// //
// //       final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
// //
// //       print("[SessionActionController] 📥 Phases response status: ${response.statusCode}");
// //       print("[SessionActionController] 📥 Phases response body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         final jsonData = jsonDecode(response.body);
// //         print("[SessionActionController] 📊 Full phases response: $jsonData");
// //
// //         // Handle the nested structure - phases are under gameFormat.phases
// //         List<dynamic> phasesList = [];
// //
// //         if (jsonData is Map<String, dynamic>) {
// //           if (jsonData['gameFormat'] != null && jsonData['gameFormat']['phases'] != null) {
// //             phasesList = jsonData['gameFormat']['phases'];
// //             print("[SessionActionController] ✅ Found ${phasesList.length} phases in gameFormat.phases");
// //           } else if (jsonData['phases'] != null) {
// //             phasesList = jsonData['phases'];
// //             print("[SessionActionController] ✅ Found ${phasesList.length} phases in root phases");
// //           } else {
// //             print("[SessionActionController] ⚠️ No phases found in response");
// //           }
// //         }
// //
// //         // Convert to the expected format
// //         final formattedPhases = phasesList.map((phase) {
// //           if (phase is Map<String, dynamic>) {
// //             return {
// //               'phaseId': phase['id'],
// //               'name': phase['name'],
// //               'description': phase['description'],
// //               'order': phase['order'],
// //               'timeDuration': phase['timeDuration'],
// //               'scoringType': phase['scoringType'],
// //               'challengeTypes': phase['challengeTypes'],
// //               'difficulty': phase['difficulty'],
// //               'badge': phase['badge'],
// //               'requiredScore': phase['requiredScore'],
// //             };
// //           }
// //           return <String, dynamic>{};
// //         }).where((phase) => phase['phaseId'] != null).toList()
// //           ..sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));
// //
// //         phases.assignAll(formattedPhases);
// //         print("[SessionActionController] 📋 Final phases list: $phases");
// //
// //       } else {
// //         print("[SessionActionController] ❌ Failed to fetch phases: ${response.statusCode}");
// //         _showErrorSnackbar('Failed to fetch phases', 'Status: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print("[SessionActionController] ⚠️ Error fetching phases: $e");
// //       _showErrorSnackbar('Error fetching phases', e.toString());
// //     }
// //   }
// //
// // // Add this method for debugging
// //   Future<void> debugPhasesAPI(int sessionId) async {
// //     try {
// //       final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
// //       print("🧪 DEBUG: Testing phases API: $url");
// //
// //       final response = await http.get(Uri.parse(url));
// //       print("🧪 DEBUG: Response status: ${response.statusCode}");
// //       print("🧪 DEBUG: Response body: ${response.body}");
// //
// //       if (response.statusCode == 200) {
// //         final jsonData = jsonDecode(response.body);
// //         print("🧪 DEBUG: Full JSON structure:");
// //         print(jsonData);
// //
// //         // Check if gameFormat exists
// //         if (jsonData['gameFormat'] != null) {
// //           print("🧪 DEBUG: gameFormat found");
// //           if (jsonData['gameFormat']['phases'] != null) {
// //             print("🧪 DEBUG: phases found under gameFormat: ${jsonData['gameFormat']['phases']}");
// //           } else {
// //             print("🧪 DEBUG: No phases under gameFormat");
// //           }
// //         } else {
// //           print("🧪 DEBUG: No gameFormat in response");
// //         }
// //       }
// //     } catch (e) {
// //       print("🧪 DEBUG: Error testing API: $e");
// //     }
// //   }
// //   //
// //   // // ==================== FETCH PHASES ====================
// //   // Future<void> _fetchPhases(int sessionId) async {
// //   //   try {
// //   //     final url = ApiEndpoints.getPhaseSessionUrl(sessionId);
// //   //     final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
// //   //
// //   //     if (response.statusCode == 200) {
// //   //       final jsonData = jsonDecode(response.body) as List;
// //   //       phases.assignAll(jsonData.cast<Map<String, dynamic>>()..sort((a, b) => (a['phaseId'] ?? 0).compareTo(b['phaseId'] ?? 0)));
// //   //     } else {
// //   //       _showErrorSnackbar('Failed to fetch phases', 'Status: ${response.statusCode}');
// //   //     }
// //   //   } catch (e) {
// //   //     _showErrorSnackbar('Error fetching phases', e.toString());
// //   //   }
// //   // }
// //
// //   // ==================== HELPER METHODS ====================
// //   void _updateSessionState(dynamic model) {
// //     currentSession.value = model is StartSessionModel ? model : currentSession.value;
// //
// //     if (model is StartSessionModel || model is ResumeSessionModel) {
// //       sessionStatus.value = 'ACTIVE';
// //     } else if (model is PauseSessionModel) {
// //       sessionStatus.value = 'PAUSED';
// //     } else {
// //       sessionStatus.value = model.status ?? 'UNKNOWN';
// //     }
// //
// //     elapsedTime.value = model.elapsedTime ?? 0;
// //     totalDuration.value = model.duration ?? 0;
// //     remainingTime.value = (model.duration ?? 0) - (model.elapsedTime ?? 0);
// //     joinCode.value = model.joinCode ?? '';
// //     joiningLink.value = model.joiningLink ?? '';
// //     gameFormatId.value = model.gameFormatId ?? 0;
// //
// //     print("[_updateSessionState] Updated sessionStatus => ${sessionStatus.value}");
// //   }
// //
// //   Future<void> _refreshSessionsList() async {
// //     try {
// //       if (Get.isRegistered<ActiveAndSessionController>()) {
// //         final activeController = Get.find<ActiveAndSessionController>();
// //         await activeController.fetchScheduleAndActiveSessions();
// //       }
// //     } catch (e) {
// //       print("[SessionActionController] ⚠️ Error refreshing sessions: $e");
// //     }
// //   }
// //
// //   void _showErrorSnackbar(String title, String message) {
// //     final shortMessage = message.length > 100 ? '${message.substring(0, 100)}...' : message;
// //     Get.snackbar('❌ $title', shortMessage, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 3), icon: const Icon(Icons.error, color: Colors.white));
// //   }
// //
// //   @override
// //   void onClose() {
// //     print("[SessionActionController] 👋 Controller disposed");
// //     super.onClose();
// //   }
// // }
// //
// //
