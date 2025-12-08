// import 'package:get/get.dart';
// import '../api_models/facilitator_model_toshow.dart';
// import '../api_services/facilitator_model_api_service.dart';
//
// class FacilitatorControllerToShow extends GetxController {
//   var facilitators = <FacilitatorModelToShow>[].obs;
//   var filteredFacilitators = <FacilitatorModelToShow>[].obs;
//   var isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchFacilitators(1); // load gameFormatId = 1 initially
//   }
//
//   Future<void> fetchFacilitators(int gameFormatId) async {
//     try {
//       isLoading.value = true;
//       print("🔵 Fetching facilitators for gameFormatId: $gameFormatId ...");
//
//       final result = await FacilitatorApiServiceToShow.getFacilitators(gameFormatId);
//
//       print("🟢 API Success: fetched ${result.length} facilitators");
//       for (var f in result) {
//         print("➡️ Facilitator: ${f.name} (${f.email})");
//       }
//
//       facilitators.assignAll(result);
//       filteredFacilitators.assignAll(result);
//     } catch (e) {
//       print("🔴 Error fetching facilitators: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void searchFacilitators(String query) {
//     if (query.isEmpty) {
//       filteredFacilitators.assignAll(facilitators);
//     } else {
//       final lowerQuery = query.toLowerCase();
//       filteredFacilitators.value = facilitators.where((f) {
//         return f.name.toLowerCase().contains(lowerQuery) ||
//             f.email.toLowerCase().contains(lowerQuery);
//       }).toList();
//
//       print("🔍 Search query: '$query' => ${filteredFacilitators.length} matches");
//     }
//   }
// }
