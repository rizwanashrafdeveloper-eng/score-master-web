// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../api_models/facilitator_model_toshow.dart';
// import '../api_urls.dart';
// class FacilitatorApiServiceToShow {
//   static Future<List<FacilitatorModelToShow>> getFacilitators(int gameFormatId) async {
//     final url = Uri.parse(ApiEndpoints.facilitators(gameFormatId));
//     print("🌐 Calling API: $url");
//
//     try {
//       final response = await http.get(url);
//       print("📩 Status Code: ${response.statusCode}");
//       print("📦 Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final List<dynamic> decoded = json.decode(response.body);
//         return decoded.map((e) => FacilitatorModelToShow.fromJson(e)).toList();
//       } else {
//         throw Exception("Failed to load facilitators (${response.statusCode})");
//       }
//     } catch (e) {
//       print("❌ API Exception: $e");
//       rethrow;
//     }
//   }
// }
