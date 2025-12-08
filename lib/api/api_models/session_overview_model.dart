import 'dart:convert';

class SessionOverViewModel {
  final int id;
  final String sessionTitle;
  final String description;
  final String joinCode;
  final String joinLink;
  final String status;
  final int remainingTime;
  final int totalPlayers;
  final int engagement;
  final ActivePhase activePhase;
  final CreatedBy createdBy;
  final DateTime createdAt;

  SessionOverViewModel({
    required this.id,
    required this.sessionTitle,
    required this.description,
    required this.joinCode,
    required this.joinLink,
    required this.status,
    required this.remainingTime,
    required this.totalPlayers,
    required this.engagement,
    required this.activePhase,
    required this.createdBy,
    required this.createdAt,
  });

  factory SessionOverViewModel.fromJson(Map<String, dynamic> json) {
    return SessionOverViewModel(
      id: json['id'] ?? 0,
      // handles multiple possible key names and null values safely
      sessionTitle: (json['sessiontitle'] ??
          json['sessionTitle'] ??
          json['teamTitle'] ??
          '')
          .toString(),
      description: (json['description'] ?? '').toString(),
      joinCode: (json['joinCode'] ?? '').toString(),
      joinLink: (json['joinLink'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      remainingTime: json['remainingTime'] is int
          ? json['remainingTime']
          : int.tryParse(json['remainingTime']?.toString() ?? '0') ?? 0,
      totalPlayers: json['totalPlayers'] is int
          ? json['totalPlayers']
          : int.tryParse(json['totalPlayers']?.toString() ?? '0') ?? 0,
      engagement: json['engagement'] is int
          ? json['engagement']
          : int.tryParse(json['engagement']?.toString() ?? '0') ?? 0,
      activePhase: json['activePhase'] != null
          ? ActivePhase.fromJson(json['activePhase'])
          : ActivePhase(id: 0, name: '', status: '', remainingTime: 0),
      createdBy: json['createdBy'] != null
          ? CreatedBy.fromJson(json['createdBy'])
          : CreatedBy(id: 0, name: '', role: ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessiontitle': sessionTitle,
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
  final String name;
  final String status;
  final int remainingTime;

  ActivePhase({
    required this.id,
    required this.name,
    required this.status,
    required this.remainingTime,
  });

  factory ActivePhase.fromJson(Map<String, dynamic> json) {
    return ActivePhase(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      remainingTime: json['remainingTime'] is int
          ? json['remainingTime']
          : int.tryParse(json['remainingTime']?.toString() ?? '0') ?? 0,
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
  final String name;
  final String role;

  CreatedBy({
    required this.id,
    required this.name,
    required this.role,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role': role};
  }
}
