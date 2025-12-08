


class CreateGameModel {
  String? name;
  String? description;
  String? mode;
  int? totalPhases;
  int? timeDuration;
  int? createdById;
  List<int>? facilitatorIds;
  String? scoringType; // ✅ added scoringType

  CreateGameModel({
    this.name,
    this.description,
    this.mode,
    this.totalPhases,
    this.timeDuration,
    this.createdById,
    this.facilitatorIds,
    this.scoringType, // ✅ constructor
  });

  CreateGameModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    mode = json['mode'];
    totalPhases = json['totalPhases'];
    timeDuration = json['timeDuration'];
    createdById = json['createdById'];
    facilitatorIds = json['facilitatorIds']?.cast<int>();
    scoringType = json['scoringType']; // ✅ from JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['description'] = description;
    data['mode'] = mode;
    data['totalPhases'] = totalPhases;
    data['timeDuration'] = timeDuration;
    data['createdById'] = createdById;
    data['facilitatorIds'] = facilitatorIds;
    data['scoringType'] = scoringType; // ✅ to JSON
    return data;
  }
}






// class CreateGameModel {
//   String? name;
//   String? description;
//   String? mode;
//   int? totalPhases;
//   int? timeDuration;
//   int? createdById;
//   List<int>? facilitatorIds;
//
//   CreateGameModel(
//       {this.name,
//         this.description,
//         this.mode,
//         this.totalPhases,
//         this.timeDuration,
//         this.createdById,
//         this.facilitatorIds});
//
//   CreateGameModel.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     description = json['description'];
//     mode = json['mode'];
//     totalPhases = json['totalPhases'];
//     timeDuration = json['timeDuration'];
//     createdById = json['createdById'];
//     facilitatorIds = json['facilitatorIds'].cast<int>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['mode'] = this.mode;
//     data['totalPhases'] = this.totalPhases;
//     data['timeDuration'] = this.timeDuration;
//     data['createdById'] = this.createdById;
//     data['facilitatorIds'] = this.facilitatorIds;
//     return data;
//   }
// }
