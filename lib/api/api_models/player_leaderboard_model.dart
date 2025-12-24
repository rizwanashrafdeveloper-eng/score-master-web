// lib/api/api_models/player_leaderboard_model.dart
class PlayerLeaderboardModel {
  final List<PlayerRank> top3;
  final List<PlayerRank> remaining;

  PlayerLeaderboardModel({
    required this.top3,
    required this.remaining,
  });

  factory PlayerLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return PlayerLeaderboardModel(
      top3: (json['top3'] as List<dynamic>?)
          ?.map((e) => PlayerRank.fromJson(e))
          .toList() ??
          [],
      remaining: (json['remaining'] as List<dynamic>?)
          ?.map((e) => PlayerRank.fromJson(e))
          .toList() ??
          [],
    );
  }
}
// lib/api/api_models/player_leaderboard_model.dart
class PlayerRank {
  final int rank;
  final int playerId;
  final String playerName;
  final String playerEmail;
  final int sessionId;
  final int totalPoints;

  // For UI compatibility
  int get score => totalPoints;

  PlayerRank({
    required this.rank,
    required this.playerId,
    required this.playerName,
    required this.playerEmail,
    required this.sessionId,
    required this.totalPoints,
  });

  factory PlayerRank.fromJson(Map<String, dynamic> json) {
    return PlayerRank(
      rank: json['rank'] ?? 0,
      playerId: json['playerId'] ?? 0,
      playerName: json['playerName'] ?? '',
      playerEmail: json['playerEmail'] ?? '',
      sessionId: json['sessionId'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
    );
  }
}
// class PlayerRank {
//   final int rank;
//   final int playerId;
//   final String playerName;
//   final String playerEmail;
//   final int sessionId;
//   final int totalPoints;
//
//   PlayerRank({
//     required this.rank,
//     required this.playerId,
//     required this.playerName,
//     required this.playerEmail,
//     required this.sessionId,
//     required this.totalPoints,
//   });
//
//   factory PlayerRank.fromJson(Map<String, dynamic> json) {
//     return PlayerRank(
//       rank: json['rank'] ?? 0,
//       playerId: json['playerId'] ?? 0,
//       playerName: json['playerName'] ?? '',
//       playerEmail: json['playerEmail'] ?? '',
//       sessionId: json['sessionId'] ?? 0,
//       totalPoints: json['totalPoints'] ?? 0,
//     );
//   }
// }
