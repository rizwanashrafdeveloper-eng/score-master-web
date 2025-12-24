// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../api_models/view_response_model.dart';
// import '../auth_helper.dart';
// import '../../shared_preference/shared_preference.dart';
//
// class ViewResponsesController extends GetxController {
//   var isLoading = false.obs;
//   var allResponses = <Answer>[].obs;
//   var errorMessage = ''.obs;
//   var currentSessionId = 0.obs;
//   var currentPhaseId = 0.obs;
//   var facilitatorId = 0.obs;
//
//   // ✅ Track evaluated responses
//   var evaluatedResponseIds = <String>[].obs; // "playerId-questionId"
//   var responseScores = <String, int>{}.obs; // "playerId-questionId" -> score
//
//   int get scoredCount => allResponses.where((r) => r.score != null).length;
//   int get pendingCount => allResponses.where((r) => r.score == null).length;
//
//   @override
//   void onInit() {
//     super.onInit();
//     print('🎯 [VIEW RESPONSES] Controller initialized');
//     _initializeFromStorage();
//   }
//
//   Future<void> _initializeFromStorage() async {
//     try {
//       currentSessionId.value = await SharedPrefServices.getSessionId() ?? 0;
//       currentPhaseId.value = await SharedPrefServices.getCurrentPhaseId() ?? 0;
//       facilitatorId.value = await SharedPrefServices.getFacilitatorId() ?? 0;
//
//       print('📊 [VIEW RESPONSES] Loaded from storage:');
//       print('   Session: ${currentSessionId.value}');
//       print('   Phase: ${currentPhaseId.value}');
//       print('   Facilitator: ${facilitatorId.value}');
//
//       if (currentSessionId.value > 0 && currentPhaseId.value > 0) {
//         await fetchResponses();
//       }
//     } catch (e) {
//       print('⚠️ [VIEW RESPONSES] Storage init error: $e');
//     }
//   }
//
//   Future<void> fetchResponses() async {
//     try {
//       print('═══════════════════════════════════════════════');
//       print('🔄 [FETCH RESPONSES] Starting...');
//       print('═══════════════════════════════════════════════');
//
//       if (currentSessionId.value <= 0 || currentPhaseId.value <= 0) {
//         errorMessage.value = 'Missing session or phase information';
//         print('❌ [FETCH RESPONSES] Invalid IDs');
//         return;
//       }
//
//       isLoading(true);
//       errorMessage.value = '';
//
//       final token = await AuthHelper.getAuthToken();
//       if (token == null) {
//         errorMessage.value = 'Authentication required';
//         print('❌ [FETCH RESPONSES] No token');
//         return;
//       }
//
//       final url = 'https://score-master-backend.onrender.com/answers/session/${currentSessionId.value}/phase/${currentPhaseId.value}';
//       print('🌐 [FETCH RESPONSES] URL: $url');
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print('📥 [FETCH RESPONSES] Status: ${response.statusCode}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         print('📦 [FETCH RESPONSES] Data type: ${data.runtimeType}');
//
//         List<Answer> responses = [];
//         if (data is List) {
//           responses = data.map((json) => Answer.fromJson(json)).toList();
//         } else if (data['answers'] != null) {
//           responses = (data['answers'] as List)
//               .map((json) => Answer.fromJson(json))
//               .toList();
//         }
//
//         allResponses.value = responses;
//         print('✅ [FETCH RESPONSES] Loaded ${responses.length} responses');
//
//         // Update evaluated tracking
//         _updateEvaluatedTracking();
//
//       } else {
//         errorMessage.value = 'Failed to load responses: ${response.statusCode}';
//         print('❌ [FETCH RESPONSES] Error: ${response.statusCode}');
//       }
//     } catch (e, stack) {
//       errorMessage.value = 'Error: $e';
//       print('❌ [FETCH RESPONSES] Exception: $e');
//       print('Stack: $stack');
//     } finally {
//       isLoading(false);
//       print('🏁 [FETCH RESPONSES] Complete');
//     }
//   }
//
//   void _updateEvaluatedTracking() {
//     evaluatedResponseIds.clear();
//     responseScores.clear();
//
//     for (var response in allResponses) {
//       if (response.score != null) {
//         final key = '${response.player.id}-${response.question.id}';
//         evaluatedResponseIds.add(key);
//         responseScores[key] = response.score!;
//       }
//     }
//
//     print('📊 [TRACKING] Evaluated: ${evaluatedResponseIds.length}');
//   }
//
//   /// ✅ Mark response as evaluated (call after successful score submission)
//   void markAsEvaluated(int playerId, int questionId, int score) {
//     final key = '$playerId-$questionId';
//
//     print('✅ [MARK EVALUATED] $key -> Score: $score');
//
//     if (!evaluatedResponseIds.contains(key)) {
//       evaluatedResponseIds.add(key);
//     }
//     responseScores[key] = score;
//
//     // Update the response in the list
//     final index = allResponses.indexWhere(
//             (r) => r.player.id == playerId && r.question.id == questionId
//     );
//
//     if (index != -1) {
//       final updated = allResponses[index];
//       updated.score = score; // Update score
//       allResponses[index] = updated;
//       allResponses.refresh(); // Trigger UI update
//       print('✅ [MARK EVALUATED] Updated response in list');
//     }
//   }
//
//   /// ✅ Check if response is evaluated
//   bool isEvaluated(int playerId, int questionId) {
//     final key = '$playerId-$questionId';
//     return evaluatedResponseIds.contains(key);
//   }
//
//   /// ✅ Get score for response
//   int? getScore(int playerId, int questionId) {
//     final key = '$playerId-$questionId';
//     return responseScores[key];
//   }
//
//   void setSessionAndPhase(int sessionId, int phaseId) {
//     print('🎯 [SET IDs] Session: $sessionId, Phase: $phaseId');
//     currentSessionId.value = sessionId;
//     currentPhaseId.value = phaseId;
//     fetchResponses();
//   }
// }
//




import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/stage_controller.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_endpoints/api_end_points.dart';
import '../api_models/view_response_model.dart';
import '../auth_helper.dart';

class ViewResponsesController extends GetxController {
  var questionResponses = <QuestionResponse>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var phaseId = 0.obs;
  var facilitatorId = 0.obs;
  var currentSessionId = 0.obs;
  var currentPhaseName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🎯 ViewResponsesController initialized');
    _loadStoredData();
  }
// Add this method to ViewResponsesController

// Mark a response as evaluated and refresh
  void markAsEvaluated(int playerId, int questionId, int score) {
    try {
      print('═══════════════════════════════════════════════');
      print('🎯 [MARK EVALUATED] Updating local state');
      print('   - Player ID: $playerId');
      print('   - Question ID: $questionId');
      print('   - Score: $score');
      print('═══════════════════════════════════════════════');

      // Find and update the answer in local state
      bool found = false;
      for (var questionResponse in questionResponses) {
        for (var answer in questionResponse.answers) {
          if (answer.player.id == playerId && answer.question.id == questionId) {
            // Update would require creating a new Answer object with score
            // Since Answer is immutable, we need to refresh from API
            found = true;
            break;
          }
        }
        if (found) break;
      }

      if (found) {
        print('✅ [MARK EVALUATED] Found answer, refreshing from API...');
        // Refresh data from API to get updated scores
        fetchResponses();
      } else {
        print('⚠️ [MARK EVALUATED] Answer not found locally');
      }
    } catch (e) {
      print('❌ [MARK EVALUATED] Error: $e');
    }
  }

// Add this refresh trigger method
  Future<void> triggerRefresh() async {
    print('🔄 [TRIGGER REFRESH] Manual refresh requested');
    await fetchResponses();
  }
  Future<void> _loadStoredData() async {
    try {
      print('🔍 Loading stored data for responses controller...');

      final prefs = await SharedPreferences.getInstance();

      // ✅ Get Facilitator ID - NO FALLBACKS, REAL DATA ONLY
      final storedFacilitatorId = prefs.getInt('facilitator_id');
      if (storedFacilitatorId != null && storedFacilitatorId > 0) {
        facilitatorId.value = storedFacilitatorId;
        print('👤 Loaded facilitator ID from storage: $storedFacilitatorId');
      } else {
        // Try from user profile as LAST resort
        final userProfile = await SharedPrefServices.getUserProfile();
        if (userProfile != null && userProfile['id'] != null) {
          final id = userProfile['id'] is int
              ? userProfile['id']
              : int.tryParse(userProfile['id'].toString()) ?? 0;

          if (id > 0) {
            facilitatorId.value = id;
            // Save it for future use
            await prefs.setInt('facilitator_id', id);
            print('👤 Extracted facilitator ID from profile: $id');
          }
        }
      }

      // ✅ Get Phase ID - NO DEFAULTS
      final storedPhaseId = prefs.getInt('current_phase_id');
      if (storedPhaseId != null && storedPhaseId > 0) {
        phaseId.value = storedPhaseId;
        print('📋 Loaded phase ID from storage: $storedPhaseId');
      }

      // ✅ Get Session ID
      final storedSessionId = prefs.getInt('session_id');
      if (storedSessionId != null && storedSessionId > 0) {
        currentSessionId.value = storedSessionId;
        print('🎭 Loaded session ID from storage: $storedSessionId');
      }

      // ✅ Only auto-fetch if we have REAL IDs
      if (facilitatorId.value > 0 && phaseId.value > 0) {
        print('🔄 Auto-fetching responses with REAL IDs: facilitator=${facilitatorId.value}, phase=${phaseId.value}');
        await fetchResponses();
      } else {
        print('⚠️ Missing REAL IDs - facilitator=${facilitatorId.value}, phase=${phaseId.value}');
        errorMessage.value = 'Missing facilitator or phase information. Please ensure you are logged in and a phase is active.';
      }
    } catch (e) {
      print('❌ Error loading stored data: $e');
      errorMessage.value = 'Failed to load session data: $e';
    }
  }

  /// ✅ Set Phase ID - ONLY accept real IDs
  void setPhaseId(int id) {
    if (id <= 0) {
      print('❌ Rejected invalid phase ID: $id');
      return;
    }

    if (id != phaseId.value) {
      print('🎯 Setting phase ID: $id (was: ${phaseId.value})');
      phaseId.value = id;

      // Save to storage
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('current_phase_id', id);
        print('💾 Saved phase ID to storage: $id');
      });
    }
  }

  /// ✅ Set Facilitator ID - ONLY accept real IDs
  void setFacilitatorId(int id) {
    if (id <= 0) {
      print('❌ Rejected invalid facilitator ID: $id');
      return;
    }

    if (id != facilitatorId.value) {
      print('🎯 Setting facilitator ID: $id (was: ${facilitatorId.value})');
      facilitatorId.value = id;

      // Save to storage
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('facilitator_id', id);
        print('💾 Saved facilitator ID to storage: $id');
      });
    }
  }

  /// ✅ Set Session ID
  void setSessionId(int id) {
    if (id <= 0) {
      print('❌ Rejected invalid session ID: $id');
      return;
    }

    if (id != currentSessionId.value) {
      print('🎯 Setting session ID: $id (was: ${currentSessionId.value})');
      currentSessionId.value = id;
    }
  }

  int get scoredCount {
    if (questionResponses.isEmpty) return 0;
    int count = 0;
    for (var qr in questionResponses) {
      for (var answer in qr.answers) {
        if (answer.score != null) count++;
      }
    }
    return count;
  }

  int get pendingCount {
    if (questionResponses.isEmpty) return 0;
    int count = 0;
    for (var qr in questionResponses) {
      for (var answer in qr.answers) {
        if (answer.score == null) count++;
      }
    }
    return count;
  }

  List<Answer> get allResponses {
    if (questionResponses.isEmpty) return [];
    List<Answer> all = [];
    for (var qr in questionResponses) {
      all.addAll(qr.answers);
    }
    return all;
  }

  List<Answer> get filteredResponses {
    if (questionResponses.isEmpty) return [];

    try {
      final stageController = Get.find<StageController>();
      final tabIndex = stageController.selectedIndex.value;
      final allAnswers = allResponses;

      switch (tabIndex) {
        case 0: // All
          return allAnswers;
        case 1: // Pending
          return allAnswers.where((answer) => answer.score == null).toList();
        case 2: // Scored
          return allAnswers.where((answer) => answer.score != null).toList();
        default:
          return allAnswers;
      }
    } catch (e) {
      print('⚠️ StageController not found, returning all answers');
      return allResponses;
    }
  }

  /// ✅ Fetch Responses - NO HARDCODED VALUES
  Future<void> fetchResponses() async {
    try {
      // ✅ STRICT VALIDATION - NO DEFAULTS
      if (facilitatorId.value <= 0) {
        errorMessage.value = 'Invalid facilitator ID. Please log in again.';
        print('❌ Cannot fetch: Invalid facilitator ID (${facilitatorId.value})');
        return;
      }

      if (phaseId.value <= 0) {
        errorMessage.value = 'No active phase selected. Please select a phase.';
        print('❌ Cannot fetch: Invalid phase ID (${phaseId.value})');
        return;
      }

      print('🔄 Fetching responses with REAL IDs:');
      print('   - Facilitator ID: ${facilitatorId.value}');
      print('   - Phase ID: ${phaseId.value}');
      print('   - Session ID: ${currentSessionId.value}');

      isLoading(true);
      errorMessage.value = '';

      final token = await AuthHelper.getAuthToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication required. Please login again.';
        isLoading(false);
        print('❌ No auth token found');
        return;
      }

      final url = ApiEndpoints.viewResponse(facilitatorId.value, phaseId.value);
      print('🌐 API URL: $url');
      print('🔑 Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('📊 Response type: ${decoded.runtimeType}');

        if (decoded == null || (decoded is List && decoded.isEmpty)) {
          print('📭 No responses found for this phase');
          questionResponses.clear();
          errorMessage.value = 'No responses available for this phase yet.';
        } else if (decoded is List) {
          print('✅ Found ${decoded.length} question responses');
          questionResponses.value = decoded
              .map<QuestionResponse>((json) => QuestionResponse.fromJson(json))
              .toList();

          int totalAnswers = 0;
          for (var qr in questionResponses) {
            totalAnswers += qr.answers.length;
          }
          print('✅ Loaded ${questionResponses.length} questions with $totalAnswers answers');
          print('📊 Scored: $scoredCount, Pending: $pendingCount');
        } else {
          print('⚠️ Unexpected response format');
          errorMessage.value = 'Unexpected response format from server';
        }
      } else if (response.statusCode == 404) {
        print('❌ Endpoint not found (404)');
        errorMessage.value = 'No responses found for this phase.';
        questionResponses.clear();
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized (401)');
        errorMessage.value = 'Session expired. Please login again.';
      } else {
        print('❌ Server error: ${response.statusCode}');
        errorMessage.value = 'Failed to load responses: ${response.statusCode}';
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in fetchResponses: $e');
      errorMessage.value = 'Network error: ${e.toString()}';
    } finally {
      isLoading(false);
      print('🏁 Fetch responses completed');
    }
  }

  Future<void> refreshData() async {
    print('🔄 Manual refresh triggered');
    await fetchResponses();
  }

  void clearData() {
    questionResponses.clear();
    errorMessage.value = '';
    print('🧹 Cleared response data');
  }
}

