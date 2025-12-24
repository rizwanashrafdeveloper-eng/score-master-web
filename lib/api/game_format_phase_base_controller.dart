// lib/api/api_controllers/game_format_phase_base_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_models/game_format_phase.dart';

abstract class GameFormatPhaseBaseController extends GetxController {
  // Common properties
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var sessionId = 0.obs;
  var currentPhaseIndex = 0.obs;
  var remainingSeconds = 0.obs;
  Timer? _timer;
  var allPhases = <Phases>[].obs;
  var gameFormatPhaseModel = Rxn<GameFormatPhaseModel>();
  var hasData = false.obs;

  // Required abstract methods
  Future<void> fetchGameFormatPhases();
  void setSessionId(int id);
  Phases? getPhaseById(int phaseId);
  int getPhaseIndexById(int phaseId);
  bool isPhaseActive(int index);
  bool isPhaseCompleted(int index);

  // Common methods with default implementations
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Getter methods with fallback implementations
  Phases? get currentPhase {
    if (allPhases.isNotEmpty && currentPhaseIndex.value < allPhases.length) {
      return allPhases[currentPhaseIndex.value];
    }
    return null;
  }

  String get currentPhaseTitle {
    return currentPhase?.name ?? "Phase ${currentPhaseIndex.value + 1}";
  }

  int get currentPhaseDuration {
    return currentPhase?.timeDuration ?? 0;
  }

  int get totalPhasesCount {
    return allPhases.length;
  }

  int get totalTimeDuration {
    return allPhases.fold(0, (sum, phase) => sum + (phase.timeDuration ?? 0));
  }

  String getRemainingTime(int phaseDuration) {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get currentPhaseProgress {
    final currentPhase = this.currentPhase;
    if (currentPhase != null && currentPhase.timeDuration != null) {
      final totalSeconds = currentPhase.timeDuration! * 60;
      return totalSeconds > 0 ? (remainingSeconds.value / totalSeconds) : 0.0;
    }
    return 0.0;
  }

  String getPhaseStatus(int index) {
    if (index < currentPhaseIndex.value) {
      return "completed".tr;
    } else if (index == currentPhaseIndex.value) {
      return "active".tr;
    } else {
      return "pending".tr;
    }
  }

  Color getPhaseStatusColor(int index) {
    if (index < currentPhaseIndex.value) {
      return Colors.green;
    } else if (index == currentPhaseIndex.value) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  IconData getPhaseStatusIcon(int index) {
    if (index < currentPhaseIndex.value) {
      return Icons.check;
    } else if (index == currentPhaseIndex.value) {
      return Icons.play_arrow;
    } else {
      return Icons.watch_later;
    }
  }

  void previousPhase() {
    if (currentPhaseIndex.value > 0) {
      currentPhaseIndex.value--;
      startTimerForCurrentPhase();
    }
  }

  void nextPhase() {
    if (currentPhaseIndex.value < totalPhasesCount - 1) {
      currentPhaseIndex.value++;
      startTimerForCurrentPhase();
    }
  }

  void startTimerForCurrentPhase() {
    final currentPhase = this.currentPhase;
    if (currentPhase != null && currentPhase.timeDuration != null) {
      remainingSeconds.value = currentPhase.timeDuration! * 60;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          timer.cancel();
        }
      });
    }
  }
}