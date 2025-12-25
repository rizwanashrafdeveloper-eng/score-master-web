import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:scorer_web/api/api_controllers/team_leaderboard_controller.dart';
import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/players_containers.dart';

import '../../api/api_controllers/player_leadrboard_controller.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:get/get.dart';

import '../../api/api_models/player_leaderboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import '../../shared_preference/shared_preference.dart';

class PlayerLeaderboardScreen extends StatefulWidget {
  const PlayerLeaderboardScreen({super.key});

  @override
  State<PlayerLeaderboardScreen> createState() =>
      _PlayerLeaderboardScreenState();
}

class _PlayerLeaderboardScreenState extends State<PlayerLeaderboardScreen>
    with WidgetsBindingObserver {
  final RxBool isTeamSelected = false.obs;
  final ExportShareController exportShareController = Get.put(ExportShareController());
  final PlayerLeaderboardController playerController =
  Get.put(PlayerLeaderboardController(), permanent: true);
  final TeamLeaderboardController teamController =
  Get.put(TeamLeaderboardController(), permanent: true);

  int? sessionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSession();
  }

  Future<void> _initSession() async {
    final id = await SharedPrefServices.getSessionId();
    if (id != null && id > 0) {
      setState(() => sessionId = id);
      await _loadLeaderboards(id);
    } else {
      print("⚠️ No valid sessionId found in SharedPref.");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && sessionId != null) {
      _loadLeaderboards(sessionId!);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadLeaderboards(int id) async {
    await Future.wait([
      playerController.loadLeaderboard(id),
      teamController.loadLeaderboard(id),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 13),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      Image.asset(Appimages.player2, height: 63, width: 50),
                      Expanded(
                        child: Center(
                          child: BoldText(
                            text: "team_alpha".tr,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Image.asset(Appimages.house1, height: 63, width: 80),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoldText(
                        text: "players".tr,
                        selectionColor: isTeamSelected.value
                            ? AppColors.playerColo1r
                            : AppColors.blueColor,
                        fontSize: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.025),
                      FlutterSwitch(
                        value: isTeamSelected.value,
                        onToggle: (val) => isTeamSelected.value = val,
                        height: screenHeight * 0.03,
                        width: screenWidth * 0.1,
                        activeColor: AppColors.forwardColor,
                        inactiveColor: AppColors.forwardColor,
                      ),
                      SizedBox(width: screenWidth * 0.025),
                      BoldText(
                        text: "teams".tr,
                        selectionColor: isTeamSelected.value
                            ? AppColors.blueColor
                            : AppColors.playerColo1r,
                        fontSize: screenWidth * 0.04,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.035,
                      height: screenWidth * 0.035,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.visitingColor,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    MainText(
                      text: "live_updates".tr,
                      color: AppColors.visitingColor,
                      fontSize: screenWidth * 0.035,
                    )
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                Obx(
                      () => CreateContainer(
                    text: isTeamSelected.value
                        ? "your_team_rank_2nd".tr
                        : "your_rank_2nd".tr,
                    width: isTeamSelected.value
                        ? screenWidth * 0.466
                        : screenWidth * 0.347,
                  ),
                ),

                SizedBox(height: screenHeight * 0.08),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    children: [
                      Obx(() {
                        if (isTeamSelected.value
                            ? teamController.isLoading.value
                            : playerController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<Map<String, dynamic>> topThree = [];

                        if (isTeamSelected.value) {
                          // For teams
                          for (var team in teamController.top3) {
                            topThree.add({
                              "rank": team.rank ?? 0,
                              "name": team.sessionDescription ?? 'Unknown Team',
                              "points": team.totalPoints ?? 0,
                            });
                          }
                        } else {
                          // For players
                          for (var player in playerController.top3) {
                            topThree.add({
                              "rank": player.rank ?? 0,
                              "name": player.playerName ?? 'Unknown Player',
                              "points": player.totalPoints ?? 0,
                            });
                          }
                        }

                        return PlayersRow(
                          isTeamSelected: isTeamSelected.value,
                          //topThree: topThree,
                        );
                      }),

                      SizedBox(height: screenHeight * 0.035),

                      Obx(() {
                        if (isTeamSelected.value
                            ? teamController.isLoading.value
                            : playerController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<Map<String, dynamic>> allData = [];

                        if (isTeamSelected.value) {
                          // Combine top3 and remaining for teams
                          final allTeams = [
                            ...teamController.top3,
                            ...teamController.remaining,
                          ];

                          for (var team in allTeams) {
                            allData.add({
                              "rank": team.rank ?? 0,
                              "name": team.sessionDescription ?? 'Unknown Team',
                              "points": team.totalPoints ?? 0,
                            });
                          }
                        } else {
                          // Combine top3 and remaining for players
                          final allPlayers = [
                            ...playerController.top3,
                            ...playerController.remaining,
                          ];

                          for (var player in allPlayers) {
                            allData.add({
                              "rank": player.rank ?? 0,
                              "name": player.playerName ?? 'Unknown Player',
                              "points": player.totalPoints ?? 0,
                            });
                          }
                        }

                        // Sort by rank
                        allData.sort((a, b) => (a["rank"] as int).compareTo(b["rank"] as int));

                        return Column(
                          children: List.generate(allData.length, (index) {
                            final data = allData[index];
                            final rank = data["rank"] as int;

                            Color bgColor;
                            Color arrowColor;
                            IconData arrowIcon;

                            if (rank == 1) {
                              bgColor = AppColors.yellowColor;
                              arrowColor = AppColors.forwardColor;
                              arrowIcon = Icons.arrow_drop_up;
                            } else if (rank == 2) {
                              bgColor = AppColors.newggrey;
                              arrowColor = AppColors.redColor;
                              arrowIcon = Icons.arrow_drop_down;
                            } else if (rank == 3) {
                              bgColor = AppColors.orangeColor;
                              arrowColor = AppColors.redColor;
                              arrowIcon = Icons.arrow_drop_down;
                            } else {
                              bgColor = AppColors.playerColor;
                              arrowColor = AppColors.forwardColor;
                              arrowIcon = Icons.arrow_drop_up;
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.018),
                              child: PlayersContainers(
                                text1: data["rank"].toString(),
                                text2: data["name"] as String,
                                image: Appimages.play2,
                                icon: arrowIcon,
                                iconColor: arrowColor,
                                text4: "${data["points"]} pts",
                                ishow: true,
                                containerColor: bgColor,
                                leftPadding: screenWidth * 0.05,
                              ),
                            );
                          }),
                        );
                      }),

                      SizedBox(height: screenHeight * 0.025),

                      Obx(() => LoginButton(
                        fontSize: 19,
                        text: exportShareController.isSharing.value
                            ? "sharing".tr
                            : "share_results".tr,
                        ishow: true,
                        color: AppColors.redColor,
                        image: Appimages.move,
                        onTap: exportShareController.isSharing.value
                            ? null
                            : () async {
                          List<Map<String, dynamic>> leaderboardData = [];

                          if (isTeamSelected.value) {
                            final allTeams = [
                              ...teamController.top3,
                              ...teamController.remaining,
                            ];

                            for (var team in allTeams) {
                              leaderboardData.add({
                                "rank": team.rank ?? 0,
                                "name": team.sessionDescription ?? 'Unknown Team',
                                "points": team.totalPoints ?? 0,
                              });
                            }
                          } else {
                            final allPlayers = [
                              ...playerController.top3,
                              ...playerController.remaining,
                            ];

                            for (var player in allPlayers) {
                              leaderboardData.add({
                                "rank": player.rank ?? 0,
                                "name": player.playerName ?? 'Unknown Player',
                                "points": player.totalPoints ?? 0,
                              });
                            }
                          }

                          leaderboardData.sort((a, b) => (a["rank"] as int).compareTo(b["rank"] as int));

                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("share_options".tr),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.text_fields),
                                    title: Text("share_as_text".tr),
                                    onTap: () {
                                      Navigator.pop(context);
                                      exportShareController.shareResults(
                                        isTeamSelected: isTeamSelected.value,
                                        leaderboardData: leaderboardData,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.file_present),
                                    title: Text("share_as_csv".tr),
                                    onTap: () {
                                      Navigator.pop(context);
                                      exportShareController.shareAsCSV(
                                        isTeamSelected: isTeamSelected.value,
                                        leaderboardData: leaderboardData,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),

                      SizedBox(height: screenHeight * 0.012),

                      Obx(() => LoginButton(
                        fontSize: 19,
                        text: exportShareController.isExporting.value
                            ? "exporting".tr
                            : "export_data".tr,
                        ishow: true,
                        image: Appimages.export,
                        onTap: exportShareController.isExporting.value
                            ? null
                            : () {
                          List<Map<String, dynamic>> leaderboardData = [];

                          if (isTeamSelected.value) {
                            final allTeams = [
                              ...teamController.top3,
                              ...teamController.remaining,
                            ];

                            for (var team in allTeams) {
                              leaderboardData.add({
                                "rank": team.rank ?? 0,
                                "name": team.sessionDescription ?? 'Unknown Team',
                                "points": team.totalPoints ?? 0,
                              });
                            }
                          } else {
                            final allPlayers = [
                              ...playerController.top3,
                              ...playerController.remaining,
                            ];

                            for (var player in allPlayers) {
                              leaderboardData.add({
                                "rank": player.rank ?? 0,
                                "name": player.playerName ?? 'Unknown Player',
                                "points": player.totalPoints ?? 0,
                              });
                            }
                          }

                          leaderboardData.sort((a, b) => (a["rank"] as int).compareTo(b["rank"] as int));

                          exportShareController.exportToCSV(
                            isTeamSelected: isTeamSelected.value,
                            leaderboardData: leaderboardData,
                          );
                        },
                      )),
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExportShareController extends GetxController {
  final RxBool isExporting = false.obs;
  final RxBool isSharing = false.obs;

  // Export leaderboard data to CSV (Web version)
  Future<void> exportToCSV({
    required bool isTeamSelected,
    required List<Map<String, dynamic>> leaderboardData,
  }) async {
    try {
      isExporting.value = true;

      // Prepare CSV data
      List<List<dynamic>> rows = [];

      // Add headers
      rows.add(['Rank', isTeamSelected ? 'Team Name' : 'Player Name', 'Points']);

      // Add data rows
      for (var data in leaderboardData) {
        rows.add([
          data['rank'].toString(),
          data['name'].toString(),
          data['points'].toString(),
        ]);
      }

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Create file name with timestamp
      String timestamp = DateTime.now().toString().replaceAll(':', '-').split('.')[0];
      String fileName = isTeamSelected
          ? 'team_leaderboard_$timestamp.csv'
          : 'player_leaderboard_$timestamp.csv';

      // Create download link for web
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;
      html.document.body?.children.add(anchor);

      // Trigger download
      anchor.click();

      // Clean up
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      Get.snackbar(
        'export_success'.tr,
        '${'data_exported_to'.tr}: $fileName',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_export_data'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isExporting.value = false;
    }
  }

  // Share leaderboard results as text (Web version - copies to clipboard)
  Future<void> shareResults({
    required bool isTeamSelected,
    required List<Map<String, dynamic>> leaderboardData,
  }) async {
    try {
      isSharing.value = true;

      // Create share text
      String shareText = isTeamSelected
          ? '🏆 ${'team_leaderboard_results'.tr} 🏆\n\n'
          : '🏆 ${'player_leaderboard_results'.tr} 🏆\n\n';

      // Add top 3
      if (leaderboardData.length >= 3) {
        shareText += '🥇 1st Place: ${leaderboardData[0]['name']} - ${leaderboardData[0]['points']} pts\n';
        shareText += '🥈 2nd Place: ${leaderboardData[1]['name']} - ${leaderboardData[1]['points']} pts\n';
        shareText += '🥉 3rd Place: ${leaderboardData[2]['name']} - ${leaderboardData[2]['points']} pts\n\n';
      }

      // Add remaining
      if (leaderboardData.length > 3) {
        shareText += '${'other_rankings'.tr}:\n';
        for (int i = 3; i < leaderboardData.length && i < 10; i++) {
          shareText += '${leaderboardData[i]['rank']}. ${leaderboardData[i]['name']} - ${leaderboardData[i]['points']} pts\n';
        }
      }

      shareText += '\n📊 ${'shared_via_scorer_app'.tr}';

      // Copy to clipboard for web
      await html.window.navigator.clipboard?.writeText(shareText);

      Get.snackbar(
        'share_success'.tr,
        'results_copied_to_clipboard'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_share_results'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSharing.value = false;
    }
  }

  // Share as CSV file (Web version - downloads CSV)
  Future<void> shareAsCSV({
    required bool isTeamSelected,
    required List<Map<String, dynamic>> leaderboardData,
  }) async {
    try {
      isSharing.value = true;

      // Prepare CSV data
      List<List<dynamic>> rows = [];
      rows.add(['Rank', isTeamSelected ? 'Team Name' : 'Player Name', 'Points']);

      for (var data in leaderboardData) {
        rows.add([
          data['rank'].toString(),
          data['name'].toString(),
          data['points'].toString(),
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      // Create file name
      String fileName = isTeamSelected
          ? 'team_leaderboard.csv'
          : 'player_leaderboard.csv';

      // Create download for web
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;
      html.document.body?.children.add(anchor);

      anchor.click();

      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      Get.snackbar(
        'share_success'.tr,
        'csv_downloaded_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_share_csv'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSharing.value = false;
    }
  }
}