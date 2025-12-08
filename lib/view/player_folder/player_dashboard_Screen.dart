import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/main_text.dart';

// Import your controllers
import '../../api/api_controllers/join_session_controller.dart';

import '../../api/api_controllers/login_controller_web.dart';
import '../../api/api_controllers/session_list_controller.dart';
import '../../widgets/player_side/join_session_widget.dart';


class PlayerDashboardScreen extends StatefulWidget {
  const PlayerDashboardScreen({super.key});

  @override
  State<PlayerDashboardScreen> createState() => _PlayerDashboardScreenState();
}

class _PlayerDashboardScreenState extends State<PlayerDashboardScreen> {
  final JoinSessionController joinController = Get.put(JoinSessionController());
  final SessionsListController sessionsController = Get.put(SessionsListController());

  // ✅ FIX: Get LoginController safely
  LoginControllerWeb get authController => Get.find<LoginControllerWeb>();

  @override
  void initState() {
    super.initState();
    // Ensure sessions are loaded
    if (sessionsController.scheduledSessions.isEmpty &&
        sessionsController.activeSessions.isEmpty) {
      sessionsController.fetchSessions();
    }
  }

  String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
    )
        .join(' ');
  }

  // ✅ FIX: Safe method to get player ID
  int get playerId {
    final user = authController.user.value;
    if (user == null) {
      print("❌ [PlayerDashboard] User is null in authController");
      // Try to get from shared preferences as fallback
      return 0; // This will cause the join to fail, but we need to handle it
    }
    print("✅ [PlayerDashboard] Player ID: ${user.id}");
    return user.id;
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
                height: 200.h,
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
                          Center(
                            child: BoldText(
                              text: "Welcome to Score'master+!",
                              fontSize: 48.sp,
                              selectionColor: AppColors.blueColor,
                            ),
                          ),
                          MainText(
                            text: "You're all set to join a session. Enter your session\ncode or wait for your facilitator to start the game.",
                            fontSize: 22.sp,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// Expanded scrollable part
              Expanded(
                child: GradientColor(
                  ishow: false,
                  child: Container(
                    width: 794.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: sessionsController.refreshSessions,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 30.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 30.h),

                              // Join Session Widget
                              Obx(() {
                                // ✅ FIX: Check if user is loaded
                                if (authController.user.value == null) {
                                  return Column(
                                    children: [
                                      Text(
                                        "Loading user data...",
                                        style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                                      ),
                                      SizedBox(height: 20.h),
                                      CircularProgressIndicator(),
                                    ],
                                  );
                                }
                                return JoinSessionWidget(
                                  playerId: playerId, // ✅ Now this should work
                                );
                              }),

                              SizedBox(height: 40.h),

                              // Sessions data (reactive part)
                              Obx(() {
                                if (sessionsController.isLoading.value) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(80.h),
                                      child: CircularProgressIndicator(
                                        color: AppColors.forwardColor,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  );
                                }

                                final activeSessions = sessionsController.activeSessions;
                                final scheduledSessions = sessionsController.scheduledSessions;

                                if (activeSessions.isEmpty && scheduledSessions.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 80.h),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.event_busy,
                                            size: 80.sp,
                                            color: AppColors.greyColor,
                                          ),
                                          SizedBox(height: 20.h),
                                          MainText(
                                            text: "No sessions available",
                                            fontSize: 28.sp,
                                          ),
                                          SizedBox(height: 10.h),
                                          MainText(
                                            text: "Wait for your facilitator to schedule a session",
                                            fontSize: 20.sp,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (activeSessions.isNotEmpty) ...[
                                      BoldText(
                                        text: "Active Sessions",
                                        fontSize: 32.sp,
                                        selectionColor: AppColors.blueColor,
                                      ),
                                      SizedBox(height: 20.h),
                                      ...activeSessions.map((session) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 25.h),
                                          child: CustomDashboardContainer(
                                            onTap: () {
                                              // ✅ FIX: Check player ID before joining
                                              if (playerId == 0) {
                                                Get.snackbar(
                                                  "Error",
                                                  "Unable to get player information. Please try logging in again.",
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                                return;
                                              }
                                              joinController.joinSession(
                                                playerId,
                                                session.joinCode,
                                              );
                                            },
                                            arrowshow: false,
                                            horizontal: 0,
                                            width2: 150.w,
                                            color2: AppColors.forwardColor,
                                            heading: capitalizeEachWord(session.teamTitle),
                                            text1: "Phase ${session.totalPhases}",
                                            ishow: false,
                                            text2: "Active",
                                            color1: AppColors.orangeColor,
                                            description: session.description,
                                            text7: "Join Session",
                                            icon3: Icons.play_arrow,
                                            color3: AppColors.forwardColor,
                                            text5: "${session.totalPlayers} Players",
                                            text6: (session.remainingTime != null && session.remainingTime! > 0)
                                                ? "${session.remainingTime} min left"
                                                : "In Progress",
                                            smallImage: Appimages.timeout2,
                                          ),
                                        );
                                      }),
                                    ],

                                    if (scheduledSessions.isNotEmpty) ...[
                                      SizedBox(height: 30.h),
                                      BoldText(
                                        text: "Scheduled Sessions",
                                        fontSize: 32.sp,
                                        selectionColor: AppColors.blueColor,
                                      ),
                                      SizedBox(height: 20.h),
                                      ...scheduledSessions.map((session) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 25.h),
                                          child: CustomDashboardContainer(
                                            onTap: () {
                                              Get.snackbar(
                                                "Not Started",
                                                "This session has not started yet.",
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.redAccent,
                                                colorText: Colors.white,
                                                duration: const Duration(seconds: 2),
                                              );
                                            },
                                            arrowshow: false,
                                            horizontal: 0,
                                            width2: 150.w,
                                            color2: AppColors.scheColor,
                                            heading: capitalizeEachWord(session.teamTitle),
                                            text1: "Phase ${session.totalPhases}",
                                            ishow: false,
                                            text2: "Scheduled",
                                            color1: AppColors.orangeColor,
                                            description: session.description,
                                            text7: "Join Session",
                                            icon3: Icons.schedule,
                                            color3: AppColors.scheColor,
                                            text5: "${session.totalPlayers} Players",
                                            text6: session.startTime != null
                                                ? "Starts at ${DateFormat('hh:mm a').format(session.startTime!)}"
                                                : "Starts Soon",
                                            smallImage: Appimages.timeout2,
                                          ),
                                        );
                                      }),
                                    ],
                                  ],
                                );
                              }),

                              SizedBox(height: 50.h),
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
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/facilitator_folder/active_Session_screen.dart';
// import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
// import 'package:scorer_web/components/facilitator_folder/schedule_Screen.dart';
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
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/setting_container.dart';
//
// class PlayerDashboardScreen extends StatelessWidget {
//   final FacilDashboardController controller =
//       Get.put(FacilDashboardController());
//
//   PlayerDashboardScreen({super.key});
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
//                 height: 200.h,
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
//                               text: "Welcome to Score’Master+!",
//                               fontSize: 48.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                           ),
//                           MainText(
//                             text:
//                                 "You’re all set to join a session. Enter your session\ncode or wait for your facilitator to start the game.",
//                             fontSize: 22.sp,
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Expanded scrollable part
//               Expanded(
//                 child: GradientColor(
//                   ishow: false,
//                   child: SingleChildScrollView(
//                     child: Container(
//                       width: 794.w,
//                                      decoration: BoxDecoration(
//                     // color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40.r),
//                       bottomRight: Radius.circular(40.r)
//                     ),
//                                     ),
//                       child: Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(height: 48.h),
//
//                             Container(
//                               height: 100.h,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(26.r),
//                                 border: Border.all(
//                                   color: AppColors.greyColor,
//                                   width: 1.5.w,
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     top: -20.h,
//                                     right: 20,
//                                     child: CreateContainer(
//                                       arrowW: 35.w,
//                                       arrowh: 40.h,
//                                       top: -40.h,
//                                       text: "join_with_code".tr,
//                                       width: 387.w,height: 64.h,
//                                       borderW: 2.9.w,
//                                     ),
//                                   ),
//                                   Center(
//                                     child: BoldText(
//                                       text: "enter_code".tr,
//                                       fontSize: 42.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                     SizedBox(height: 40.h,),
//                              CustomDashboardContainer(
//                         onTap: ()=>Get.toNamed(RouteName.playerLoginPlaySide),
//
//                     arrowshow: false,
//                     horizontal: 0,
//
//                               // width2: 78,
//                               color2: AppColors.scheColor,
//                               heading: "Eranove Odyssey – Team A",
//                               text1: "Phase 2",
//                               ishow: false,
//                               text2: "Scheduled",
//                               description: "Leadership Assessment strengthens teamwork through interactive activities.",
//
//
//                               text3: "paused".tr,
//                               text7:"join_session".tr,
//                               icon3: Icons.fast_forward,
//                               color3: AppColors.forwardColor,
//                               text5: "12 Players",
//                               text6: "Starts in 2h",
//                             ),
//                             SizedBox(height: 12 .h),
//                              CustomDashboardContainer(
//                         onTap: ()=>Get.toNamed(RouteName.playerLoginPlaySide),
//
//                     arrowshow: false,
//                     horizontal: 0,
//
//                               // width2: 78,
//                               color2: AppColors.scheColor,
//                               heading: "Eranove Odyssey – Team A",
//                               text1: "Phase 2",
//                               ishow: false,
//                               text2: "scheduled".tr,
//                               description: "Leadership Assessment strengthens teamwork through interactive activities.",
//
//
//                               text3: "Pause",
//                              text7: "join_session".tr,
//                               icon3: Icons.fast_forward,
//                               color3: AppColors.forwardColor,
//                               text5: "12 Players",
//                               text6: "Starts in 2h",
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
