import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// Add to your SharedPrefServices class:
// Add these methods to your existing SharedPrefServices class:
// Phone Number methods
  static Future<String?> getUserPhone() async {
    final prefs = await _prefs;
    return prefs.getString('userPhone');
  }

  static Future<void> saveUserPhone(String phone) async {
    final prefs = await _prefs;
    await prefs.setString('userPhone', phone);
    print('💾 Saved phone: $phone');
  }

// Update the saveUserProfile method to also save email and phone
  static Future<void> saveUserProfile(Map<String, dynamic> user) async {
    final prefs = await _prefs;

    await prefs.setString('userProfile', jsonEncode(user));

    // Also save individual fields for easy access
    if (user['email'] != null) {
      await saveUserEmail(user['email']);
    }
    if (user['phone'] != null) {
      await saveUserPhone(user['phone']);
    }
    if (user['name'] != null) {
      await saveUserName(user['name']);
    }

    print('💾 Saved complete user profile');
  }
// User Name methods (you have setUserName already, add getUserName)
  static Future<String?> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString('userName');
  }

// User Email methods
  static Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString('userEmail');
  }

  static Future<void> saveUserEmail(String email) async {
    final prefs = await _prefs;
    await prefs.setString('userEmail', email);
  }

// Language methods
  static Future<String?> getLanguageCode() async {
    final prefs = await _prefs;
    return prefs.getString('languageCode');
  }

  // In SharedPrefServices class, update this method:
  static Future<void> saveLanguage(String languageCode, [String? countryCode]) async {
    final prefs = await _prefs;
    await prefs.setString('languageCode', languageCode);
    if (countryCode != null) {
      await prefs.setString('countryCode', countryCode);
    }
  }

// Alias for saveUserName to match your existing code
  static Future<void> saveUserName(String name) async {
    await setUserName(name); // This calls your existing setUserName method
  }
  static Future<void> saveCurrentPhaseInfo(int phaseId, String phaseName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_phase_id', phaseId);
    await prefs.setString('current_phase_name', phaseName);
    print('💾 Saved phase info: id=$phaseId, name=$phaseName');
  }

  static Future<String?> getCurrentPhaseName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_phase_name');
  }

  static Future<Map<String, dynamic>> getSessionContext() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'sessionId': prefs.getInt('session_id'),
      'facilitatorId': prefs.getInt('facilitator_id'),
      'phaseId': prefs.getInt('current_phase_id'),
      'phaseName': prefs.getString('current_phase_name'),
    };
  }
  static Future<void> saveSessionAndPhaseInfo({
    required int sessionId,
    required int phaseId,
    required int facilitatorId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_session_id', sessionId);
    await prefs.setInt('current_phase_id', phaseId);
    await prefs.setInt('current_facilitator_id', facilitatorId);
    print('💾 Saved session/phase info: session=$sessionId, phase=$phaseId, facilitator=$facilitatorId');
  }

  static Future<int?> getCurrentSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_session_id');
  }

  static Future<int?> getCurrentPhaseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_phase_id');
  }

  static Future<int?> getCurrentFacilitatorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_facilitator_id');
  }


  // ✅ Save auth token
  static Future<void> setAuthToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString('auth_token', token);
  }

  // ✅ Get auth token
  static Future<String?> getAuthToken() async {
    final prefs = await _prefs;
    return prefs.getString('auth_token');
  }

  // // ✅ Save user profile (as JSON)
  // static Future<void> saveUserProfile(Map<String, dynamic> user) async {
  //   final prefs = await _prefs;
  //
  //   await prefs.setString('userProfile', jsonEncode(user));
  // }

  // ✅ Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await _prefs;
    final jsonStr = prefs.getString('userProfile');
    return jsonStr != null ? jsonDecode(jsonStr) : null;
  }

  // ✅ Save user ID
  static Future<void> saveUserId(String id) async {
    final prefs = await _prefs;
    await prefs.setString('userId', id);
  }

  // ✅ Save user ID
  static Future<void> savePlayerId(String id) async {
    final prefs = await _prefs;
    await prefs.setString('userId', id);
  }

  // ✅ Get user ID
  static Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString('userId');
  }

  // ✅ Save user name
  static Future<void> setUserName(String name) async {
    final prefs = await _prefs;
    await prefs.setString('userName', name);
  }

  // ✅ Save user role
  static Future<void> setUserRole(String role) async {
    final prefs = await _prefs;
    await prefs.setString('userRole', role);
  }

  // ✅ Save login role
  static Future<void> setLoginRole(String role) async {
    final prefs = await _prefs;
    await prefs.setString('loginRole', role);
  }

  // ✅ Get login role
  static Future<String?> getLoginRole() async {
    final prefs = await _prefs;
    return prefs.getString('loginRole');
  }

  // ✅ Clear all
  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }


  // === Preference Keys ===
  static const String _keyUserId = 'userId';
  static const String _keyUserProfile = 'userProfile';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserName = 'user_name';
  static const _keyUserRole = 'userRole';
  // static const String _keyUserRole = 'user_role';
  static const String _keySessionId = 'session_id';
  static const String _keyGameId = 'gameFormatId'; // updated key name
  static const String _keyTeamId = 'team_id';




  static Future<void> saveSessionInfo({
    required int sessionId,
    required int gameFormatId,
    required int playerId,
    String? joinCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessionId', sessionId);
    await prefs.setInt('gameFormatId', gameFormatId);
    await prefs.setInt('playerId', playerId);
    if (joinCode != null) await prefs.setString('joinCode', joinCode);
  }
  //
  // static Future<int?> getSessionId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt('sessionId');
  // }




  static Future<int?> getGameFormatId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('gameFormatId');
  }

  static Future<int?> getPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('playerId');
  }

  static Future<String?> getJoinCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('joinCode');
  }



  //
  // // === User ID Methods ===
  // static Future<void> saveUserId(int userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(_keyUserId, userId);
  //   log('[SharedPref] Saved userId: $userId');
  // }
  //
  // static Future<int?> getUserId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getInt(_keyUserId);
  //   log('ℹ [SharedPref] Fetched userId: $userId');
  //   return userId;
  // }


  // === Facilitator ID Methods ===
  static const String _keyFacilitatorId = 'facilitator_id';

  static Future<void> saveFacilitatorId(int facilitatorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFacilitatorId, facilitatorId);
    log('[SharedPref] Saved facilitatorId: $facilitatorId');
  }

  static Future<int?> getFacilitatorId() async {
    final prefs = await SharedPreferences.getInstance();
    final facilitatorId = prefs.getInt(_keyFacilitatorId);
    log('ℹ [SharedPref] Fetched facilitatorId: $facilitatorId');
    return facilitatorId;
  }
