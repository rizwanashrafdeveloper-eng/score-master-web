//
//
//
//
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../shared_preferences/shared_preferences.dart';
// import '../api_models/create_game_model.dart';
// import '../api_models/phase_model.dart';
// import 'facilitator_controller.dart';
// import '../api_urls.dart';
//
// class CreateGameController extends GetxController {
//   // Game basic fields
//   var name = ''.obs;
//   var description = ''.obs;
//   var mode = 'team'.obs;
//   var totalPhases = 0.obs;
//   var timeDuration = 0.obs;
//   var createdById = 1.obs;
//   var facilitatorIds = <int>[].obs;
//
//   // ✅ Add scoringType
//   var scoringType = 'MANUAL'.obs; // default: MANUAL
//
//   // Phases data
//   var phases = <PhaseModel>[].obs;
//
//   // Current game ID
//   var currentGameId = RxnInt();
//
//   // Loading states
//   var isCreatingGame = false.obs;
//   var isFetchingPhases = false.obs;
//   var isSavingPhase = false.obs;
//
//   // Workflow control flags
//   var canAddPhases = false.obs;
//   var canFinalize = false.obs;
//
//   final FacilitatorsController facilitatorsController = Get.find<FacilitatorsController>();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Restore facilitator selection
//     facilitatorIds.assignAll(facilitatorsController.selectedIds);
//     ever(facilitatorsController.selectedIds, (_) {
//       facilitatorIds.assignAll(facilitatorsController.selectedIds);
//     });
//
//     // Restore saved gameId if exists
//     _loadSavedGameId();
//
//     // Auto-fetch phases when gameId changes
//     ever(currentGameId, (gameId) {
//       if (gameId != null) {
//         fetchPhases(gameId);
//       }
//     });
//   }
//
//   Future<void> _loadSavedGameId() async {
//     final savedId = await SharedPrefServices.getGameId();
//     if (savedId != null) {
//       currentGameId.value = savedId;
//       canAddPhases.value = true;
//       print("📌 Loaded saved gameId=$savedId from SharedPref");
//     }
//   }
//
//   CreateGameModel toCreateGameModel() {
//     return CreateGameModel(
//       name: name.value,
//       description: description.value,
//       mode: mode.value,
//       totalPhases: totalPhases.value,
//       timeDuration: timeDuration.value,
//       createdById: createdById.value,
//       facilitatorIds: facilitatorIds.toList(),
//       scoringType: scoringType.value, // ✅ include scoring type
//     );
//   }
//
//   Future<void> createGameFormat() async {
//     // Validate inputs
//     if (name.value.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter game name',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (description.value.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter description',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (totalPhases.value == 0) {
//       Get.snackbar(
//         'Error',
//         'Please select number of phases',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (isCreatingGame.value) return; // Prevent multiple calls
//     isCreatingGame.value = true;
//
//     final url = Uri.parse(ApiEndpoints.createGame);
//     final createGameModel = toCreateGameModel();
//     final body = jsonEncode(createGameModel.toJson());
//
//     print("📤 Sending create game request → $body");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//
//       print("📥 Create Game Response → ${response.statusCode} | ${response.body}");
//
//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         final gameId = responseData['id'];
//
//         print("✅ Game created successfully → ID: $gameId");
//
//         if (gameId != null) {
//           await SharedPrefServices.saveGameId(gameId);
//           print("💾 [SharedPref] Saved gameId=$gameId");
//
//           currentGameId.value = gameId;
//           canAddPhases.value = true;
//
//           Get.snackbar(
//             'Success',
//             'Game created successfully! Now add ${totalPhases.value} phases.',
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//             duration: Duration(seconds: 3),
//           );


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../shared_preference/shared_preference.dart';

import '../api_models/create_game_model.dart';
import '../api_models/phase_model.dart';
import 'facilitator_controller.dart';
import '../api_urls.dart';

class CreateGameController extends GetxController {
  // Game basic fields
  var name = ''.obs;
  var description = ''.obs;
  var mode = 'team'.obs;
  var totalPhases = 0.obs;
  var timeDuration = 0.obs;
  var createdById = 1.obs;
  var facilitatorIds = <int>[].obs;

  // Phases data
  var phases = <PhaseModel>[].obs;

  // Current game ID
  var currentGameId = RxnInt();

  // Loading states
  var isCreatingGame = false.obs;
  var isFetchingPhases = false.obs;
  var isSavingPhase = false.obs;

  // Workflow control flags
  var canAddPhases = false.obs;
  var canFinalize = false.obs;

  final FacilitatorsController facilitatorsController = Get.find<FacilitatorsController>();

  @override
  void onInit() {
    super.onInit();

    // Restore facilitator selection
    facilitatorIds.assignAll(facilitatorsController.selectedIds);
    ever(facilitatorsController.selectedIds, (_) {
      facilitatorIds.assignAll(facilitatorsController.selectedIds);
    });

    // Restore saved gameId if exists
    _loadSavedGameId();

    // Auto-fetch phases when gameId changes
    ever(currentGameId, (gameId) {
      if (gameId != null) {
        fetchPhases(gameId);
      }
    });
  }

  Future<void> _loadSavedGameId() async {
    final savedId = await SharedPrefServices.getGameId();
    if (savedId != null) {
      currentGameId.value = savedId;
      canAddPhases.value = true;
      print("📌 Loaded saved gameId=$savedId from SharedPref");
    }
  }

