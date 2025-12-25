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
          ?.map((e) => PlayerRank.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      remaining: (json['remaining'] as List<dynamic>?)
          ?.map((e) => PlayerRank.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top3': top3.map((e) => e.toJson()).toList(),
      'remaining': remaining.map((e) => e.toJson()).toList(),
    };
  }
}

class PlayerRank {
  final int rank;
  final int playerId;
  final String playerName;
  final String playerEmail;
  final int sessionId;
  final int totalPoints;

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

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'playerId': playerId,
      'playerName': playerName,
      'playerEmail': playerEmail,
      'sessionId': sessionId,
      'totalPoints': totalPoints,
    };
  }
}

// ============================================================================

// team_leaderboard_model.dart
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
          ?.map((e) => TeamRank.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      remaining: (json['remaining'] as List<dynamic>?)
          ?.map((e) => TeamRank.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top3': top3.map((e) => e.toJson()).toList(),
      'remaining': remaining.map((e) => e.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'sessionId': sessionId,
      'sessionDescription': sessionDescription,
      'totalPoints': totalPoints,
    };
  }
}



// // lib/api/api_models/player_leaderboard_model.dart
// class PlayerLeaderboardModel {
//   final List<PlayerRank> top3;
//   final List<PlayerRank> remaining;
//
//   PlayerLeaderboardModel({
//     required this.top3,
//     required this.remaining,
//   });
//
//   factory PlayerLeaderboardModel.fromJson(Map<String, dynamic> json) {
//     return PlayerLeaderboardModel(
//       top3: (json['top3'] as List<dynamic>?)
//           ?.map((e) => PlayerRank.fromJson(e))
//           .toList() ??
//           [],
//       remaining: (json['remaining'] as List<dynamic>?)
//           ?.map((e) => PlayerRank.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
// }
// // lib/api/api_models/player_leaderboard_model.dart
// class PlayerRank {
//   final int rank;
//   final int playerId;
//   final String playerName;
//   final String playerEmail;
//   final int sessionId;
//   final int totalPoints;
//
//   // For UI compatibility
//   int get score => totalPoints;
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
// // class PlayerRank {
// //   final int rank;
// //   final int playerId;
// //   final String playerName;
// //   final String playerEmail;
// //   final int sessionId;
// //   final int totalPoints;
// //
// //   PlayerRank({
// //     required this.rank,
// //     required this.playerId,
// //     required this.playerName,
// //     required this.playerEmail,
// //     required this.sessionId,
// //     required this.totalPoints,
// //   });
// //
// //   factory PlayerRank.fromJson(Map<String, dynamic> json) {
// //     return PlayerRank(
// //       rank: json['rank'] ?? 0,
// //       playerId: json['playerId'] ?? 0,
// //       playerName: json['playerName'] ?? '',
// //       playerEmail: json['playerEmail'] ?? '',
// //       sessionId: json['sessionId'] ?? 0,
// //       totalPoints: json['totalPoints'] ?? 0,
// //     );
// //   }
// // }
