class CreateGameFormatModel {
  int? gameFormatId;
  int? minPlayers;
  int? maxPlayers;
  List<String>? badgeNames;
  bool? requireAllTrue;
  bool? aiScoring;
  bool? allowLaterJoin;
  bool? sendInvitation;
  bool? recordSession;

  CreateGameFormatModel(
      {this.gameFormatId,
        this.minPlayers,
        this.maxPlayers,
        this.badgeNames,
        this.requireAllTrue,
        this.aiScoring,
        this.allowLaterJoin,
        this.sendInvitation,
        this.recordSession});

  CreateGameFormatModel.fromJson(Map<String, dynamic> json) {
    gameFormatId = json['gameFormatId'];
    minPlayers = json['minPlayers'];
    maxPlayers = json['maxPlayers'];
    badgeNames = json['badgeNames'].cast<String>();
    requireAllTrue = json['requireAllTrue'];
    aiScoring = json['aiScoring'];
    allowLaterJoin = json['allowLaterJoin'];
    sendInvitation = json['sendInvitation'];
    recordSession = json['recordSession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameFormatId'] = this.gameFormatId;
    data['minPlayers'] = this.minPlayers;
    data['maxPlayers'] = this.maxPlayers;
    data['badgeNames'] = this.badgeNames;
    data['requireAllTrue'] = this.requireAllTrue;
    data['aiScoring'] = this.aiScoring;
    data['allowLaterJoin'] = this.allowLaterJoin;
    data['sendInvitation'] = this.sendInvitation;
    data['recordSession'] = this.recordSession;
    return data;
  }
}
