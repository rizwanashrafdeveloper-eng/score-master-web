import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/question_for_session_model.dart';

class QuestionForSessionsService {
  static const String baseUrl = "https://score-master-backend.onrender.com";

  /// Fetches questions for a session
  /// API Format: /questions/questions-for-session/{gameFormatId}/{sessionId}
  static Future<QuestionForSessionModel?> fetchQuestions({
    required int sessionId,
    required int gameFormatId,
  }) async {
    // CORRECT ORDER: gameFormatId FIRST, then sessionId
    final url = Uri.parse('$baseUrl/questions/questions-for-session/$gameFormatId/$sessionId');

    try {
      print("🔄 Fetching questions from: $url");

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("📡 Response Status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        print("✅ Successfully fetched questions");
        return QuestionForSessionModel.fromJson(jsonData);
      } else {
        print("❌ [QuestionForSessionsService] Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 [QuestionForSessionsService] Exception: $e");
      return null;
    }
  }
}