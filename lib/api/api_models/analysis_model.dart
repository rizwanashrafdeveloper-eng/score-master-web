class AnalysisModel {
  SessionOverview? sessionOverview;
  List<String>? badges;
  SessionStats? sessionStats;
  List<PlayerRanking>? playerRanking;
  List<PhasesBreakdown>? phasesBreakdown;

  AnalysisModel({
    this.sessionOverview,
    this.badges,
    this.sessionStats,
    this.playerRanking,
    this.phasesBreakdown,
  });

  AnalysisModel.fromJson(Map<String, dynamic> json) {
    sessionOverview = json['sessionOverview'] != null
        ? SessionOverview.fromJson(json['sessionOverview'])
        : null;
    badges = (json['badges'] != null) ? List<String>.from(json['badges']) : [];
    sessionStats = json['sessionStats'] != null
        ? SessionStats.fromJson(json['sessionStats'])
        : null;
    if (json['playerRanking'] != null) {
      playerRanking = <PlayerRanking>[];
      json['playerRanking'].forEach((v) {
        playerRanking!.add(PlayerRanking.fromJson(v));
      });
    }
    if (json['phasesBreakdown'] != null) {
      phasesBreakdown = <PhasesBreakdown>[];
      json['phasesBreakdown'].forEach((v) {
        phasesBreakdown!.add(PhasesBreakdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (sessionOverview != null) {
      data['sessionOverview'] = sessionOverview!.toJson();
    }
    data['badges'] = badges;
    if (sessionStats != null) {
      data['sessionStats'] = sessionStats!.toJson();
    }
    if (playerRanking != null) {
      data['playerRanking'] = playerRanking!.map((v) => v.toJson()).toList();
    }
    if (phasesBreakdown != null) {
      data['phasesBreakdown'] =
          phasesBreakdown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// Helper function to safely cast int/double/string → int
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

class SessionOverview {
  int? timeDuration;
  int? totalPhases;
  int? activePlayers;

  SessionOverview({this.timeDuration, this.totalPhases, this.activePlayers});

  SessionOverview.fromJson(Map<String, dynamic> json) {
    timeDuration = _toInt(json['timeDuration']);
    totalPhases = _toInt(json['totalPhases']);
    activePlayers = _toInt(json['activePlayers']);
  }

  Map<String, dynamic> toJson() {
    return {
      'timeDuration': timeDuration,
      'totalPhases': totalPhases,
      'activePlayers': activePlayers,
    };
  }
}

class SessionStats {
  int? averageScore;
  TopPerformer? topPerformer;
  int? completionRate;
  int? participationRate;

  SessionStats({
    this.averageScore,
    this.topPerformer,
    this.completionRate,
    this.participationRate,
  });

  SessionStats.fromJson(Map<String, dynamic> json) {
    averageScore = _toInt(json['averageScore']);
    completionRate = _toInt(json['completionRate']);
    participationRate = _toInt(json['participationRate']);
    topPerformer = json['topPerformer'] != null
        ? TopPerformer.fromJson(json['topPerformer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['averageScore'] = averageScore;
    data['completionRate'] = completionRate;
    data['participationRate'] = participationRate;
    if (topPerformer != null) {
      data['topPerformer'] = topPerformer!.toJson();
    }
    return data;
  }
}

class TopPerformer {
  String? name;
  int? points;

  TopPerformer({this.name, this.points});

  TopPerformer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    points = _toInt(json['points']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
    };
  }
}

class PlayerRanking {
  int? rank;
  String? playerName;
  int? totalPoints;

  PlayerRanking({this.rank, this.playerName, this.totalPoints});

  PlayerRanking.fromJson(Map<String, dynamic> json) {
    rank = _toInt(json['rank']);
    playerName = json['playerName'];
    totalPoints = _toInt(json['totalPoints']);
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'playerName': playerName,
      'totalPoints': totalPoints,
    };
  }
}

class PhasesBreakdown {
  String? phaseName;
  int? timeDuration;
  int? totalPoints;

  PhasesBreakdown({this.phaseName, this.timeDuration, this.totalPoints});

  PhasesBreakdown.fromJson(Map<String, dynamic> json) {
    phaseName = json['phaseName'];
    timeDuration = _toInt(json['timeDuration']);
    totalPoints = _toInt(json['totalPoints']);
  }

  Map<String, dynamic> toJson() {
    return {
      'phaseName': phaseName,
      'timeDuration': timeDuration,
      'totalPoints': totalPoints,
    };
  }
}
