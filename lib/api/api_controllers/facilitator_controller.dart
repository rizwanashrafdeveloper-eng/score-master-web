import 'package:get/get.dart';
import '../api_models/facilitators_model.dart';
import '../api_services/api_services.dart';

class FacilitatorsController extends GetxController {
  var facilitators = <Facilitators>[].obs;   // all facilitators from API
  var selectedIds = <int>[].obs;             // stores selected facilitator IDs
  var isLoading = false.obs;                 // loading state
  var searchQuery = "".obs;                  // search input value

  @override
  void onInit() {
    super.onInit();
    fetchFacilitatorsFromApi();
  }

  /// Fetch data from API (get all facilitators once)
  Future<void> fetchFacilitatorsFromApi() async {
    try {
      isLoading.value = true;
      print("🌍 Fetching facilitators from API...");

      final data = await ApiService.getFacilitators();

      print("📦 Raw response data: $data");

      facilitators.value = data.map((e) => Facilitators.fromJson(e)).toList();

      print("✅ Facilitators loaded: ${facilitators.length}");
      for (var f in facilitators) {
        print(" - ${f.id} | ${f.name} | ${f.email}");
      }
    } catch (e) {
      print("❌ Error fetching facilitators: $e");
    } finally {
      isLoading.value = false;
    }
  }


  /// Toggle facilitator selection
  void toggleSelection(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);   // unselect
    } else {
      selectedIds.add(id);      // select
    }
  }

  /// Return selected facilitator objects
  List<Facilitators> getSelectedFacilitators() {
    return facilitators.where((f) => selectedIds.contains(f.id)).toList();
  }

  /// Filter facilitators by search query (case-insensitive)
  List<Facilitators> get filteredFacilitators {
    final query = searchQuery.value.trim().toLowerCase();
    print("🔎 Current search query: '$query'");

    if (query.isEmpty) {
      print("⚠️ Empty query → returning []");
      return [];
    }

    // Log all facilitator names to confirm data
    print("📋 Available facilitators:");
    for (var f in facilitators) {
      print(" - ${f.name} | email: ${f.email} | phone: ${f.phone}");
    }

    final results = facilitators.where((f) {
      final name = f.name?.toLowerCase() ?? "";
      final email = f.email?.toLowerCase() ?? "";
      final phone = f.phone?.toLowerCase() ?? "";
      final match = name.contains(query) || email.contains(query) || phone.contains(query);

      if (match) {
        print("✅ Match found: ${f.name}");
      }
      return match;
    }).toList();

    print("🎯 Total matches: ${results.length}");
    return results;
  }

}
