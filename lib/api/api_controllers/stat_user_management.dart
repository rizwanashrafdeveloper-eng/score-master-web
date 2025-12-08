import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_endpoints/api_end_points.dart';
import '../api_models/stat_user_managemnt.dart';

class StatsUserManagementController extends GetxController {
  var isLoading = true.obs;
  var statsUserManagement = StatsUserManagementModel().obs;
  var errorMessage = ''.obs;

  Future<void> fetchStatsUserManagement(String userId, String role) async {
    try {
      print("[StatsUserManagementController] Fetching stats for user ID: $userId, Role: $role");
      isLoading(true);
      errorMessage.value = '';

      final String apiUrl = ApiEndpoints.userManagementStat(int.parse(userId), role);
      print("[StatsUserManagementController] API URL: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("[StatsUserManagementController] Response status: ${response.statusCode}");
      print("[StatsUserManagementController] Raw response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        statsUserManagement.value = StatsUserManagementModel.fromJson(jsonData);
        errorMessage.value = '';
      } else {
        final errorData = json.decode(response.body);
        errorMessage.value = 'Failed to load data: ${errorData['message'] ?? 'Unknown error'}';
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error: $e';
      print("[StatsUserManagementController] Exception: $e");
      print("[StatsUserManagementController] StackTrace: $stackTrace");
    } finally {
      isLoading(false);
      print("[StatsUserManagementController] Loading finished.");
    }
  }
}
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import 'dart:convert';
//
// import '../api_endpoints/api_end_points.dart';
// import '../api_models/stat_user_managemnt.dart';
//
// class StatsUserManagementController extends GetxController {
//   var isLoading = true.obs;
//   var statsUserManagement = StatsUserManagementModel().obs;
//   var errorMessage = ''.obs;
//
//   // @override
//   // void onInit() {
//   //   print("[StatsUserManagementController] onInit called");
//   //   fetchStatsUserManagement();
//   //   super.onInit();
//   // }
//
//   Future<void> fetchStatsUserManagement(int userId) async {
//     try {
//       print("[StatsUserManagementController] Fetching stats for user ID: $userId");
//       isLoading(true);
//
//       final response = await http.get(
//         Uri.parse(ApiEndpoints.userManagementStat(userId)),
//       );
//
//       print("[StatsUserManagementController] Response status: ${response.statusCode}");
//       print("[StatsUserManagementController] Raw response body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final jsonData = json.decode(response.body);
//         statsUserManagement.value = StatsUserManagementModel.fromJson(jsonData);
//         errorMessage.value = '';
//       } else {
//         errorMessage.value = 'Failed to load data: ${response.statusCode}';
//       }
//     } catch (e, stackTrace) {
//       errorMessage.value = 'Error: $e';
//       print("[StatsUserManagementController] Exception: $e");
//       print("[StatsUserManagementController] StackTrace: $stackTrace");
//     } finally {
//       isLoading(false);
//       print("[StatsUserManagementController] Loading finished.");
//     }
//   }
//
// }
