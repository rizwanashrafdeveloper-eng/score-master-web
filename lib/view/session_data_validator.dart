// Add this helper class to ensure proper API usage:

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../api/api_controllers/game_format_phase.dart';
import '../shared_preference/shared_preference.dart';

class SessionDataValidator {
  /// ✅ Validates and gets session data - NO DEFAULTS
  static Future<Map<String, int>> getValidSessionData() async {
    final sessionId = await SharedPrefServices.getSessionId() ?? 0;
    final facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;
    final phaseId = await SharedPrefServices.getCurrentPhaseId() ?? 0;

    print('🔍 [Validator] Session Data Check:');
    print('   - Session ID: $sessionId ${sessionId == 0 ? "❌ INVALID" : "✅"}');
    print('   - Facilitator ID: $facilitatorId ${facilitatorId == 0 ? "❌ INVALID" : "✅"}');
    print('   - Phase ID: $phaseId ${phaseId == 0 ? "⚠️ NONE" : "✅"}');

    return {
      'sessionId': sessionId,
      'facilitatorId': facilitatorId,
      'phaseId': phaseId,
    };
  }

  /// ✅ Validates that required IDs are present
  static bool hasRequiredIds(Map<String, int> data) {
    final hasSession = data['sessionId']! > 0;
    final hasFacilitator = data['facilitatorId']! > 0;

    if (!hasSession) {
      print('❌ [Validator] Missing session ID');
    }
    if (!hasFacilitator) {
      print('❌ [Validator] Missing facilitator ID');
    }

    return hasSession && hasFacilitator;
  }

  /// ✅ Gets facilitator ID from multiple sources
  static Future<int> getFacilitatorId() async {
    // Try storage first
    int facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;

    if (facilitatorId > 0) {
      print('✅ [Validator] Facilitator ID from storage: $facilitatorId');
      return facilitatorId;
    }

    // Try user profile
    final profile = await SharedPrefServices.getUserProfile();
    if (profile != null && profile['id'] != null) {
      facilitatorId = profile['id'] is int
          ? profile['id']
          : int.tryParse(profile['id'].toString()) ?? 0;

      if (facilitatorId > 0) {
        // Save for future use
        await SharedPrefServices.saveFacilitatorId(facilitatorId);
        print('✅ [Validator] Facilitator ID from profile: $facilitatorId');
        return facilitatorId;
      }
    }

    print('❌ [Validator] No facilitator ID found');
    return 0;
  }

  /// ✅ Gets current phase ID from Phase Controller
  static Future<int> getCurrentPhaseId(int sessionId) async {
    if (sessionId == 0) {
      print('❌ [Validator] Cannot get phase ID - invalid session');
      return 0;
    }

    try {
      final phaseController = Get.put(GameFormatPhaseController());

      // Ensure we have the right session
      if (phaseController.sessionId.value != sessionId) {
        print('🔄 [Validator] Fetching phases for session $sessionId');
        phaseController.setSessionId(sessionId);
        await phaseController.fetchGameFormatPhases();
      }

      // Get the real current phase ID
      final phaseId = await phaseController.getCurrentPhaseId();

      if (phaseId > 0) {
        print('✅ [Validator] Current phase ID: $phaseId');
        return phaseId;
      } else {
        print('⚠️ [Validator] No active phase found');
        return 0;
      }
    } catch (e) {
      print('❌ [Validator] Error getting phase ID: $e');
      return 0;
    }
  }

  /// ✅ Prepares data for navigation to responses screen
  static Future<Map<String, int>?> prepareResponsesNavigation(int? sessionId) async {
    print('🎯 [Validator] Preparing navigation to responses...');

    // Get session ID
    final currentSessionId = sessionId ?? await SharedPrefServices.getSessionId() ?? 0;
    if (currentSessionId == 0) {
      print('❌ [Validator] No valid session ID');
      Get.snackbar('Error', 'No session selected');
      return null;
    }

    // Get facilitator ID
    final facilitatorId = await getFacilitatorId();
    if (facilitatorId == 0) {
      print('❌ [Validator] No valid facilitator ID');
      Get.snackbar('Error', 'Facilitator information not found. Please login again.');
      return null;
    }

    // Get current phase ID
    final phaseId = await getCurrentPhaseId(currentSessionId);
    if (phaseId == 0) {
      print('⚠️ [Validator] No active phase');
      Get.snackbar(
        'No Active Phase',
        'No active phase found. You can view phases but responses may be empty.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      // Don't return null - allow navigation with warning
    }

    final data = {
      'sessionId': currentSessionId,
      'facilitatorId': facilitatorId,
      'phaseId': phaseId,
    };

    print('✅ [Validator] Navigation data prepared:');
    print('   - Session: $currentSessionId');
    print('   - Facilitator: $facilitatorId');
    print('   - Phase: $phaseId');

    // Save all IDs
    await SharedPrefServices.saveSessionAndPhaseInfo(
      sessionId: currentSessionId,
      phaseId: phaseId,
      facilitatorId: facilitatorId,
    );

    return data;
  }
}

// ✅ USAGE EXAMPLE in any screen:

/*
// Replace any navigation to responses with:

onTap: () async {
  final data = await SessionDataValidator.prepareResponsesNavigation(sessionId);
  if (data != null) {
    Get.toNamed(
      RouteName.viewResponsesScreen,
      arguments: data,
    );
  }
},
*/