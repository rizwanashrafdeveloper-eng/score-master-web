/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scorer/api/api_urls.dart';
import 'dart:convert';
import '../api_models/AiChallenge_session.dart';
import '../api_models/create_game_format_model.dart';

class CreateSessionAIController extends GetxController {
  // Form controllers
  final sessionNameController = TextEditingController();
  final durationController = TextEditingController();

  // Observable variables for CreateGameFormatModel
  var gameFormatId = Rxn<int>();
  var minPlayers = 5.obs;
  var maxPlayers = 10.obs;
  var badgeNames = <String>[].obs;
  var requireAllTrue = false.obs;
  var aiScoring = true.obs;
  var allowLaterJoin = false.obs;
  var sendInvitation = false.obs;
  var recordSession = false.obs;
  var isLoading = false.obs;

  // Observable variables for AiChallengeSession
  var startedAt = Rxn<DateTime>();
  var userId = 2.obs; // Default userId from JSON example

  // Validation methods
  String? validateSessionName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Session name is required';
    }
    if (value.length < 3) {
      return 'Session name must be at least 3 characters';
    }
    return null;
  }

  String? validatePlayers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Player count is required';
    }
    final count = int.tryParse(value);
    if (count == null || count < 1) {
      return 'Player count must be a positive number';
    }
    return null;
  }

  String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Duration is required';
    }
    final duration = int.tryParse(value);
    if (duration == null || duration <= 0) {
      return 'Duration must be a positive number';
    }
    return null;
  }

  String? validateStartedAt(DateTime? value) {
    if (value == null) {
      return 'Start time is required';
    }
    if (value.isBefore(DateTime.now())) {
      return 'Start time must be in the future';
    }
    return null;
  }

  // Setters
  void setGameFormatId(int? id) => gameFormatId.value = id;
  void setPlayerRange(int min, int max) {
    minPlayers.value = min;
    maxPlayers.value = max;
  }
  void addBadgeName(String badge) {
    if (!badgeNames.contains(badge)) {
      badgeNames.add(badge);
    }
  }
  void removeBadgeName(String badge) => badgeNames.remove(badge);
  void setAiScoring(bool value) => aiScoring.value = value;
  void setAllowLaterJoin(bool value) => allowLaterJoin.value = value;
  void setSendInvitation(bool value) => sendInvitation.value = value;
  void setRecordSession(bool value) => recordSession.value = value;
  void setStartedAt(DateTime? dateTime) => startedAt.value = dateTime;

  // Create CreateGameFormatModel for /admin/player-capability
  CreateGameFormatModel createGameFormatModel() {
    return CreateGameFormatModel(
      gameFormatId: gameFormatId.value,
      minPlayers: minPlayers.value,
      maxPlayers: maxPlayers.value,
      badgeNames: badgeNames.toList(),
      requireAllTrue: requireAllTrue.value,
      aiScoring: aiScoring.value,
      allowLaterJoin: allowLaterJoin.value,
      sendInvitation: sendInvitation.value,
      recordSession: recordSession.value,
    );
  }

  // Create AiChallengeSession for /sessions/post/method
  AiChallengeSession createAiChallengeSession() {
    return AiChallengeSession(
      gameFormatId: gameFormatId.value,
      duration: int.tryParse(durationController.text) ?? 600, // Default to 600 seconds (10 min)
      userId: userId.value,
      description: sessionNameController.text.isNotEmpty
          ? sessionNameController.text
          : 'AI Challenge Session',
      startedAt: startedAt.value?.toUtc().toIso8601String(),
    );
  }

  // API call for CreateGameFormatModel
  Future<void> createSession({bool scheduleForLater = false}) async {
    if (sessionNameController.text.isEmpty || gameFormatId.value == null) {
      Get.snackbar('Error', 'Session name and game format are required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      const String baseUrl = '${ApiEndpoints.postSessionMethod}'; // Replace with actual base URL
      if (scheduleForLater) {
        // Validate AiChallengeSession fields
        if (startedAt.value == null) {
          Get.snackbar('Error', 'Start time is required for scheduling',
              backgroundColor: Colors.red, colorText: Colors.white);
          isLoading.value = false;
          return;
        }
        if (startedAt.value!.isBefore(DateTime.now())) {
          Get.snackbar('Error', 'Start time must be in the future',
              backgroundColor: Colors.red, colorText: Colors.white);
          isLoading.value = false;
          return;
        }
        if (durationController.text.isEmpty) {
          Get.snackbar('Error', 'Duration is required for scheduling',
              backgroundColor: Colors.red, colorText: Colors.white);
          isLoading.value = false;
          return;
        }

        // Call /sessions/post/method for scheduling
        const String postSessionMethod = '$baseUrl/sessions/post/method';
        final sessionModel = createAiChallengeSession();
        final response = await http.post(
          Uri.parse(postSessionMethod),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(sessionModel.toJson()),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar(
            'Success',
            'Session scheduled successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Clear form
          clearForm();
          Get.back();
        } else {
          throw Exception('Failed to schedule session: ${response.statusCode}');
        }
      } else {
        // Call /admin/player-capability for immediate start
        const String createNewSessionFormat = '$baseUrl/admin/player-capability';
        final model = createGameFormatModel();
        final response = await http.post(
          Uri.parse(createNewSessionFormat),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(model.toJson()),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar(
            'Success',
            'Session created successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Clear form
          clearForm();
          Get.back();
        } else {
          throw Exception('Failed to create session: ${response.statusCode}');
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${scheduleForLater ? 'schedule' : 'create'} session: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form data
  void clearForm() {
    sessionNameController.clear();
    durationController.clear();
    gameFormatId.value = null;
    badgeNames.clear();
    minPlayers.value = 5;
    maxPlayers.value = 10;
    startedAt.value = null;
  }

  @override
  void onClose() {
    sessionNameController.dispose();
    durationController.dispose();
    super.onClose();
  }
}*/