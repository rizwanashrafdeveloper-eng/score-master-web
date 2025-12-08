class GameModel {
  final String name;
  final String description;
  final String mode;
  final int totalPhases;
  final int timeDuration; // ✅ new field
  final bool isActive;
  final String scoringType;

  GameModel({
    required this.name,
    required this.description,
    required this.mode,
    required this.totalPhases,
    required this.timeDuration, // ✅ add to constructor
    required this.isActive,
    required this.scoringType,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    // ✅ Try both possible keys for timeDuration (camelCase and snake_case) to handle API inconsistencies
    final timeDur = json['timeDuration'] ?? json['timeduration'] ?? json['time_duration'] ?? 0;

    // ✅ Also handle scoringType if missing (defaults to 'AUTOMATIC' as before)
    final scoreType = json['scoringType'] ?? json['scoringtype'] ?? json['scoring_type'] ?? 'AUTOMATIC';

    final game = GameModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      mode: json['mode'] ?? 'team',
      totalPhases: json['totalPhases'] ?? json['total_phases'] ?? 0,
      timeDuration: timeDur,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      scoringType: scoreType,
    );

    // ✅ Debug print for each parsed game
    print("🔍 GameModel.fromJson DEBUG → ID: ${json['id'] ?? 'unknown'} | Name: '${game.name}' | Time Raw: ${json['timeDuration']}, ${json['timeduration']}, ${json['time_duration']} → Parsed: ${game.timeDuration} | Scoring Raw: ${json['scoringType']}, ${json['scoringtype']} → Parsed: ${game.scoringType}");

    return game;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'mode': mode,
      'totalPhases': totalPhases,
      'timeDuration': timeDuration, // ✅ Consistent camelCase for API (matches your sample)
      'isActive': isActive,
      'scoringType': scoringType,
    };
  }

  // Helper methods
  bool get isEmpty => name.trim().isEmpty && description.trim().isEmpty;

  String get displayName => name.trim().isEmpty ? 'Untitled Game' : name;

  String get displayDescription =>
      description.trim().isEmpty ? 'No description available' : description;

  String get modeDisplayText => mode == 'team' ? 'Team Mode' : 'Solo Mode';

  String get statusText => isActive ? 'Active' : 'Inactive';

  String get scoringTypeDisplay {
    switch (scoringType) {

      case 'AI':
        return 'Ai-Based';
      case 'MANUAL':
        return 'Manual';
      case 'HYBRID':
        return 'Hybrid';
      default:
        return scoringType;
    }
  }
}