import 'package:get/get.dart';
import 'package:scorer_web/api/api_controllers/session_controller.dart';

import '../../api/api_controllers/session_list_controller.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/session_list_model.dart';
import '../api_services/session_list_service.dart';
import 'dart:developer' as developer;

class SessionsListController extends GetxController {
  var isLoading = false.obs;
  var scheduledSessions = <SessionSummary>[].obs;
  var activeSessions = <SessionSummary>[].obs;

  final SessionsListService _service = SessionsListService();
  final SessionController sessionController = Get.put(SessionController());

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      isLoading(true);
      developer.log('Fetching sessions list', name: 'SessionsListController');

      final result = await _service.fetchAllSessions();

      if (result != null) {
        scheduledSessions.assignAll(result.scheduledSessions);
        activeSessions.assignAll(result.activeSessions);
        developer.log('Loaded ${scheduledSessions.length} scheduled and ${activeSessions.length} active sessions',
            name: 'SessionsListController');
      } else {
        developer.log('Failed to fetch sessions', name: 'SessionsListController');
        scheduledSessions.clear();
        activeSessions.clear();
      }
    } catch (e) {
      developer.log('Error in fetchSessions: $e', name: 'SessionsListController');
      Get.snackbar(
        'Error',
        'Failed to load sessions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectSession(int sessionId, {String? routeName}) async {
    try {
      developer.log('Session $sessionId selected', name: 'SessionsListController');

      await SharedPrefServices.saveSessionId(sessionId);
      developer.log('Session ID saved to SharedPreferences', name: 'SessionsListController');

      if (routeName != null) {
        Get.toNamed(routeName);
      }

      developer.log('Navigated to session detail', name: 'SessionsListController');

    } catch (e) {
      developer.log('Error selecting session: $e', name: 'SessionsListController');
      Get.snackbar(
        'Error',
        'Failed to load session',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshSessions() async {
    await fetchSessions();
  }

  int get totalSessions => scheduledSessions.length + activeSessions.length;
}

// import 'package:get/get.dart';
// import 'package:scorer/api/api_controllers/session_controller.dart';
// import 'package:scorer/shared_preferences/shared_preferences.dart';
// import '../api_models/session_list_model.dart';
// import '../api_services/session_list_service.dart';
// import 'dart:developer' as developer;
//
// class SessionsListController extends GetxController {
//   var isLoading = false.obs;
//   var scheduledSessions = <SessionSummary>[].obs;
//   var activeSessions = <SessionSummary>[].obs;
//
//   final SessionsListService _service = SessionsListService();
//   final SessionController sessionController = Get.find<SessionController>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchSessions();
//   }
//
//   Future<void> fetchSessions() async {
//     try {
//       isLoading(true);
//       developer.log('Fetching sessions list', name: 'SessionsListController');
//
//       final result = await _service.fetchAllSessions();
//
//       if (result != null) {
//         scheduledSessions.assignAll(result.scheduledSessions);
//         activeSessions.assignAll(result.activeSessions);
//         developer.log('Loaded ${scheduledSessions.length} scheduled and ${activeSessions.length} active sessions',
//             name: 'SessionsListController');
//       } else {
//         developer.log('Failed to fetch sessions', name: 'SessionsListController');
//         scheduledSessions.clear();
//         activeSessions.clear();
//       }
//     } catch (e) {
//       developer.log('Error in fetchSessions: $e', name: 'SessionsListController');
//       Get.snackbar(
//         'Error',
//         'Failed to load sessions',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> selectSession(int sessionId, {String? routeName}) async {
//     try {
//       developer.log('Session $sessionId selected', name: 'SessionsListController');
//
//       await SharedPrefServices.saveSessionId(sessionId);
//       developer.log('Session ID saved to SharedPreferences', name: 'SessionsListController');
//
//       if (routeName != null) {
//         Get.toNamed(routeName);
//       }
//
//       developer.log('Navigated to session detail', name: 'SessionsListController');
//
//     } catch (e) {
//       developer.log('Error selecting session: $e', name: 'SessionsListController');
//       Get.snackbar(
//         'Error',
//         'Failed to load session',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   Future<void> refreshSessions() async {
//     await fetchSessions();
//   }
//
//   int get totalSessions => scheduledSessions.length + activeSessions.length;
// }
