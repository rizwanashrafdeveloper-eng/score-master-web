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
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(ishow4: true),
              SizedBox(height: 56.h),

              /// Top fixed container
              GradientColor(
                height: 180.h,
                child: Container(
                  width: 794.w,
                  height: 235.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -140,
                        right: 312.w,
                        left: 312.w,
                        child: CustomStackImage(
                          image: Appimages.player2,
                          text: "Player",
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Team Name
                          Center(
                            child: BoldText(
                              text: teamName,
                              fontSize: 48.sp,
                              selectionColor: AppColors.blueColor,
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
                    width: 794.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.r),
                          bottomRight: Radius.circular(40.r)
                      ),
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 36.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // TEAM INFO SECTION
                              Obx(() {
                                if (teamController.isLoading.value) {
                                  return SizedBox(
                                    height: 370.h,
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
                                    height: 370.h,
                                    child: Center(
                                      child: Text(
                                        "No team data available",
                                        style: TextStyle(color: Colors.white70, fontSize: 20.sp),
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
                                          height: 370.h,
                                          width: 428.w,
                                          child: Image.asset(
                                            Appimages.group,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10.h,
                                          right: 15.w,
                                          child: CreateContainer(
                                            fontsize2: 12,
                                            text: "${teamData.gameFormat.id} Phases",
                                            top: -25.h,
                                            right: 2.w,
                                            width: 172.w,
                                            borderW: 2.w,
                                            arrowW: 30.w,
                                            arrowh: 35.h,
                                            height: 63.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    BoldText(
                                      text: "team_building_workshop".tr,
                                      fontSize: 30.sp,
                                      selectionColor: AppColors.blueColor,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Appimages.person,
                                          height: 25.h,
                                          width: 25.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        MainText(
                                          text: "Facilitator: $facilitatorName",
                                          fontSize: 20.sp,
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              }),

                              SizedBox(height: 30.h),

                              // SESSION CODE SECTION
                              Obx(() {
                                if (sessionsController.isLoading.value) {
                                  return SizedBox(
                                    height: 131.h,
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
                                    height: 131.h,
                                    child: Center(
                                      child: Text(
                                        "No session data available",
                                        style: TextStyle(color: Colors.white70, fontSize: 20.sp),
                                      ),
                                    ),
                                  );
                                }

                                return ABCDContainer(
                                  sessionCode: currentSession.joinCode ?? "N/A",
                                );
                              }),

                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.brownColor2,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  MainText(
                                    text: "waiting_facilitator_start".tr,
                                    fontSize: 20.sp,
                                  ),
                                ],
                              ),

                              SizedBox(height: 40.h),

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
                                      style: TextStyle(color: Colors.white70, fontSize: 20.sp),
                                    ),
                                  );
                                }

                                return Column(
                                  children: teamData.teams.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final team = entry.value;
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 15.h),
                                      child: PlayersContainers(
                                        color: AppColors.forwardColor,
                                        text3: "joined".tr,
                                        text1: (index + 1).toString(),
                                        text2: team.nickname,
                                        image: _getPlayerImage(index),
                                        delay: Duration(milliseconds: index * 200), // Staggered animation
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),

                              SizedBox(height: 50.h),
                              DeviceConnectNote(),
                              SizedBox(height: 30.h),
                              LoginButton(
                                onTap: () => Get.toNamed(RouteName.gameStart1Screen),
                                text: "leave_session".tr,
                                ishow: true,
                                image: Appimages.leave,
                                color: AppColors.redColor,
                              ),
                              SizedBox(height: 70.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/admin_folder.dart/abcd_container.dart';
// import 'package:scorer_web/components/facilitator_folder/active_Session_screen.dart';
// import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
// import 'package:scorer_web/components/facilitator_folder/schedule_Screen.dart';
// import 'package:scorer_web/components/player_folder/device_connect_note.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/controller/facil_dashboard_controller.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/add_one_Container.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/players_containers.dart';
// import 'package:scorer_web/widgets/setting_container.dart';
//
//
// class PlayerDashboardScreen2 extends StatelessWidget {
//
//
//   PlayerDashboardScreen2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Column(
//             children: [
//               CustomAppbar(ishow4: true),
//               SizedBox(height: 56.h),
//
//               /// Top fixed container
//               GradientColor(
//                 height: 180.h,
//                 child: Container(
//                   width: 794.w,
//                   height: 235.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40.r),
//                       topRight: Radius.circular(40.r),
//                     ),
//                     // color: AppColors.whiteColor,
//                   ),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Positioned(
//                         top: -140,
//                         right: 312.w,
//                         left: 312.w,
//                         child: CustomStackImage(
//                           image: Appimages.player2,
//                           text: "Player",
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Center(
//                             child: BoldText(
//                               text: "Team Alpha",
//                               fontSize: 48.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//
//                Expanded(
//               child: GradientColor(
//                 ishow: false,
//                 child: Container(
//                   width: 794.w,
//                   decoration: BoxDecoration(
//                     // color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40.r),
//                       bottomRight: Radius.circular(40.r)
//                     ),
//                   ),
//                   child: ScrollConfiguration(
//                       behavior: ScrollConfiguration.of(context).copyWith(
//                     scrollbars: false, // ✅ ye side wali scrollbar hatayega
//                   ),
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 36.w),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//
//                           Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             SizedBox(
//                                height: 370 .h,
//                                width: 428.w,
//                                 // width: 209 * widthScaleFactor,
//                               child: Image.asset(
//                                 Appimages.group,
//                                fit: BoxFit.contain,
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 10.h,
//                               right: 15 .w,
//                               child: CreateContainer(fontsize2: 12,
//                                 text: "5 Phases",
//                                 top: -25.h,
//                                 right: 2.w,
//                                 width: 172 .w,
//                                 borderW: 2.w,
//                                 arrowW: 30.w,
//                                 arrowh: 35.h,
//                                 height: 63 .h,
//                                  // Assuming a default height
//                                 // fontSize: 14 * widthScaleFactor,
//                               ),
//                             ),
//                           ],
//                         ),
//
//                             SizedBox(height: 20.h,),
//                         BoldText(
//                   text: "team_building_workshop".tr,
//                   fontSize: 30.sp,
//                   selectionColor: AppColors.blueColor,
//                 ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(
//                               Appimages.person,
//                               height: 25.h,
//                               width: 25.w,
//                             ),
//                             SizedBox(width: 8 .w),
//                             MainText(
//                               text: "Facilitator: Sarah Johnson",
//                               fontSize: 20.sp,
//                             )
//                           ],
//                         ),
//
//                         SizedBox(height: 30.h,),
//                         ABCDContainer(),
//                         SizedBox(height: 20.h,),
//                           Row(
//                           children: [
//                             Container(
//                               height: 20.h,
//                               width: 20.w,
//                               decoration: BoxDecoration(
//                                 color: AppColors.brownColor2,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//
//                             SizedBox(width: 10.w),
//                           MainText(
//                   text: "waiting_facilitator_start".tr,
//                   fontSize: 20.sp,
//                 ),
//                           ],
//                         ),
//
//                            SizedBox(height: 40 .h
//                            ),
//
//                         PlayersContainers(
//                           color: AppColors.forwardColor,
//                           text3: "joined".tr,
//                           text1: "1",
//                           text2: "You",
//                           image: Appimages.play1,
//                           // scaleFactor: widthScaleFactor,
//                         ),
//                         SizedBox(height: 15 .h),
//                         PlayersContainers(
//                           color: AppColors.forwardColor,
//                           text3: "joined".tr,
//                           text1: "2",
//                           text2: "Sarah J.",
//                           image: Appimages.play2,
//                           // scaleFactor: widthScaleFactor,
//                         ),
//                         // SizedBox(height: 15 * heightScaleFactor)
//                         SizedBox(height: 15 .h),
//                         // ,
//                         PlayersContainers(
//                           color: AppColors.forwardColor,
//                           text3:"joined".tr,
//                           text1: "3",
//                           text2: "Mike C.",
//                           image: Appimages.play3,
//                           // scaleFactor: widthScaleFactor,
//                         ),
//                         // SizedBox(height: 15 * heightScaleFactor),
//                         SizedBox(height: 15 .h),
//
//                         PlayersContainers(
//                           color: AppColors.forwardColor,
//                           text3: "joined".tr,
//                           text1: "4",
//                           text2: "David B.",
//                           image: Appimages.play4,
//                           // scaleFactor: widthScaleFactor,
//                         ),
//                         // SizedBox(height: 15 * heightScaleFactor),
//                         SizedBox(height: 15 .h),
//
//                         PlayersContainers(
//                           color: AppColors.forwardColor,
//                           text3: "joined".tr,
//                           text1: "5",
//                           text2: "Lisa G.",
//                           image: Appimages.play5,
//                           // scaleFactor: widthScaleFactor,
//                         ),
//                         SizedBox(height: 50.h,),
//                         DeviceConnectNote(),
//                         SizedBox(height: 30.h,),
//                              LoginButton(
//                           onTap: ()=>Get.toNamed(RouteName.gameStart1Screen),
//                           text:"leave_session".tr,
//                           ishow: true,
//                           image: Appimages.leave,
//                           color: AppColors.redColor,
//
//                         ),
//                         SizedBox(height: 70.h,)
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // SizedBox(height: 50.h,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
