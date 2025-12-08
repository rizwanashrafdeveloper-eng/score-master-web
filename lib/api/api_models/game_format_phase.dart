class GameFormatPhaseModel {
  int? sessionId;
  GameFormat? gameFormat;

  GameFormatPhaseModel({this.sessionId, this.gameFormat});

  GameFormatPhaseModel.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    gameFormat = json['gameFormat'] != null
        ? new GameFormat.fromJson(json['gameFormat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionId'] = this.sessionId;
    if (this.gameFormat != null) {
      data['gameFormat'] = this.gameFormat!.toJson();
    }
    return data;
  }
}

class GameFormat {
  int? id;
  String? name;
  String? description;
  String? mode;
  int? totalPhases;
  int? timeDuration;
  bool? isPublished;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? createdById;
  List<Phases>? phases;

  GameFormat(
      {this.id,
        this.name,
        this.description,
        this.mode,
        this.totalPhases,
        this.timeDuration,
        this.isPublished,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.createdById,
        this.phases});

  GameFormat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    mode = json['mode'];
    totalPhases = json['totalPhases'];
    timeDuration = json['timeDuration'];
    isPublished = json['isPublished'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdById = json['createdById'];
    if (json['phases'] != null) {
      phases = <Phases>[];
      json['phases'].forEach((v) {
        phases!.add(new Phases.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['mode'] = this.mode;
    data['totalPhases'] = this.totalPhases;
    data['timeDuration'] = this.timeDuration;
    data['isPublished'] = this.isPublished;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdById'] = this.createdById;
    if (this.phases != null) {
      data['phases'] = this.phases!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phases {
  int? id;
  int? gameFormatId;
  String? name;
  String? description;
  int? order;
  String? scoringType;
  int? timeDuration;
  List<String>? challengeTypes;
  String? difficulty;
  String? badge;
  int? requiredScore;
  String? createdAt;
  String? updatedAt;

  Phases(
      {this.id,
        this.gameFormatId,
        this.name,
        this.description,
        this.order,
        this.scoringType,
        this.timeDuration,
        this.challengeTypes,
        this.difficulty,
        this.badge,
        this.requiredScore,
        this.createdAt,
        this.updatedAt});

  Phases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameFormatId = json['gameFormatId'];
    name = json['name'];
    description = json['description'];
    order = json['order'];
    scoringType = json['scoringType'];
    timeDuration = json['timeDuration'];
    challengeTypes = json['challengeTypes'].cast<String>();
    difficulty = json['difficulty'];
    badge = json['badge'];
    requiredScore = json['requiredScore'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gameFormatId'] = this.gameFormatId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['order'] = this.order;
    data['scoringType'] = this.scoringType;
    data['timeDuration'] = this.timeDuration;
    data['challengeTypes'] = this.challengeTypes;
    data['difficulty'] = this.difficulty;
    data['badge'] = this.badge;
    data['requiredScore'] = this.requiredScore;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
