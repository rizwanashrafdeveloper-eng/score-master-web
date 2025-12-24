// active_schedule_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/schedule_and_active_session_model.dart';
import '../api_urls.dart';

class ActiveAndSessionController extends GetxController {
  final isLoading = false.obs;
  final sessionLoading = <int, bool>{}.obs; // Track loading per session
  final scheduleAndActiveSession = ScheduleAndActiveSessionModel().obs;
  final selectedIndex = 0.obs;
  final searchQuery = ''.obs;

  /// ✅ NEW: Track last action time to prevent rapid clicks
  final lastActionTime = <int, DateTime>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchScheduleAndActiveSessions();
  }

  /// ✅ Check if we should allow another action (prevent rapid clicks)
  bool canPerformAction(int sessionId) {
    final lastTime = lastActionTime[sessionId];
    if (lastTime == null) return true;

    final now = DateTime.now();
    final diff = now.difference(lastTime);
    return diff.inSeconds >= 2; // Minimum 2 seconds between actions
  }

  /// ✅ Update last action time
  void updateLastActionTime(int sessionId) {
    lastActionTime[sessionId] = DateTime.now();
  }

  /// ✅ Get filtered active sessions based on search
  List<ActiveSessions> get filteredActiveSessions {
    final sessions = scheduleAndActiveSession.value.activeSessions ?? [];
    if (searchQuery.value.isEmpty) return sessions;

    final query = searchQuery.value.toLowerCase();
    return sessions.where((session) {
      final title = (session.teamTitle ?? '').toLowerCase();
      final description = (session.description ?? '').toLowerCase();
      final status = (session.status ?? '').toLowerCase();
      return title.contains(query) ||
          description.contains(query) ||
          status.contains(query);
    }).toList();
  }

  /// ✅ Get filtered scheduled sessions based on search
  List<ScheduledSessions> get filteredScheduledSessions {
    final sessions = scheduleAndActiveSession.value.scheduledSessions ?? [];
    if (searchQuery.value.isEmpty) return sessions;

    final query = searchQuery.value.toLowerCase();
    return sessions.where((session) {
      final title = (session.teamTitle ?? '').toLowerCase();
      final description = (session.description ?? '').toLowerCase();
      final startTime = (session.startTime ?? '').toLowerCase();
      return title.contains(query) ||
          description.contains(query) ||
          startTime.contains(query);
    }).toList();
  }

  /// ✅ Optimized fetch with error handling
  Future<void> fetchScheduleAndActiveSessions({bool showLoading = true}) async {
    if (isLoading.value && showLoading) return;

    try {
      if (showLoading) isLoading.value = true;

      final token = await SharedPrefServices.getAuthToken() ?? '';
      final url = ApiEndpoints.scheduleAndActiveSession;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        scheduleAndActiveSession.value = ScheduleAndActiveSessionModel.fromJson(jsonData);

        // Clear all session loading states
        sessionLoading.clear();
      } else {
        print("Error fetching sessions: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching sessions: $e");
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  /// ✅ Update session status locally (immediate UI update)
  void updateSessionStatus(int sessionId, String newStatus) {
    // Find in active sessions
    var index = scheduleAndActiveSession.value.activeSessions
        ?.indexWhere((s) => s.id == sessionId);

    if (index != null && index != -1) {
      scheduleAndActiveSession.value.activeSessions![index].status = newStatus;
      scheduleAndActiveSession.refresh();
      return;
    }

    // Find in scheduled sessions (if starting early)
    index = scheduleAndActiveSession.value.scheduledSessions
        ?.indexWhere((s) => s.id == sessionId);

    if (index != null && index != -1) {
      // Remove from scheduled and add to active
      final session = scheduleAndActiveSession.value.scheduledSessions![index];
      scheduleAndActiveSession.value.scheduledSessions!.removeAt(index);

      scheduleAndActiveSession.value.activeSessions ??= [];
      scheduleAndActiveSession.value.activeSessions!.add(
        ActiveSessions(
          id: session.id,
          teamTitle: session.teamTitle,
          description: session.description,
          totalPlayers: session.totalPlayers,
          totalPhases: session.totalPhases,
          remainingTime: 0,
          status: 'ACTIVE',
        ),
      );

      scheduleAndActiveSession.refresh();
    }
  }

  /// ✅ Set session loading state
  void setSessionLoading(int sessionId, bool loading) {
    if (loading) {
      sessionLoading[sessionId] = true;
    } else {
      sessionLoading.remove(sessionId);
    }
  }

  /// ✅ Check if specific session is loading
  bool isSessionLoading(int sessionId) {
    return sessionLoading[sessionId] == true;
  }
}
