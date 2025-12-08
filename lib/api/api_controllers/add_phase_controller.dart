import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_models/add_phase_model.dart';
import '../api_urls.dart';

class AddPhaseController extends GetxController {
  // Form Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final orderController = TextEditingController();
  final timeDurationController = TextEditingController();
  final requiredScoreController = TextEditingController();

  // Observable variables
  var gameFormatId = Rxn<int>();
  var scoringType = Rxn<String>();
  var challengeTypes = <String>[].obs;
  var difficulty = Rxn<String>();
  var badge = Rxn<String>();
  var isLoading = false.obs;
  var phases = <AddPhaseModel>[].obs;
  var currentPhaseIndex = 0.obs;
  var remainingSeconds = 0.obs;
  var errorMessage = ''.obs;

  // Dropdown options
  final scoringTypeOptions = ['HYBRID', 'AI', 'HUBRID'].obs;
  final difficultyOptions = ['EASY', 'MEDIUM', 'HARD'].obs;final challengeTypeOptions = [
    'MCQ',
    'OPEN_ENDED',
    'PUZZLE',
    'SIMULATION',
  ].obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Computed properties
  AddPhaseModel? get currentPhase => phases.isNotEmpty && currentPhaseIndex.value < phases.length
      ? phases[currentPhaseIndex.value]
      : null;

  int get totalPhasesCount => phases.length;

  int get totalTimeDuration => phases.fold(0, (sum, phase) => sum + (phase.timeDuration ?? 0));

  @override
  void onInit() {
    super.onInit();
    // Fetch phases only if needed; commented out to avoid init-time errors
    // fetchPhases();
    startPhaseTimer();
    developer.log('[AddPhaseController] Initialized', name: 'AddPhaseController');
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    orderController.dispose();
    timeDurationController.dispose();
    requiredScoreController.dispose();
    super.onClose();
    developer.log('[AddPhaseController] Disposed', name: 'AddPhaseController');
  }

