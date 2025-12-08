// lib/api/api_models/team_leaderboard_model.dart
class TeamLeaderboardModel {
  final List<TeamRank> top3;
  final List<TeamRank> remaining;

  TeamLeaderboardModel({
    required this.top3,
    required this.remaining,
  });

  factory TeamLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return TeamLeaderboardModel(
      top3: (json['top3'] as List<dynamic>?)
          ?.map((e) => TeamRank.fromJson(e))
          .toList() ??
          [],
      remaining: (json['remaining'] as List<dynamic>?)
          ?.map((e) => TeamRank.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class TeamRank {
  final int rank;
  final int sessionId;
  final String sessionDescription;
  final int totalPoints;

  TeamRank({
    required this.rank,
    required this.sessionId,
    required this.sessionDescription,
    required this.totalPoints,
  });

  factory TeamRank.fromJson(Map<String, dynamic> json) {
    return TeamRank(
      rank: json['rank'] ?? 0,
      sessionId: json['sessionId'] ?? 0,
      sessionDescription: json['sessionDescription'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
    );
  }
}