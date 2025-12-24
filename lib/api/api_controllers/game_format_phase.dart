// lib/api/api_controllers/game_format_phase.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_endpoints/api_end_points.dart';
import '../api_models/game_format_phase.dart';
import '../auth_helper.dart';
import '../game_format_phase_base_controller.dart';

class GameFormatPhaseController extends GameFormatPhaseBaseController {

  /// ✅ Track the REAL current phase from API
  var realCurrentPhaseId = 0.obs;

// In your GameFormatPhaseController, update the fetchGameFormatPhases method:

  Future<void> fetchGameFormatPhases() async {
    try {
      print('═══════════════════════════════════════════════');
      print('🔄 [PHASE FETCH] Starting phase fetch...');
      print('═══════════════════════════════════════════════');

      if (sessionId.value == 0) {
        errorMessage.value = 'No session ID provided';
        print('❌ [PHASE FETCH] REJECTED: Session ID is 0');
        return;
      }

      print('✅ [PHASE FETCH] Session ID validated: ${sessionId.value}');

      isLoading(true);
      errorMessage.value = '';
      hasData.value = false;

      final token = await AuthHelper.getAuthToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication required';
        isLoading(false);
        print('❌ [PHASE FETCH] No auth token available');
        return;
      }

      print('✅ [PHASE FETCH] Auth token validated');

      final url = ApiEndpoints.getPhaseSessionUrl(sessionId.value);
      print('🌐 [PHASE FETCH] API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 [PHASE FETCH] Response Status: ${response.statusCode}');
      print('📦 [PHASE FETCH] Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('📊 [PHASE FETCH] Decoded JSON type: ${jsonData.runtimeType}');
        print('📊 [PHASE FETCH] Full JSON response:');
        print(jsonData);
        print('📊 [PHASE FETCH] JSON Keys: ${jsonData.keys}');

        // ✅ Extract current/active phase ID from multiple possible locations
        int? activePhaseId;

        // Try different possible keys
        if (jsonData['currentPhaseId'] != null) {
          activePhaseId = jsonData['currentPhaseId'];
          print('🎯 [PHASE FETCH] Found currentPhaseId: $activePhaseId');
        } else if (jsonData['activePhaseId'] != null) {
          activePhaseId = jsonData['activePhaseId'];
          print('🎯 [PHASE FETCH] Found activePhaseId: $activePhaseId');
        } else if (jsonData['activePhase'] != null) {
          if (jsonData['activePhase'] is Map && jsonData['activePhase']['id'] != null) {
            activePhaseId = jsonData['activePhase']['id'];
            print('🎯 [PHASE FETCH] Found activePhase.id: $activePhaseId');
          }
        } else if (jsonData['currentPhase'] != null) {
          if (jsonData['currentPhase'] is Map && jsonData['currentPhase']['id'] != null) {
            activePhaseId = jsonData['currentPhase']['id'];
            print('🎯 [PHASE FETCH] Found currentPhase.id: $activePhaseId');
          }
        }

        if (activePhaseId != null) {
          print('✅ [PHASE FETCH] Active Phase ID extracted: $activePhaseId');
        } else {
          print('⚠️ [PHASE FETCH] No active phase ID in response, will use first phase');
        }

        // Extract phases from response
        List<Phases> phasesList = [];

        // Check for phases in different possible locations
        if (jsonData['phases'] != null && jsonData['phases'] is List) {
          print('📋 [PHASE FETCH] Extracting phases from root phases array');
          phasesList = (jsonData['phases'] as List)
              .map<Phases>((phaseJson) => Phases.fromJson(phaseJson))
              .toList();
          print('✅ [PHASE FETCH] Extracted ${phasesList.length} phases from root');
        } else if (jsonData['gameFormat'] != null && jsonData['gameFormat']['phases'] != null) {
          print('📋 [PHASE FETCH] Extracting phases from gameFormat.phases');
          gameFormatPhaseModel.value = GameFormatPhaseModel.fromJson(jsonData);
          phasesList = gameFormatPhaseModel.value?.gameFormat?.phases ?? [];
          print('✅ [PHASE FETCH] Extracted ${phasesList.length} phases from gameFormat');
        } else if (jsonData['sessionPhases'] != null && jsonData['sessionPhases'] is List) {
          print('📋 [PHASE FETCH] Extracting phases from sessionPhases array');
          phasesList = (jsonData['sessionPhases'] as List)
              .map<Phases>((phaseJson) => Phases.fromJson(phaseJson))
              .toList();
          print('✅ [PHASE FETCH] Extracted ${phasesList.length} phases from sessionPhases');
        } else {
          print('❌ [PHASE FETCH] No phases found in response');
          print('📊 [PHASE FETCH] Available keys: ${jsonData.keys}');

          // If we have a gameFormat but no phases, maybe it's nested differently
          if (jsonData['gameFormat'] != null) {
            print('📊 [PHASE FETCH] GameFormat exists, checking structure:');
            print(jsonData['gameFormat']);
          }
        }

        if (phasesList.isEmpty) {
          errorMessage.value = 'No phases found for this session';
          print('❌ [PHASE FETCH] FAILED: No phases in response');
          isLoading(false);
          return;
        }

        allPhases.value = phasesList;
        print('✅ [PHASE FETCH] Total phases loaded: ${allPhases.length}');

        // Log each phase
        for (int i = 0; i < allPhases.length; i++) {
          final phase = allPhases[i];
          print('   Phase ${i + 1}: ID=${phase.id}, Name="${phase.name}", Order=${phase.order}, Duration=${phase.timeDuration}');
        }

        // ✅ Set the real current phase
        if (activePhaseId != null && activePhaseId > 0) {
          realCurrentPhaseId.value = activePhaseId;
          print('🎯 [PHASE FETCH] Setting realCurrentPhaseId: $activePhaseId');

          // Find the index of this phase
          final index = allPhases.indexWhere((p) => p.id == activePhaseId);
          if (index != -1) {
            currentPhaseIndex.value = index;
            print('✅ [PHASE FETCH] Found phase at index $index');
            print('   Phase Name: ${allPhases[index].name}');
          } else {
            print('⚠️ [PHASE FETCH] Phase ID $activePhaseId not found in list');
            print('   Available Phase IDs: ${allPhases.map((p) => p.id).toList()}');
            currentPhaseIndex.value = 0;
            realCurrentPhaseId.value = allPhases.first.id ?? 0;
            print('⚠️ [PHASE FETCH] Defaulting to first phase: ${realCurrentPhaseId.value}');
          }
        } else {
          // No active phase specified, use first phase
          currentPhaseIndex.value = 0;
          realCurrentPhaseId.value = allPhases.first.id ?? 0;
          print('⚙️ [PHASE FETCH] No active phase from API');
          print('   Using first phase: ID=${realCurrentPhaseId.value}, Name="${allPhases.first.name}"');
        }

        // ✅ Save the REAL current phase ID
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('current_phase_id', realCurrentPhaseId.value);
        print('💾 [PHASE FETCH] Saved to storage: current_phase_id=${realCurrentPhaseId.value}');

        hasData.value = true;
        startTimerForCurrentPhase();

        print('═══════════════════════════════════════════════');
        print('✅ [PHASE FETCH] SUCCESS!');
        print('   Total Phases: ${allPhases.length}');
        print('   Current Phase ID: ${realCurrentPhaseId.value}');
        print('   Current Phase Index: ${currentPhaseIndex.value}');
        print('   Current Phase Name: ${currentPhase?.name ?? "Unknown"}');
        print('═══════════════════════════════════════════════');

      } else {
        errorMessage.value = 'Failed to load phases: ${response.statusCode}';
        print('❌ [PHASE FETCH] HTTP Error: ${response.statusCode}');
        print('   Response: ${response.body}');
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error: $e';
      print('❌ [PHASE FETCH] EXCEPTION: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading(false);
      print('🏁 [PHASE FETCH] Completed (loading=false)');
    }
  }

  /// ✅ Get the REAL current phase ID (not index-based)
  Future<int> getCurrentPhaseId() async {
    try {
      print('🔍 [GET PHASE ID] Requesting current phase ID...');

      // If we have a real current phase ID, use it
      if (realCurrentPhaseId.value > 0) {
        print('✅ [GET PHASE ID] Using cached: ${realCurrentPhaseId.value}');
        return realCurrentPhaseId.value;
      }

      print('⚠️ [GET PHASE ID] No cached ID, fetching phases...');

      // Otherwise fetch phases to get it
      if (allPhases.isEmpty) {
        await fetchGameFormatPhases();
      }

      // After fetch, return the real current phase ID
      if (realCurrentPhaseId.value > 0) {
        print('✅ [GET PHASE ID] Got from fetch: ${realCurrentPhaseId.value}');
        return realCurrentPhaseId.value;
      }

      // Last resort: return first phase ID if available
      if (allPhases.isNotEmpty) {
        final firstPhaseId = allPhases.first.id ?? 0;
        print('⚙️ [GET PHASE ID] Using first phase: $firstPhaseId');
        return firstPhaseId;
      }

      print('❌ [GET PHASE ID] No phases available');
      return 0;
    } catch (e) {
      print('❌ [GET PHASE ID] Error: $e');
      return 0;
    }
  }

  @override
  void setSessionId(int id) {
    if (id <= 0) {
      print('❌ [SET SESSION] Rejected invalid ID: $id');
      return;
    }

    print('🎯 [SET SESSION] Setting session ID: $id (was: ${sessionId.value})');
    sessionId.value = id;

    // Reset phase tracking when session changes
    realCurrentPhaseId.value = 0;
    currentPhaseIndex.value = 0;
    print('🔄 [SET SESSION] Reset phase tracking');
  }

  @override
  Phases? getPhaseById(int phaseId) {
    final phase = allPhases.firstWhereOrNull((phase) => phase.id == phaseId);
    if (phase != null) {
      print('✅ [GET BY ID] Found phase $phaseId: ${phase.name}');
    } else {
      print('❌ [GET BY ID] Phase $phaseId not found');
    }
    return phase;
  }

  @override
  int getPhaseIndexById(int phaseId) {
    final index = allPhases.indexWhere((phase) => phase.id == phaseId);
    print('🔍 [GET INDEX] Phase $phaseId is at index: $index');
    return index;
  }

  @override
  bool isPhaseActive(int index) {
    if (index < 0 || index >= allPhases.length) return false;

    final isCurrentIndex = index == currentPhaseIndex.value;
    final phase = allPhases[index];
    final isCurrentId = phase.id == realCurrentPhaseId.value;

    final result = isCurrentIndex || isCurrentId;
    if (result) {
      print('✅ [IS ACTIVE] Phase at index $index is ACTIVE');
    }
    return result;
  }

  @override
  bool isPhaseCompleted(int index) {
    return index < currentPhaseIndex.value;
  }

  /// ✅ Get current phase with proper null handling
  Phases? get currentPhase {
    if (allPhases.isEmpty) {
      print('⚠️ [CURRENT PHASE] No phases available');
      return null;
    }

    // Try to find by real current phase ID first
    if (realCurrentPhaseId.value > 0) {
      final phase = allPhases.firstWhereOrNull((p) => p.id == realCurrentPhaseId.value);
      if (phase != null) {
        return phase;
      }
    }

    // Fall back to index
    if (currentPhaseIndex.value >= 0 && currentPhaseIndex.value < allPhases.length) {
      return allPhases[currentPhaseIndex.value];
    }

    print('⚠️ [CURRENT PHASE] Could not determine current phase');
    return null;
  }

  void refreshPhases() {
    print('🔄 [REFRESH] Manual phase refresh triggered');
    fetchGameFormatPhases();
  }

  @override
  String getRemainingTime([int? phaseDuration]) {
    final duration = phaseDuration ?? currentPhaseDuration * 60;
    final minutes = (remainingSeconds.value ~/ 60).clamp(0, duration ~/ 60);
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// ✅ Navigate to specific phase by ID
  Future<void> navigateToPhaseById(int phaseId) async {
    if (phaseId <= 0) {
      print('❌ [NAVIGATE] Invalid phase ID: $phaseId');
      return;
    }

    final index = allPhases.indexWhere((p) => p.id == phaseId);
    if (index == -1) {
      print('❌ [NAVIGATE] Phase ID $phaseId not found in list');
      return;
    }

    print('🎯 [NAVIGATE] Moving to phase ID $phaseId at index $index');
    currentPhaseIndex.value = index;
    realCurrentPhaseId.value = phaseId;

    // Save to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_phase_id', phaseId);
    print('💾 [NAVIGATE] Saved phase ID: $phaseId');

    startTimerForCurrentPhase();
  }
}


