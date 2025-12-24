// toselectgameformatforsessioncontroller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../shared_preference/shared_preference.dart';
import '../api_models/toselectgameformatforsessionmodel.dart';

class ToSelectGameFormatForSessionController extends GetxController {
  // --- Form controllers ---
  final sessionNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController(text: '60');
  final searchController = TextEditingController();

  // --- Observables ---
  var selectedGameFormat = Rxn<ToSelectGameFormatForSessionModel>();
  var minPlayers = 5.obs;
  var maxPlayers = 10.obs;
  var aiScoring = false.obs;
  var allowLaterJoin = false.obs;
  var sendInvitation = false.obs;
  var recordSession = false.obs;
  var startedAt = Rxn<DateTime>();

  var isLoading = false.obs;
  var isGameFormatsLoading = true.obs;
  var gameFormats = <ToSelectGameFormatForSessionModel>[].obs;
  var filteredGameFormats = <ToSelectGameFormatForSessionModel>[].obs;

  // Validation errors
  var sessionNameError = ''.obs;
  var descriptionError = ''.obs;
  var durationError = ''.obs;
  var gameFormatError = ''.obs;
  var startTimeError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGameFormats();
  }

  @override
  void onClose() {
    sessionNameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // --- Fetch game formats ---
  Future<void> fetchGameFormats() async {
    isGameFormatsLoading.value = true;
    try {
      final token = await SharedPrefServices.getAuthToken() ?? '';

      final response = await http.get(
        Uri.parse('https://score-master-backend.onrender.com/admin/game-formats'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter out formats with empty names and valid IDs
        final validFormats = data.map((json) {
          try {
            final format = ToSelectGameFormatForSessionModel.fromJson(json);
            // Only include formats with valid ID and non-empty name
            if ((format.id ?? 0) > 0 && (format.name?.trim().isNotEmpty ?? false)) {
              return format;
            }
            return null;
          } catch (e) {
            print('Error parsing game format: $e');
            return null;
          }
        }).where((format) => format != null).cast<ToSelectGameFormatForSessionModel>().toList();

        gameFormats.value = validFormats;
        filteredGameFormats.value = validFormats;

        print('✅ Loaded ${gameFormats.length} valid game formats');
      } else {
        print('❌ API Error: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Failed to fetch game formats: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Exception fetching game formats: $e');
      Get.snackbar(
        'Error',
        'Failed to load game formats: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGameFormatsLoading.value = false;
    }
  }

  // --- Filter game formats ---
  void filterGameFormats(String query) {
    if (query.isEmpty) {
      filteredGameFormats.value = gameFormats;
    } else {
      filteredGameFormats.value = gameFormats.where((format) {
        final name = format.name?.toLowerCase() ?? '';
        final desc = format.description?.toLowerCase() ?? '';
        final mode = format.mode?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            desc.contains(searchQuery) ||
            mode.contains(searchQuery);
      }).toList();
    }
  }

  // --- Game format selection ---
  void selectGameFormat(ToSelectGameFormatForSessionModel format) {
    selectedGameFormat.value = format;
    gameFormatError.value = '';
    print('Selected game format: ${format.name} (ID: ${format.id})');
  }

  void clearGameFormatSelection() {
    selectedGameFormat.value = null;
  }

  // --- Validation methods ---
  bool validateForm({bool isScheduled = false}) {
    bool isValid = true;

    // Validate session name
    if (sessionNameController.text.trim().isEmpty) {
      sessionNameError.value = 'Session name is required';
      isValid = false;
    } else {
      sessionNameError.value = '';
    }

    // Validate description
    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'Description is required';
      isValid = false;
    } else {
      descriptionError.value = '';
    }

    // Validate duration
    final duration = int.tryParse(durationController.text.trim());
    if (duration == null || duration <= 0) {
      durationError.value = 'Please enter a valid duration (minutes)';
      isValid = false;
    } else {
      durationError.value = '';
    }

    // Validate game format selection
    if (selectedGameFormat.value == null) {
      gameFormatError.value = 'Please select a game format';
      isValid = false;
    } else {
      gameFormatError.value = '';
    }

    // Validate start time for scheduled sessions
    if (isScheduled && startedAt.value == null) {
      startTimeError.value = 'Please select a start time';
      isValid = false;
    } else {
      startTimeError.value = '';
    }

    return isValid;
  }

  // --- Create session ---
  Future<bool> createSession({bool scheduleForLater = false}) async {
    if (!validateForm(isScheduled: scheduleForLater)) {
      return false;
    }

    isLoading.value = true;

    try {
      final token = await SharedPrefServices.getAuthToken();
      final userId = await SharedPrefServices.getUserId();

      if (token == null || userId == null) {
        Get.snackbar(
          'Error',
          'Authentication failed. Please login again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return false;
      }

      // Format date for API
      final String formattedDate = scheduleForLater
          ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(startedAt.value!.toUtc())
          : DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(DateTime.now().toUtc());

      // Prepare session payload
      final Map<String, dynamic> sessionPayload = {
        'gameFormatId': selectedGameFormat.value!.id,
        'userId': int.parse(userId),
        'description': descriptionController.text.trim(),
        'duration': int.parse(durationController.text.trim()),
        'startedAt': formattedDate,
        'status': scheduleForLater ? 'scheduled' : 'active',
      };

      print('Creating session with payload: ${json.encode(sessionPayload)}');

      final response = await http.post(
        Uri.parse('https://score-master-backend.onrender.com/sessions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(sessionPayload),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final sessionId = responseData['id'] as int?;

        if (sessionId != null) {
          await SharedPrefServices.saveSessionId(sessionId);
        }

        Get.snackbar(
          'Success',
          scheduleForLater ? 'Session scheduled successfully!' : 'Session created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form after successful creation
        clearForm();
        return true;
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Failed to create session';
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Exception creating session: $e');
      Get.snackbar(
        'Error',
        'Failed to create session: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // --- Clear form ---
  void clearForm() {
    sessionNameController.clear();
    descriptionController.clear();
    durationController.clear();
    searchController.clear();
    selectedGameFormat.value = null;
    startedAt.value = null;

    // Clear errors
    sessionNameError.value = '';
    descriptionError.value = '';
    durationError.value = '';
    gameFormatError.value = '';
    startTimeError.value = '';

    // Reset to default values
    minPlayers.value = 5;
    maxPlayers.value = 10;
    aiScoring.value = false;
    allowLaterJoin.value = false;
    sendInvitation.value = false;
    recordSession.value = false;

    // Reset filtered list
    filteredGameFormats.value = gameFormats;
  }

  // --- Set start time ---
  void setStartTime(DateTime dateTime) {
    startedAt.value = dateTime;
    startTimeError.value = '';
  }
}