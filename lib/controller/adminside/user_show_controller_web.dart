import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/api_endpoints/api_end_points.dart';
import '../../api/models/admin_side/user_show_model.dart';


class UserShowControllerWeb extends GetxController {
  var allUsers = <UserModel>[].obs;
  var isLoading = false.obs;
  var searchText = "".obs;

  final String apiUrl = "${ApiEndpoints.userAdminFacilitator}";

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      print("📡 Fetching users from $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));

      print("📥 Status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        allUsers.assignAll(data.map((e) => UserModel.fromJson(e)).toList());
        print("✅ Loaded ${allUsers.length} users");
      } else {
        print("❌ Failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<UserModel> filteredUsers(String role) {
    return allUsers
        .where((u) =>
    u.role.toLowerCase() == role.toLowerCase() ||
        (role == "admin" &&
            (u.role.toLowerCase() == "administrator" ||
                u.role.toLowerCase() == "admin")))
        .where((u) =>
    u.name.toLowerCase().contains(searchText.value.toLowerCase()) ||
        u.email.toLowerCase().contains(searchText.value.toLowerCase()))
        .toList();
  }
}
