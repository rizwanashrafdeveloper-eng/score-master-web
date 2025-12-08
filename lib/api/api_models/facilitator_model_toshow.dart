// class FacilitatorModelToShow {
//   final int id;
//   final String email;
//   final String name;
//   final String language;
//   final String phone;
//   final String role;
//   final String createdAt;
//
//   FacilitatorModelToShow({
//     required this.id,
//     required this.email,
//     required this.name,
//     required this.language,
//     required this.phone,
//     required this.role,
//     required this.createdAt,
//   });
//
//   factory FacilitatorModelToShow.fromJson(Map<String, dynamic> json) {
//     return FacilitatorModelToShow(
//       id: json['id'] ?? 0,
//       email: json['email'] ?? '',
//       name: json['name'] ?? 'Unknown',
//       language: json['language'] ?? 'en',
//       phone: json['phone'] ?? '',
//       role: json['role'] ?? 'facilitator',
//       createdAt: json['createdAt'] ?? '',
//     );
//   }
// }
