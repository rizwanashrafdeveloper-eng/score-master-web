import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../shared_preference/shared_preference.dart';
import '../api_urls.dart';
import '../api_models/player_model.dart';

class AdminPlayerController extends GetxController {
  var teams = <TeamModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var activePlayersCount = 0.obs;
  var inactivePlayersCount = 0.obs;

  int? sessionId;

  @override
  void onInit() {
    super.onInit();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    try {
      // First, check if passed from Get.arguments
      sessionId = Get.arguments?['sessionId'];

      // If not, load from SharedPreferences
      if (sessionId == null) {
        sessionId = await SharedPrefServices.getSessionId();
        print("📦 [AdminPlayerController] Loaded sessionId from SharedPref: $sessionId");
      } else {
        print("📦 [AdminPlayerController] Loaded sessionId from Get.arguments: $sessionId");
      }

      if (sessionId != null && sessionId! > 0) {
        await fetchTeams(sessionId!);
      } else {
        errorMessage.value = "Session ID not found";
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = "Error loading session ID: $e";
      isLoading.value = false;
    }
  }

  Future<void> fetchTeams(int sessionId) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      print('[fetchTeams] Fetching teams for sessionId=$sessionId');

      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/team/session/$sessionId/players'),
      );

      print('[fetchTeams] Response status: ${response.statusCode}');
      print('[fetchTeams] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        teams.value = data.map((json) => TeamModel.fromJson(json)).toList();
        print('[fetchTeams] Parsed teams count: ${teams.length}');

        activePlayersCount.value = teams.fold(0, (sum, team) => sum + (team.players.length));
        inactivePlayersCount.value = 0; // adjust logic if backend supports it
      } else {
        errorMessage.value = 'Failed to load teams: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}








// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../api_urls.dart';
// import '../api_models/player_model.dart';
//
// class AdminPlayerController extends GetxController {
//   var teams = <TeamModel>[].obs;
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//   var activePlayersCount = 0.obs;
//   var inactivePlayersCount = 0.obs;
//
//   int? sessionId;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch sessionId from Get.arguments if not set
//     sessionId ??= Get.arguments?['sessionId'];
//     if (sessionId != null) {
//       fetchTeams(sessionId!);
//     } else {
//       errorMessage.value = "Session ID not found";
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchTeams(int sessionId) async {
//     try {
//       isLoading(true);
//       errorMessage.value = '';
//       print('[fetchTeams] Fetching teams for sessionId=$sessionId');
//
//       final response =
//       await http.get(Uri.parse('${ApiEndpoints.baseUrl}/team/session/$sessionId/players'));
//
//       print('[fetchTeams] Response status: ${response.statusCode}');
//       print('[fetchTeams] Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         teams.value = data.map((json) => TeamModel.fromJson(json)).toList();
//         print('[fetchTeams] Parsed teams count: ${teams.length}');
//
//         activePlayersCount.value =
//             teams.fold(0, (sum, team) => sum + (team.players.length));
//         inactivePlayersCount.value = 0; // Adjust if needed
//       } else {
//         errorMessage.value = 'Failed to load teams: ${response.statusCode}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//     } finally {
//       isLoading(false);
//     }
//   }
// }
//
//
//
//
//





// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:scorer/api/api_urls.dart';
// import 'package:http/http.dart' as http;
// import '../api_models/player_model.dart'; // Assuming this is your model file path
//
// class AdminPlayerController extends GetxController {
//   var teams = <TeamModel>[].obs;
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//   var activePlayersCount = 0.obs; // Dynamic active count
//   var inactivePlayersCount = 0.obs; // Dynamic inactive count
//
//   @override
//   void onInit() {
//     super.onInit();
//     print('[AdminPlayerController] onInit called');
//     fetchTeams();
//   }
//
//   Future<void> fetchTeams() async {
//     try {
//       isLoading(true);
//       errorMessage.value = '';
//       print('[fetchTeams] Fetching teams from: ${ApiEndpoints.players}');
//
//       final response = await http.get(Uri.parse('${ApiEndpoints.players}'));
//       print('[fetchTeams] Response status: ${response.statusCode}');
//       print('[fetchTeams] Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         teams.value = data.map((json) => TeamModel.fromJson(json)).toList();
//         print('[fetchTeams] Parsed teams count: ${teams.length}');
//
//         activePlayersCount.value = teams.fold(0, (sum, team) => sum + team.players.length);
//         inactivePlayersCount.value = 0;
//         print('[fetchTeams] Active players: ${activePlayersCount.value}, Inactive: ${inactivePlayersCount.value}');
//       } else {
//         errorMessage.value = 'Failed to load teams: ${response.statusCode}';
//         print('[fetchTeams] Error: ${errorMessage.value}');
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//       print('[fetchTeams] Exception: $e');
//     } finally {
//       isLoading(false);
//       print('[fetchTeams] Finished, isLoading=false');
//     }
//   }
// }
//
// // TeamModel, CreatedBy, PlayerModel remain the same as in your code
// // (No changes needed; they parse the JSON correctly)