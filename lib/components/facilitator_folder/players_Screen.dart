import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/team_distrbution_container.dart';
import 'package:scorer_web/constants/app_routes.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/all_players_container.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import '../../../api/api_controllers/players_controller.dart';
import '../../api/api_controllers/game_format_phase.dart';
import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';
import '../../view/FacilitatorFolder/vew_responses_screen.dart';
import '../../widgets/main_text.dart'; // Adjust path

class PlayersScreen extends StatelessWidget {
  final int? sessionId;
  const PlayersScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    final AdminPlayerController controller = Get.put(AdminPlayerController());

    print("📱 [Web PlayersScreen] Building with sessionId: $sessionId");

    // Initialize controller if sessionId is provided
    if (sessionId != null) {
      print("🎯 [Web PlayersScreen] Initializing controller with sessionId: $sessionId");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.teams.isEmpty && !controller.isLoading.value) {
          controller.fetchTeams(sessionId!);
        }
      });
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20.h),
              BoldText(
                text: "Loading players...",
                fontSize: 24.sp,
                selectionColor: AppColors.blueColor,
              ),
            ],
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 60.sp, color: Colors.red),
              SizedBox(height: 20.h),
              MainText(
                text: controller.errorMessage.value,
                fontSize: 22.sp,
                color: Colors.red,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              LoginButton(
                text: "Retry",
                fontSize: 20.sp,
                onTap: () {
                  if (sessionId != null) {
                    controller.fetchTeams(sessionId!);
                  }
                },
              ),
            ],
          ),
        );
      }

      if (controller.teams.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Appimages.group,
                width: 200.w,
                height: 200.h,
              ),
              SizedBox(height: 20.h),
              BoldText(
                text: "No players yet",
                fontSize: 28.sp,
                selectionColor: AppColors.blueColor,
              ),
              SizedBox(height: 10.h),
              MainText(
                text: "Players will appear here when they join",
                fontSize: 22.sp,
                color: AppColors.greyColor,
              ),
              SizedBox(height: 30.h),
              LoginButton(
                text: "Refresh",
                fontSize: 20.sp,
                onTap: () {
                  if (sessionId != null) {
                    controller.fetchTeams(sessionId!);
                  }
                },
              ),
            ],
          ),
        );
      }

      print("✅ [Web PlayersScreen] Displaying ${controller.teams.length} teams with ${controller.activePlayersCount.value} active players");

      final totalPlayers = controller.activePlayersCount.value + controller.inactivePlayersCount.value;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 51.h),
            Padding(
              padding: EdgeInsets.only(right: 30.w, left: 22.w),
              child: Row(
                children: [
                  Image.asset(
                    Appimages.group,
                    width: 238.w,
                    height: 209.h,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      width: 212.w,
                      height: 228.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor,
                          width: 1.7.w,
                        ),
                        borderRadius: BorderRadius.circular(47.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BoldText(
                            text: "${controller.activePlayersCount.value}",
                            selectionColor: AppColors.forwardColor,
                            fontSize: 47.sp,
                          ),
                          BoldText(
                            textAlign: TextAlign.center,
                            text: "active".tr,
                            fontSize: 31.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                          BoldText(
                            textAlign: TextAlign.center,
                            text: "players".tr,
                            fontSize: 31.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      width: 212.w,
                      height: 228.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor,
                          width: 1.7.w,
                        ),
                        borderRadius: BorderRadius.circular(47.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BoldText(
                            text: "${controller.inactivePlayersCount.value}",
                            selectionColor: AppColors.redColor,
                            fontSize: 47.sp,
                          ),
                          BoldText(
                            textAlign: TextAlign.center,
                            text: "inactive\nplayers".tr,
                            fontSize: 31.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoldText(
                        text: "all_players".tr,
                        fontSize: 31.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      // Row(
                      //   children: [
                      //     SvgPicture.asset(
                      //       Appimages.filter,
                      //       height: 31.h,
                      //       width: 31.w,
                      //     ),
                      //     SizedBox(width: 11.w),
                      //     BoldText(
                      //       text: "filter".tr,
                      //       fontSize: 31.sp,
                      //       selectionColor: AppColors.blueColor,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  // Dynamic Teams and Players List
                  ...controller.teams.asMap().entries.map((entry) {
                    final index = entry.key;
                    final team = entry.value;
                    final teamColor = _getTeamColor(index);
                    final teamImage = _getTeamImage(index);

                    return Column(
                      children: [
                        // Players in team
                        ...team.players.map((player) {
                          return Column(
                            children: [
                              AllPlayersContainer(
                                text: player.name ?? "Player ${player.playerId}",
                                text2: "Joined ${team.createdAt != null
                                    ? DateTime.parse(team.createdAt!).toLocal().toString().substring(11, 16)
                                    : 'Unknown'}",
                                image: teamImage,
                                                             ),
                              SizedBox(height: 20.h),
                            ],
                          );
                        }).toList(),

                        // Team label
                        CreateContainer(
                          top: -30.h,
                          right: 80.w,
                          width: 180.w,
                          height: 70.h,
                          arrowh: 40.h,
                          arrowW: 70.w,
                          borderW: 1.4.w,
                          fontsize2: 20.sp,
                          textColor: teamColor,
                          borderColor: teamColor,
                          containerColor: teamColor.withOpacity(0.1),
                          text: team.nickname ?? "Team ${index + 1}",
                        ),
                        SizedBox(height: 30.h),
                      ],
                    );
                  }).toList(),

                  SizedBox(height: 40.h),
                  // In PlayersScreen.dart line 288:
                  TeamDistributionContainer(
                    sessionId: sessionId, // Pass sessionId
                  ),
                  SizedBox(height: 50.h),

                  Center(
                    child: Column(
                      children: [
                        // LoginButton(
                        //   fontSize: 22.sp,
                        //   text: "add_player".tr,
                        //   image: Appimages.personadd,
                        //   ishow: true,
                        //   onTap: () {
                        //     Get.snackbar(
                        //       'Info',
                        //       'Add player feature coming soon',
                        //       snackPosition: SnackPosition.TOP,
                        //     );
                        //   },
                        // ),
                        // SizedBox(height: 20.h),
                        // In the LoginButton for "view_responses":
                        // In PlayersScreen.dart - REPLACE the LoginButton for "view_responses":

                        LoginButton(
                          onTap: () async {
                            print("🔍 Preparing to view responses...");

                            // ✅ Get current session ID
                            final sessionId = this.sessionId;
                            if (sessionId == null || sessionId == 0) {
                              Get.snackbar('Error', 'No session selected');
                              return;
                            }

                            // ✅ Get facilitator ID
                            final facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;
                            if (facilitatorId == 0) {
                              // Try from user profile
                              final profile = await SharedPrefServices.getUserProfile();
                              if (profile != null && profile['id'] != null) {
                                final id = profile['id'] is int
                                    ? profile['id']
                                    : int.tryParse(profile['id'].toString()) ?? 0;

                                if (id > 0) {
                                  await SharedPrefServices.saveFacilitatorId(id);
                                  print('💾 Saved facilitator ID from profile: $id');
                                } else {
                                  Get.snackbar('Error', 'Facilitator information not found');
                                  return;
                                }
                              } else {
                                Get.snackbar('Error', 'Facilitator information not found');
                                return;
                              }
                            }

                            // ✅ Get REAL current phase ID from Phase Controller
                            print('🔄 Getting real current phase ID...');

                            // Initialize phase controller if needed
                            final phaseController = Get.find<GameFormatPhaseController>();
                            if (phaseController.sessionId.value != sessionId) {
                              phaseController.setSessionId(sessionId);
                              await phaseController.fetchGameFormatPhases();
                            }

                            // Get the REAL current phase ID from API
                            final phaseId = await phaseController.getCurrentPhaseId();

                            if (phaseId == 0) {
                              print('⚠️ No active phase found');
                              Get.snackbar(
                                'No Active Phase',
                                'Please start or select a phase first',
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                              // Still navigate but with 0 - let the responses screen handle it
                            }

                            print("🎯 Navigating with REAL data:");
                            print("   - Session ID: $sessionId");
                            print("   - Facilitator ID: $facilitatorId");
                            print("   - Phase ID: $phaseId");

                            // ✅ Save before navigation
                            await SharedPrefServices.saveSessionAndPhaseInfo(
                              sessionId: sessionId,
                              phaseId: phaseId,
                              facilitatorId: facilitatorId,
                            );

                            Get.toNamed(
                              RouteName.viewResponsesScreen,
                              arguments: {
                                'sessionId': sessionId,
                                'facilitatorId': facilitatorId,
                                'phaseId': phaseId,
                              },
                            );
                          },
                          fontSize: 22.sp,
                          text: "view_responses".tr,
                          image: Appimages.eye,
                          color: AppColors.forwardColor,
                          ishow: true,
                        ),
                        SizedBox(height: 20.h),
                        // LoginButton(
                        //   fontSize: 22.sp,
                        //   text: "send_alert".tr,
                        //   image: Appimages.noti,
                        //   color: AppColors.redColor,
                        //   ishow: true,
                        //   onTap: () {
                        //     Get.snackbar(
                        //       'Info',
                        //       'Send alert feature coming soon',
                        //       snackPosition: SnackPosition.TOP,
                        //     );
                        //   },
                        // ),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Color _getTeamColor(int index) {
    final colors = [
      AppColors.forwardColor,
      AppColors.purpleColor,
      AppColors.orangeColor,
      AppColors.forwardColor2,
      AppColors.forwardColor3,
    ];
    return colors[index % colors.length];
  }

  String _getTeamImage(int index) {
    final images = [
      Appimages.play3,
      Appimages.player2,
      Appimages.prince2,
      Appimages.play4,
      Appimages.play5,
    ];
    return images[index % images.length];
  }
}