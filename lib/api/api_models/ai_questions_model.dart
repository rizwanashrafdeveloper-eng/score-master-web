// lib/api/api_models/ai_questions_model.dart

import 'package:scorer_web/api/api_models/questions_model.dart';

class AIQuestionResponse {
  final String type;
  final String scenario;
  final String questionText;
  final List<String> mcqOptions;
  final List<String> sequenceOptions;
  final List<String> correctSequence; // Changed to List<String> to match API response
  final Map<String, int> scoringRubric; // Changed to Map<String, int> for type safety
  final int point;

  AIQuestionResponse({
    required this.type,
    required this.scenario,
    required this.questionText,
    required this.mcqOptions,
    required this.sequenceOptions,
    required this.correctSequence,
    required this.scoringRubric,
    required this.point,
  });

  factory AIQuestionResponse.fromJson(Map<String, dynamic> json) {
    return AIQuestionResponse(
      type: json['type'] ?? '',
      scenario: json['scenario'] ?? '',
      questionText: json['questionText'] ?? '',
      mcqOptions: json['mcqOptions'] != null
          ? List<String>.from(json['mcqOptions'])
          : [],
      sequenceOptions: json['sequenceOptions'] != null
          ? List<String>.from(json['sequenceOptions'])
          : [],
      correctSequence: json['correctSequence'] != null
          ? List<String>.from(json['correctSequence'])
          : [],
      scoringRubric: json['scoringRubric'] != null
          ? (json['scoringRubric'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value is int ? value : int.tryParse(value.toString()) ?? 0))
          : {},
      point: json['point'] ?? 5,
    );
  }

  Question toQuestion(int phaseId, int order) {
    return Question(
      phaseId: phaseId,
      type: _convertToQuestionType(type),
      scenario: scenario,
      questionText: questionText,
      order: order,
      point: point,
      mcqOptions: mcqOptions.isNotEmpty ? mcqOptions : null,
      sequenceOptions: sequenceOptions.isNotEmpty ? sequenceOptions : null,
      correctSequence: correctSequence.isNotEmpty ? correctSequence.map((s) => s.split(') ').last).map((s) => int.tryParse(s) ?? 0).toList() : null,
      scoringRubric: scoringRubric,
    );
  }

  QuestionType _convertToQuestionType(String type) {
    switch (type.toUpperCase()) {
      case 'PUZZLE':
        return QuestionType.PUZZLE;
      case 'MCQ':
        return QuestionType.MCQ;
      case 'OPEN_ENDED':
        return QuestionType.OPEN_ENDED;
      case 'SIMULATION':
        return QuestionType.SIMULATION;
      default:
        return QuestionType.OPEN_ENDED;
    }
  }
}




class AIQuestionRequest {
  final String topic;
  final String type;
  final String gameName;
  final String phaseName;

  AIQuestionRequest({
    required this.topic,
    required this.type,
    required this.gameName,
    required this.phaseName,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'type': type,
      'gameName': gameName,
      'phaseName': phaseName,
    };
  }
}
