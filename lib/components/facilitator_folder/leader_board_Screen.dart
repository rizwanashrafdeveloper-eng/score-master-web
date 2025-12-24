import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/metrices_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../../../api/api_controllers/player_leadrboard_controller.dart';
import '../../../api/api_controllers/team_leaderboard_controller.dart';
import '../../../api/api_controllers/session_controller.dart';
import '../../../api/api_controllers/end_session_controller.dart';

class LeaderBoardScreen extends StatefulWidget {
  final int? sessionId;
  final VoidCallback? onOpenDrawer;

  const LeaderBoardScreen({super.key, this.sessionId, this.onOpenDrawer});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  final RxBool isTeamSelected = false.obs;
  final playerController = Get.put(PlayerLeaderboardController());
  final teamController = Get.put(TeamLeaderboardController());
  final sessionController = Get.put(SessionController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLeaderboardData();
    });
  }

  void _loadLeaderboardData() {
    final sessionId = widget.sessionId ?? sessionController.sessionId.value;

    if (sessionId > 0) {
      print("🔄 Loading leaderboard for session: $sessionId");
      print("📊 Mode: ${isTeamSelected.value ? 'Team' : 'Player'}");

      if (isTeamSelected.value) {
        teamController.loadLeaderboard(sessionId);
      } else {
        playerController.loadLeaderboard(sessionId);
      }
    } else {
      print("⚠️ No valid session ID found");
    }
  }

  Widget _buildTopItem(dynamic item, int position, bool isTeam) {
    final double containerSize = position == 1 ? 150.w : 120.w;
    final double avatarSize = position == 1 ? 80.w : 60.w;
    final double nameFontSize = position == 1 ? 24.sp : 20.sp;
    final double scoreFontSize = position == 1 ? 28.sp : 22.sp;

    Color medalColor;
    switch (position) {
      case 1:
        medalColor = AppColors.yellowColor;
        break;
      case 2:
        medalColor = AppColors.greyColor;
        break;
      case 3:
        medalColor = AppColors.orangeColor;
        break;
      default:
        medalColor = AppColors.greyColor;
    }

    // ✅ FIXED: Use correct property names based on model
    final name = isTeam
        ? (item.teamName ?? item.sessionDescription ?? "Session ${item.sessionId ?? ''}")
        : (item.playerName ?? "Player");
    final score = isTeam
        ? (item.totalPoints ?? item.score ?? 0)
        : (item.totalPoints ?? item.score ?? 0);
    final rank = item.rank ?? position;

    return Column(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: medalColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: medalColor,
              width: position == 1 ? 4.w : 2.w,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundColor: AppColors.forwardColor.withOpacity(0.2),
                    child: Icon(
                      isTeam ? Icons.groups : Icons.person,
                      size: avatarSize * 0.6,
                      color: AppColors.forwardColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  BoldText(
                    text: "$score pts",
                    fontSize: scoreFontSize,
                    selectionColor: AppColors.forwardColor,
                  ),
                ],
              ),
              Positioned(
                top: 5.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: medalColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "#$rank",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: position == 1 ? 0.h : 30.h),
      ],
    );
  }

  Widget _buildLeaderboardItem(dynamic item, bool isTeam) {
    Color containerColor = AppColors.playerColor;
    final rank = item.rank ?? 0;

    if (rank == 1) containerColor = AppColors.yellowColor;
    if (rank == 2) containerColor = AppColors.greyColor;
    if (rank == 3) containerColor = AppColors.orangeColor;

    // ✅ FIXED: Use correct property names
    final name = isTeam
        ? (item.teamName ?? item.sessionDescription ?? "Session ${item.sessionId ?? ''}")
        : (item.playerName ?? "Player");
    final score = isTeam
        ? (item.totalPoints ?? item.score ?? 0)
        : (item.totalPoints ?? item.score ?? 0);
    final subtitle = isTeam
        ? "Session ${item.sessionId ?? ''}"
        : (item.playerEmail ?? "No Email");

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: containerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: containerColor.withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: containerColor,
            ),
            child: Center(
              child: BoldText(
                text: "#${rank}",
                fontSize: 20.sp,
                selectionColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.w),
          CircleAvatar(
            radius: 25.w,
            backgroundColor: AppColors.forwardColor.withOpacity(0.2),
            child: Icon(
              isTeam ? Icons.groups : Icons.person,
              size: 25.w,
              color: AppColors.forwardColor,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),
                MainText(
                  text: subtitle,
                  fontSize: 18.sp,
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ),
          BoldText(
            text: "$score pts",
            fontSize: 24.sp,
            selectionColor: AppColors.forwardColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if session is scheduled
    final isScheduled = sessionController.session.value?.status?.toUpperCase() == 'SCHEDULED';

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),

                // Live indicator and Overall tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 25.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isScheduled ? AppColors.orangeColor : AppColors.visitingColor,
                          ),
                        ),
                        SizedBox(width: 18.w),
                        MainText(
                          text: isScheduled ? "Scheduled" : "live_updates".tr,
                          color: isScheduled ? AppColors.orangeColor : AppColors.visitingColor,
                          fontSize: 31.sp,
                        ),
                      ],
                    ),
                    CreateContainer(
                      containerColor: AppColors.forwardColor.withOpacity(0.3),
                      text: "overall".tr,
                      textColor: AppColors.forwardColor,
                      borderColor: AppColors.forwardColor,
                      width: 150.w,
                      height: 70.h,
                      borderW: 1.97.w,
                      fontsize2: 31.sp,
                      ishow: false,
                    ),
                  ],
                ),
                SizedBox(height: 70.h),

                // Switch between Players/Teams
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Row(
                      children: [
                        BoldText(
                          text: "players".tr,
                          selectionColor: isTeamSelected.value
                              ? AppColors.playerColo1r
                              : AppColors.blueColor,
                          fontSize: 31.sp,
                        ),
                        SizedBox(width: 18.w),
                        FlutterSwitch(
                          value: isTeamSelected.value,
                          onToggle: (val) {
                            isTeamSelected.value = val;
                            _loadLeaderboardData();
                          },
                          height: 52.h,
                          width: 75.w,
                          activeColor: AppColors.forwardColor,
                          inactiveColor: Colors.grey[300]!,
                        ),
                        SizedBox(width: 18.w),
                        BoldText(
                          text: "teams".tr,
                          selectionColor: isTeamSelected.value
                              ? AppColors.blueColor
                              : AppColors.playerColo1r,
                          fontSize: 31.sp,
                        ),
                      ],
                    )),
                    if (widget.onOpenDrawer != null)
                      GestureDetector(
                        onTap: widget.onOpenDrawer,
                        child: CreateContainer(
                          text: "use_filter".tr,
                          width: 173.w,
                          height: 61.h,
                          arrowh: 40.h,
                          arrowW: 34.w,
                          borderW: 1.97.w,
                          top: -33.h,
                          right: 10.w,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 120.h),

                // Leaderboard Content
                Obx(() {
                  final isLoading = isTeamSelected.value
                      ? teamController.isLoading.value
                      : playerController.isLoading.value;

                  if (isLoading) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.h),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final top3 = isTeamSelected.value
                      ? teamController.top3
                      : playerController.top3;
                  final remaining = isTeamSelected.value
                      ? teamController.remaining
                      : playerController.remaining;

                  final hasData = top3.isNotEmpty || remaining.isNotEmpty;

                  if (!hasData) {
                    return Column(
                      children: [
                        Image.asset(
                          Appimages.player2,
                          width: 200.w,
                          height: 200.h,
                        ),
                        SizedBox(height: 30.h),
                        BoldText(
                          text: "No data available",
                          fontSize: 28.sp,
                          selectionColor: AppColors.blueColor,
                        ),
                        SizedBox(height: 10.h),
                        MainText(
                          text: isTeamSelected.value
                              ? "Team scores will appear here once teams join"
                              : "Player scores will appear here once players join",
                          fontSize: 22.sp,
                          color: AppColors.greyColor,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        MainText(
                          text: "Session ID: ${widget.sessionId ?? sessionController.sessionId.value}",
                          fontSize: 18.sp,
                          color: AppColors.greyColor,
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      // Top 3 Section
                      SizedBox(
                        height: 220.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (top3.length > 1)
                              _buildTopItem(top3[1], 2, isTeamSelected.value),
                            SizedBox(width: 20.w),
                            if (top3.isNotEmpty)
                              _buildTopItem(top3[0], 1, isTeamSelected.value),
                            SizedBox(width: 20.w),
                            if (top3.length > 2)
                              _buildTopItem(top3[2], 3, isTeamSelected.value),
                            if (top3.isEmpty && remaining.isNotEmpty) ...[
                              SizedBox(width: 20.w),
                              Text(
                                "No top 3 rankings yet",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 37.h),

                      // Full list (including top 3 if needed)
                      ...top3.map((item) =>
                          _buildLeaderboardItem(item, isTeamSelected.value)
                      ).toList(),

                      ...remaining.map((item) =>
                          _buildLeaderboardItem(item, isTeamSelected.value)
                      ).toList(),
                    ],
                  );
                }),

                SizedBox(height: 40.h),
                //MetricesContainer(),
                SizedBox(height: 40.h),

                // End Session Button (only if not scheduled)
                if (!isScheduled)
                  Center(
                    child: LoginButton(
                      onTap: () {
                        final EndSessionController endController =
                        Get.put(EndSessionController());
                        Get.defaultDialog(
                          title: "End Session",
                          content: Column(
                            children: [
                              Icon(Icons.warning, size: 60.sp, color: Colors.orange),
                              SizedBox(height: 20.h),
                              MainText(
                                text: "Are you sure you want to end this session?",
                                fontSize: 22.sp,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text("Cancel", style: TextStyle(fontSize: 18.sp)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Get.back();
                                await endController.completeSession();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                              ),
                              child: Text("End Session", style: TextStyle(fontSize: 18.sp)),
                            ),
                          ],
                        );
                      },
                      fontSize: 22.sp,
                      text: "end_session".tr,
                      color: AppColors.redColor,
                      ishow: true,
                      icon: Icons.logout,
                    ),
                  ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/facilitator_folder/metrices_container.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import '../../../api/api_controllers/player_leadrboard_controller.dart';
// import '../../../api/api_controllers/team_leaderboard_controller.dart';
// import '../../../api/api_controllers/session_controller.dart';
// import '../../../api/api_controllers/end_session_controller.dart';
//
// class LeaderBoardScreen extends StatefulWidget {
//   final int? sessionId;
//   final VoidCallback? onOpenDrawer;
//
//   const LeaderBoardScreen({super.key, this.sessionId, this.onOpenDrawer});
//
//   @override
//   State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
// }
//
// class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
//   final RxBool isTeamSelected = false.obs;
//   final playerController = Get.put(PlayerLeaderboardController());
//   final teamController = Get.put(TeamLeaderboardController());
//   final sessionController = Get.put(SessionController());
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadLeaderboardData();
//     });
//   }
//
//   void _loadLeaderboardData() {
//     final sessionId = widget.sessionId ?? sessionController.sessionId.value;
//
//     if (sessionId > 0) {
//       if (isTeamSelected.value) {
//         teamController.loadLeaderboard(sessionId);
//       } else {
//         playerController.loadLeaderboard(sessionId);
//       }
//     }
//   }
//
//   Widget _buildTopItem(dynamic item, int position, bool isTeam) {
//     final double containerSize = position == 1 ? 150.w : 120.w;
//     final double avatarSize = position == 1 ? 80.w : 60.w;
//     final double nameFontSize = position == 1 ? 24.sp : 20.sp;
//     final double scoreFontSize = position == 1 ? 28.sp : 22.sp;
//
//     Color medalColor;
//     switch (position) {
//       case 1:
//         medalColor = AppColors.yellowColor;
//         break;
//       case 2:
//         medalColor = AppColors.greyColor;
//         break;
//       case 3:
//         medalColor = AppColors.orangeColor;
//         break;
//       default:
//         medalColor = AppColors.greyColor;
//     }
//
//     final name = isTeam
//         ? (item.teamName ?? "Team")
//         : (item.playerName ?? "Player");
//     final score = item.score ?? 0;
//     final rank = item.rank ?? position;
//
//     return Column(
//       children: [
//         Container(
//           width: containerSize,
//           height: containerSize,
//           decoration: BoxDecoration(
//             color: medalColor.withOpacity(0.1),
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: medalColor,
//               width: position == 1 ? 4.w : 2.w,
//             ),
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: avatarSize / 2,
//                     backgroundColor: AppColors.forwardColor.withOpacity(0.2),
//                     child: Icon(
//                       isTeam ? Icons.groups : Icons.person,
//                       size: avatarSize * 0.6,
//                       color: AppColors.forwardColor,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   BoldText(
//                     text: name,
//                     fontSize: nameFontSize,
//                     selectionColor: AppColors.blueColor,
//                   ),
//                   SizedBox(height: 5.h),
//                   BoldText(
//                     text: "$score pts",
//                     fontSize: scoreFontSize,
//                     selectionColor: AppColors.forwardColor,
//                   ),
//                 ],
//               ),
//               Positioned(
//                 top: 5.h,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                   decoration: BoxDecoration(
//                     color: medalColor,
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: Text(
//                     "#$rank",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: position == 1 ? 0.h : 30.h),
//       ],
//     );
//   }
//
//   Widget _buildLeaderboardItem(dynamic item, bool isTeam) {
//     Color containerColor = AppColors.playerColor;
//     final rank = item.rank ?? 0;
//
//     if (rank == 1) containerColor = AppColors.yellowColor;
//     if (rank == 2) containerColor = AppColors.greyColor;
//     if (rank == 3) containerColor = AppColors.orangeColor;
//
//     final name = isTeam
//         ? (item.teamName ?? "Team")
//         : (item.playerName ?? "Player");
//     final score = item.score ?? 0;
//     final subtitle = isTeam
//         ? "${item.playerCount ?? 0} players"
//         : (item.teamName ?? "No Team");
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 15.h),
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: containerColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(
//           color: containerColor.withOpacity(0.3),
//           width: 1.w,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50.w,
//             height: 50.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: containerColor,
//             ),
//             child: Center(
//               child: BoldText(
//                 text: "#$rank",
//                 fontSize: 20.sp,
//                 selectionColor: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(width: 20.w),
//           CircleAvatar(
//             radius: 25.w,
//             backgroundColor: AppColors.forwardColor.withOpacity(0.2),
//             child: Icon(
//               isTeam ? Icons.groups : Icons.person,
//               size: 25.w,
//               color: AppColors.forwardColor,
//             ),
//           ),
//           SizedBox(width: 15.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BoldText(
//                   text: name,
//                   fontSize: 22.sp,
//                   selectionColor: AppColors.blueColor,
//                 ),
//                 MainText(
//                   text: subtitle,
//                   fontSize: 18.sp,
//                   color: AppColors.greyColor,
//                 ),
//               ],
//             ),
//           ),
//           BoldText(
//             text: "$score pts",
//             fontSize: 24.sp,
//             selectionColor: AppColors.forwardColor,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Check if session is scheduled
//     final isScheduled = sessionController.session.value?.status?.toUpperCase() == 'SCHEDULED';
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 60.w),
//             child: Column(
//               children: [
//                 SizedBox(height: 50.h),
//
//                 // Live indicator and Overall tag
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 25.w,
//                           height: 25.h,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: isScheduled ? AppColors.orangeColor : AppColors.visitingColor,
//                           ),
//                         ),
//                         SizedBox(width: 18.w),
//                         MainText(
//                           text: isScheduled ? "Scheduled" : "live_updates".tr,
//                           color: isScheduled ? AppColors.orangeColor : AppColors.visitingColor,
//                           fontSize: 31.sp,
//                         ),
//                       ],
//                     ),
//                     CreateContainer(
//                       containerColor: AppColors.forwardColor.withOpacity(0.3),
//                       text: "overall".tr,
//                       textColor: AppColors.forwardColor,
//                       borderColor: AppColors.forwardColor,
//                       width: 150.w,
//                       height: 70.h,
//                       borderW: 1.97.w,
//                       fontsize2: 31.sp,
//                       ishow: false,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 70.h),
//
//                 // Switch between Players/Teams
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Obx(() => Row(
//                       children: [
//                         BoldText(
//                           text: "players".tr,
//                           selectionColor: isTeamSelected.value
//                               ? AppColors.playerColo1r
//                               : AppColors.blueColor,
//                           fontSize: 31.sp,
//                         ),
//                         SizedBox(width: 18.w),
//                         FlutterSwitch(
//                           value: isTeamSelected.value,
//                           onToggle: (val) {
//                             isTeamSelected.value = val;
//                             _loadLeaderboardData();
//                           },
//                           height: 52.h,
//                           width: 75.w,
//                           activeColor: AppColors.forwardColor,
//                           inactiveColor: Colors.grey[300]!,
//                         ),
//                         SizedBox(width: 18.w),
//                         BoldText(
//                           text: "teams".tr,
//                           selectionColor: isTeamSelected.value
//                               ? AppColors.blueColor
//                               : AppColors.playerColo1r,
//                           fontSize: 31.sp,
//                         ),
//                       ],
//                     )),
//                     if (widget.onOpenDrawer != null)
//                       GestureDetector(
//                         onTap: widget.onOpenDrawer,
//                         child: CreateContainer(
//                           text: "use_filter".tr,
//                           width: 173.w,
//                           height: 61.h,
//                           arrowh: 40.h,
//                           arrowW: 34.w,
//                           borderW: 1.97.w,
//                           top: -33.h,
//                           right: 10.w,
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 120.h),
//
//                 // Leaderboard Content
//                 Obx(() {
//                   final isLoading = isTeamSelected.value
//                       ? teamController.isLoading.value
//                       : playerController.isLoading.value;
//
//                   if (isLoading) {
//                     return Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(40.h),
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   }
//
//                   final top3 = isTeamSelected.value
//                       ? teamController.top3
//                       : playerController.top3;
//                   final remaining = isTeamSelected.value
//                       ? teamController.remaining
//                       : playerController.remaining;
//
//                   if (top3.isEmpty && remaining.isEmpty) {
//                     return Column(
//                       children: [
//                         Image.asset(
//                           Appimages.player2,
//                           width: 200.w,
//                           height: 200.h,
//                         ),
//                         SizedBox(height: 30.h),
//                         BoldText(
//                           text: "No data available",
//                           fontSize: 28.sp,
//                           selectionColor: AppColors.blueColor,
//                         ),
//                         SizedBox(height: 10.h),
//                         MainText(
//                           text: isTeamSelected.value
//                               ? "Team scores will appear here"
//                               : "Player scores will appear here",
//                           fontSize: 22.sp,
//                           color: AppColors.greyColor,
//                         ),
//                       ],
//                     );
//                   }
//
//                   return Column(
//                     children: [
//                       // Top 3
//                       SizedBox(
//                         height: 220.h,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             if (top3.length > 1)
//                               _buildTopItem(top3[1], 2, isTeamSelected.value),
//                             SizedBox(width: 20.w),
//                             if (top3.isNotEmpty)
//                               _buildTopItem(top3[0], 1, isTeamSelected.value),
//                             SizedBox(width: 20.w),
//                             if (top3.length > 2)
//                               _buildTopItem(top3[2], 3, isTeamSelected.value),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 37.h),
//
//                       // Full list
//                       ...remaining.map((item) =>
//                           _buildLeaderboardItem(item, isTeamSelected.value)
//                       ).toList(),
//                     ],
//                   );
//                 }),
//
//                 SizedBox(height: 40.h),
//                 //MetricesContainer(),
//                 SizedBox(height: 40.h),
//
//                 // End Session Button (only if not scheduled)
//                 if (!isScheduled)
//                   Center(
//                     child: LoginButton(
//                       onTap: () {
//                         final EndSessionController endController =
//                         Get.put(EndSessionController());
//                         Get.defaultDialog(
//                           title: "End Session",
//                           content: Column(
//                             children: [
//                               Icon(Icons.warning, size: 60.sp, color: Colors.orange),
//                               SizedBox(height: 20.h),
//                               MainText(
//                                 text: "Are you sure you want to end this session?",
//                                 fontSize: 22.sp,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Get.back(),
//                               child: Text("Cancel", style: TextStyle(fontSize: 18.sp)),
//                             ),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 Get.back();
//                                 await endController.completeSession();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.redColor,
//                               ),
//                               child: Text("End Session", style: TextStyle(fontSize: 18.sp)),
//                             ),
//                           ],
//                         );
//                       },
//                       fontSize: 22.sp,
//                       text: "end_session".tr,
//                       color: AppColors.redColor,
//                       ishow: true,
//                       icon: Icons.logout,
//                     ),
//                   ),
//                 SizedBox(height: 50.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }