class StatsUserManagementModel {
  PlayerInfo? playerInfo;
  SessionStats? sessionStats;
  User? user;
  List<RecentSession>? recentSessions; // <-- FIXED (singular)

  StatsUserManagementModel({
    this.playerInfo,
    this.sessionStats,
    this.user,
    this.recentSessions,
  });

  StatsUserManagementModel.fromJson(Map<String, dynamic> json) {
    playerInfo = json['playerInfo'] != null
        ? PlayerInfo.fromJson(json['playerInfo'])
        : null;
    sessionStats = json['sessionStats'] != null
        ? SessionStats.fromJson(json['sessionStats'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    if (json['recentSessions'] != null) {
      recentSessions = <RecentSession>[]; // <-- FIXED
      json['recentSessions'].forEach((v) {
        recentSessions!.add(RecentSession.fromJson(v));
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

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

class SessionStats {
  int? totalSessions;
  num? avgScore;
  int? totalMVP;

  SessionStats({this.totalSessions, this.avgScore, this.totalMVP});

  SessionStats.fromJson(Map<String, dynamic> json) {
    totalSessions = json['totalSessions'];
    avgScore = json['avgScore'];
    totalMVP = json['totalMVP'];
  }

  Map<String, dynamic> toJson() => {
    'totalSessions': totalSessions,
    'avgScore': avgScore,
    'totalMVP': totalMVP,
  };
}

class User {
  int? id;
  String? email;
  String? name;
  String? password;
  String? language;
  String? phone;
  String? role;
  String? createdAt;
  dynamic roleId;
  List<dynamic>? sessions;
  List<Score>? scores;
  List<JoinedSessions>? joinedSessions;
  List<dynamic>? createdTeams;
  List<dynamic>? gameFormats;

  User({
    this.id,
    this.email,
    this.name,
    this.password,
    this.language,
    this.phone,
    this.role,
    this.createdAt,
    this.roleId,
    this.sessions,
    this.scores,
    this.joinedSessions,
    this.createdTeams,
    this.gameFormats,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    language = json['language'];
    phone = json['phone'];
    role = json['role'];
    createdAt = json['createdAt'];
    roleId = json['roleId'];
    sessions = json['sessions'];
    scores = (json['scores'] as List?)?.map((e) => Score.fromJson(e)).toList();
    if (json['joinedSessions'] != null) {
      joinedSessions = <JoinedSessions>[];
      json['joinedSessions'].forEach((v) {
        joinedSessions!.add(JoinedSessions.fromJson(v));
      });
    }
    createdTeams = json['createdTeams'];
    gameFormats = json['gameFormats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['language'] = language;
    data['phone'] = phone;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['roleId'] = roleId;
    if (scores != null)
      data['scores'] = scores!.map((v) => v.toJson()).toList();
    if (joinedSessions != null) {
      data['joinedSessions'] = joinedSessions!.map((v) => v.toJson()).toList();
    }
    data['sessions'] = sessions;
    data['createdTeams'] = createdTeams;
    data['gameFormats'] = gameFormats;
    return data;
  }
}

class Score {
  int? id;
  int? questionId;
  int? playerId;
  int? sessionId;
  int? phaseId;
  int? finalScore;
  int? relevanceScore;
  String? suggestion;
  String? qualityAssessment;
  String? description;
  int? charityScore;
  int? strategicThinking;
  int? feasibilityScore;
  int? innovationScore;
  int? points;
  String? createdAt;
  String? updatedAt;

  Score({
    this.id,
    this.questionId,
    this.playerId,
    this.sessionId,
    this.phaseId,
    this.finalScore,
    this.relevanceScore,
    this.suggestion,
    this.qualityAssessment,
    this.description,
    this.charityScore,
    this.strategicThinking,
    this.feasibilityScore,
    this.innovationScore,
    this.points,
    this.createdAt,
    this.updatedAt,
  });

  Score.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['questionId'];
    playerId = json['playerId'];
    sessionId = json['sessionId'];
    phaseId = json['phaseId'];
    finalScore = json['finalScore'];
    relevanceScore = json['relevanceScore'];
    suggestion = json['suggestion'];
    qualityAssessment = json['qualityAssessment'];
    description = json['description'];
    charityScore = json['charityScore'];
    strategicThinking = json['strategicThinking'];
    feasibilityScore = json['feasibilityScore'];
    innovationScore = json['innovationScore'];
    points = json['points'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
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
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class JoinedSessions {
  int? id;
  int? sessionId;
  int? playerId;
  String? joinedAt;

  JoinedSessions({this.id, this.sessionId, this.playerId, this.joinedAt});

  JoinedSessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sessionId = json['sessionId'];
    playerId = json['playerId'];
    joinedAt = json['joinedAt'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sessionId': sessionId,
    'playerId': playerId,
    'joinedAt': joinedAt,
  };
}

class RecentSession {
  int? sessionId;
  String? sessionName;
  String? sessionDescription;
  int? totalPhases;
  String? status; // ✅ instead of phaseStatus
  int? totalPlayers;
  int? rank;

  RecentSession({
    this.sessionId,
    this.sessionName,
    this.sessionDescription,
    this.totalPhases,
    this.status,
    this.totalPlayers,
    this.rank,
  });

  factory RecentSession.fromJson(Map<String, dynamic> json) {
    return RecentSession(
      sessionId: json['sessionId'],
      sessionName: json['sessionName'],
      sessionDescription: json['sessionDescription'],
      totalPhases: json['totalPhases'],
      status: json['status'],
      // ✅ match response
      totalPlayers: json['totalPlayers'],
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'sessionName': sessionName,
    'sessionDescription': sessionDescription,
    'totalPhases': totalPhases,
    'status': status, // ✅ match response
    'totalPlayers': totalPlayers,
    'rank': rank,
  };
}
