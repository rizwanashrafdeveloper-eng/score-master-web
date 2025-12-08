import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/question_for_session_model.dart';


class QuestionForSessionsService {
  static const String baseUrl = "https://score-master-backend.onrender.com";

  static Future<QuestionForSessionModel?> fetchQuestions({
    required int sessionId,
    required int gameFormatId,
  }) async {
    final url = Uri.parse('$baseUrl/questions/questions-for-session/$sessionId/$gameFormatId');

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
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
