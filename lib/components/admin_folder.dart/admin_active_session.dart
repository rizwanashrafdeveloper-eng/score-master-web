import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';

// Import your API controllers
import 'package:scorer_web/api/api_controllers/active_schedule_controller.dart';
import 'package:scorer_web/api/api_controllers/session_action_controller.dart';

import '../../shared_preference/shared_preference.dart';

class AdminActiveSession extends StatelessWidget {
  const AdminActiveSession({super.key});

  @override
  Widget build(BuildContext context) {
    final ActiveAndSessionController controller =
        Get.find<ActiveAndSessionController>();
    final SessionActionController sessionController =
        Get.find<SessionActionController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // ✅ Use filtered sessions based on search
      final activeSessions = controller.filteredActiveSessions;

      if (activeSessions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64.sp, color: AppColors.teamColor),
              SizedBox(height: 16.h),
              Text(
                controller.searchQuery.value.isEmpty
                    ? 'No active sessions available'
                    : 'No sessions found matching "${controller.searchQuery.value}"',
                style: TextStyle(fontSize: 16.sp, color: AppColors.teamColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                ...activeSessions.map((session) {
                  final int sessionId = session.id ?? 0;

                  return Obx(() {
                    // ✅ Get status from sessionStatuses map (reactive)
                    final currentStatus =
                        sessionController.sessionStatuses[sessionId] ??
                        session.status ??
                        'ACTIVE';
                    final bool isPaused =
                        currentStatus.toUpperCase() == 'PAUSED';
                    final bool isActive =
                        currentStatus.toUpperCase() == 'ACTIVE';
                    final bool isProcessing = sessionController.isLoading.value;

                    print(
                      "[AdminActiveSession] Session $sessionId - Status: $currentStatus, isPaused: $isPaused, isActive: $isActive",
                    );

                    return Column(
                      children: [
                        CustomDashboardContainer(
                          onTap: () async {
                            print(
                              "[AdminActiveSession] Container tapped for session ID: $sessionId",
                            );
                            await SharedPrefServices.saveSessionId(sessionId);
                            Get.toNamed(RouteName.adminOverviewOptionScreens);
                          },

                          onTapResume: () async {
                            print(
                              "🎯 Button tapped - Session: $sessionId, Current Status: ${session.status}",
                            );

                            // Show loading indicator
                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            try {
                              if (isPaused) {
                                print(
                                  "🔄 Attempting to RESUME session $sessionId",
                                );
                                final success = await sessionController
                                    .resumeSession(sessionId);
                                if (success) {
                                  print(
                                    "✅ Resume successful - refreshing data...",
                                  );
                                  // ✅ Refresh the data to update UI
                                  controller.updateSessionStatus(
                                    sessionId,
                                    'ACTIVE',
                                  );
                                  print("✅ UI refreshed after resume");
                                } else {
                                  print("❌ Resume failed");
                                }
                              } else if (isActive) {
                                print(
                                  "⏸️ Attempting to PAUSE session $sessionId",
                                );
                                final success = await sessionController
                                    .pauseSession(sessionId);
                                if (success) {
                                  print(
                                    "✅ Pause successful - refreshing data...",
                                  );
                                  // ✅ Refresh the data to update UI
                                  controller.updateSessionStatus(
                                    sessionId,
                                    'PAUSED',
                                  );
                                  print("✅ UI refreshed after pause");
                                } else {
                                  print("❌ Pause failed");
                                }
                              } else {
                                Get.snackbar(
                                  '⚠️ Invalid State',
                                  'Cannot perform action. Status: ${session.status}',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                              }
                            } finally {
                              // Close loading dialog
                              Get.back();
                            }
                          },

                          heading: session.teamTitle ?? "Session",
                          text1:
                              "Phase ${sessionController.currentPhaseId.value}",
                          text2: "Phases: ${sessionController.phases.length}",
                          description:
                              session.description ?? "Session Description",

                          /// ✅ Dynamic button text and icon based on status
                          text3: isPaused ? "Resume" : "Pause",
                          icon1: isPaused
                              ? Icons.play_circle_filled
                              : Icons.pause_circle_filled,

                         // text4: "Next Phase",
                         // icon2: Icons.fast_forward,
                          text5: "${session.totalPlayers ?? 0} Players",
                          text6: currentStatus,

                          /// ✅ Dynamic button color
                          color1: AppColors.redColor,
                          color2: isPaused ? Colors.green : Colors.orange,
                          //
                          // onTapNextPhase: isProcessing
                          //     ? null
                          //     : () async {
                          //         await sessionController.nextPhase(sessionId);
                          //       },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    );
                  });
                }).toList(),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
//
// class AdminActiveSession extends StatelessWidget {
//   const AdminActiveSession({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(
//     scrollbars: false, // ✅ ye side wali scrollbar hatayega
//   ),
//       child: ListView(
//          physics: BouncingScrollPhysics(), // iOS style
//         children: [
//           Column(
//             children: [
//             //  Container(
//             //   width: 698.w,
//             //   height: 602.h,
//             //   color: AppColors.arrowColor,
//             //  )
//              CustomDashboardContainer(
//              onTap: () {
//                Get.toNamed(RouteName.adminOverviewOptionScreens);
//              },
//           // width: 70,
//                 heading: "Team Building Workshop",
//                 text1: "phase_1".tr,
//                 // height: 10,
//                 text2: "phase_1".tr,
//                 description: "Eranove Odyssey sessions immerse teams in fast-paced, collaborative challenges with real-time scoring and progression.",
//                 text3: "Pause".tr,
//                 text4: "next_phase".tr,
//                 icon1: Icons.pause,
//                 text5: "15 Players",
//                 text6: "25min left",
//                 icon2: Icons.fast_forward,
//               ),
//               SizedBox(height: 20.h,),
//                  CustomDashboardContainer(
//                onTap: () {
//                Get.toNamed(RouteName.adminOverviewOptionScreens);
//              },
//           // width: 70,
//                 heading: "Team Building Workshop",
//                 text1: "phase_1".tr,
//                 // height: 10,
//                 text2: "phase_1".tr,
//                 description: "Eranove Odyssey sessions immerse teams in fast-paced, collaborative challenges with real-time scoring and progression.",
//                 text3: "Pause".tr,
//                 text4: "next_phase".tr,
//                 icon1: Icons.pause,
//                 text5: "15 Players",
//                 text6: "25min left",
//                 icon2: Icons.fast_forward,
//               ),
//
//               //   CustomDashboardContainer(
//
//               //   // onTap:()=> Get.toNamed(RouteName.overViewOptionScreen),
//               //   heading: "Team Building Workshop",
//               //   text1: "phase_1".tr,
//               //   // height: 10,
//               //   text2:"phase_1".tr,
//               //   description: "Team Building Workshop strengthens teamwork through interactive activities.",
//               //   text3: "resume".tr,
//               //   text4:  "end".tr,
//               //   icon1: Icons.play_arrow,
//               //   text5: "15 Players",
//               //   text6: "paused".tr,
//               //   icon2: Icons.square,
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
