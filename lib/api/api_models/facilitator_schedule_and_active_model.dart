import 'dart:developer';

class FacilitatorScheduleAndActiveSessionModel {
  List<FacilitatorScheduledSessions>? scheduledSessions;
  List<FacilitatorActiveSessions>? activeSessions;

  FacilitatorScheduleAndActiveSessionModel({
    this.scheduledSessions,
    this.activeSessions,
  });

  FacilitatorScheduleAndActiveSessionModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['scheduledSessions'] != null) {
        scheduledSessions = <FacilitatorScheduledSessions>[];
        for (var v in json['scheduledSessions']) {
          scheduledSessions!.add(FacilitatorScheduledSessions.fromJson(v));
        }
      }

      if (json['activeSessions'] != null) {
        activeSessions = <FacilitatorActiveSessions>[];
        for (var v in json['activeSessions']) {
          activeSessions!.add(FacilitatorActiveSessions.fromJson(v));
        }
      }

      log('✅ FacilitatorScheduleAndActiveSessionModel parsed successfully');
    } catch (e, s) {
      log('❌ Error parsing FacilitatorScheduleAndActiveSessionModel: $e');
      log('Stacktrace: $s');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (scheduledSessions != null) {
      data['scheduledSessions'] =
          scheduledSessions!.map((v) => v.toJson()).toList();
    }
    if (activeSessions != null) {
      data['activeSessions'] = activeSessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// Facilitator Scheduled Session Model
class FacilitatorScheduledSessions {
  int? id;
  String? description;
  String? sessionTitle;
  int? totalPlayers;
  int? totalPhases;
  String? startTime;

  FacilitatorScheduledSessions({
    this.id,
    this.description,
    this.sessionTitle,
    this.totalPlayers,
    this.totalPhases,
    this.startTime,
  });

  FacilitatorScheduledSessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    sessionTitle = json['sessiontitle'];
    totalPlayers = json['totalPlayers'];
    totalPhases = json['totalPhases'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'sessiontitle': sessionTitle,
      'totalPlayers': totalPlayers,
      'totalPhases': totalPhases,
      'startTime': startTime,
    };
  }
}

/// Facilitator Active Session Model
class FacilitatorActiveSessions {
  int? id;
  String? description;
  String? sessionTitle;
  int? totalPlayers;
  int? totalPhases;
  String? status;
  int? remainingTime;

  FacilitatorActiveSessions({
    this.id,
    this.description,
    this.sessionTitle,
    this.totalPlayers,
    this.totalPhases,
    this.status,
    this.remainingTime,
  });

  FacilitatorActiveSessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    sessionTitle = json['sessiontitle'];
    totalPlayers = json['totalPlayers'];
    totalPhases = json['totalPhases'];
    status = json['status'];
    remainingTime = json['remainingTime'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'sessiontitle': sessionTitle,
      'totalPlayers': totalPlayers,
      'totalPhases': totalPhases,
      'status': status,
      'remainingTime': remainingTime,
    };
  }
}
