class AiChallengeSession {
  int? gameFormatId;
  int? duration;
  int? userId;
  String? description;
  String? startedAt;

  AiChallengeSession({
    this.gameFormatId,
    this.duration,
    this.userId,
    this.description,
    this.startedAt,
  });

  AiChallengeSession.fromJson(Map<String, dynamic> json) {
    gameFormatId = json['gameFormatId'];
    duration = json['duration'];
    userId = json['userId'];
    description = json['description'];
    startedAt = json['startedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameFormatId'] = this.gameFormatId;
    data['duration'] = this.duration;
    data['userId'] = this.userId;
    data['description'] = this.description;
    data['startedAt'] = this.startedAt;
    return data;
  }
}