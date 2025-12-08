// lib/api/api_models/view_response_model.dart
class QuestionResponse {
  final Question question;
  final List<Answer> answers;

  QuestionResponse({
    required this.question,
    required this.answers,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    try {
      final question = Question.fromJson(json['question']);

      // Handle null or empty answers array
      final answersJson = json['answers'];
      final List<Answer> answersList = [];

      if (answersJson != null && answersJson is List) {
        for (var answerJson in answersJson) {
          try {
            answersList.add(Answer.fromJson(answerJson, question));
          } catch (e) {
            print('Error parsing answer: $e');
          }
        }
      }

      return QuestionResponse(
        question: question,
        answers: answersList,
      );
    } catch (e) {
      print('Error parsing QuestionResponse: $e');
      rethrow;
    }
  }
}

class Question {
  final int id;
  final String text;
  final String scenario;
  final String type;
  final int point;

  Question({
    required this.id,
    required this.text,
    required this.scenario,
    required this.type,
    required this.point,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      scenario: json['scenario'] ?? '',
      type: json['type'] ?? '',
      point: json['point'] ?? 0,
    );
  }
}

class Answer {
  final Player player;
  final AnswerData answerData;
  final String submittedAt;
  final int? score;
  final Question question;

  Answer({
    required this.player,
    required this.answerData,
    required this.submittedAt,
    this.score,
    required this.question,
  });

  factory Answer.fromJson(Map<String, dynamic> json, Question question) {
    try {
      return Answer(
        player: Player.fromJson(json['player'] ?? {}),
        answerData: AnswerData.fromJson(json['answerData'] ?? {}),
        submittedAt: json['submittedAt'] ?? '',
        score: json['score'], // Can be null
        question: question,
      );
    } catch (e) {
      print('Error parsing Answer: $e');
      rethrow;
    }
  }
}

class Player {
  final int id;
  final String name;

  Player({
    required this.id,
    required this.name,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }
}

class AnswerData {
  final List<String> sequence;

  AnswerData({required this.sequence});

  factory AnswerData.fromJson(Map<String, dynamic> json) {
    try {
      final sequenceJson = json['sequence'];
      if (sequenceJson == null) {
        return AnswerData(sequence: []);
      }

      if (sequenceJson is List) {
        return AnswerData(
          sequence: sequenceJson.map((e) => e.toString()).toList(),
        );
      }

      return AnswerData(sequence: []);
    } catch (e) {
      print('Error parsing AnswerData: $e');
      return AnswerData(sequence: []);
    }
  }
}