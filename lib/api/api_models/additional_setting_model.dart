class AdditionalSetting {
  int? id;
  int? gameFormatId;
  int? minPlayers;
  int? maxPlayers;
  List<String>? badgeNames;
  bool? requireAllTrue;
  bool? aiScoring;
  bool? allowLaterJoin;
  bool? sendInvitation;
  bool? recordSession;
  String? createdAt;
  String? updatedAt;

  AdditionalSetting(
      {this.id,
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
        this.updatedAt});

  AdditionalSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameFormatId = json['gameFormatId'];
    minPlayers = json['minPlayers'];
    maxPlayers = json['maxPlayers'];
    badgeNames = json['badgeNames'].cast<String>();
    requireAllTrue = json['requireAllTrue'];
    aiScoring = json['aiScoring'];
    allowLaterJoin = json['allowLaterJoin'];
    sendInvitation = json['sendInvitation'];
    recordSession = json['recordSession'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gameFormatId'] = this.gameFormatId;
    data['minPlayers'] = this.minPlayers;
    data['maxPlayers'] = this.maxPlayers;
    data['badgeNames'] = this.badgeNames;
    data['requireAllTrue'] = this.requireAllTrue;
    data['aiScoring'] = this.aiScoring;
    data['allowLaterJoin'] = this.allowLaterJoin;
    data['sendInvitation'] = this.sendInvitation;
    data['recordSession'] = this.recordSession;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}