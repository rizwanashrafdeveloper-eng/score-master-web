import 'package:get/get.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/player_team_model.dart';
import '../api_services/player_team_service.dart';

class PlayerTeamController extends GetxController {
  var isLoading = false.obs;
  var team = Rxn<PlayerTeamModel>();
  var errorMessage = ''.obs;

  /// Create team for player
  Future<void> createTeam({required String nickname, required int gameFormatId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print("🔄 [PlayerTeamController] Starting team creation for: $nickname");

      // Fetch IDs from SharedPreferences
      final sessionId = await SharedPrefServices.getSessionId();
      final userIdString = await SharedPrefServices.getUserId(); // This returns String?

      print("ℹ [PlayerTeamController] Retrieved IDs → sessionId=$sessionId | gameFormatId=$gameFormatId | userId=$userIdString");

      // Validate required IDs
      if (sessionId == null || userIdString == null) {
        errorMessage.value = "Missing required IDs.";
        print("❌ [PlayerTeamController] $errorMessage");
        return;
      }

      // ✅ FIX: Convert userId from String to int
      final userId = int.tryParse(userIdString);
      if (userId == null) {
        errorMessage.value = "Invalid user ID format.";
        print("❌ [PlayerTeamController] $errorMessage");
        return;
      }

      // Prepare request model
      final newTeam = PlayerTeamModel(
        id: 0, // placeholder, backend returns real ID
        nickname: nickname,
        sessionId: sessionId,
        gameFormatId: gameFormatId,
        createdById: userId, // ✅ Now passing int
      );

      // API Request
      final result = await PlayerTeamService.createTeam(newTeam);

      if (result != null) {
        team.value = result;
        print("✅ [PlayerTeamController] Team created: ${result.nickname}");

        // Save important IDs to SharedPreferences
        await SharedPrefServices.saveTeamId(result.id);
        await SharedPrefServices.saveSessionId(result.sessionId);
        await SharedPrefServices.saveGameId(result.gameFormatId);
        await SharedPrefServices.saveUserId(result.createdById.toString()); // ✅ Convert to String

        print("💾 [PlayerTeamController] Saved IDs → teamId=${result.id}, sessionId=${result.sessionId}, gameFormatId=${result.gameFormatId}, userId=${result.createdById}");
      } else {
        errorMessage.value = "Failed to create team.";
        print("❌ [PlayerTeamController] API returned null.");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("🔥 [PlayerTeamController] Exception: $e");
    } finally {
      isLoading.value = false;
      print("✅ [PlayerTeamController] Team creation process finished");
    }
  }
}



// import 'package:get/get.dart';
// import '../../shared_preference/shared_preference.dart';
//
// import '../api_models/player_team_model.dart';
// import '../api_services/player_team_service.dart';
//
// class PlayerTeamController extends GetxController {
//   var isLoading = false.obs;
//   var team = Rxn<PlayerTeamModel>();
//   var errorMessage = ''.obs;
//
//   /// Create team for player
//   Future<void> createTeam({required String nickname, required int gameFormatId}) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       print("🔄 [PlayerTeamController] Starting team creation for: $nickname");
//
//       // Fetch IDs from SharedPreferences
//       final sessionId = await SharedPrefServices.getSessionId();
//       final userId = await SharedPrefServices.getUserId();
//
//       print("ℹ [PlayerTeamController] Retrieved IDs → sessionId=$sessionId | gameFormatId=$gameFormatId | userId=$userId");
//
//       // Validate required IDs
//       if (sessionId == null || userId == null) {
//         errorMessage.value = "Missing required IDs.";
//         print("❌ [PlayerTeamController] $errorMessage");
//         return;
//       }
//
//       // Prepare request model
//       final newTeam = PlayerTeamModel(
//         id: 0, // placeholder, backend returns real ID
//         nickname: nickname,
//         sessionId: sessionId,
//         gameFormatId: gameFormatId,
//         createdById: userId,
//       );
//
//       // API Request
//       final result = await PlayerTeamService.createTeam(newTeam);
//
//       if (result != null) {
//         team.value = result;
//         print("✅ [PlayerTeamController] Team created: ${result.nickname}");
//
//         // Save important IDs to SharedPreferences
//         await SharedPrefServices.saveTeamId(result.id);
//         await SharedPrefServices.saveSessionId(result.sessionId);
//         await SharedPrefServices.saveGameId(result.gameFormatId);
//         await SharedPrefServices.saveUserId(result.createdById);
//
//         print("💾 [PlayerTeamController] Saved IDs → teamId=${result.id}, sessionId=${result.sessionId}, gameFormatId=${result.gameFormatId}, userId=${result.createdById}");
//       } else {
//         errorMessage.value = "Failed to create team.";
//         print("❌ [PlayerTeamController] API returned null.");
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       print("🔥 [PlayerTeamController] Exception: $e");
//     } finally {
//       isLoading.value = false;
//       print("✅ [PlayerTeamController] Team creation process finished");
//     }
//   }
// }
