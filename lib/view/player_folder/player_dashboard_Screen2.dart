import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/player_folder/device_connect_note.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/players_containers.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';

// Import your controllers (adjust path as needed)
import 'package:scorer_web/api/api_controllers/session_list_controller.dart';
import 'package:scorer_web/api/api_controllers/team_view_controller.dart';

import '../../components/admin_folder.dart/abcd_container.dart';

class PlayerDashboardScreen2 extends StatefulWidget {
  const PlayerDashboardScreen2({super.key});

  @override
  State<PlayerDashboardScreen2> createState() => _PlayerDashboardScreen2State();
}

class _PlayerDashboardScreen2State extends State<PlayerDashboardScreen2> {
  final TeamViewController teamController = Get.put(TeamViewController());
  final SessionsListController sessionsController = Get.put(SessionsListController());

  bool _snackbarShown = false;
  String teamName = "Team Alpha"; // Default team name

  @override
  void initState() {
    super.initState();

    // Fetch APIs only once when screen opens
    Future.delayed(Duration.zero, () async {
      await teamController.loadTeams();
      await sessionsController.fetchSessions();

      // Update team name after loading data
      _updateTeamName();
    });
  }

  void _updateTeamName() {
    final teamData = teamController.teamView.value;
    if (teamData != null && teamData.teams.isNotEmpty) {
      // Use the first team's nickname as team name
      setState(() {
        teamName = teamData.teams.first.nickname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 768;
    final bool isMediumScreen = screenWidth >= 768 && screenWidth < 1200;
    final bool isLargeScreen = screenWidth >= 1200;

    // Responsive calculations
    double mainContainerWidth = screenWidth * 0.85;
    if (isSmallScreen) {
      mainContainerWidth = screenWidth * 0.95;
    } else if (isMediumScreen) {
      mainContainerWidth = screenWidth * 0.9;
    }

    double topContainerHeight = screenHeight * 0.22;
    if (screenHeight < 700) {
      topContainerHeight = screenHeight * 0.25;
    }

    double stackImageTop = isSmallScreen ? -100 : -140;
    double stackImageHorizontal = isSmallScreen ? 50 : 312;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  CustomAppbar(ishow4: true),
                  SizedBox(height: isSmallScreen ? 20.h : 56.h),

                  /// Top fixed container
                  GradientColor(
                    height: topContainerHeight,
                    child: Container(
                      width: mainContainerWidth,
                      height: topContainerHeight,
                      constraints: BoxConstraints(
                        maxWidth: 794,
                        minWidth: 300,
                        maxHeight: 235,
                        minHeight: 180,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSmallScreen ? 20.r : 40.r),
                          topRight: Radius.circular(isSmallScreen ? 20.r : 40.r),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: stackImageTop,
                            right: isSmallScreen ? constraints.maxWidth * 0.3 : stackImageHorizontal,
                            left: isSmallScreen ? constraints.maxWidth * 0.3 : stackImageHorizontal,
                            child: CustomStackImage(
                              image: Appimages.player2,
                              text: "Player",
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Team Name
                              Center(
                                child: BoldText(
                                  text: teamName,
                                  fontSize: isSmallScreen ? 32.sp :
                                  isMediumScreen ? 40.sp : 48.sp,
                                  selectionColor: AppColors.blueColor,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: GradientColor(
                      ishow: false,
                      child: Container(
                        width: mainContainerWidth,
                        constraints: BoxConstraints(
                          maxWidth: 794,
                          minWidth: 300,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(isSmallScreen ? 20.r : 40.r),
                            bottomRight: Radius.circular(isSmallScreen ? 20.r : 40.r),
                          ),
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 10.w : 20.w,
                              vertical: isSmallScreen ? 5.h : 10.h,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 16.w : 36.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // TEAM INFO SECTION
                                  Obx(() {
                                    if (teamController.isLoading.value) {
                                      return SizedBox(
                                        height: isSmallScreen ? 280.h : 370.h,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    final teamData = teamController.teamView.value;
                                    if (teamData == null) {
                                      if (!_snackbarShown) {
                                        _snackbarShown = true;
                                        Get.snackbar(
                                          "No Team Data",
                                          "Unable to load team information",
                                          backgroundColor: Colors.redAccent,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: const Duration(seconds: 2),
                                        );
                                      }
                                      return SizedBox(
                                        height: isSmallScreen ? 280.h : 370.h,
                                        child: Center(
                                          child: Text(
                                            "No team data available",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: isSmallScreen ? 16.sp : 20.sp,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    final facilitatorName = teamData.gameFormat.facilitators.isNotEmpty
                                        ? _formatName(teamData.gameFormat.facilitators[0].name)
                                        : "N/A";

                                    return Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            SizedBox(
                                              height: isSmallScreen ? 250.h : 370.h,
                                              width: isSmallScreen ? 300.w : 428.w,
                                              child: Image.asset(
                                                Appimages.group,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 10.h,
                                              right: 15.w,
                                              child: CreateContainer(
                                                fontsize2: isSmallScreen ? 10 : 12,
                                                text: " Phases",
                                                //${teamData.gameFormat.id}
                                                top: isSmallScreen ? -15.h : -25.h,
                                                right: 2.w,
                                                width: isSmallScreen ? 140.w : 172.w,
                                                borderW: isSmallScreen ? 1.w : 2.w,
                                                arrowW: isSmallScreen ? 20.w : 30.w,
                                                arrowh: isSmallScreen ? 25.h : 35.h,
                                                height: isSmallScreen ? 50.h : 63.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isSmallScreen ? 10.h : 20.h),
                                        BoldText(
                                          text: "team_building_workshop".tr,
                                          fontSize: isSmallScreen ? 22.sp :
                                          isMediumScreen ? 26.sp : 30.sp,
                                          selectionColor: AppColors.blueColor,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              Appimages.person,
                                              height: isSmallScreen ? 18.h : 25.h,
                                              width: isSmallScreen ? 18.w : 25.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: MainText(
                                                text: "Facilitator: $facilitatorName",
                                                fontSize: isSmallScreen ? 14.sp :
                                                isMediumScreen ? 18.sp : 20.sp,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),

                                  SizedBox(height: isSmallScreen ? 15.h : 30.h),

                                  // SESSION CODE SECTION
                                  Obx(() {
                                    if (sessionsController.isLoading.value) {
                                      return SizedBox(
                                        height: isSmallScreen ? 100.h : 131.h,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    final currentSession = sessionsController.activeSessions.isNotEmpty
                                        ? sessionsController.activeSessions.first
                                        : sessionsController.scheduledSessions.isNotEmpty
                                        ? sessionsController.scheduledSessions.first
                                        : null;

                                    if (currentSession == null) {
                                      return SizedBox(
                                        height: isSmallScreen ? 100.h : 131.h,
                                        child: Center(
                                          child: Text(
                                            "No session data available",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: isSmallScreen ? 14.sp : 20.sp,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return ABCDContainer(
                                      sessionCode: currentSession.joinCode ?? "N/A",
                                      isSmallScreen: isSmallScreen,
                                    );
                                  }),

                                  SizedBox(height: isSmallScreen ? 15.h : 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: isSmallScreen ? 15.h : 20.h,
                                        width: isSmallScreen ? 15.w : 20.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.brownColor2,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Flexible(
                                        child: MainText(
                                          text: "waiting_facilitator_start".tr,
                                          fontSize: isSmallScreen ? 14.sp :
                                          isMediumScreen ? 18.sp : 20.sp,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: isSmallScreen ? 20.h : 40.h),

                                  // PLAYERS LIST SECTION
                                  Obx(() {
                                    if (teamController.isLoading.value) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final teamData = teamController.teamView.value;
                                    if (teamData == null || teamData.teams.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No players joined yet",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: isSmallScreen ? 14.sp : 20.sp,
                                          ),
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: teamData.teams.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final team = entry.value;
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: isSmallScreen ? 10.h : 15.h),
                                          child: PlayersContainers(
                                            color: AppColors.forwardColor,
                                            text3: "joined".tr,
                                            text1: (index + 1).toString(),
                                            text2: team.nickname,
                                            image: _getPlayerImage(index),
                                            delay: Duration(milliseconds: index * 200),
                                            isSmallScreen: isSmallScreen,
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }),

                                  SizedBox(height: isSmallScreen ? 20.h : 50.h),
                                  DeviceConnectNote(isSmallScreen: isSmallScreen),
                                  SizedBox(height: isSmallScreen ? 15.h : 30.h),
                                  LoginButton(
                                    onTap: () => Get.toNamed(RouteName.gameStart1Screen),
                                    text: "leave_session".tr,
                                    ishow: true,
                                    image: Appimages.leave,
                                    color: AppColors.redColor,
                                   // isSmallScreen: isSmallScreen,
                                  ),
                                  SizedBox(height: isSmallScreen ? 30.h : 70.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to format name with proper capitalization
  String _formatName(String name) {
    return name.split(" ")
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : "")
        .join(" ");
  }

  // Helper method to get player images
  String _getPlayerImage(int index) {
    final images = [
      Appimages.play1,
      Appimages.play2,
      Appimages.play3,
      Appimages.play4,
      Appimages.play5,
    ];
    return index < images.length ? images[index] : Appimages.play1;
  }
}

