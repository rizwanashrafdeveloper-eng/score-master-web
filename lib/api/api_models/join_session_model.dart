class JoinSessionResponse {
  final bool success;
  final String message;
  final int? sessionId; // Optional: if backend returns session info

  JoinSessionResponse({
    required this.success,
    required this.message,
    this.sessionId,
  });

  factory JoinSessionResponse.fromJson(Map<String, dynamic> json) {
    return JoinSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      sessionId: json['sessionId'], // nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'sessionId': sessionId,
    };
  }
}
