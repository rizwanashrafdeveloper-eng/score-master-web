import 'dart:convert';

class TeamViewModel {
  final int sessionId;
  final String sessionJoinCode;
  final GameFormat gameFormat;
  final List<Team> teams;

  TeamViewModel({
    required this.sessionId,
    required this.sessionJoinCode,
    required this.gameFormat,
    required this.teams,
  });

  factory TeamViewModel.fromJson(Map<String, dynamic> json) {
    return TeamViewModel(
      sessionId: json['sessionId'],
      sessionJoinCode: json['sessionJoinCode'],
      gameFormat: GameFormat.fromJson(json['gameFormat']),
      teams: (json['teams'] as List).map((e) => Team.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionJoinCode': sessionJoinCode,
      'gameFormat': gameFormat.toJson(),
      'teams': teams.map((e) => e.toJson()).toList(),
    };
  }
}

class GameFormat {
  final int id;
  final String name;
  final List<Facilitator> facilitators;

  GameFormat({
    required this.id,
    required this.name,
    required this.facilitators,
  });

  factory GameFormat.fromJson(Map<String, dynamic> json) {
    return GameFormat(
      id: json['id'],
      name: json['name'],
      facilitators: (json['facilitators'] as List)
          .map((e) => Facilitator.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'facilitators': facilitators.map((e) => e.toJson()).toList(),
    };
  }
}

class Facilitator {
  final int id;
  final String email;
  final String name;
  final String role;

  Facilitator({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory Facilitator.fromJson(Map<String, dynamic> json) {
    return Facilitator(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }
}

class Team {
  final int id;
  final String nickname;
  final int sessionId;
  final int gameFormatId;
  final int createdById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> players;

  Team({
    required this.id,
    required this.nickname,
    required this.sessionId,
    required this.gameFormatId,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      nickname: json['nickname'],
      sessionId: json['sessionId'],
      gameFormatId: json['gameFormatId'],
      createdById: json['createdById'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      players: json['players'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'sessionId': sessionId,
      'gameFormatId': gameFormatId,
      'createdById': createdById,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'players': players,
    };
  }
}
