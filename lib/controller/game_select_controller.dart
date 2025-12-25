import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorer_web/api/api_controllers/question_for_sessions_controller.dart';
import 'package:scorer_web/api/api_controllers/player_q_submit_controller.dart';
import 'package:scorer_web/api/api_controllers/team_view_controller.dart';
import '../api/api_models/question_for_session_model.dart';
import '../shared_preference/shared_preference.dart';

class GameSelectController extends GetxController {
  // Observables
  final currentPhase = 0.obs;
  final currentQuestionIndex = 0.obs;
  final timeProgress = 0.0.obs;
  final remainingTime = "00:00".obs;
  final isPhaseActive = true.obs;
  final isCompleted = false.obs;
  final submittedQuestions = <int>{}.obs;
  final questionResponses = <int, dynamic>{}.obs;
  final puzzleSequences = <int, List<int>>{}.obs;

  // Dependencies
  final QuestionForSessionsController questionController;
  late final PlayerQSubmitController submitController;
  late final TeamViewController teamController;

  // Timer variables
  int _totalTimeInSeconds = 0;
  int _elapsedTimeInSeconds = 0;
  Timer? _timer;
  bool _autoSubmitted = false;

  GameSelectController({required this.questionController});

  @override
  void onInit() {
    super.onInit();
    submitController = Get.find<PlayerQSubmitController>();
    teamController = Get.find<TeamViewController>();
    _initializeController();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initializeController() {
    ever(questionController.questionData, (data) {
      if (data != null) {
        print("✅ Questions loaded in GameSelectController: ${data.phases.length} phases");
        _resetCurrentPhaseState();
        startTimer();
        _showPhaseStartMessage();
      }
    });
  }

  void _resetCurrentPhaseState() {
    currentQuestionIndex.value = 0;
    submittedQuestions.clear();
    _autoSubmitted = false;
    isPhaseActive.value = true;
    questionResponses.clear();
    puzzleSequences.clear();
  }

  void startTimer() {
    final phase = getCurrentPhase();
    if (phase != null) {
      _totalTimeInSeconds = phase.timeDuration; // Already in seconds
      _elapsedTimeInSeconds = 0;
      timeProgress.value = 0.0;
      isPhaseActive.value = true;
      updateRemainingTime();

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_elapsedTimeInSeconds < _totalTimeInSeconds && isPhaseActive.value) {
          _elapsedTimeInSeconds++;
          // Progress increases as time passes (0.0 to 1.0)
          timeProgress.value = _elapsedTimeInSeconds / _totalTimeInSeconds;
          updateRemainingTime();
        } else if (_elapsedTimeInSeconds >= _totalTimeInSeconds && !_autoSubmitted) {
          _autoSubmitted = true;
          timer.cancel();
          isPhaseActive.value = false;
          timeProgress.value = 1.0; // Complete the circle
          _autoSubmitPhaseQuestions();
        }
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    isPhaseActive.value = false;
  }

  void updateRemainingTime() {
    int remainingSeconds = _totalTimeInSeconds - _elapsedTimeInSeconds;
    if (remainingSeconds < 0) remainingSeconds = 0;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    remainingTime.value = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Phase? getCurrentPhase() {
    final data = questionController.questionData.value;
    if (data == null || currentPhase.value >= data.phases.length) return null;
    return data.phases[currentPhase.value];
  }

  List<Question> getCurrentPhaseQuestions() {
    final phase = getCurrentPhase();
    if (phase == null) return [];
    return List<Question>.from(phase.questions)..sort((a, b) => a.order.compareTo(b.order));
  }

  Question? getCurrentQuestion() {
    final questions = getCurrentPhaseQuestions();
    if (currentQuestionIndex.value < questions.length) {
      return questions[currentQuestionIndex.value];
    }
    return null;
  }

  bool isLastPhase() {
    final totalPhases = questionController.questionData.value?.phases.length ?? 0;
    return currentPhase.value >= totalPhases - 1;
  }

  bool isCurrentPhaseComplete() {
    final questions = getCurrentPhaseQuestions();
    return submittedQuestions.length == questions.length;
  }

  bool canSubmitQuestion() {
    if (isCurrentPhaseComplete()) return false;

    final currentQuestion = getCurrentQuestion();
    if (currentQuestion == null) return false;

    final type = currentQuestion.type.toUpperCase();

    if (type == 'MCQ') {
      return questionResponses.containsKey(currentQuestion.id);
    } else if (type == 'PUZZLE') {
      final sequence = puzzleSequences[currentQuestion.id];
      return sequence != null && sequence.isNotEmpty;
    }

    return true;
  }

  // MCQ Methods
  void selectMcqOption(int questionId, int optionIndex) {
    if (!isPhaseActive.value) return;
    questionResponses[questionId] = optionIndex;
  }

  int? getSelectedMcqOption(int questionId) {
    final response = questionResponses[questionId];
    return response is int ? response : null;
  }

  // Puzzle/Sequence Methods
  void toggleSequenceSelection(int questionId, int optionIndex) {
    if (!isPhaseActive.value) return;

    if (!puzzleSequences.containsKey(questionId)) {
      puzzleSequences[questionId] = [];
    }

    final sequence = puzzleSequences[questionId]!;
    if (sequence.contains(optionIndex)) {
      sequence.remove(optionIndex);
    } else {
      sequence.add(optionIndex);
    }
    puzzleSequences.refresh();
    questionResponses[questionId] = List<int>.from(sequence);
  }

  List<int> getPuzzleSequence(int questionId) {
    return puzzleSequences[questionId] ?? [];
  }

  void clearPuzzleSequence(int questionId) {
    puzzleSequences[questionId] = [];
    questionResponses.remove(questionId);
    puzzleSequences.refresh();
  }

  // Text Response Methods
  void saveTextResponse(int questionId, String text) {
    if (!isPhaseActive.value) return;
    questionResponses[questionId] = text;
  }

  String? getTextResponse(int questionId) {
    final response = questionResponses[questionId];
    return response is String ? response : null;
  }

  Future<void> submitCurrentQuestion() async {
    final currentQuestion = getCurrentQuestion();
    if (currentQuestion == null) return;

    print("🔄 Submitting question: ${currentQuestion.id}");

    try {
      final playerIdStr = await SharedPrefServices.getUserId();
      final playerId = int.tryParse(playerIdStr ?? '') ?? 0;

      if (playerId == 0) {
        Get.snackbar(
          'error'.tr,
          'player_id_not_found'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final sessionId = questionController.questionData.value?.sessionId ?? 1;
      final phase = getCurrentPhase();
      final phaseId = phase?.id ?? 0;

      final facilitatorId = teamController.teamView.value?.gameFormat.facilitators.isNotEmpty == true
          ? teamController.teamView.value!.gameFormat.facilitators[0].id
          : 1;

      final answerData = _prepareAnswerData(currentQuestion);

      await submitController.submitPlayerAnswer(
        playerId: playerId,
        facilitatorId: facilitatorId,
        sessionId: sessionId,
        phaseId: phaseId,
        questionId: currentQuestion.id,
        answerData: answerData,
      );

      if (submitController.successMessage.isNotEmpty) {
        submittedQuestions.add(currentQuestion.id);

        final isLastQuestion = currentQuestionIndex.value == getCurrentPhaseQuestions().length - 1;

        if (isLastQuestion) {
          _stopTimer();
          timeProgress.value = 1.0; // Complete the circle
          Get.snackbar(
            'phase_complete'.tr,
            'all_questions_submitted_wait'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        } else {
          _moveToNextQuestion();
          Get.snackbar(
            'question_submitted'.tr,
            'moving_to_next_question'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'submission_failed'.tr,
          submitController.errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error submitting question: $e");
      Get.snackbar(
        'submission_error'.tr,
        '${'failed_to_submit_question'.tr}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Map<String, dynamic> _prepareAnswerData(Question question) {
    final response = questionResponses[question.id];
    final type = question.type.toUpperCase();

    switch (type) {
      case 'MCQ':
        int selectedOption = -1;
        if (response is int) {
          selectedOption = response;
        } else if (response != null) {
          selectedOption = int.tryParse(response.toString()) ?? -1;
        }
        return {"selectedOption": selectedOption};

      case 'PUZZLE':
        List<int> sequence = [];
        if (response is List<int>) {
          sequence = response;
        } else if (response is List) {
          sequence = response.cast<int>().toList();
        }
        return {"sequence": sequence};

      case 'OPENENDED':
      case 'OPEN_ENDED':
      case 'SIMULATION':
        return {"textResponse": response?.toString() ?? ""};

      default:
        return {"response": response?.toString() ?? ""};
    }
  }

  void _moveToNextQuestion() {
    final questions = getCurrentPhaseQuestions();
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  Future<void> _autoSubmitPhaseQuestions() async {
    final phase = getCurrentPhase();
    if (phase == null) return;

    Get.snackbar(
      'times_up'.tr,
      'auto_submitting_answers'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );

    final playerIdStr = await SharedPrefServices.getUserId();
    final playerId = int.tryParse(playerIdStr ?? '') ?? 0;

    final sessionId = questionController.questionData.value?.sessionId ?? 1;
    final facilitatorId = teamController.teamView.value?.gameFormat.facilitators.isNotEmpty == true
        ? teamController.teamView.value!.gameFormat.facilitators[0].id
        : 1;

    for (final question in getCurrentPhaseQuestions()) {
      if (!submittedQuestions.contains(question.id)) {
        final answerData = _prepareAnswerData(question);

        await submitController.submitPlayerAnswer(
          playerId: playerId,
          facilitatorId: facilitatorId,
          sessionId: sessionId,
          phaseId: phase.id,
          questionId: question.id,
          answerData: answerData,
        );

        submittedQuestions.add(question.id);
      }
    }

    Get.snackbar(
      'phase_completed_auto'.tr,
      'all_answers_auto_submitted'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void moveToNextPhase() {
    final totalPhases = questionController.questionData.value?.phases.length ?? 0;
    if (currentPhase.value < totalPhases - 1) {
      currentPhase.value++;
      _resetCurrentPhaseState();
      startTimer();
      _showPhaseStartMessage();
    } else {
      isCompleted.value = true;
      Get.snackbar(
        'session_completed'.tr,
        'all_phases_completed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  List<String> getCurrentChallengeTypes() {
    final phase = getCurrentPhase();
    if (phase == null) return [];
    return phase.questions.map((q) => q.type.toUpperCase()).toSet().toList();
  }

  void _showPhaseStartMessage() {
    final currentPhaseNum = currentPhase.value + 1;
    final phase = getCurrentPhase();
    if (phase != null) {
      Get.snackbar(
        '${'phase'.tr} $currentPhaseNum ${'started'.tr}',
        phase.name,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  // Backward compatibility methods
  final clickCount = 0.obs;
  final gamevalue = 0.obs;

  void nextPhase() {
    if (currentPhase.value < 2) {
      currentPhase.value += 1;
    }
    clickCount.value += 1;
    isCompleted.value = true;
  }

  void pause() {
    isCompleted.value = false;
    _stopTimer();
  }

  void back() {
    currentPhase.value = 0;
    clickCount.value = 0;
    isCompleted.value = false;
    _resetCurrentPhaseState();
  }

  void gameSelect(int index) {
    gamevalue.value = index;
  }
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/api/api_controllers/question_for_sessions_controller.dart';
// import 'package:scorer_web/api/api_controllers/player_q_submit_controller.dart';
// import 'package:scorer_web/api/api_controllers/team_view_controller.dart';
// import '../api/api_models/question_for_session_model.dart';
// import '../shared_preference/shared_preference.dart';
//
// class GameSelectController extends GetxController {
//   // Observables
//   final currentPhase = 0.obs;
//   final currentQuestionIndex = 0.obs;
//   final timeProgress = 0.0.obs;
//   final remainingTime = "00:00".obs;
//   final isPhaseActive = true.obs;
//   final isCompleted = false.obs;
//   final submittedQuestions = <int>{}.obs;
//   final questionResponses = <int, dynamic>{}.obs;
//   final puzzleSequences = <int, List<int>>{}.obs;
//
//   // Dependencies
//   final QuestionForSessionsController questionController;
//   late final PlayerQSubmitController submitController;
//   late final TeamViewController teamController;
//
//   // Timer variables
//   int _totalTimeInSeconds = 0;
//   int _elapsedTimeInSeconds = 0;
//   Timer? _timer;
//   bool _autoSubmitted = false;
//
//   GameSelectController({required this.questionController});
//
//   @override
//   void onInit() {
//     super.onInit();
//     submitController = Get.find<PlayerQSubmitController>();
//     teamController = Get.find<TeamViewController>();
//     _initializeController();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
//
//   void _initializeController() {
//     ever(questionController.questionData, (data) {
//       if (data != null) {
//         print("✅ Questions loaded in GameSelectController: ${data.phases.length} phases");
//         _resetCurrentPhaseState();
//         startTimer();
//         _showPhaseStartMessage();
//       }
//     });
//   }
//
//   void _resetCurrentPhaseState() {
//     currentQuestionIndex.value = 0;
//     submittedQuestions.clear();
//     _autoSubmitted = false;
//     isPhaseActive.value = true;
//     questionResponses.clear();
//     puzzleSequences.clear();
//   }
//
//   void startTimer() {
//     final phase = getCurrentPhase();
//     if (phase != null) {
//       _totalTimeInSeconds = phase.timeDuration;
//       _elapsedTimeInSeconds = 0;
//       timeProgress.value = 0.0;
//       isPhaseActive.value = true;
//       updateRemainingTime();
//
//       _timer?.cancel();
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (_elapsedTimeInSeconds < _totalTimeInSeconds && isPhaseActive.value) {
//           _elapsedTimeInSeconds++;
//           timeProgress.value = _elapsedTimeInSeconds / _totalTimeInSeconds;
//           updateRemainingTime();
//         } else if (_elapsedTimeInSeconds >= _totalTimeInSeconds && !_autoSubmitted) {
//           _autoSubmitted = true;
//           timer.cancel();
//           isPhaseActive.value = false;
//           _autoSubmitPhaseQuestions();
//         }
//       });
//     }
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//     isPhaseActive.value = false;
//   }
//
//   void updateRemainingTime() {
//     int remainingSeconds = _totalTimeInSeconds - _elapsedTimeInSeconds;
//     if (remainingSeconds < 0) remainingSeconds = 0;
//     int minutes = remainingSeconds ~/ 60;
//     int seconds = remainingSeconds % 60;
//     remainingTime.value = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }
//
//   Phase? getCurrentPhase() {
//     final data = questionController.questionData.value;
//     if (data == null || currentPhase.value >= data.phases.length) return null;
//     return data.phases[currentPhase.value];
//   }
//
//   List<Question> getCurrentPhaseQuestions() {
//     final phase = getCurrentPhase();
//     if (phase == null) return [];
//     return List<Question>.from(phase.questions)..sort((a, b) => a.order.compareTo(b.order));
//   }
//
//   Question? getCurrentQuestion() {
//     final questions = getCurrentPhaseQuestions();
//     if (currentQuestionIndex.value < questions.length) {
//       return questions[currentQuestionIndex.value];
//     }
//     return null;
//   }
//
//   bool isLastPhase() {
//     final totalPhases = questionController.questionData.value?.phases.length ?? 0;
//     return currentPhase.value >= totalPhases - 1;
//   }
//
//   bool isCurrentPhaseComplete() {
//     final questions = getCurrentPhaseQuestions();
//     return submittedQuestions.length == questions.length;
//   }
//
//   bool canSubmitQuestion() {
//     if (isCurrentPhaseComplete()) return false;
//
//     final currentQuestion = getCurrentQuestion();
//     if (currentQuestion == null) return false;
//
//     final type = currentQuestion.type.toUpperCase();
//
//     if (type == 'MCQ') {
//       return questionResponses.containsKey(currentQuestion.id);
//     } else if (type == 'PUZZLE') {
//       final sequence = puzzleSequences[currentQuestion.id];
//       return sequence != null && sequence.isNotEmpty;
//     }
//
//     return true;
//   }
//
//   // MCQ Methods
//   void selectMcqOption(int questionId, int optionIndex) {
//     if (!isPhaseActive.value) return;
//     questionResponses[questionId] = optionIndex;
//   }
//
//   int? getSelectedMcqOption(int questionId) {
//     final response = questionResponses[questionId];
//     return response is int ? response : null;
//   }
//
//   // Puzzle/Sequence Methods
//   void toggleSequenceSelection(int questionId, int optionIndex) {
//     if (!isPhaseActive.value) return;
//
//     if (!puzzleSequences.containsKey(questionId)) {
//       puzzleSequences[questionId] = [];
//     }
//
//     final sequence = puzzleSequences[questionId]!;
//     if (sequence.contains(optionIndex)) {
//       sequence.remove(optionIndex);
//     } else {
//       sequence.add(optionIndex);
//     }
//     puzzleSequences.refresh();
//     questionResponses[questionId] = List<int>.from(sequence);
//   }
//
//   List<int> getPuzzleSequence(int questionId) {
//     return puzzleSequences[questionId] ?? [];
//   }
//
//   void clearPuzzleSequence(int questionId) {
//     puzzleSequences[questionId] = [];
//     questionResponses.remove(questionId);
//     puzzleSequences.refresh();
//   }
//
//   // Text Response Methods
//   void saveTextResponse(int questionId, String text) {
//     if (!isPhaseActive.value) return;
//     questionResponses[questionId] = text;
//   }
//
//   String? getTextResponse(int questionId) {
//     final response = questionResponses[questionId];
//     return response is String ? response : null;
//   }
//
//   Future<void> submitCurrentQuestion() async {
//     final currentQuestion = getCurrentQuestion();
//     if (currentQuestion == null) return;
//
//     print("🔄 Submitting question: ${currentQuestion.id}");
//
//     try {
//       final playerIdStr = await SharedPrefServices.getUserId();
//       final playerId = int.tryParse(playerIdStr ?? '') ?? 0;
//
//       if (playerId == 0) {
//         Get.snackbar(
//           'Error',
//           'Player ID not found',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       final sessionId = questionController.questionData.value?.sessionId ?? 1;
//       final phase = getCurrentPhase();
//       final phaseId = phase?.id ?? 0;
//
//       final facilitatorId = teamController.teamView.value?.gameFormat.facilitators.isNotEmpty == true
//           ? teamController.teamView.value!.gameFormat.facilitators[0].id
//           : 1;
//
//       final answerData = _prepareAnswerData(currentQuestion);
//
//       await submitController.submitPlayerAnswer(
//         playerId: playerId,
//         facilitatorId: facilitatorId,
//         sessionId: sessionId,
//         phaseId: phaseId,
//         questionId: currentQuestion.id,
//         answerData: answerData,
//       );
//
//       if (submitController.successMessage.isNotEmpty) {
//         submittedQuestions.add(currentQuestion.id);
//
//         final isLastQuestion = currentQuestionIndex.value == getCurrentPhaseQuestions().length - 1;
//
//         if (isLastQuestion) {
//           _stopTimer();
//           Get.snackbar(
//             'Phase ${currentPhase.value + 1} Complete! 🎉',
//             'All questions submitted!',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         } else {
//           _moveToNextQuestion();
//           Get.snackbar(
//             'Question Submitted ✅',
//             'Moving to next question',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         }
//       } else {
//         Get.snackbar(
//           'Submission Failed',
//           submitController.errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print("❌ Error submitting question: $e");
//       Get.snackbar(
//         'Submission Error',
//         'Failed to submit question: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Map<String, dynamic> _prepareAnswerData(Question question) {
//     final response = questionResponses[question.id];
//     final type = question.type.toUpperCase();
//
//     switch (type) {
//       case 'MCQ':
//         int selectedOption = -1;
//         if (response is int) {
//           selectedOption = response;
//         } else if (response != null) {
//           selectedOption = int.tryParse(response.toString()) ?? -1;
//         }
//         return {"selectedOption": selectedOption};
//
//       case 'PUZZLE':
//         List<int> sequence = [];
//         if (response is List<int>) {
//           sequence = response;
//         } else if (response is List) {
//           sequence = response.cast<int>().toList();
//         }
//         return {"sequence": sequence};
//
//       case 'OPENENDED':
//       case 'OPEN_ENDED':
//       case 'SIMULATION':
//         return {"textResponse": response?.toString() ?? ""};
//
//       default:
//         return {"response": response?.toString() ?? ""};
//     }
//   }
//
//   void _moveToNextQuestion() {
//     final questions = getCurrentPhaseQuestions();
//     if (currentQuestionIndex.value < questions.length - 1) {
//       currentQuestionIndex.value++;
//     }
//   }
//
//   Future<void> _autoSubmitPhaseQuestions() async {
//     final phase = getCurrentPhase();
//     if (phase == null) return;
//
//     Get.snackbar(
//       'Time\'s Up! ⏰',
//       'Auto-submitting answers...',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//
//     final playerIdStr = await SharedPrefServices.getUserId();
//     final playerId = int.tryParse(playerIdStr ?? '') ?? 0;
//
//     final sessionId = questionController.questionData.value?.sessionId ?? 1;
//     final facilitatorId = teamController.teamView.value?.gameFormat.facilitators.isNotEmpty == true
//         ? teamController.teamView.value!.gameFormat.facilitators[0].id
//         : 1;
//
//     for (final question in getCurrentPhaseQuestions()) {
//       if (!submittedQuestions.contains(question.id)) {
//         final answerData = _prepareAnswerData(question);
//
//         await submitController.submitPlayerAnswer(
//           playerId: playerId,
//           facilitatorId: facilitatorId,
//           sessionId: sessionId,
//           phaseId: phase.id,
//           questionId: question.id,
//           answerData: answerData,
//         );
//
//         submittedQuestions.add(question.id);
//       }
//     }
//
//     Get.snackbar(
//       'Phase ${currentPhase.value + 1} Completed!',
//       'All answers auto-submitted.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }
//
//   void moveToNextPhase() {
//     final totalPhases = questionController.questionData.value?.phases.length ?? 0;
//     if (currentPhase.value < totalPhases - 1) {
//       currentPhase.value++;
//       _resetCurrentPhaseState();
//       startTimer();
//       _showPhaseStartMessage();
//     } else {
//       isCompleted.value = true;
//       Get.snackbar(
//         'Session Completed! 🎉',
//         'All phases completed successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   List<String> getCurrentChallengeTypes() {
//     final phase = getCurrentPhase();
//     if (phase == null) return [];
//     return phase.questions.map((q) => q.type.toUpperCase()).toSet().toList();
//   }
//
//   void _showPhaseStartMessage() {
//     final currentPhaseNum = currentPhase.value + 1;
//     final phase = getCurrentPhase();
//     if (phase != null) {
//       Get.snackbar(
//         'Phase $currentPhaseNum Started',
//         phase.name,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   // Backward compatibility methods
//   final clickCount = 0.obs;
//   final gamevalue = 0.obs;
//
//   void nextPhase() {
//     if (currentPhase.value < 2) {
//       currentPhase.value += 1;
//     }
//     clickCount.value += 1;
//     isCompleted.value = true;
//   }
//
//   void pause() {
//     isCompleted.value = false;
//     _stopTimer();
//   }
//
//   void back() {
//     currentPhase.value = 0;
//     clickCount.value = 0;
//     isCompleted.value = false;
//     _resetCurrentPhaseState();
//   }
//
//   void gameSelect(int index) {
//     gamevalue.value = index;
//   }
// }