class PlayerTeamModel {
  final int id;
  final String nickname;
  final int sessionId;
  final int gameFormatId;
  final int createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlayerTeamModel({
    required this.id,
    required this.nickname,
    required this.sessionId,
    required this.gameFormatId,
    required this.createdById,
    this.createdAt,
    this.updatedAt,
  });

  factory PlayerTeamModel.fromJson(Map<String, dynamic> json) {
    return PlayerTeamModel(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      sessionId: json['sessionId'] as int,
      gameFormatId: json['gameFormatId'] as int,
      createdById: json['createdById'] as int,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  /// ✅ Request payload (only fields API expects)
  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname,
      "sessionId": sessionId,
      "gameFormatId": gameFormatId,
      "createdById": createdById,
    };
  }
}
