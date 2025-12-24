import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_models/show_all_game_model.dart';
import '../api_urls.dart';

class GamesController extends GetxController {
  // Observable list of games
  var games = <GameModel>[].obs;

  // Loading state
  var isLoading = false.obs;

  // Error handling
  var errorMessage = ''.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch games when controller initializes
    fetchAllGames();
  }

  /// Fetch all games from API
  Future<void> fetchAllGames() async {
    if (isLoading.value) return; // Prevent multiple calls

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final url = "${ApiEndpoints.baseUrl}/admin/game-formats/all-games";
    print("🌍 Fetching all games from → $url");

    http.Response? response; // ✅ Declare response outside try block for catch access

    try {
      response = await http.get(Uri.parse(url));

      print("📥 FetchAllGames Response → ${response.statusCode}");
      print("📥 Body Preview (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...");
      print("📥 Full Body Length: ${response.body.length}");

      if (response.statusCode == 200) {
        final responseBody = response.body.trim();

        // Handle empty response
        if (responseBody.isEmpty || responseBody == '[]') {
          print("📝 No games found");
          games.clear();
          return;
        }

        final List<dynamic> data = jsonDecode(responseBody);

        if (data.isEmpty) {
          print("📝 Empty games array");
          games.clear();
          return;
        }

        print("📊 Raw API Data Count: ${data.length} items");

        // Parse games and filter out completely empty ones
        final parsedGames = data.map((json) {
          final game = GameModel.fromJson(json); // This will print debug inside fromJson
          print("🟢 Parsed Game → ${game.displayName} | Mode: ${game.mode} | Phases: ${game.totalPhases} | Time: ${game.timeDuration} min | Active: ${game.isActive} | Scoring: ${game.scoringType}");
          return game;
        }).where((game) {
          final keep = !game.isEmpty && game.totalPhases > 0; // ✅ Stricter filter: also require totalPhases > 0 to exclude truly invalid games
          if (!keep) {
            print("🔴 Filtered out game: ${game.displayName} (empty: ${game.isEmpty}, phases: ${game.totalPhases}, time: ${game.timeDuration})");
          }
          return keep;
        }).toList(); // Filter out empty/invalid games

        games.assignAll(parsedGames);
        print("✅ Total Games Loaded: ${games.length} (filtered from ${data.length})");

        // ✅ Additional debug: Log times for ALL loaded games
        print("📊 LOADED GAMES TIMES:");
        for (int i = 0; i < games.length; i++) {
          final game = games[i];
          print("  ${i+1}. ${game.displayName}: ${game.timeDuration} min (ID: ${data[i]?['id'] ?? 'N/A'})");
        }

      } else if (response.statusCode == 404) {
        print("📝 No games endpoint found (404)");
        games.clear();
        hasError.value = true;
        errorMessage.value = 'Games not found';
      } else {
        print("❌ Failed to fetch games → ${response.statusCode}: ${response.body}");
        hasError.value = true;
        errorMessage.value = 'failed_load_games'.tr + ': ${response.statusCode}';
        Get.snackbar('error'.tr, 'error_fetching_games'.tr + ' ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Exception in fetchAllGames → $e");
      print("❌ Full Response Body on Error: ${response?.body ?? 'No response'}");
      hasError.value = true;
      errorMessage.value = 'network_error'.tr;
      Get.snackbar('error'.tr, 'error_fetching_games'.tr + ': $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh games list
  Future<void> refreshGames() async {
    print("🔄 Refreshing games list");
    await fetchAllGames();
  }

  /// Get filtered games by status
  List<GameModel> getActiveGames() {
    return games.where((game) => game.isActive).toList();
  }

  List<GameModel> getInactiveGames() {
    return games.where((game) => !game.isActive).toList();
  }

  /// Get games by mode
  List<GameModel> getTeamGames() {
    return games.where((game) => game.mode == 'team').toList();
  }

  List<GameModel> getSoloGames() {
    return games.where((game) => game.mode == 'solo').toList();
  }

  /// Get games by scoring type
  List<GameModel> getGamesByScoringType(String scoringType) {
    return games.where((game) => game.scoringType == scoringType).toList();
  }

  /// Get games count
  int get totalGames => games.length;
  int get activeGamesCount => getActiveGames().length;
  int get inactiveGamesCount => getInactiveGames().length;

  /// Search games
  List<GameModel> searchGames(String query) {
    if (query.trim().isEmpty) return games.toList();

    final lowerQuery = query.toLowerCase();
    return games.where((game) {
      return game.name.toLowerCase().contains(lowerQuery) ||
          game.description.toLowerCase().contains(lowerQuery) ||
          game.mode.toLowerCase().contains(lowerQuery) ||
          game.scoringType.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get random sample of games for testing
  List<GameModel> getSampleGames({int count = 3}) {
    if (games.isEmpty) return [];

    final shuffled = List<GameModel>.from(games)..shuffle();
    return shuffled.take(count).toList();
  }
}