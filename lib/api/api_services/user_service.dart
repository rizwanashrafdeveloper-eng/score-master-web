// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:scorer/api/api_urls.dart';
// import '../api_models/user_model.dart';
//
// class UserService {
//   static const String userAdminFacilitator = "${ApiEndpoints.userAdminFacilitator}";
//
//   static Future<List<UserModel>> fetchUsers() async {
//     print("📡 Fetching users from: $userAdminFacilitator");
//     final response = await http.get(Uri.parse(userAdminFacilitator));
//
//     print("📥 Response status: ${response.statusCode}");
//     print("📦 Response body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       print("✅ Parsed ${data.length} users");
//       return data.map((e) => UserModel.fromJson(e)).toList();
//     } else {
//       throw Exception("❌ Failed to load users: ${response.statusCode}");
//     }
//   }
// }
