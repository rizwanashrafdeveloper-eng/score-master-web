// lib/api/api_controllers/game_format_phase_adapter.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_controllers/game_format_phase.dart';
import 'api_models/game_format_phase.dart';

class GameFormatPhaseAdapter extends GetxController {
  final GameFormatPhaseController _webController = Get.find();

  // Map all required methods to web controller
  bool get isLoading => _webController.isLoading.value;
  String get errorMessage => _webController.errorMessage.value;
  int get sessionId => _webController.sessionId.value;
  int get currentPhaseIndex => _webController.currentPhaseIndex.value;
  int get remainingSeconds => _webController.remainingSeconds.value;
  List<Phases> get allPhases => _webController.allPhases;

  Phases? get currentPhase => _webController.currentPhase;
  String get currentPhaseTitle => _webController.currentPhaseTitle;
  int get currentPhaseDuration => _webController.currentPhaseDuration;
  int get totalPhasesCount => _webController.totalPhasesCount;
  int get totalTimeDuration => _webController.totalTimeDuration;
  double get currentPhaseProgress => _webController.currentPhaseProgress;

  Future<void> fetchGameFormatPhases() => _webController.fetchGameFormatPhases();
  void setSessionId(int id) => _webController.setSessionId(id);

  String getRemainingTime([int? duration]) => _webController.getRemainingTime(duration);
  String getPhaseStatus(int index) => _webController.getPhaseStatus(index);
  Color getPhaseStatusColor(int index) => _webController.getPhaseStatusColor(index);
  IconData getPhaseStatusIcon(int index) => _webController.getPhaseStatusIcon(index);
  void previousPhase() => _webController.previousPhase();
  void nextPhase() => _webController.nextPhase();
}