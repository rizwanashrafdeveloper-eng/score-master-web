import 'package:get/get.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/team_view_model.dart';
import '../api_services/team_view_service.dart';

class TeamViewController extends GetxController {
  var isLoading = false.obs;
  var teamView = Rxn<TeamViewModel>();
  var errorMessage = ''.obs;

  /// Fetch teams for a session
  Future<void> loadTeams() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final sessionId = await SharedPrefServices.getSessionId();
      if (sessionId == null) {
        errorMessage.value = "Session ID not found";
        return;
      }

      final result = await TeamViewService.fetchTeams(sessionId);

      if (result != null) {
        teamView.value = result;
        print("✅ [TeamViewController] Teams loaded: ${result.teams.length}");
      } else {
        errorMessage.value = "Failed to load teams.";
        print("❌ [TeamViewController] No data returned from API");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("🔥 [TeamViewController] Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
