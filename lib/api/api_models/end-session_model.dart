class EndSessionModel {
  final int id;
  final int gameFormatId;
  final String description;
  final int createdById;
  final String joinCode;
  final String joiningLink;
  final String status;
  final int duration;
  final int elapsedTime;
  final String? startedAt;
  final String? pausedAt;
  final String endedAt;
  final String createdAt;
  final String updatedAt;

  EndSessionModel({
    required this.id,
    required this.gameFormatId,
    required this.description,
    required this.createdById,
    required this.joinCode,
    required this.joiningLink,
    required this.status,
    required this.duration,
    required this.elapsedTime,
    this.startedAt,
    this.pausedAt,
    required this.endedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EndSessionModel.fromJson(Map<String, dynamic> json) {
    return EndSessionModel(
      id: json['id'] ?? 0,
      gameFormatId: json['gameFormatId'] ?? 0,
      description: json['description'] ?? '',
      createdById: json['createdById'] ?? 0,
      joinCode: json['joinCode'] ?? '',
      joiningLink: json['joiningLink'] ?? '',
      status: json['status'] ?? '',
      duration: json['duration'] ?? 0,
      elapsedTime: json['elapsedTime'] ?? 0,
      startedAt: json['startedAt'],
      pausedAt: json['pausedAt'],
      endedAt: json['endedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameFormatId': gameFormatId,
      'description': description,
      'createdById': createdById,
      'joinCode': joinCode,
      'joiningLink': joiningLink,
      'status': status,
      'duration': duration,
      'elapsedTime': elapsedTime,
      'startedAt': startedAt,
      'pausedAt': pausedAt,
      'endedAt': endedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  bool get isCompleted => status == 'COMPLETED';
}