//
//   static Future<void> clearFacilitatorId() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyFacilitatorId);
//     log('[SharedPref] Cleared facilitatorId');
//   }
//
//
//   // === User Profile Methods ===
//   static Future<void> saveUserProfile(Map<String, dynamic> profile) async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonProfile = jsonEncode(profile);
//     await prefs.setString(_keyUserProfile, jsonProfile);
//     log('[SharedPref] Saved userProfile: $jsonProfile');
//   }
//
//   static Future<Map<String, dynamic>?> getUserProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     final profileString = prefs.getString(_keyUserProfile);
//     log('[SharedPref] Fetched userProfile: $profileString');
//     return profileString != null ? jsonDecode(profileString) : null;
//   }
//
//   // === Auth Token Methods ===
//   static Future<void> setAuthToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyAuthToken, token);
//     log('[SharedPref] Saved token: $token');
//   }
//
//   static Future<String?> getAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_keyAuthToken);
//     log('ℹ [SharedPref] Fetched token: $token');
//     return token;
//   }
//
//   // === User Name Methods ===
//   static Future<void> setUserName(String name) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyUserName, name);
//     log('[SharedPref] Saved userName: $name');
//   }
//
//   static Future<String?> getUserName() async {
//     final prefs = await SharedPreferences.getInstance();
//     final name = prefs.getString(_keyUserName);
//     log('ℹ [SharedPref] Fetched userName: $name');
//     return name;
//   }
//
//
//
// // Save role
//   static Future<void> setUserRole(String role) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyUserRole, role);
//     log('[SharedPref] Saved userRole: $role');
//   }

// Get role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_keyUserRole);
    log('ℹ [SharedPref] Fetched userRole: $role');
    return role;
  }

  //
  // // === User Role Methods ===
  // static Future<void> setUserRole(String role) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_keyUserRole, role);
  //   log('[SharedPref] Saved userRole: $role');
  // }
  //
  // static Future<String?> getUserRole() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final role = prefs.getString(_keyUserRole);
  //   log('ℹ [SharedPref] Fetched userRole: $role');
  //   return role;
  // }

  // === Session ID Methods ===
  static Future<void> saveSessionId(int sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySessionId, sessionId);
    log('[SharedPref] Saved sessionId: $sessionId');
  }

  static Future<int?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getInt(_keySessionId);
    log('ℹ [SharedPref] Fetched sessionId: $sessionId');
    return sessionId;
  }

  static Future<void> clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessionId);
    log('[SharedPref] Cleared sessionId');
  }

  // === Game Format ID Methods ===
  static Future<void> saveGameId(int gameFormatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGameId, gameFormatId);
    log('[SharedPref] Saved gameFormatId: $gameFormatId');
  }

  static Future<int?> getGameId() async {
    final prefs = await SharedPreferences.getInstance();
    final gameId = prefs.getInt(_keyGameId);
    log('ℹ [SharedPref] Fetched gameFormatId: $gameId');
    return gameId;
  }

  static Future<void> clearGameId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGameId);
    log('[SharedPref] Cleared gameFormatId');
  }

  // === Team ID Methods ===
  static Future<void> saveTeamId(int teamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTeamId, teamId);
    log('[SharedPref] Saved teamId: $teamId');
  }

  static Future<int?> getTeamId() async {
    final prefs = await SharedPreferences.getInstance();
    final teamId = prefs.getInt(_keyTeamId);
    log('ℹ [SharedPref] Fetched teamId: $teamId');
    return teamId;
  }

  static Future<void> clearTeamId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTeamId);
    log('[SharedPref] Cleared teamId');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserProfile);
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keySessionId);
    await prefs.remove(_keyGameId);
    await prefs.remove(_keyTeamId);
    await prefs.remove('playerId');
    await prefs.remove('joinCode');
    await prefs.remove(_keyFacilitatorId);
    await prefs.remove('userEmail');
    await prefs.remove('userPhone');
    await prefs.remove('languageCode');
    await prefs.remove('countryCode');
    log('🧹 [SharedPref] Cleared all user data');
  }
}
