class RegistrationModel {
  String name;
  String email;
  String password;
  String language;
  String phone;
  String role;
  int roleId;

  RegistrationModel({
    required this.name,
    required this.email,
    required this.password,
    this.language = 'en',
    this.phone = '',
    required this.role,
    required this.roleId,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      language: json['language'] ?? 'en',
      phone: json['phone'] ?? '',
      role: json['role'],
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'language': language,
      'phone': phone,
      'role': role,
      'roleId': roleId,
    };
  }
}
