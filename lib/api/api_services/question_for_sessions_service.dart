import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/question_for_session_model.dart';

class SessionException implements Exception {
  final String message;
  final int statusCode;

  SessionException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class QuestionForSessionsService {
  static const String baseUrl = "https://score-master-backend.onrender.com";

  /// Fetches questions for a session
  /// API Format: /questions/questions-for-session/{gameFormatId}/{sessionId}
  static Future<QuestionForSessionModel?> fetchQuestions({
    required int sessionId,
    required int gameFormatId,
  }) async {
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
      } else if (response.statusCode == 400) {
        // Parse the error message
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Bad Request';
        print("❌ [QuestionForSessionsService] 400 Error: $errorMessage");

        // Throw specific exception for session not active
        if (errorMessage.toLowerCase().contains('not active')) {
          throw SessionException('session_not_active', 400);
        } else if (errorMessage.toLowerCase().contains('paused')) {
          throw SessionException('session_paused', 400);
        } else {
          throw SessionException(errorMessage, 400);
        }
      } else if (response.statusCode == 404) {
        print("❌ [QuestionForSessionsService] 404: Not Found");
        throw SessionException('session_not_found', 404);
      } else {
        print("❌ [QuestionForSessionsService] Failed: ${response.body}");
        throw SessionException('Failed to load questions: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      print("🔥 [QuestionForSessionsService] Exception: $e");
      rethrow; // Re-throw to let controller handle it
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../api_models/question_for_session_model.dart';
//
// class QuestionForSessionsService {
//   static const String baseUrl = "https://score-master-backend.onrender.com";
//
//   /// Fetches questions for a session
//   /// API Format: /questions/questions-for-session/{gameFormatId}/{sessionId}
//   static Future<QuestionForSessionModel?> fetchQuestions({
//     required int sessionId,
//     required int gameFormatId,
//   }) async {
//     // CORRECT ORDER: gameFormatId FIRST, then sessionId
//     final url = Uri.parse('$baseUrl/questions/questions-for-session/$gameFormatId/$sessionId');
//
//     try {
//       print("🔄 Fetching questions from: $url");
//
//       final response = await http.get(
//         url,
//         headers: {"Content-Type": "application/json"},
//       );
//
//       print("📡 Response Status: ${response.statusCode}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final jsonData = jsonDecode(response.body);
//         print("✅ Successfully fetched questions");
//         return QuestionForSessionModel.fromJson(jsonData);
//       } else {
//         print("❌ [QuestionForSessionsService] Failed: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("🔥 [QuestionForSessionsService] Exception: $e");
//       return null;
//     }
//   }
// }