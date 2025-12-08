// lib/api/api_models/score_response_model.dart
class ScoreResponse {
  final int finalScore;
  final int relevanceScore;
  final String suggestion;
  final String qualityAssessment;
  final String description;
  final ScoreBreakdown scoreBreakdown;
  final String feedback;

  ScoreResponse({
    required this.finalScore,
    required this.relevanceScore,
    required this.suggestion,
    required this.qualityAssessment,
    required this.description,
    required this.scoreBreakdown,
    required this.feedback,
  });

  factory ScoreResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing ScoreResponse...');
      print('scoreBreakdown JSON: ${json['scoreBreakdown']}');

      return ScoreResponse(
        finalScore: json['finalScore'] ?? 0,
        relevanceScore: json['relevanceScore'] ?? 0,
        suggestion: json['suggestion'] ?? '',
        qualityAssessment: json['qualityAssessment'] ?? 'average',
        description: json['description'] ?? '',
        scoreBreakdown: json['scoreBreakdown'] != null
            ? ScoreBreakdown.fromJson(json['scoreBreakdown'] as Map<String, dynamic>)
            : ScoreBreakdown.empty(),
        feedback: json['feedback'] ?? '',
      );
    } catch (e, stackTrace) {
      print('Error parsing ScoreResponse: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

class ScoreBreakdown {
  final String charity;
  final String strategicThinking;
  final String feasibility;
  final String innovation;

  ScoreBreakdown({
    required this.charity,
    required this.strategicThinking,
    required this.feasibility,
    required this.innovation,
  });

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing ScoreBreakdown...');
      print('charity: ${json['charity']}');
      print('strategicThinking: ${json['strategicThinking']}');
      print('feasibility: ${json['feasibility']}');
      print('innovation: ${json['innovation']}');

      return ScoreBreakdown(
        charity: json['charity']?.toString() ?? '0/25',
        strategicThinking: json['strategicThinking']?.toString() ?? '0/25',
        feasibility: json['feasibility']?.toString() ?? '0/25',
        innovation: json['innovation']?.toString() ?? '0/25',
      );
    } catch (e) {
      print('Error parsing ScoreBreakdown: $e');
      return ScoreBreakdown.empty();
    }
  }

  // Factory for empty/default values
  factory ScoreBreakdown.empty() {
    return ScoreBreakdown(
      charity: '0/25',
      strategicThinking: '0/25',
      feasibility: '0/25',
      innovation: '0/25',
    );
  }

  // Helper method to get numeric value from string like "20/25"
  int getNumericValue(String scoreString) {
    try {
      return int.parse(scoreString.split('/')[0]);
    } catch (e) {
      return 0;
    }
  }

  // Helper to get max value (denominator)
  int getMaxValue(String scoreString) {
    try {
      return int.parse(scoreString.split('/')[1]);
    } catch (e) {
      return 25;
    }
  }
}