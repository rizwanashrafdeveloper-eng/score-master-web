class SelectGameFormat {
  final int? id; // Added id field
  final String? name;
  final String? description;
  final String? mode;
  final int? totalPhases;
  final int? timeDuration;
  final bool? isActive;
  final String? scoringType;

  SelectGameFormat({
    this.id,
    this.name,
    this.description,
    this.mode,
    this.totalPhases,
    this.timeDuration,
    this.isActive,
    this.scoringType,
  });

  factory SelectGameFormat.fromJson(Map<String, dynamic> json) {
    return SelectGameFormat(
      id: json['id'] as int?, // Map id from JSON
      name: json['name'] as String?,
      description: json['description'] as String?,
      mode: json['mode'] as String?,
      totalPhases: json['totalPhases'] as int?,
      timeDuration: json['timeDuration'] as int?,
      isActive: json['isActive'] as bool?,
      scoringType: json['scoringType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['mode'] = mode;
    data['totalPhases'] = totalPhases;
    data['timeDuration'] = timeDuration;
    data['isActive'] = isActive;
    data['scoringType'] = scoringType;
    return data;
  }
}

class EnterSessionName {
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

  EnterSessionName({
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

  factory EnterSessionName.fromJson(Map<String, dynamic> json) {
    return EnterSessionName(
      id: json['id'] as int?,
      gameFormatId: json['gameFormatId'] as int?,
      description: json['description'] as String?,
      createdById: json['createdById'] as int?,
      joinCode: json['joinCode'] as String?,
      joiningLink: json['joiningLink'] as String?,
      status: json['status'] as String?,
      duration: json['duration'] as int?,
      elapsedTime: json['elapsedTime'] as int?,
      startedAt: json['startedAt'] as String?,
      pausedAt: json['pausedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gameFormatId'] = gameFormatId;
    data['description'] = description;
    data['createdById'] = createdById;
    data['joinCode'] = joinCode;
    data['joiningLink'] = joiningLink;
    data['status'] = status;
    data['duration'] = duration;
    data['elapsedTime'] = elapsedTime;
    data['startedAt'] = startedAt;
    data['pausedAt'] = pausedAt;
    data['endedAt'] = endedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PlayerCapacityBadgeLabelingAndAdditionalSetting {
  final int? id;
  final int? gameFormatId;
  final int? minPlayers;
  final int? maxPlayers;
  final List<String>? badgeNames;
  final bool? requireAllTrue;
  final bool? aiScoring;
  final bool? allowLaterJoin;
  final bool? sendInvitation;
  final bool? recordSession;
  final String? createdAt;
  final String? updatedAt;

  PlayerCapacityBadgeLabelingAndAdditionalSetting({
    this.id,
    this.gameFormatId,
    this.minPlayers,
    this.maxPlayers,
    this.badgeNames,
    this.requireAllTrue,
    this.aiScoring,
    this.allowLaterJoin,
    this.sendInvitation,
    this.recordSession,
    this.createdAt,
    this.updatedAt,
  });

  factory PlayerCapacityBadgeLabelingAndAdditionalSetting.fromJson(Map<String, dynamic> json) {
    return PlayerCapacityBadgeLabelingAndAdditionalSetting(
      id: json['id'] as int?,
      gameFormatId: json['gameFormatId'] as int?,
      minPlayers: json['minPlayers'] as int?,
      maxPlayers: json['maxPlayers'] as int?,
      badgeNames: (json['badgeNames'] as List<dynamic>?)?.cast<String>(),
      requireAllTrue: json['requireAllTrue'] as bool?,
      aiScoring: json['aiScoring'] as bool?,
      allowLaterJoin: json['allowLaterJoin'] as bool?,
      sendInvitation: json['sendInvitation'] as bool?,
      recordSession: json['recordSession'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gameFormatId'] = gameFormatId;
    data['minPlayers'] = minPlayers;
    data['maxPlayers'] = maxPlayers;
    data['badgeNames'] = badgeNames;
    data['requireAllTrue'] = requireAllTrue;
    data['aiScoring'] = aiScoring;
    data['allowLaterJoin'] = allowLaterJoin;
    data['sendInvitation'] = sendInvitation;
    data['recordSession'] = recordSession;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}