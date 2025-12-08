import 'dart:convert';

class AddPhaseModel {
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

  AddPhaseModel({
    this.id,
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
    this.updatedAt,
  });

  factory AddPhaseModel.fromJson(Map<String, dynamic> json) {
    return AddPhaseModel(
      id: json['id'] as int?,
      gameFormatId: json['gameFormatId'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      order: json['order'] as int?,
      scoringType: json['scoringType'] as String?,
      timeDuration: json['timeDuration'] as int?,
      challengeTypes: json['challengeTypes'] != null
          ? (json['challengeTypes'] as List<dynamic>).map((e) => e.toString()).toList()
          : [],
      difficulty: json['difficulty'] as String?,
      badge: json['badge'] as String?,
      requiredScore: json['requiredScore'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameFormatId': gameFormatId,
      'name': name,
      'description': description,
      'order': order,
      'scoringType': scoringType,
      'timeDuration': timeDuration,
      'challengeTypes': challengeTypes,
      'difficulty': difficulty,
      'badge': badge,
      'requiredScore': requiredScore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}