class SessionModel {
  final int id;
  final String? sessiontitle; // Nullable
  final String? description; // Nullable
  final String? joinCode; // Nullable
  final String? joinLink; // Nullable
  final String? status; // Nullable
  final int remainingTime;
  final int totalPlayers;
  final int engagement;
  final ActivePhase activePhase;
  final CreatedBy createdBy;
  final DateTime createdAt;
  final DateTime startTime; // e.g., from JSON key "startTime"
  final int duration;       // e.g., from JSON key "duration" in minutes


  SessionModel( {
    required this.startTime,  // <-- initialize in constructor
    required this.duration,
    required this.id,
    this.sessiontitle, // Nullable
    this.description, // Nullable
    this.joinCode, // Nullable
    this.joinLink, // Nullable
    this.status, // Nullable
    required this.remainingTime,
    required this.totalPlayers,
    required this.engagement,
    required this.activePhase,
    required this.createdBy,
    required this.createdAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] ?? 0, // Provide default if null
      sessiontitle: json['teamTitle'], // Nullable, no need for default
      description: json['description'], // Nullable
      joinCode: json['joinCode'], // Nullable
      joinLink: json['joinLink'], // Nullable
      status: json['status'], // Nullable
      remainingTime: json['remainingTime'] ?? 0, // Provide default if null
      totalPlayers: json['totalPlayers'] ?? 0, // Provide default if null
      engagement: json['engagement'] ?? 0, // Provide default if null
      activePhase: ActivePhase.fromJson(json['activePhase'] ?? {}), // Handle null
      createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}), // Handle null
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()), // Default to now if null

      startTime: DateTime.tryParse(json['startTime']?.toString() ?? '') ?? DateTime.now(),
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teamTitle': sessiontitle,
      'description': description,
      'joinCode': joinCode,
      'joinLink': joinLink,
      'status': status,
      'remainingTime': remainingTime,
      'totalPlayers': totalPlayers,
      'engagement': engagement,
      'activePhase': activePhase.toJson(),
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

}
class ActivePhase {
  final int id;
  final String? name; // Nullable
  final String? status; // Nullable
  final int remainingTime;

  ActivePhase({
    required this.id,
    this.name, // Nullable
    this.status, // Nullable
    required this.remainingTime,
  });

  factory ActivePhase.fromJson(Map<String, dynamic> json) {
    return ActivePhase(
      id: json['id'] ?? 0, // Default if null
      name: json['name'], // Nullable
      status: json['status'], // Nullable
      remainingTime: json['remainingTime'] ?? 0, // Default if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'remainingTime': remainingTime,
    };
  }
}

class CreatedBy {
  final int id;
  final String? name; // Nullable
  final String? role; // Nullable

  CreatedBy({
    required this.id,
    this.name, // Nullable
    this.role, // Nullable
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] ?? 0, // Default if null
      name: json['name'], // Nullable
      role: json['role'], // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
    };
  }
}