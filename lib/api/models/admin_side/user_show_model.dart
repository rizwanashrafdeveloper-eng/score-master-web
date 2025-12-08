class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;   // "Admin" | "facilitator" | "player"
  final String? phone;
  final String? language;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.language,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
      language: json['language'],
    );
  }
}
