// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import '../../constants/appcolors.dart';
// import '../api_models/game_format_phase.dart';
// import '../api_urls.dart';
//
// // Add this enum for phase states
// enum PhaseState {
//   active,     // Currently running
//   completed,  // Finished
//   inactive    // Not started
// }
//
// class GameFormatPhaseController extends GetxController {
//   var isLoading = false.obs;
//   var gameFormatPhaseModel = Rxn<GameFormatPhaseModel>();
//   var errorMessage = ''.obs;
//   var currentPhaseIndex = 0.obs;
//   var remainingSeconds = 0.obs;
//   Timer? _timer;
//   var sessionId = 0.obs;
//   var hasData = false.obs;
//
//   // Add phase states - track which phases are actually active/completed
//   var phaseStates = <int, PhaseState>{}.obs; // phaseId -> PhaseState
//
//   @override
//   void onInit() {
//     super.onInit();
//     print('🎮 GameFormatPhaseController initialized');
//     // REMOVED arguments handling - we'll use setSessionId() manually
//   }
//
//   // Set session ID and fetch phases
//   void setSessionId(int id) {
//     print('🎯 Setting session ID: $id');
//     sessionId.value = id;
//     fetchGameFormatPhases();
//   }
//
//   // Fetch game format phases from API
//   Future<void> fetchGameFormatPhases() async {
//     try {
//       if (sessionId.value == 0) {
//         errorMessage.value = 'No session ID provided';
//         hasData.value = false;
//         print('❌ No session ID provided');
//         return;
//       }
//
//       isLoading.value = true;
//       errorMessage.value = '';
//       hasData.value = false;
//
//       // Use the correct endpoint for session phases
//       final url = ApiEndpoints.getPhaseSessionUrl(sessionId.value);
//       print('🔄 Fetching phases from: $url');
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//
//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         print('📊 Full API Response: $jsonData');
//
//         // Handle different response structures
//         if (jsonData is Map<String, dynamic>) {
//           // Check if we have the nested gameFormat structure
//           if (jsonData['gameFormat'] != null && jsonData['gameFormat']['phases'] != null) {
//             print('✅ Found phases in gameFormat.phases structure');
//             gameFormatPhaseModel.value = GameFormatPhaseModel.fromJson(jsonData);
//           }
//           // Check if phases are at root level
//           else if (jsonData['phases'] != null) {
//             print('✅ Found phases in root level');
//             // Create a mock gameFormat structure
//             gameFormatPhaseModel.value = GameFormatPhaseModel.fromJson({
//               'sessionId': sessionId.value,
//               'gameFormat': {
//                 'id': jsonData['id'],
//                 'name': jsonData['name'] ?? 'Session ${sessionId.value}',
//                 'description': jsonData['description'] ?? '',
//                 'mode': jsonData['mode'] ?? 'team',
//                 'totalPhases': (jsonData['phases'] as List).length,
//                 'timeDuration': jsonData['timeDuration'] ?? 0,
//                 'isPublished': jsonData['isPublished'] ?? false,
//                 'isActive': jsonData['isActive'] ?? true,
//                 'createdAt': jsonData['createdAt'],
//                 'updatedAt': jsonData['updatedAt'],
//                 'createdById': jsonData['createdById'],
//                 'phases': jsonData['phases'],
//               }
//             });
//           }
//           // No phases found
//           else {
//             print('⚠️ No phases found in response');
//             errorMessage.value = 'No phases found for this session';
//             Get.snackbar(
//               'Info',
//               'No phases configured for this session',
//               snackPosition: SnackPosition.TOP,
//             );
//             return;
//           }
//         }
//
//         hasData.value = true;
//
//         // Debug: Print what we received
//         print('🎯 Game Format: ${gameFormatPhaseModel.value?.gameFormat?.name}');
//         print('📋 Phases count: ${allPhases.length}');
//
//         for (var phase in allPhases) {
//           print('   - ${phase.name} (Order: ${phase.order}, Duration: ${phase.timeDuration}min)');
//         }
//
//         // Reset current phase index and start timer
//         currentPhaseIndex.value = 0;
//
//         // Initialize phase states
//         _initializePhaseStates();
//
//         startTimerForCurrentPhase();
//
//         Get.snackbar(
//           '✅ Success',
//           'Loaded ${allPhases.length} phases',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         errorMessage.value = 'Failed to load phases: ${response.statusCode}';
//         hasData.value = false;
//         Get.snackbar(
//           '❌ Error',
//           'Failed to load phases: ${response.statusCode}',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print('❌ Error fetching phases: $e');
//       errorMessage.value = 'Error: $e';
//       hasData.value = false;
//       Get.snackbar(
//         '❌ Error',
//         'An error occurred: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Initialize phase states based on current phase index
//   void _initializePhaseStates() {
//     phaseStates.clear();
//     for (int i = 0; i < allPhases.length; i++) {
//       final phase = allPhases[i];
//       if (i < currentPhaseIndex.value) {
//         phaseStates[phase.id!] = PhaseState.completed;
//       } else if (i == currentPhaseIndex.value) {
//         phaseStates[phase.id!] = PhaseState.active;
//       } else {
//         phaseStates[phase.id!] = PhaseState.inactive;
//       }
//     }
//     print('📊 Initialized phase states: $phaseStates');
//   }
//
//   // Start timer for the current phase
//   void startTimerForCurrentPhase() {
//     final currentPhase = this.currentPhase;
//     if (currentPhase != null && currentPhase.timeDuration != null) {
//       remainingSeconds.value = currentPhase.timeDuration! * 60;
//       print('⏰ Starting timer for ${currentPhase.name}: ${currentPhase.timeDuration} minutes');
//
//       _timer?.cancel();
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (remainingSeconds.value > 0) {
//           remainingSeconds.value--;
//         } else {
//           timer.cancel();
//           print('⏰ Timer completed for ${currentPhase.name}');
//           // Auto-move to next phase when time completes
//           if (currentPhaseIndex.value < totalPhasesCount - 1) {
//             nextPhase();
//           } else {
//             Get.snackbar(
//               '🎉 Completed',
//               'All phases completed!',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white,
//             );
//           }
//         }
//       });
//     } else {
//       print('⚠️ Cannot start timer - no current phase or duration');
//     }
//   }
//
//   // Get current phase
//   Phases? get currentPhase {
//     if (allPhases.isNotEmpty && currentPhaseIndex.value < allPhases.length) {
//       return allPhases[currentPhaseIndex.value];
//     }
//     return null;
//   }
//
//   // Get current ACTIVE phase (not just viewed phase)
//   Phases? get activePhase {
//     for (int i = 0; i < allPhases.length; i++) {
//       if (phaseStates[allPhases[i].id!] == PhaseState.active) {
//         return allPhases[i];
//       }
//     }
//     return currentPhase; // fallback
//   }
//
//   // Get current phase title
//   String get currentPhaseTitle {
//     return currentPhase?.name ?? "Phase ${currentPhaseIndex.value + 1}";
//   }
//
//   // Get current phase description
//   String get currentPhaseDescription {
//     return currentPhase?.description ?? "";
//   }
//
//   // Get current phase duration
//   int get currentPhaseDuration {
//     return currentPhase?.timeDuration ?? 0;
//   }
//
//   // Get phase status
//   String getPhaseStatus(int index) {
//     if (index < currentPhaseIndex.value) {
//       return "completed".tr;
//     } else if (index == currentPhaseIndex.value) {
//       return "active".tr;
//     } else {
//       return "pending".tr;
//     }
//   }
//
//   // Get phase status color
//   Color getPhaseStatusColor(int index) {
//     if (index < currentPhaseIndex.value) {
//       return AppColors.forwardColor;
//     } else if (index == currentPhaseIndex.value) {
//       return AppColors.selectLangugaeColor;
//     } else {
//       return AppColors.watchColor;
//     }
//   }
//
//   // Get phase status icon
//   IconData getPhaseStatusIcon(int index) {
//     if (index < currentPhaseIndex.value) {
//       return Icons.check;
//     } else if (index == currentPhaseIndex.value) {
//       return Icons.play_arrow;
//     } else {
//       return Icons.watch_later;
//     }
//   }
//
//   // Get all phases
//   List<Phases> get allPhases {
//     return gameFormatPhaseModel.value?.gameFormat?.phases ?? [];
//   }
//
//   // Get total phases count
//   int get totalPhasesCount {
//     return allPhases.length;
//   }
//
//   // Get total time duration (sum of all phase durations)
//   int get totalTimeDuration {
//     return allPhases.fold(0, (sum, phase) => sum + (phase.timeDuration ?? 0));
//   }
//
//   // Get remaining time as formatted string
//   String getRemainingTime(int phaseDuration) {
//     final minutes = remainingSeconds.value ~/ 60;
//     final seconds = remainingSeconds.value % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   // Get progress percentage for current phase
//   double get currentPhaseProgress {
//     final currentPhase = this.currentPhase;
//     if (currentPhase != null && currentPhase.timeDuration != null) {
//       final totalSeconds = currentPhase.timeDuration! * 60;
//       return totalSeconds > 0 ? (remainingSeconds.value / totalSeconds) : 0.0;
//     }
//     return 0.0;
//   }
//
//   // Check if phase is completed
//   bool isPhaseCompleted(int index) {
//     if (index >= 0 && index < allPhases.length) {
//       final phaseId = allPhases[index].id;
//       return phaseStates[phaseId] == PhaseState.completed;
//     }
//     return false;
//   }
//
//   // Check if phase is active
//   bool isPhaseActive(int index) {
//     if (index >= 0 && index < allPhases.length) {
//       final phaseId = allPhases[index].id;
//       return phaseStates[phaseId] == PhaseState.active;
//     }
//     return false;
//   }
//
//   // Check if phase is inactive (not started)
//   bool isPhaseInactive(int index) {
//     if (index >= 0 && index < allPhases.length) {
//       final phaseId = allPhases[index].id;
//       return phaseStates[phaseId] == PhaseState.inactive;
//     }
//     return false;
//   }
//
//   // Check if phase is pending (old method for compatibility)
//   bool isPhasePending(int index) {
//     return index > currentPhaseIndex.value;
//   }
//
//   // Get phase by index
//   Phases? getPhase(int index) {
//     if (index >= 0 && index < allPhases.length) {
//       return allPhases[index];
//     }
//     return null;
//   }
//
//   // Move to next phase - actually activate it
//   void nextPhase() {
//     if (currentPhaseIndex.value < totalPhasesCount - 1) {
//       // Mark current phase as completed
//       final currentPhaseId = currentPhase?.id;
//       if (currentPhaseId != null) {
//         phaseStates[currentPhaseId] = PhaseState.completed;
//       }
//
//       currentPhaseIndex.value++;
//
//       // Mark new phase as active
//       final newPhaseId = currentPhase?.id;
//       if (newPhaseId != null) {
//         phaseStates[newPhaseId] = PhaseState.active;
//       }
//
//       print('⏭️ Activated next phase: ${currentPhase?.name}');
//       startTimerForCurrentPhase();
//
//       Get.snackbar(
//         '⏭️ Phase Activated',
//         'Moved to ${currentPhase?.name ?? "Phase ${currentPhaseIndex.value + 1}"}',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//       );
//     } else {
//       Get.snackbar(
//         'ℹ️ Info',
//         'No more phases available',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }
//
//   // Move to previous phase - reactivate it
//   void previousPhase() {
//     if (currentPhaseIndex.value > 0) {
//       // Mark current phase as inactive
//       final currentPhaseId = currentPhase?.id;
//       if (currentPhaseId != null) {
//         phaseStates[currentPhaseId] = PhaseState.inactive;
//       }
//
//       currentPhaseIndex.value--;
//
//       // Mark previous phase as active
//       final newPhaseId = currentPhase?.id;
//       if (newPhaseId != null) {
//         phaseStates[newPhaseId] = PhaseState.active;
//       }
//
//       print('⏮️ Reactivated previous phase: ${currentPhase?.name}');
//       startTimerForCurrentPhase();
//
//       Get.snackbar(
//         '⏮️ Phase Reactivated',
//         'Returned to ${currentPhase?.name ?? "Phase ${currentPhaseIndex.value + 1}"}',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//     } else {
//       Get.snackbar(
//         'ℹ️ Info',
//         'Already at the first phase',
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }
//
//   // Refresh data
//   Future<void> refreshPhases() async {
//     print('🔄 Refreshing phases data');
//     await fetchGameFormatPhases();
//   }
//
//   // Test with sample data (for debugging)
//   void testWithSampleData() {
//     print('🧪 Loading test sample data');
//     final sampleData = {
//       "id": 14,
//       "gameFormatId": 11,
//       "description": "ww",
//       "createdById": 5,
//       "joinCode": "ac5028",
//       "joiningLink": "https://your-app.com/join/ac5028",
//       "status": "PAUSED",
//       "duration": 60,
//       "elapsedTime": 202,
//       "startedAt": null,
//       "pausedAt": "2025-10-11T05:54:11.624Z",
//       "endedAt": null,
//       "createdAt": "2025-10-11T05:50:42.179Z",
//       "updatedAt": "2025-10-11T05:54:11.627Z",
//       "gameFormat": {
//         "id": 11,
//         "name": "Test Game Format",
//         "description": "Test description",
//         "mode": "team",
//         "totalPhases": 3,
//         "timeDuration": 20,
//         "isPublished": false,
//         "isActive": true,
//         "createdAt": "2025-10-08T04:23:28.399Z",
//         "updatedAt": "2025-10-08T04:23:28.399Z",
//         "createdById": 1,
//         "phases": [
//           {
//             "id": 23,
//             "gameFormatId": 11,
//             "name": "Phase 1",
//             "description": "This is the first phase",
//             "order": 1,
//             "scoringType": "HYBRID",
//             "timeDuration": 5, // Shorter for testing
//             "challengeTypes": ["MCQ", "Puzzle"],
//             "difficulty": "MEDIUM",
//             "badge": "Starter Badge",
//             "requiredScore": 50,
//             "createdAt": "2025-10-11T07:41:30.120Z",
//             "updatedAt": "2025-10-11T07:41:30.120Z",
//           },
//           {
//             "id": 24,
//             "gameFormatId": 11,
//             "name": "Phase 2",
//             "description": "This is the second phase",
//             "order": 2,
//             "scoringType": "HYBRID",
//             "timeDuration": 3, // Shorter for testing
//             "challengeTypes": ["MCQ", "Puzzle"],
//             "difficulty": "MEDIUM",
//             "badge": "Intermediate Badge",
//             "requiredScore": 75,
//             "createdAt": "2025-10-11T07:41:40.738Z",
//             "updatedAt": "2025-10-11T07:41:40.738Z",
//           },
//           {
//             "id": 25,
//             "gameFormatId": 11,
//             "name": "Phase 3",
//             "description": "This is the third phase",
//             "order": 3,
//             "scoringType": "HYBRID",
//             "timeDuration": 4, // Shorter for testing
//             "challengeTypes": ["MCQ", "Puzzle"],
//             "difficulty": "HARD",
//             "badge": "Expert Badge",
//             "requiredScore": 100,
//             "createdAt": "2025-10-11T07:41:50.738Z",
//             "updatedAt": "2025-10-11T07:41:50.738Z",
//           }
//         ]
//       }
//     };
//
//     try {
//       gameFormatPhaseModel.value = GameFormatPhaseModel.fromJson(sampleData);
//       hasData.value = true;
//       currentPhaseIndex.value = 0;
//
//       // Initialize phase states for test data
//       _initializePhaseStates();
//
//       startTimerForCurrentPhase();
//       print('✅ Test data loaded successfully with ${allPhases.length} phases');
//
//       Get.snackbar(
//         '🧪 Test Data',
//         'Loaded ${allPhases.length} test phases',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.purple,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print('❌ Error loading test data: $e');
//     }
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     print('👋 GameFormatPhaseController disposed');
//     super.onClose();
//   }
// }