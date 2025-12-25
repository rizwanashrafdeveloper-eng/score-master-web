
// team_leaderboard_controller_web.dart
import 'package:get/get.dart';
import 'package:scorer_web/api/api_models/team_leaderboard_model.dart';
import 'package:scorer_web/api/api_services/team_leaderboard_service.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';

class TeamLeaderboardController extends GetxController {
  final TeamLeaderboardService _service = TeamLeaderboardService();

  var top3 = <TeamRank>[].obs;
  var remaining = <TeamRank>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  int? sessionId;

  @override
  void onInit() {
    super.onInit();
    _loadFromSharedPref();
  }

  Future<void> _loadFromSharedPref() async {
    try {
      final id = await SharedPrefServices.getSessionId();

      if (id != null && id > 0) {
        sessionId = id;
        print("✅ [TeamLeaderboardController] Using sessionId from SharedPref: $sessionId");
        await loadLeaderboard(id);
      } else {
        print("⚠️ [TeamLeaderboardController] No valid sessionId found in SharedPref.");
        errorMessage.value = 'no_session_found'.tr;
      }
    } catch (e) {
      print("❌ [TeamLeaderboardController] Error loading sessionId from SharedPref: $e");
      errorMessage.value = e.toString();
    }
  }

  Future<void> loadLeaderboard(int sessionId) async {
    print("🔹 [TeamLeaderboardController] Loading leaderboard for sessionId: $sessionId");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _service.fetchLeaderboard(sessionId);

      if (data != null) {
        print("✅ [TeamLeaderboardController] Leaderboard data fetched successfully.");
        print("   ├─ Top 3 Teams Count: ${data.top3.length}");
        print("   └─ Remaining Teams Count: ${data.remaining.length}");

        top3.assignAll(data.top3);
        remaining.assignAll(data.remaining);
      } else {
        print("⚠️ [TeamLeaderboardController] No data returned from service.");
        errorMessage.value = 'no_data_available'.tr;
      }
    } catch (e) {
      print("❌ [TeamLeaderboardController] Error loading leaderboard: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      print("🔸 [TeamLeaderboardController] Loading complete.");
    }
  }
}







// import 'package:get/get.dart';
//
// import '../../shared_preference/shared_preference.dart';
// import '../api_models/team_leaderboard_model.dart';
// import '../api_services/team_leaderboard_service.dart';
//
// class TeamLeaderboardController extends GetxController {
//   final TeamLeaderboardService _service = TeamLeaderboardService();
//
//   var top3 = <TeamRank>[].obs;
//   var remaining = <TeamRank>[].obs;
//   var isLoading = false.obs;@override
//   void onInit() {
//     super.onInit();
//     _loadFromSharedPref();
//   }
//
//   Future<void> _loadFromSharedPref() async {
//     try {
//       final prefs = await SharedPrefServices.getSessionId();
//       final sessionId = prefs ?? 0;
//
//       if (sessionId > 0) {
//         print("✅ [TeamLeaderboardController] Using sessionId from SharedPref: $sessionId");
//         await loadLeaderboard(sessionId);
//       } else {
//         print("⚠️ [TeamLeaderboardController] No valid sessionId found in SharedPref.");
//       }
//     } catch (e) {
//       print("❌ [TeamLeaderboardController] Error loading sessionId from SharedPref: $e");
//     }
//   }
//
//
//   Future<void> loadLeaderboard(int sessionId) async {
//     print("🔹 [TeamLeaderboardController] Loading leaderboard for sessionId: $sessionId");
//
//     try {
//       isLoading.value = true;
//
//       final data = await _service.fetchLeaderboard(sessionId);
//
//       if (data != null) {
//         print("✅ [TeamLeaderboardController] Leaderboard data fetched successfully.");
//         print("   ├─ Top 3 Teams Count: ${data.top3.length}");
//         print("   └─ Remaining Teams Count: ${data.remaining.length}");
//
//         top3.assignAll(data.top3);
//         remaining.assignAll(data.remaining);
//       } else {
//         print("⚠️ [TeamLeaderboardController] No data returned from service.");
//       }
//     } catch (e) {
//       print("❌ [TeamLeaderboardController] Error loading leaderboard: $e");
//     } finally {
//       isLoading.value = false;
//       print("🔸 [TeamLeaderboardController] Loading complete.");
//     }
//   }
// }
