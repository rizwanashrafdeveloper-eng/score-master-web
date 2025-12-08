



class ScheduleAndActiveSessionModel {
  List<ScheduledSessions>? scheduledSessions;
  List<ActiveSessions>? activeSessions;

  ScheduleAndActiveSessionModel({this.scheduledSessions, this.activeSessions});

  ScheduleAndActiveSessionModel.fromJson(Map<String, dynamic> json) {
    if (json['scheduledSessions'] != null) {
      scheduledSessions = <ScheduledSessions>[];
      json['scheduledSessions'].forEach((v) {
        scheduledSessions!.add(ScheduledSessions.fromJson(v));
      });
    }
    if (json['activeSessions'] != null) {
      activeSessions = <ActiveSessions>[];
      json['activeSessions'].forEach((v) {
        activeSessions!.add(ActiveSessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (scheduledSessions != null) {
      data['scheduledSessions'] = scheduledSessions!.map((v) => v.toJson()).toList();
    }
    if (activeSessions != null) {
      data['activeSessions'] = activeSessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduledSessions {
  int? id;
  String? teamTitle;
  String? description;
  int? totalPlayers;
  int? totalPhases;
  String? startTime;

  ScheduledSessions({
    this.id,
    this.teamTitle,
    this.description,
    this.totalPlayers,
    this.totalPhases,
    this.startTime,
  });

  ScheduledSessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamTitle = json['teamTitle'];
    description = json['description'];
    totalPlayers = json['totalPlayers'];
    totalPhases = json['totalPhases'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['teamTitle'] = teamTitle;
    data['description'] = description;
    data['totalPlayers'] = totalPlayers;
    data['totalPhases'] = totalPhases;
    data['startTime'] = startTime;
    return data;
  }
}class ActiveSessions {
  int? id;
  String? teamTitle;
  String? description;
  int? totalPlayers;
  int? totalPhases;
  int? remainingTime;
  String? status;

  ActiveSessions({
    this.id,
    this.teamTitle,
    this.description,
    this.totalPlayers,
    this.totalPhases,
    this.remainingTime,
    this.status,
  });

  ActiveSessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // ✅ FIX: Backend uses 'sessiontitle' not 'teamTitle'
    teamTitle = json['teamTitle'] ?? json['sessiontitle'];
    description = json['description'];
    totalPlayers = json['totalPlayers'];
    totalPhases = json['totalPhases'];
    remainingTime = json['remainingTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['teamTitle'] = teamTitle;
    data['description'] = description;
    data['totalPlayers'] = totalPlayers;
    data['totalPhases'] = totalPhases;
    data['remainingTime'] = remainingTime;
    data['status'] = status;
    return data;
  }
}