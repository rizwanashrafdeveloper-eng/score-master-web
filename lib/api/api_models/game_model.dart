// import 'package:scorer/api/api_models/add_phase_model.dart';
//
// class GameModel {
//   final int? id;
//   final String? displayName;
//   final String? description;
//   final int? totalPhases;
//   List<AddPhaseModel>? phases;
//
//   GameModel({
//     this.id,
//     this.displayName,
//     this.description,
//     this.totalPhases,
//     this.phases,
//   });
//
//   factory GameModel.fromJson(Map<String, dynamic> json) {
//     return GameModel(
//       id: json['id'],
//       displayName: json['displayName'],
//       description: json['description'],
//       totalPhases: json['totalPhases'],
//       phases: json['phases'] != null
//           ? (json['phases'] as List).map((p) => AddPhaseModel.fromJson(p)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'displayName': displayName,
//       'description': description,
//       'totalPhases': totalPhases,
//       'phases': phases?.map((p) => p.toJson()).toList(),
//     };
//   }
// }