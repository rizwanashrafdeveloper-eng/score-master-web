// player_leaderboard_controller_web.dart
import 'package:get/get.dart';
import 'package:scorer_web/api/api_models/player_leaderboard_model.dart';
import 'package:scorer_web/api/api_services/player_leaderboard_service.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';

class PlayerLeaderboardController extends GetxController {
  final PlayerLeaderboardService _service = PlayerLeaderboardService();

  var top3 = <PlayerRank>[].obs;
  var remaining = <PlayerRank>[].obs;
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
        print("✅ [PlayerLeaderboardController] Using sessionId from SharedPref: $sessionId");
        await loadLeaderboard(id);
      } else {
        print("⚠️ [PlayerLeaderboardController] No valid sessionId found in SharedPref.");
        errorMessage.value = 'no_session_found'.tr;
      }
    } catch (e) {
      print("❌ [PlayerLeaderboardController] Error loading sessionId from SharedPref: $e");
      errorMessage.value = e.toString();
    }
  }

  Future<void> loadLeaderboard(int sessionId) async {
    print("🔹 [PlayerLeaderboardController] Loading leaderboard for sessionId: $sessionId");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _service.fetchLeaderboard(sessionId);

      if (data != null) {
        print("✅ [PlayerLeaderboardController] Leaderboard data received successfully.");
        print("   ├─ Top 3 Players Count: ${data.top3.length}");
        print("   └─ Remaining Players Count: ${data.remaining.length}");

        top3.assignAll(data.top3);
        remaining.assignAll(data.remaining);
      } else {
        print("⚠️ [PlayerLeaderboardController] No data returned from service.");
        errorMessage.value = 'no_data_available'.tr;
      }
    } catch (e) {
      print("❌ [PlayerLeaderboardController] Error loading leaderboard: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      print("🔸 [PlayerLeaderboardController] Loading complete.");
    }
  }
}

// ============================================================================

// import 'package:get/get.dart';
//
// import '../../shared_preference/shared_preference.dart';
// import '../api_models/player_leaderboard_model.dart';
// import '../api_services/player_leaderboard_service.dart';
//
// class PlayerLeaderboardController extends GetxController {
//   final PlayerLeaderboardService _service = PlayerLeaderboardService();
//
//   var top3 = <PlayerRank>[].obs;
//   var remaining = <PlayerRank>[].obs;
//   var isLoading = false.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     _loadFromSharedPref();
//   }
//
//   Future<void> _loadFromSharedPref() async {
//     try {
//       final prefs = await SharedPrefServices.getSessionId(); // your existing method
//       final sessionId = prefs ?? 0;
//
//       if (sessionId > 0) {
//         print("✅ [PlayerLeaderboardController] Using sessionId from SharedPref: $sessionId");
//         await loadLeaderboard(sessionId);
//       } else {
//         print("⚠️ [PlayerLeaderboardController] No valid sessionId found in SharedPref.");
//       }
//     } catch (e) {
//       print("❌ [PlayerLeaderboardController] Error loading sessionId from SharedPref: $e");
//     }
//   }
//
//
//   Future<void> loadLeaderboard(int sessionId) async {
//     print("🔹 [PlayerLeaderboardController] Loading leaderboard for sessionId: $sessionId");
//
//     try {
//       isLoading.value = true;
//       final data = await _service.fetchLeaderboard(sessionId);
//
//       if (data != null) {
//         print("✅ [PlayerLeaderboardController] Leaderboard data received successfully.");
//         print("   ├─ Top 3 Players Count: ${data.top3.length}");
//         print("   └─ Remaining Players Count: ${data.remaining.length}");
//
//         top3.assignAll(data.top3);
//         remaining.assignAll(data.remaining);
//       } else {
//         print("⚠️ [PlayerLeaderboardController] No data returned from service.");
//       }
//     } catch (e) {
//       print("❌ [PlayerLeaderboardController] Error loading leaderboard: $e");
//     } finally {
//       isLoading.value = false;
//       print("🔸 [PlayerLeaderboardController] Loading complete.");
//     }
//   }
// }
