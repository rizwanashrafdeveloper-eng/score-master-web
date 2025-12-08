class PlayerQSubmitModel {
  final int id;
  final int playerId;
  final int facilitatorId;
  final int sessionId;
  final int phaseId;
  final int questionId;
  final Map<String, dynamic> answerData;
  final dynamic score;
  final dynamic feedback;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlayerQSubmitModel({
    required this.id,
    required this.playerId,
    required this.facilitatorId,
    required this.sessionId,
    required this.phaseId,
    required this.questionId,
    required this.answerData,
    this.score,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  factory PlayerQSubmitModel.fromJson(Map<String, dynamic> json) {
    return PlayerQSubmitModel(
      id: json['id'],
      playerId: json['playerId'],
      facilitatorId: json['facilitatorId'],
      sessionId: json['sessionId'],
      phaseId: json['phaseId'],
      questionId: json['questionId'],
      answerData: Map<String, dynamic>.from(json['answerData'] ?? {}),
      score: json['score'],
      feedback: json['feedback'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "playerId": playerId,
      "facilitatorId": facilitatorId,
      "sessionId": sessionId,
      "phaseId": phaseId,
      "questionId": questionId,
      "answerData": answerData,
    };
  }
}
