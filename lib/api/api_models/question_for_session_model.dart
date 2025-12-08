import 'dart:convert';

class QuestionForSessionModel {
  final int sessionId;
  final int gameFormatId;
  final List<Phase> phases;

  QuestionForSessionModel({
    required this.sessionId,
    required this.gameFormatId,
    required this.phases,
  });

  factory QuestionForSessionModel.fromJson(Map<String, dynamic> json) {
    return QuestionForSessionModel(
      sessionId: json['sessionId'],
      gameFormatId: json['gameFormatId'],
      phases: (json['phases'] as List)
          .map((e) => Phase.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'gameFormatId': gameFormatId,
      'phases': phases.map((e) => e.toJson()).toList(),
    };
  }
}

class Phase {
  final int id;
  final int gameFormatId;
  final String name;
  final String description;
  final int order;
  final String scoringType;
  final int timeDuration;
  final List<String> challengeTypes;
  final String difficulty;
  final String badge;
  final int requiredScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Question> questions;

  Phase({
    required this.id,
    required this.gameFormatId,
    required this.name,
    required this.description,
    required this.order,
    required this.scoringType,
    required this.timeDuration,
    required this.challengeTypes,
    required this.difficulty,
    required this.badge,
    required this.requiredScore,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Phase.fromJson(Map<String, dynamic> json) {
    return Phase(
      id: json['id'],
      gameFormatId: json['gameFormatId'],
      name: json['name'],
      description: json['description'],
      order: json['order'],
      scoringType: json['scoringType'],
      timeDuration: json['timeDuration'],
      challengeTypes: List<String>.from(json['challengeTypes']),
      difficulty: json['difficulty'],
      badge: json['badge'],
      requiredScore: json['requiredScore'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameFormatId': gameFormatId,
      'name': name,
      'description': description,
      'order': order,
      'scoringType': scoringType,
      'timeDuration': timeDuration,
      'challengeTypes': challengeTypes,
      'difficulty': difficulty,
      'badge': badge,
      'requiredScore': requiredScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

class Question {
  final int id;
  final int phaseId;
  final String type;
  final String scenario;
  final String questionText;
  final ScoringRubric scoringRubric;
  final int order;
  final int point;
  final List<String>? mcqOptions;
  final List<String>? sequenceOptions;
  final List<int>? correctSequence;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSelected; // Added for UI state
  final List<int>? selectedSequence; // Added for sequence question answers
  final String? selectedOption; // Added for MCQ answers

  Question({
    required this.id,
    required this.phaseId,
    required this.type,
    required this.scenario,
    required this.questionText,
    required this.scoringRubric,
    required this.order,
    required this.point,
    this.mcqOptions,
    this.sequenceOptions,
    this.correctSequence,
    required this.createdAt,
    required this.updatedAt,
    this.isSelected = false, // Default to false
    this.selectedSequence, // Nullable, no default
    this.selectedOption, // Nullable, no default
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      phaseId: json['phaseId'],
      type: json['type'],
      scenario: json['scenario'],
      questionText: json['questionText'],
      scoringRubric: ScoringRubric.fromJson(json['scoringRubric']),
      order: json['order'],
      point: json['point'],
      mcqOptions: json['mcqOptions'] != null ? List<String>.from(json['mcqOptions']) : null,
      sequenceOptions: json['sequenceOptions'] != null ? List<String>.from(json['sequenceOptions']) : null,
      correctSequence: json['correctSequence'] != null ? List<int>.from(json['correctSequence']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isSelected: json['isSelected'] ?? false,
      selectedSequence: json['selectedSequence'] != null ? List<int>.from(json['selectedSequence']) : null,
      selectedOption: json['selectedOption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phaseId': phaseId,
      'type': type,
      'scenario': scenario,
      'questionText': questionText,
      'scoringRubric': scoringRubric.toJson(),
      'order': order,
      'point': point,
      'mcqOptions': mcqOptions,
      'sequenceOptions': sequenceOptions,
      'correctSequence': correctSequence,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSelected': isSelected,
      'selectedSequence': selectedSequence,
      'selectedOption': selectedOption,
    };
  }
}

class ScoringRubric {
  final int wrong;
  final int correct;

  ScoringRubric({required this.wrong, required this.correct});

  factory ScoringRubric.fromJson(Map<String, dynamic> json) {
    return ScoringRubric(
      wrong: json['wrong'],
      correct: json['correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wrong': wrong,
      'correct': correct,
    };
  }
}









// import 'dart:convert';
//
// class QuestionForSessionModel {
//   final int sessionId;
//   final int gameFormatId;
//   final List<Phase> phases;
//
//   QuestionForSessionModel({
//     required this.sessionId,
//     required this.gameFormatId,
//     required this.phases,
//   });
//
//   factory QuestionForSessionModel.fromJson(Map<String, dynamic> json) {
//     return QuestionForSessionModel(
//       sessionId: json['sessionId'],
//       gameFormatId: json['gameFormatId'],
//       phases: (json['phases'] as List)
//           .map((e) => Phase.fromJson(e))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'sessionId': sessionId,
//       'gameFormatId': gameFormatId,
//       'phases': phases.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class Phase {
//   final int id;
//   final int gameFormatId;
//   final String name;
//   final String description;
//   final int order;
//   final String scoringType;
//   final int timeDuration;
//   final List<String> challengeTypes;
//   final String difficulty;
//   final String badge;
//   final int requiredScore;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final List<Question> questions;
//
//   Phase({
//     required this.id,
//     required this.gameFormatId,
//     required this.name,
//     required this.description,
//     required this.order,
//     required this.scoringType,
//     required this.timeDuration,
//     required this.challengeTypes,
//     required this.difficulty,
//     required this.badge,
//     required this.requiredScore,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.questions,
//   });
//
//   factory Phase.fromJson(Map<String, dynamic> json) {
//     return Phase(
//       id: json['id'],
//       gameFormatId: json['gameFormatId'],
//       name: json['name'],
//       description: json['description'],
//       order: json['order'],
//       scoringType: json['scoringType'],
//       timeDuration: json['timeDuration'],
//       challengeTypes: List<String>.from(json['challengeTypes']),
//       difficulty: json['difficulty'],
//       badge: json['badge'],
//       requiredScore: json['requiredScore'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       questions: (json['questions'] as List)
//           .map((e) => Question.fromJson(e))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'gameFormatId': gameFormatId,
//       'name': name,
//       'description': description,
//       'order': order,
//       'scoringType': scoringType,
//       'timeDuration': timeDuration,
//       'challengeTypes': challengeTypes,
//       'difficulty': difficulty,
//       'badge': badge,
//       'requiredScore': requiredScore,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'questions': questions.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class Question {
//   final int id;
//   final int phaseId;
//   final String type;
//   final String scenario;
//   final String questionText;
//   final ScoringRubric scoringRubric;
//   final int order;
//   final int point;
//   final List<String>? mcqOptions;
//   final List<String>? sequenceOptions;
//   final List<int>? correctSequence;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Question({
//     required this.id,
//     required this.phaseId,
//     required this.type,
//     required this.scenario,
//     required this.questionText,
//     required this.scoringRubric,
//     required this.order,
//     required this.point,
//     this.mcqOptions,
//     this.sequenceOptions,
//     this.correctSequence,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Question.fromJson(Map<String, dynamic> json) {
//     return Question(
//       id: json['id'],
//       phaseId: json['phaseId'],
//       type: json['type'],
//       scenario: json['scenario'],
//       questionText: json['questionText'],
//       scoringRubric: ScoringRubric.fromJson(json['scoringRubric']),
//       order: json['order'],
//       point: json['point'],
//       mcqOptions: json['mcqOptions'] != null ? List<String>.from(json['mcqOptions']) : null,
//       sequenceOptions: json['sequenceOptions'] != null ? List<String>.from(json['sequenceOptions']) : null,
//       correctSequence: json['correctSequence'] != null ? List<int>.from(json['correctSequence']) : null,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'phaseId': phaseId,
//       'type': type,
//       'scenario': scenario,
//       'questionText': questionText,
//       'scoringRubric': scoringRubric.toJson(),
//       'order': order,
//       'point': point,
//       'mcqOptions': mcqOptions,
//       'sequenceOptions': sequenceOptions,
//       'correctSequence': correctSequence,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }
//
// class ScoringRubric {
//   final int wrong;
//   final int correct;
//
//   ScoringRubric({required this.wrong, required this.correct});
//
//   factory ScoringRubric.fromJson(Map<String, dynamic> json) {
//     return ScoringRubric(
//       wrong: json['wrong'],
//       correct: json['correct'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'wrong': wrong,
//       'correct': correct,
//     };
//   }
// }
