
class TeamModel {
final int teamId;
final String nickname;
final String createdAt;
final CreatedBy createdBy;
final List<PlayerModel> players;

TeamModel({
required this.teamId,
required this.nickname,
required this.createdAt,
required this.createdBy,
required this.players,
});

factory TeamModel.fromJson(Map<String, dynamic> json) {
return TeamModel(
teamId: json['teamId'],
nickname: json['nickname'],
createdAt: json['createdAt'],
createdBy: CreatedBy.fromJson(json['createdBy']),
players: (json['players'] as List)
    .map((p) => PlayerModel.fromJson(p))
    .toList(),
);
}
}

class CreatedBy {
final int id;
final String name;
final String email;

CreatedBy({required this.id, required this.name, required this.email});

factory CreatedBy.fromJson(Map<String, dynamic> json) {
return CreatedBy(
id: json['id'],
name: json['name'],
email: json['email'],
);
}
}

class PlayerModel {
final int? playerId;
final String? name;
final String? email;

PlayerModel({
this.playerId,
this.name,
this.email,
});

factory PlayerModel.fromJson(Map<String, dynamic> json) {
return PlayerModel(
playerId: json['id'],
name: json['name'],
email: json['email'],
);
}
}
