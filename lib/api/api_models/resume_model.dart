// Start Session Model
class StartSessionModel {
  final int? id;
  final int? gameFormatId;
  final String? description;
  final int? createdById;
  final String? joinCode;
  final String? joiningLink;
  final String? status;
  final int? duration;
  final int? elapsedTime;
  final String? startedAt;
  final String? pausedAt;
  final String? endedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<Map<String, dynamic>>? phases; // Store raw phase data

  StartSessionModel({
    this.id,
    this.gameFormatId,
    this.description,
    this.createdById,
    this.joinCode,
    this.joiningLink,
    this.status,
    this.duration,
    this.elapsedTime,
    this.startedAt,
    this.pausedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
    this.phases,
  });

  factory StartSessionModel.fromJson(Map<String, dynamic> json) {
    return StartSessionModel(
      id: json['id'],
      gameFormatId: json['gameFormatId'],
      description: json['description'],
      createdById: json['createdById'],
      joinCode: json['joinCode'],
      joiningLink: json['joiningLink'],
      status: json['status'],
      duration: json['duration'],
      elapsedTime: json['elapsedTime'],
      startedAt: json['startedAt'],
      pausedAt: json['pausedAt'],
      endedAt: json['endedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phases: json['phases'] != null
          ? List<Map<String, dynamic>>.from(json['phases'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameFormatId': gameFormatId,
      'description': description,
      'createdById': createdById,
      'joinCode': joinCode,
      'joiningLink': joiningLink,
      'status': status,
      'duration': duration,
      'elapsedTime': elapsedTime,
      'startedAt': startedAt,
      'pausedAt': pausedAt,
      'endedAt': endedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phases': phases,
    };
  }
}
class PauseSessionModel {
  final int? id;
  final int? gameFormatId;
  final String? description;
  final int? createdById;
  final String? joinCode;
  final String? joiningLink;
  final String? status;
  final int? duration;
  final int? elapsedTime;
  final String? startedAt;
  final String? pausedAt;
  final String? endedAt;
  final String? createdAt;
  final String? updatedAt;

  PauseSessionModel({
    this.id,
    this.gameFormatId,
    this.description,
    this.createdById,
    this.joinCode,
    this.joiningLink,
    this.status,
    this.duration,
    this.elapsedTime,
    this.startedAt,
    this.pausedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PauseSessionModel.fromJson(Map<String, dynamic> json) {
    return PauseSessionModel(
      id: json['id'],
      gameFormatId: json['gameFormatId'],
      description: json['description'],
      createdById: json['createdById'],
      joinCode: json['joinCode'],
      joiningLink: json['joiningLink'],
      status: json['status'],
      duration: json['duration'],
      elapsedTime: json['elapsedTime'],
      startedAt: json['startedAt'],
      pausedAt: json['pausedAt'],
      endedAt: json['endedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class ResumeSessionModel {
  final int? id;
  final int? gameFormatId;
  final String? description;
  final int? createdById;
  final String? joinCode;
  final String? joiningLink;
  final String? status;
  final int? duration;
  final int? elapsedTime;
  final String? startedAt;
  final String? pausedAt;
  final String? endedAt;
  final String? createdAt;
  final String? updatedAt;

  ResumeSessionModel({
    this.id,
    this.gameFormatId,
    this.description,
    this.createdById,
    this.joinCode,
    this.joiningLink,
    this.status,
    this.duration,
    this.elapsedTime,
    this.startedAt,
    this.pausedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ResumeSessionModel.fromJson(Map<String, dynamic> json) {
    return ResumeSessionModel(
      id: json['id'],
      gameFormatId: json['gameFormatId'],
      description: json['description'],
      createdById: json['createdById'],
      joinCode: json['joinCode'],
      joiningLink: json['joiningLink'],
      status: json['status'],
      duration: json['duration'],
      elapsedTime: json['elapsedTime'],
      startedAt: json['startedAt'],
      pausedAt: json['pausedAt'],
      endedAt: json['endedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
class PhaseData {
  final int? id;
  final int? sessionId;
  final int? phaseId;
  final String? status;
  final int? timeDuration;
  final int? elapsedTime;
  final String? startedAt;
  final String? pausedAt;
  final String? endedAt;
  final String? createdAt;
  final String? updatedAt;

  PhaseData({
    this.id,
    this.sessionId,
    this.phaseId,
    this.status,
    this.timeDuration,
    this.elapsedTime,
    this.startedAt,
    this.pausedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PhaseData.fromJson(Map<String, dynamic> json) {
    return PhaseData(
      id: json['id'],
      sessionId: json['sessionId'],
      phaseId: json['phaseId'],
      status: json['status'],
      timeDuration: json['timeDuration'],
      elapsedTime: json['elapsedTime'],
      startedAt: json['startedAt'],
      pausedAt: json['pausedAt'],
      endedAt: json['endedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'phaseId': phaseId,
      'status': status,
      'timeDuration': timeDuration,
      'elapsedTime': elapsedTime,
      'startedAt': startedAt,
      'pausedAt': pausedAt,
      'endedAt': endedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}