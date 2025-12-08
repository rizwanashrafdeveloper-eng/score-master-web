// lib/api/api_models/player_score_model.dart
class PlayerScoreModel {
  final int id;
  final int questionId;
  final int playerId;
  final int sessionId;
  final int phaseId;
  final int finalScore;
  final int relevanceScore;
  final String suggestion;
  final String qualityAssessment;
  final String description;
  final int charityScore;
  final int strategicThinking;
  final int feasibilityScore;
  final int innovationScore;
  final int points;

  PlayerScoreModel({
    required this.id,
    required this.questionId,
    required this.playerId,
    required this.sessionId,
    required this.phaseId,
    required this.finalScore,
    required this.relevanceScore,
    required this.suggestion,
    required this.qualityAssessment,
    required this.description,
    required this.charityScore,
    required this.strategicThinking,
    required this.feasibilityScore,
    required this.innovationScore,
    required this.points,
  });

  factory PlayerScoreModel.fromJson(Map<String, dynamic> json) {
    return PlayerScoreModel(
      id: json['id'] ?? 0,
      questionId: json['questionId'] ?? 0,
      playerId: json['playerId'] ?? 0,
      sessionId: json['sessionId'] ?? 0,
      phaseId: json['phaseId'] ?? 0,
      finalScore: json['finalScore'] ?? 0,
      relevanceScore: json['relevanceScore'] ?? 0,
      suggestion: json['suggestion'] ?? '',
      qualityAssessment: json['qualityAssessment'] ?? '',
      description: json['description'] ?? '',
      charityScore: json['charityScore'] ?? 0,
      strategicThinking: json['strategicThinking'] ?? 0,
      feasibilityScore: json['feasibilityScore'] ?? 0,
      innovationScore: json['innovationScore'] ?? 0,
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'playerId': playerId,
      'sessionId': sessionId,
      'phaseId': phaseId,
      'finalScore': finalScore,
      'relevanceScore': relevanceScore,
      'suggestion': suggestion,
      'qualityAssessment': qualityAssessment,
      'description': description,
      'charityScore': charityScore,
      'strategicThinking': strategicThinking,
      'feasibilityScore': feasibilityScore,
      'innovationScore': innovationScore,
      'points': points,
    };
  }
}
