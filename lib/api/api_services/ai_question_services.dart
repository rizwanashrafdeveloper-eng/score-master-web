// lib/api/api_services/ai_question_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;


import '../api_models/ai_questions_model.dart';
import '../api_urls.dart';

class AIQuestionService {


  static Future<AIQuestionResponse> generateQuestion(AIQuestionRequest request) async {
    final url = Uri.parse(ApiEndpoints.aiGenerate);
    print("📤 Generating AI question → $url with body: ${jsonEncode(request.toJson())}");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print("📥 AI Question Response → ${response.statusCode} | ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AIQuestionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to generate AI question: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("❌ Error in generateQuestion: $e");
      throw e;
    }
  }
}