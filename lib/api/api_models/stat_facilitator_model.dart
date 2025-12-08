class StatsFacilitatorManagementModel {
  PlayerInfo? playerInfo;
  SessionStats? sessionStats;
  User? user;
  List<RecentSessions>? recentSessions;

  StatsFacilitatorManagementModel(
      {this.playerInfo, this.sessionStats, this.user, this.recentSessions});

  StatsFacilitatorManagementModel.fromJson(Map<String, dynamic> json) {
    playerInfo = json['playerInfo'] != null
        ? PlayerInfo.fromJson(json['playerInfo'])
        : null;
    sessionStats = json['sessionStats'] != null
        ? SessionStats.fromJson(json['sessionStats'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['recentSessions'] != null) {
      recentSessions = <RecentSessions>[];
      json['recentSessions'].forEach((v) {
        recentSessions!.add(RecentSessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (playerInfo != null) data['playerInfo'] = playerInfo!.toJson();
    if (sessionStats != null) data['sessionStats'] = sessionStats!.toJson();
    if (user != null) data['user'] = user!.toJson();
    if (recentSessions != null) {
      data['recentSessions'] = recentSessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerInfo {
  int? id;
  String? name;
  String? email;

  PlayerInfo({this.id, this.name, this.email});

  PlayerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email};
}

class SessionStats {
  int? totalSessions;
  int? totalManagePlayer;
  int? successRate;

  SessionStats({this.totalSessions, this.totalManagePlayer, this.successRate});

  SessionStats.fromJson(Map<String, dynamic> json) {
    totalSessions = json['totalSessions'];
    totalManagePlayer = json['totalManagePlayer'];
    successRate = json['successRate'];
  }

  Map<String, dynamic> toJson() => {
    'totalSessions': totalSessions,
    'totalManagePlayer': totalManagePlayer,
    'successRate': successRate,
  };
}

class User {
  int? id;
  String? email;
  String? name;
  String? phone;
  String? role;
  String? createdAt;
  List<Sessions>? sessions;
  List<JoinedSession>? joinedSessions;
  List<GameFormats>? gameFormats;

  User(
      {this.id,
        this.email,
        this.name,
        this.phone,
        this.role,
        this.createdAt,
        this.sessions,
        this.joinedSessions,
        this.gameFormats});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    createdAt = json['createdAt'];

    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(Sessions.fromJson(v));
      });
    }

    if (json['joinedSessions'] != null) {
      joinedSessions = <JoinedSession>[];
      json['joinedSessions'].forEach((v) {
        joinedSessions!.add(JoinedSession.fromJson(v));
      });
    }

    if (json['gameFormats'] != null) {
      gameFormats = <GameFormats>[];
      json['gameFormats'].forEach((v) {
        gameFormats!.add(GameFormats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['role'] = role;
    data['createdAt'] = createdAt;

    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    if (joinedSessions != null) {
      data['joinedSessions'] = joinedSessions!.map((v) => v.toJson()).toList();
    }
    if (gameFormats != null) {
      data['gameFormats'] = gameFormats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sessions {
  int? id;
  String? description;

  Sessions({this.id, this.description});

  Sessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'description': description};
}

class JoinedSession {
  int? id;
  int? sessionId;
  int? playerId;
  String? joinedAt;

  JoinedSession({this.id, this.sessionId, this.playerId, this.joinedAt});

  JoinedSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['sessionId'];
    playerId = json['playerId'];
    joinedAt = json['joinedAt'];
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'sessionId': sessionId, 'playerId': playerId, 'joinedAt': joinedAt};
}

class GameFormats {
  int? id;
  String? name;
  String? description;

  GameFormats({this.id, this.name, this.description});

  GameFormats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'description': description};
}

class RecentSessions {
  int? sessionId;
  String? sessionName;
  String? sessionDescription;
  int? totalPhases;
  int? totalPlayers;
  String? status;

  RecentSessions(
      {this.sessionId,
        this.sessionName,
        this.sessionDescription,
        this.totalPhases,
        this.totalPlayers,
        this.status});

  RecentSessions.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    sessionName = json['sessionName'];
    sessionDescription = json['sessionDescription'];
    totalPhases = json['totalPhases'];
    totalPlayers = json['totalPlayers'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'sessionName': sessionName,
    'sessionDescription': sessionDescription,
    'totalPhases': totalPhases,
    'totalPlayers': totalPlayers,
    'status': status,
  };
}
