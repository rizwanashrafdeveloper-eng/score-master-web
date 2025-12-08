import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_models/player_q_submit_model.dart';
import '../api_urls.dart';

class PlayerQSubmitService {
  Future<PlayerQSubmitModel?> submitAnswer(PlayerQSubmitModel requestData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.submitPlayerAnswer),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PlayerQSubmitModel.fromJson(data);
      } else {
        print("❌ Failed to submit answer: ${response.statusCode}");
        print(response.body);
        return null;
      }
    } catch (e) {
      print("⚠️ Error submitting player answer: $e");
      return null;
    }
  }
}
