import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_models/stat_facilitator_model.dart';
import '../api_urls.dart';


class StatsFacilitatorManagementController extends GetxController {
  var isLoading = true.obs;
  var facilitatorStats = StatsFacilitatorManagementModel().obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchFacilitatorStats();
    super.onInit();
  }

  Future<void> fetchFacilitatorStats() async {
    try {
      isLoading(true);
      final response =
      await http.get(Uri.parse(ApiEndpoints.facilitatorManagementStat));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        facilitatorStats.value =
            StatsFacilitatorManagementModel.fromJson(jsonData);
        errorMessage.value = '';
        print("[FacilitatorController] Data loaded successfully");
      } else {
        errorMessage.value = 'Failed: ${response.statusCode}';
        print("[FacilitatorController] Error code: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print("[FacilitatorController] Exception: $e");
    } finally {
      isLoading(false);
    }
  }
}