  CreateGameModel toCreateGameModel() {
    return CreateGameModel(
      name: name.value,
      description: description.value,
      mode: mode.value,
      totalPhases: totalPhases.value,
      timeDuration: timeDuration.value,
      createdById: createdById.value,
      facilitatorIds: facilitatorIds.toList(),
    );
  }

  Future<void> createGameFormat() async {
    // Validate inputs
    if (name.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter game name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (description.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter description',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (totalPhases.value == 0) {
      Get.snackbar(
        'Error',
        'Please select number of phases',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (isCreatingGame.value) return; // Prevent multiple calls

    isCreatingGame.value = true;

    final url = Uri.parse(ApiEndpoints.createGame);
    final createGameModel = toCreateGameModel();
    final body = jsonEncode(createGameModel.toJson());

    print("📤 Sending create game request → $body");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("📥 Create Game Response → ${response.statusCode} | ${response.body}");

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final gameId = responseData['id'];

        print("✅ Game created successfully → ID: $gameId");

        if (gameId != null) {
          // Save in SharedPrefs
          await SharedPrefServices.saveGameId(gameId);
          print("💾 [SharedPref] Saved gameId=$gameId");

          // Set current game ID (auto-fetches phases)
          currentGameId.value = gameId;
          canAddPhases.value = true;

          Get.snackbar(
            'Success',
            'Game created successfully! Now add ${totalPhases.value} phases.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to create game: ${response.body}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Exception in createGameFormat → $e");
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingGame.value = false;
    }
  }

  Future<void> savePhase({
    required String phaseName,
    required int timeDuration,
    required int stagesCount,
    required List<String> challengeTypes,
    required Map<String, dynamic> badges,
    required String filterType,
  }) async {
    try {
      if (currentGameId.value == null) {
        Get.snackbar(
          'Error',
          'Please create a game first',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (phaseName.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter phase name',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (challengeTypes.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select at least one challenge type',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isSavingPhase.value = true;

      final url = Uri.parse("${ApiEndpoints.baseUrl}/admin/phases");
      final body = jsonEncode({
        'gameId': currentGameId.value,
        'name': phaseName,
        'timeDuration': timeDuration,
        'stagesCount': stagesCount,
        'challengeTypes': challengeTypes,
        'badges': badges,
        'filterType': filterType,
        'order': phases.length + 1,
      });

      print("📤 Saving phase → $body");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("📥 SavePhase Response → ${response.statusCode} | ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newPhase = PhaseModel.fromJson(responseData);
        phases.add(newPhase);

        Get.snackbar(
          'Phase Added',
          'Phase "$phaseName" added successfully! (${phases.length}/${totalPhases.value})',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Check if all phases are added
        if (phases.length >= totalPhases.value) {
          canFinalize.value = true;
          Get.snackbar(
            'All Phases Added',
            'You can now add questions to your phases!',
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: Duration(seconds: 4),
          );
        }

        // Reload phases to ensure sync
        await fetchPhases(currentGameId.value!);
      } else {
        Get.snackbar(
          'Error',
          'Failed to save phase: ${response.body}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error saving phase: $e');
      Get.snackbar(
        'Error',
        'Failed to save phase: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSavingPhase.value = false;
    }
  }

  Future<void> fetchPhases(int gameId) async {
    if (isFetchingPhases.value) return;

    isFetchingPhases.value = true;
    final url = "${ApiEndpoints.baseUrl}/admin/phases/game/$gameId";

    print("🌍 Fetching phases for gameId=$gameId → $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("📥 FetchPhases Response → ${response.statusCode}");
      print("📥 Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = response.body.trim();

        if (responseBody.isEmpty || responseBody == '[]') {
          phases.clear();
          print("ℹ️ No phases found for game $gameId");
          return;
        }

        final List<dynamic> data = jsonDecode(responseBody);
        phases.assignAll(data.map((json) => PhaseModel.fromJson(json)).toList());

        print("✅ Total Phases Fetched: ${phases.length}");

        // Update workflow flags
        if (phases.length >= totalPhases.value) {
          canFinalize.value = true;
        }
      } else {
        phases.clear();
        Get.snackbar(
          'Error',
          'Failed to fetch phases: ${response.body}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      phases.clear();
      print("❌ Exception in fetchPhases → $e");
      Get.snackbar(
        'Error',
        'Error fetching phases: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isFetchingPhases.value = false;
    }
  }

  Future<void> loadExistingGame(int gameId) async {
    try {
      print("🔄 Loading phases for game ID: $gameId");
      await fetchPhases(gameId);
    } catch (e) {
      print("❌ Error loading game: $e");
      Get.snackbar(
        'Error',
        'Failed to load game: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> refreshPhases() async {
    if (currentGameId.value != null) {
      await fetchPhases(currentGameId.value!);
    } else {
      print("⚠️ No currentGameId available, cannot refresh phases.");
      Get.snackbar(
        'Info',
        'No game selected',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void resetForNewGame() {
    currentGameId.value = null;
    phases.clear();
    name.value = '';
    description.value = '';
    totalPhases.value = 0;
    timeDuration.value = 0;
    canAddPhases.value = false;
    canFinalize.value = false;
    facilitatorIds.clear();
    SharedPrefServices.clearGameId();
    print("🔄 Reset for new game");
  }

  // Helper methods
  bool hasAllPhasesAdded() {
    return phases.length >= totalPhases.value && totalPhases.value > 0;
  }

  int getRemainingPhases() {
    return totalPhases.value - phases.length;
  }

  PhaseModel? getPhaseById(int phaseId) {
    try {
      return phases.firstWhere((phase) => phase.id == phaseId);
    } catch (e) {
      return null;
    }
  }
}



