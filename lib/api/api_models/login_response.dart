class LoginResponse {
  final String token;
  final User user;
  final int? sessionId; // NEW - Optional for facilitators

  LoginResponse({
    required this.token,
    required this.user,
    this.sessionId, // NEW
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
      sessionId: json['sessionId'], // NEW - Will be null if not present
    );
  }
}
class User {
  final int id;
  final String name;
  final String email;
  final String language;
  final String phone;
  final String role;
  final int? facilitatorId; // ✅ Added field

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.language,
    required this.phone,
    required this.role,
    this.facilitatorId, // ✅ Added to constructor
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      language: json['language'] ?? 'en',
      phone: json['phone'] ?? '',
      role: json['role'],
      facilitatorId: json['facilitatorId'], // ✅ Added safely
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "language": language,
    "phone": phone,
    "role": role,
    "facilitatorId": facilitatorId, // ✅ Added for saving
  };
}
