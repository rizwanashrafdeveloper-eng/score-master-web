class PhaseModel {
  final int? id; // optional if not saved yet
  final String name;
  final List<String> challengeTypes;
  final int timeDuration;
  final int stagesCount;

  PhaseModel({
    this.id,
    required this.name,
    required this.challengeTypes,
    required this.timeDuration,
    required this.stagesCount,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'],
      name: json['name'] ?? '',
      challengeTypes: List<String>.from(json['challengeTypes'] ?? []),
      timeDuration: json['timeDuration'] ?? 0,
      stagesCount: json['stagesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "challengeTypes": challengeTypes,
      "timeDuration": timeDuration,
      "stagesCount": stagesCount,
    };
  }
}