  // Get auth token from SharedPreferences
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        developer.log('[AddPhaseController] No auth token found', name: 'AddPhaseController');
      } else {
        developer.log('[AddPhaseController] Retrieved token: ***', name: 'AddPhaseController');
      }
      return token;
    } catch (e) {
      developer.log('[AddPhaseController] Error getting token: $e', name: 'AddPhaseController');
      return null;
    }
  }

  // Fetch phases from API
  Future<void> fetchPhases() async {
    isLoading.value = true;
    errorMessage.value = '';
    developer.log('[AddPhaseController] Fetching phases from ${ApiEndpoints.createGame}...', name: 'AddPhaseController');

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage.value = 'Authentication token is missing';
        developer.log('[AddPhaseController] Missing token', name: 'AddPhaseController');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.createGame),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      developer.log('[AddPhaseController] GET response status: ${response.statusCode}', name: 'AddPhaseController');
      developer.log('[AddPhaseController] GET response body preview: ${response.body.substring(0, math.min(500, response.body.length))}', name: 'AddPhaseController');

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        List<AddPhaseModel> parsedPhases = [];
        if (decoded is List) {
          parsedPhases = decoded.map((dynamic item) {
            try {
              return AddPhaseModel.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              developer.log('[AddPhaseController] Failed to parse phase item: $item, error: $e', name: 'AddPhaseController');
              return null;
            }
          }).where((phase) => phase != null).cast<AddPhaseModel>().toList();
        } else if (decoded is Map<String, dynamic>) {
          final data = decoded['data'] ?? decoded['phases'] ?? decoded;
          if (data is List) {
            parsedPhases = data.map((dynamic item) {
              try {
                return AddPhaseModel.fromJson(item as Map<String, dynamic>);
              } catch (e) {
                developer.log('[AddPhaseController] Failed to parse phase item: $item, error: $e', name: 'AddPhaseController');
                return null;
              }
            }).where((phase) => phase != null).cast<AddPhaseModel>().toList();
          } else if (data is Map<String, dynamic>) {
            try {
              parsedPhases = [AddPhaseModel.fromJson(data)];
            } catch (e) {
              developer.log('[AddPhaseController] Failed to parse single phase: $data, error: $e', name: 'AddPhaseController');
            }
          }
        }
        phases.value = parsedPhases;
        if (parsedPhases.isNotEmpty) {
          Get.snackbar(
            'Success',
            'Phases fetched: ${parsedPhases.length}',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          developer.log('[AddPhaseController] No phases found in response', name: 'AddPhaseController');
        }
        developer.log('[AddPhaseController] Phases fetched: ${phases.length} phases', name: 'AddPhaseController');
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Unauthorized: Please login again';
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      } else if (response.statusCode == 404) {
        phases.value = [];
        developer.log('[AddPhaseController] No phases found (404)', name: 'AddPhaseController');
      } else {
        throw Exception('Failed to fetch phases: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      developer.log('[AddPhaseController] Fetch error: $e', name: 'AddPhaseController', error: e, stackTrace: stackTrace);
      phases.value = []; // Reset to empty list to avoid stale data
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh phases
  Future<void> refreshPhases() async {
    await fetchPhases();
    startPhaseTimer();
  }

  // Start timer for current phase
  void startPhaseTimer() {
    if (currentPhase != null && currentPhase!.timeDuration != null) {
      remainingSeconds.value = currentPhase!.timeDuration! * 60;
      Future.delayed(Duration(seconds: 1), () {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
          startPhaseTimer();
        }
      });
    }
  }

  // Get remaining time as formatted string
  String getRemainingTime(int timeDuration) {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Navigate to next phase
  void nextPhase() {
    if (currentPhaseIndex.value < phases.length - 1) {
      currentPhaseIndex.value++;
      startPhaseTimer();
      developer.log('[AddPhaseController] Moved to next phase: ${currentPhaseIndex.value}', name: 'AddPhaseController');
    }
  }

  // Navigate to previous phase
  void previousPhase() {
    if (currentPhaseIndex.value > 0) {
      currentPhaseIndex.value--;
      startPhaseTimer();
      developer.log('[AddPhaseController] Moved to previous phase: ${currentPhaseIndex.value}', name: 'AddPhaseController');
    }
  }

  // Get phase status
  String getPhaseStatus(int index) {
    if (index < currentPhaseIndex.value) return 'Completed';
    if (index == currentPhaseIndex.value) return 'In Progress';
    return 'Upcoming';
  }

  // Get status color for phase
  Color getPhaseStatusColor(int index) {
    if (index < currentPhaseIndex.value) return Colors.green;
    if (index == currentPhaseIndex.value) return Colors.blue;
    return Colors.grey;
  }

  // Get status icon for phase
  IconData getPhaseStatusIcon(int index) {
    if (index < currentPhaseIndex.value) return Icons.check_circle;
    if (index == currentPhaseIndex.value) return Icons.play_circle;
    return Icons.lock;
  }

  // Methods for handling challenge types
  void addChallengeType(String type) {
    if (!challengeTypes.contains(type)) {
      challengeTypes.add(type);
      developer.log('[AddPhaseController] Added challenge type: $type', name: 'AddPhaseController');
    }
  }

  void removeChallengeType(String type) {
    challengeTypes.remove(type);
    developer.log('[AddPhaseController] Removed challenge type: $type', name: 'AddPhaseController');
  }

  void toggleChallengeType(String type) {
    if (challengeTypes.contains(type)) {
      challengeTypes.remove(type);
    } else {
      challengeTypes.add(type);
    }
    developer.log('[AddPhaseController] Toggled challenge type: $type', name: 'AddPhaseController');
  }

  // Setters
  void setGameFormatId(int? id) {
    gameFormatId.value = id;
    developer.log('[AddPhaseController] GameFormatId set: $id', name: 'AddPhaseController');
  }

  void setScoringType(String? type) {
    if (type != null && scoringTypeOptions.contains(type.toUpperCase())) {
      scoringType.value = type.toUpperCase();
      developer.log('[AddPhaseController] ScoringType set: ${scoringType.value}', name: 'AddPhaseController');
    } else {
      scoringType.value = null;
      errorMessage.value = 'Invalid scoring type selected: $type';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      developer.log('[AddPhaseController] Invalid ScoringType: $type', name: 'AddPhaseController');
    }
  }

  void setDifficulty(String? level) {
    if (level != null && difficultyOptions.contains(level.toUpperCase())) {
      difficulty.value = level.toUpperCase();
      developer.log('[AddPhaseController] Difficulty set: ${difficulty.value}', name: 'AddPhaseController');
    } else {
      difficulty.value = null;
      errorMessage.value = 'Invalid difficulty selected: $level';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      developer.log('[AddPhaseController] Invalid Difficulty: $level', name: 'AddPhaseController');
    }
  }

  void setBadge(String? badgeType, {String? score}) {
    badge.value = badgeType;
    if (score != null) {
      final cleanedScore = score.replaceAll(RegExp(r'[^0-9]'), '');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        requiredScoreController.text = cleanedScore.isNotEmpty ? cleanedScore : '0';
      });
      developer.log('[AddPhaseController] Badge set: $badgeType, Score: $cleanedScore', name: 'AddPhaseController');
    } else {
      developer.log('[AddPhaseController] Badge set: $badgeType', name: 'AddPhaseController');
    }
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    if (value.length < 10) return 'Description must be at least 10 characters';
    return null;
  }

  String? validateOrder(String? value) {
    if (value == null || value.trim().isEmpty) return 'Order is required';
    final order = int.tryParse(value);
    if (order == null || order < 1) return 'Order must be a positive number';
    return null;
  }

  String? validateTimeDuration(String? value) {
    if (value == null || value.trim().isEmpty) return 'Time duration is required';
    final duration = int.tryParse(value);
    if (duration == null || duration < 1) return 'Time duration must be a positive number';
    return null;
  }

  String? validateRequiredScore(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required score is required';
    final score = int.tryParse(value);
    if (score == null) return 'Required score must be a valid number';
    if (score < 0) return 'Required score must be a non-negative number';
    return null;
  }

  // Create AddPhaseModel
  AddPhaseModel createPhaseModel() {
    return AddPhaseModel(
      gameFormatId: gameFormatId.value,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      order: int.tryParse(orderController.text),
      scoringType: scoringType.value,
      timeDuration: int.tryParse(timeDurationController.text),
      challengeTypes: challengeTypes.toList(),
      difficulty: difficulty.value,
      badge: badge.value,
      requiredScore: int.tryParse(requiredScoreController.text),
    );
  }

  // Populate form
  void populateForm(AddPhaseModel phase) {
    gameFormatId.value = phase.gameFormatId;
    nameController.text = phase.name ?? '';
    descriptionController.text = phase.description ?? '';
    orderController.text = phase.order?.toString() ?? '';
    scoringType.value = phase.scoringType;
    timeDurationController.text = phase.timeDuration?.toString() ?? '';
    challengeTypes.value = phase.challengeTypes ?? [];
    difficulty.value = phase.difficulty;
    badge.value = phase.badge;
    requiredScoreController.text = phase.requiredScore?.toString() ?? '';
    developer.log('[AddPhaseController] Form populated with phase: ${phase.name}', name: 'AddPhaseController');
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    orderController.clear();
    timeDurationController.clear();
    requiredScoreController.clear();
    gameFormatId.value = null;
    scoringType.value = null;
    challengeTypes.clear();
    difficulty.value = null;
    badge.value = null;
    errorMessage.value = '';
    developer.log('[AddPhaseController] Form cleared', name: 'AddPhaseController');
  }

  // Submit phase to API
  Future<void> submitPhase() async {
    developer.log('[AddPhaseController] Submitting phase...', name: 'AddPhaseController');
    developer.log(
      '[AddPhaseController] Form values: name=${nameController.text}, '
          'description=${descriptionController.text}, order=${orderController.text}, '
          'timeDuration=${timeDurationController.text}, requiredScore=${requiredScoreController.text}, '
          'scoringType=${scoringType.value}, difficulty=${difficulty.value}, '
          'challengeTypes=${challengeTypes}, badge=${badge.value}',
      name: 'AddPhaseController',
    );

    // Validate form fields
    if (!formKey.currentState!.validate()) {
      developer.log('[AddPhaseController] Form validation failed', name: 'AddPhaseController');
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (gameFormatId.value == null) {
      errorMessage.value = 'Please select a game format';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      developer.log('[AddPhaseController] GameFormatId is null', name: 'AddPhaseController');
      return;
    }

    if (!validateDropdowns()) {
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      developer.log('[AddPhaseController] Dropdown validation failed: ${errorMessage.value}', name: 'AddPhaseController');
      return;
    }

    isLoading.value = true;
    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage.value = 'Authentication token is missing';
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        developer.log('[AddPhaseController] No auth token found', name: 'AddPhaseController');
        return;
      }

      final phaseModel = createPhaseModel();
      final phaseData = phaseModel.toJson();
      developer.log('[AddPhaseController] Phase data: ${json.encode(phaseData)}', name: 'AddPhaseController');

      final response = await http.post(
        Uri.parse("https://score-master-backend.onrender.com/admin/phases"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(phaseData),
      );

      developer.log('[AddPhaseController] POST response status: ${response.statusCode}', name: 'AddPhaseController');
      developer.log('[AddPhaseController] POST response body: ${response.body}', name: 'AddPhaseController');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Phase added successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        developer.log('[AddPhaseController] Phase added successfully', name: 'AddPhaseController');
        clearForm();
        await fetchPhases().catchError((e) {
          developer.log('[AddPhaseController] Refresh after add failed: $e', name: 'AddPhaseController');
        });
      } else {
        final responseBody = json.decode(response.body);
        final errorMsg = responseBody['message'] ?? 'Failed to add phase: ${response.statusCode} - ${response.reasonPhrase}';
        errorMessage.value = errorMsg;
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        developer.log('[AddPhaseController] Failed to add phase: $errorMsg', name: 'AddPhaseController');
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to add phase: $e';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      developer.log('[AddPhaseController] Submit error: $e', name: 'AddPhaseController', error: e, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  // Validate all dropdowns
  bool validateDropdowns() {
    if (scoringType.value == null) {
      errorMessage.value = 'Please select a scoring type';
      return false;
    }
    if (difficulty.value == null) {
      errorMessage.value = 'Please select a difficulty level';
      return false;
    }
    if (challengeTypes.isEmpty) {
      errorMessage.value = 'Please select at least one challenge type';
      return false;
    }
    return true;
  }
}