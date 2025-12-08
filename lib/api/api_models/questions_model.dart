// File: lib/api/api_models/questions_model.dart
// Changes: Added QuestionType enum for better type safety.
// The rest remains the same, but updated fromJson and toJson to handle the enum.

enum QuestionType { PUZZLE, MCQ, OPEN_ENDED, SIMULATION }


// Update your Question model in lib/api/api_models/questions_model.dart
class Question {
  final int id; // Add this if missing
  final int phaseId;
  final QuestionType type;
  final String scenario;
  final String questionText;
  final int order;
  final int point;
  final int correctOption; // ADD THIS FIELD

  // Type-specific fields
  final List<String>? sequenceOptions;
  final List<int>? correctSequence;
  final List<String>? mcqOptions;
  final Map<String, dynamic>? scoringRubric;

  Question({
    this.id = 0, // Add this
    required this.phaseId,
    required this.type,
    required this.scenario,
    required this.questionText,
    required this.order,
    required this.point,
    this.correctOption = 0, // Add with default value
    this.sequenceOptions,
    this.correctSequence,
    this.mcqOptions,
    this.scoringRubric,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      phaseId: json['phaseId'],
      type: QuestionType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
        orElse: () => QuestionType.PUZZLE,
      ),
      scenario: json['scenario'] ?? '',
      questionText: json['questionText'] ?? '',
      order: json['order'] ?? 0,
      point: json['point'] ?? 0,
      correctOption: json['correctOption'] ?? 0, // Add this
      sequenceOptions: json['sequenceOptions'] != null
          ? List<String>.from(json['sequenceOptions'])
          : null,
      correctSequence: json['correctSequence'] != null
          ? List<int>.from(json['correctSequence'])
          : null,
      mcqOptions: json['mcqOptions'] != null
          ? List<String>.from(json['mcqOptions'])
          : null,
      scoringRubric: json['scoringRubric'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "phaseId": phaseId,
      "type": type.toString().split('.').last,
      "scenario": scenario,
      "questionText": questionText,
      "order": order,
      "point": point,
      "correctOption": correctOption, // Add this
      if (sequenceOptions != null) "sequenceOptions": sequenceOptions,
      if (correctSequence != null) "correctSequence": correctSequence,
      if (mcqOptions != null) "mcqOptions": mcqOptions,
      if (scoringRubric != null) "scoringRubric": scoringRubric,
    };
  }
}
// class Question {
//   final int phaseId;
//   final QuestionType type;
//   final String scenario;
//   final String questionText;
//   final int order;
//   final int point;
//
//
//   // Type-specific fields
//   final List<String>? sequenceOptions;
//   final List<int>? correctSequence;
//   final List<String>? mcqOptions;
//   final Map<String, dynamic>? scoringRubric;
//
//   Question({
//     required this.phaseId,
//     required this.type,
//     required this.scenario,
//     required this.questionText,
//     required this.order,
//     required this.point,
//     this.sequenceOptions,
//     this.correctSequence,
//     this.mcqOptions,
//     this.scoringRubric,
//
//   });
//
//   factory Question.fromJson(Map<String, dynamic> json) {
//     return Question(
//       phaseId: json['phaseId'],
//       type: QuestionType.values.firstWhere(
//             (e) => e.toString().split('.').last == json['type'],
//         orElse: () => QuestionType.PUZZLE, // Default fallback
//       ),
//       scenario: json['scenario'] ?? '',
//       questionText: json['questionText'] ?? '',
//       order: json['order'] ?? 0,
//       point: json['point'] ?? 0,
//       sequenceOptions: json['sequenceOptions'] != null
//           ? List<String>.from(json['sequenceOptions'])
//           : null,
//       correctSequence: json['correctSequence'] != null
//           ? List<int>.from(json['correctSequence'])
//           : null,
//       mcqOptions: json['mcqOptions'] != null
//           ? List<String>.from(json['mcqOptions'])
//           : null,
//       scoringRubric: json['scoringRubric'] ?? {},
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "phaseId": phaseId,
//       "type": type.toString().split('.').last,
//       "scenario": scenario,
//       "questionText": questionText,
//       "order": order,
//       "point": point,
//       if (sequenceOptions != null) "sequenceOptions": sequenceOptions,
//       if (correctSequence != null) "correctSequence": correctSequence,
//       if (mcqOptions != null) "mcqOptions": mcqOptions,
//       if (scoringRubric != null) "scoringRubric": scoringRubric,
//     };
//   }
// }