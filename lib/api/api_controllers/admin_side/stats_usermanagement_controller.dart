// import 'package:get/get.dart';
// import 'package:scorer_web/models/stats_user_management_model.dart';
// import 'package:scorer_web/api/api_controllers/stat_user_management.dart';
//
// class StatsUserManagementController extends GetxController {
//   final _api = StatsUserManagementApi();
//
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//   var statsUserManagement = StatsUserManagementModel().obs;
//
//   /// Call this when the screen opens (pass the user id & role)
//   Future<void> fetchUserDetails(int userId, String role) async {
//     try {
//       isLoading(true);
//       errorMessage('');
//       final data = await _api.getUserStats(userId, role);
//       statsUserManagement(data);
//     } catch (e) {
//       errorMessage(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
// }