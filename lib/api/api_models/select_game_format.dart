class SelectGameFormat {
  final int? id;
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
      id: json['id'] as int?,
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
    return {
      'id': id,
      'name': name,
      'description': description,
      'mode': mode,
      'totalPhases': totalPhases,
      'timeDuration': timeDuration,
      'isActive': isActive,
      'scoringType': scoringType,
    };
  }
}






// class SelectGameFormat {
//   String? name;
//   String? description;
//   String? mode;
//   int? totalPhases;
//   int? timeDuration;
//   bool? isActive;
//   String? scoringType;
//
//   SelectGameFormat(
//       {this.name,
//         this.description,
//         this.mode,
//         this.totalPhases,
//         this.timeDuration,
//         this.isActive,
//         this.scoringType});
//
//   SelectGameFormat.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     description = json['description'];
//     mode = json['mode'];
//     totalPhases = json['totalPhases'];
//     timeDuration = json['timeDuration'];
//     isActive = json['isActive'];
//     scoringType = json['scoringType'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['mode'] = this.mode;
//     data['totalPhases'] = this.totalPhases;
//     data['timeDuration'] = this.timeDuration;
//     data['isActive'] = this.isActive;
//     data['scoringType'] = this.scoringType;
//     return data;
//   }
// }