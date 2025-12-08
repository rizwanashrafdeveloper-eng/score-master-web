class SessionsListResponse {
  final List<SessionSummary> scheduledSessions;
  final List<SessionSummary> activeSessions;

  SessionsListResponse({
    required this.scheduledSessions,
    required this.activeSessions,
  });

  factory SessionsListResponse.fromJson(Map<String, dynamic> json) {
    return SessionsListResponse(
      scheduledSessions: (json['scheduledSessions'] as List<dynamic>?)
          ?.map((e) => SessionSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      activeSessions: (json['activeSessions'] as List<dynamic>?)
          ?.map((e) => SessionSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduledSessions': scheduledSessions.map((e) => e.toJson()).toList(),
      'activeSessions': activeSessions.map((e) => e.toJson()).toList(),
    };
  }
}

class SessionSummary {
  final int id;
  final String teamTitle;
  final String description;
  final int totalPlayers;
  final int totalPhases;
  final int? remainingTime; // ✅ for activeSessions
  final DateTime? startTime; // ✅ for scheduledSessions
  final String joinCode;

  SessionSummary({
    required this.id,
    required this.teamTitle,
    required this.description,
    required this.totalPlayers,
    required this.totalPhases,
    this.remainingTime,
    this.startTime,
    required this.joinCode,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      id: json['id'] ?? 0,
      teamTitle: json['teamTitle'] ?? '',
      description: json['description'] ?? '',
      totalPlayers: json['totalPlayers'] ?? 0,
      totalPhases: json['totalPhases'] ?? 0,
      remainingTime: json['remainingTime'],
      startTime:
      json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      joinCode: json['joinCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamTitle': teamTitle,
      'description': description,
      'totalPlayers': totalPlayers,
      'totalPhases': totalPhases,
      'remainingTime': remainingTime,
      'startTime': startTime?.toIso8601String(),
      'joinCode': joinCode,
    };
  }
}
