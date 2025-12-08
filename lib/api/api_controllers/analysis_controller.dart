// import 'dart:convert'; // for jsonDecode
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:scorer/api/api_urls.dart';
// import '../api_models/analysis_model.dart';
//
//
//
// class EndSessionController extends GetxController {
//   // Observable variables
//   final isLoading = false.obs;
//   final hasError = false.obs;
//   final errorMessage = ''.obs;
//
//   // Add sessionId
//   final sessionId = 0.obs;
//
//   // Data observables
//   Rx<AnalysisModel?> analysisData = Rx<AnalysisModel?>(null);
//
//   // Getters for easy access
//   SessionOverview? get sessionOverview => analysisData.value?.sessionOverview;
//   List? get badges => analysisData.value?.badges;
//   SessionStats? get sessionStats => analysisData.value?.sessionStats;
//   List? get playerRanking => analysisData.value?.playerRanking;
//   List? get phasesBreakdown => analysisData.value?.phasesBreakdown;
//
//   @override
//   void onInit() {
//     super.onInit();
//     print("🔄 EndSessionController initialized");
//
//     // Get sessionId from arguments
//     final arguments = Get.arguments;
//     if (arguments != null && arguments['sessionId'] != null) {
//       sessionId.value = arguments['sessionId'];
//       print("🎯 Received sessionId: ${sessionId.value}");
//       fetchSessionAnalysis();
//     } else {
//       print("❌ No sessionId provided in arguments");
//       hasError.value = true;
//       errorMessage.value = "No session ID provided";
//     }
//   }
//
//   // Fetch session analysis data - GET API with dynamic sessionId
//   Future fetchSessionAnalysis() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;
//
//       // Use dynamic sessionId in the API endpoint
//       final url = '${ApiEndpoints.baseUrl}/scores/${sessionId.value}/analytics';
//       print("📡 Sending GET request to: $url");
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           // 'Authorization': 'Bearer YOUR_TOKEN', // if needed
//         },
//       );
//
//       print("📥 Response received [${response.statusCode}]");
//
//       if (response.statusCode == 200) {
//         final bodyString = response.body;
//         print("✅ Raw Response Body: $bodyString");
//
//         final data = jsonDecode(bodyString);
//         print("📝 Decoded JSON: $data");
//
//         analysisData.value = AnalysisModel.fromJson(data);
//         print("🎯 Parsed AnalysisModel: ${analysisData.value}");
//
//         // Debug print the data
//         _debugPrintAnalysisData();
//       } else {
//         print("❌ Failed with status: ${response.statusCode}");
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = e.toString();
//       print('🚨 Error while fetching session analysis: $e');
//     } finally {
//       isLoading.value = false;
//       print("⏹️ fetchSessionAnalysis completed.");
//     }
//   }
//
//   // Debug method to print all analysis data
//   void _debugPrintAnalysisData() {
//     print("📊 === ANALYSIS DATA DEBUG ===");
//     print("📋 Session Overview:");
//     print("   - Duration: ${sessionOverview?.timeDuration} min");
//     print("   - Total Phases: ${sessionOverview?.totalPhases}");
//     print("   - Active Players: ${sessionOverview?.activePlayers}");
//
//     print("🎖️ Badges: ${badges?.length ?? 0} badges");
//     if (badges != null && badges!.isNotEmpty) {
//       for (var badge in badges!) {
//         print("   - $badge");
//       }
//     }
//
//     print("📈 Session Stats:");
//     print("   - Average Score: ${sessionStats?.averageScore}");
//     print("   - Completion Rate: ${sessionStats?.completionRate}%");
//     print("   - Participation Rate: ${sessionStats?.participationRate}%");
//     print("   - Top Performer: ${sessionStats?.topPerformer?.name} (${sessionStats?.topPerformer?.points} pts)");
//
//     print("🏆 Player Ranking: ${playerRanking?.length ?? 0} players");
//     if (playerRanking != null) {
//       for (var player in playerRanking!) {
//         print("   - Rank ${player.rank}: ${player.playerName} (${player.totalPoints} pts)");
//       }
//     }
//
//     print("📋 Phase Breakdown: ${phasesBreakdown?.length ?? 0} phases");
//     if (phasesBreakdown != null) {
//       for (var phase in phasesBreakdown!) {
//         print("   - ${phase.phaseName}: ${phase.timeDuration}min, ${phase.totalPoints} pts");
//       }
//     }
//     print("📊 === END DEBUG ===");
//   }
//
//   // Helper method to format time duration
//   String formatDuration(int? minutes) {
//     if (minutes == null) return '0 min';
//     if (minutes < 60) return '$minutes min';
//
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     return mins > 0 ? '${hours}h ${mins}min' : '${hours}h';
//   }
//
//   // Helper method to get rank suffix
//   String getRankSuffix(int rank) {
//     if (rank == 1) return 'st';
//     if (rank == 2) return 'nd';
//     if (rank == 3) return 'rd';
//     return 'th';
//   }
//
//   // Refresh data
//   Future refreshData() async {
//     print("🔄 Refreshing session analysis...");
//     await fetchSessionAnalysis();
//   }
//   // Get top 3 players for PlayersRow widget
//   List<Map<String, dynamic>> get topThreePlayers {
//     if (playerRanking == null || playerRanking!.isEmpty) return [];
//
//     // Sort players by rank just in case
//     final sorted = List.from(playerRanking!);
//     sorted.sort((a, b) => a.rank.compareTo(b.rank));
//
//     // Take top 3 and map into PlayersRow format
//     return sorted.take(3).map((p) => {
//       "rank": p.rank,
//       "name": p.playerName,
//       "points": p.totalPoints,
//     }).toList();
//   }
//
// }
//
// // class EndSessionController extends GetxController {
// //   // Observable variables
// //   final isLoading = false.obs;
// //   final hasError = false.obs;
// //   final errorMessage = ''.obs;
// //
// //   // Data observables
// //   Rx<AnalysisModel?> analysisData = Rx<AnalysisModel?>(null);
// //
// //   // Getters for easy access
// //   SessionOverview? get sessionOverview => analysisData.value?.sessionOverview;
// //   List? get badges => analysisData.value?.badges;
// //   SessionStats? get sessionStats => analysisData.value?.sessionStats;
// //   List? get playerRanking => analysisData.value?.playerRanking;
// //   List? get phasesBreakdown => analysisData.value?.phasesBreakdown;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     print("🔄 EndSessionController initialized. Fetching session analysis...");
// //     fetchSessionAnalysis();
// //   }
// //
// //   // Fetch session analysis data - GET API
// //   Future fetchSessionAnalysis() async {
// //     try {
// //       isLoading.value = true;
// //       hasError.value = false;
// //
// //       print("📡 Sending GET request to: ${ApiEndpoints.analysis}");
// //
// //       final response = await http.get(
// //         Uri.parse(ApiEndpoints.analysis),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Accept': 'application/json',
// //           // 'Authorization': 'Bearer YOUR_TOKEN', // if needed
// //         },
// //       );
// //
// //       print("📥 Response received [${response.statusCode}]");
// //
// //       if (response.statusCode == 200) {
// //         final bodyString = response.body;
// //         print("✅ Raw Response Body: $bodyString");
// //
// //         final data = jsonDecode(bodyString);
// //         print("📝 Decoded JSON: $data");
// //
// //         analysisData.value = AnalysisModel.fromJson(data);
// //         print("🎯 Parsed AnalysisModel: ${analysisData.value}");
// //       } else {
// //         print("❌ Failed with status: ${response.statusCode}");
// //         throw Exception('Failed to load data: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       hasError.value = true;
// //       errorMessage.value = e.toString();
// //       print('🚨 Error while fetching session analysis: $e');
// //     } finally {
// //       isLoading.value = false;
// //       print("⏹️ fetchSessionAnalysis completed.");
// //     }
// //   }
// //
// //   // Helper method to format time duration
// //   String formatDuration(int? minutes) {
// //     if (minutes == null) return '0 min';
// //     if (minutes < 60) return '$minutes min';
// //
// //     final hours = minutes ~/ 60;
// //     final mins = minutes % 60;
// //     return mins > 0 ? '${hours}h ${mins}min' : '${hours}h';
// //   }
// //
// //   // Helper method to get rank suffix
// //   String getRankSuffix(int rank) {
// //     if (rank == 1) return 'st';
// //     if (rank == 2) return 'nd';
// //     if (rank == 3) return 'rd';
// //     return 'th';
// //   }
// //
// //   // Refresh data
// //   Future refreshData() async {
// //     print("🔄 Refreshing session analysis...");
// //     await fetchSessionAnalysis();
// //   }
// // }
