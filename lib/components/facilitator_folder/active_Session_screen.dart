import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';

// Import your API controllers
import 'package:scorer_web/api/api_controllers/facilitator_schedule_and_active_controller.dart';
import 'package:scorer_web/api/api_controllers/session_action_controller.dart';

import '../../shared_preference/shared_preference.dart';


class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controllers
    final facilitatorController = Get.find<FacilitatorScheduleAndActiveSessionController>();
    final sessionActionController = Get.find<SessionActionController>();

    return Obx(() {
      if (facilitatorController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final activeSessions = facilitatorController
          .facilitatorScheduleAndActiveSession.value.activeSessions ?? [];

      // ✅ ADD DEBUGGING FOR SESSIONS
      print("📱 Web - Active sessions count: ${activeSessions.length}");
      for (var session in activeSessions) {
        print("📱 Web - Session ${session.id} - Status: ${session.status}, Title: ${session.sessionTitle}");
      }

      if (activeSessions.isEmpty) {
        return Center(
          child: Text(
            "No active sessions available",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        );
      }

      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                ...activeSessions.map((session) {
                  final sessionId = session.id ?? 0;
                  final isPaused = (session.status ?? '').toUpperCase() == 'PAUSED';
                  final isActive = (session.status ?? '').toUpperCase() == 'ACTIVE';

                  // ✅ ADD DEBUG PRINT FOR EACH SESSION
                  print("📱 Web - Building UI for Session $sessionId - Status: ${session.status}, isPaused: $isPaused, isActive: $isActive");

                  return Column(
                    children: [
                      CustomDashboardContainer(
                        onTap: () async {
                          if (session.id != null) {
                            print("🟢 Facilitator Web tapped session ID: ${session.id}");
                            await SharedPrefServices.saveSessionId(session.id!);
                            print("💾 Saved session ID ${session.id} to SharedPreferences");

                            final role = await SharedPrefServices.getUserRole() ?? '';
                            print("🟢 Navigating with role: $role");

                            Get.toNamed(
                              RouteName.overViewOptionScreen,
                              arguments: {
                                'sessionId': session.id,
                                'role': role,
                              },
                            );
                          }
                        },

                        onTapResume: () async {
                          print("🎯 Web Button tapped - Session: $sessionId, Current Status: ${session.status}");

                          // Show loading indicator
                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          try {
                            if (isPaused) {
                              print("🔄 Web Attempting to RESUME session $sessionId");
                              final success = await sessionActionController.resumeSession(sessionId);
                              if (success) {
                                print("✅ Web Resume successful - refreshing data...");
                                // ✅ Refresh the data to update UI
                                facilitatorController.updateSessionStatus(sessionId, 'ACTIVE');
                                print("✅ Web UI refreshed after resume");
                              } else {
                                print("❌ Web Resume failed");
                              }
                            } else if (isActive) {
                              print("⏸️ Web Attempting to PAUSE session $sessionId");
                              final success = await sessionActionController.pauseSession(sessionId);
                              if (success) {
                                print("✅ Web Pause successful - refreshing data...");
                                // ✅ Refresh the data to update UI
                                facilitatorController.updateSessionStatus(sessionId, 'PAUSED');
                                print("✅ Web UI refreshed after pause");
                              } else {
                                print("❌ Web Pause failed");
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

                        heading: session.sessionTitle ?? "Session",
                        text1: "Total Phases: ${session.totalPhases ?? 0}",
                        text2: "Status: ${session.status ?? 'Unknown'}",
                        description: session.description ?? "",
                        text3: isPaused ? "Resume" : "Pause",
                        //text4: "Next Phase",
                        icon1: isPaused ? Icons.play_arrow : Icons.pause,
                       // icon2: Icons.fast_forward,
                        text5: "${session.totalPlayers ?? 0} Players",
                        text6: "${session.remainingTime ?? 0} sec left",
                        color1: AppColors.redColor,
                        color2: isPaused ? Colors.green : Colors.orange,
                        ishow: true,
                        arrowshow: true,
                        //
                        // onTapNextPhase: sessionActionController.isLoading.value ? null : () async {
                        //   await sessionActionController.nextPhase(sessionId);
                        // },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  );
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
// class ActiveSessionScreen extends StatelessWidget {
//   const ActiveSessionScreen({super.key});
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
//               onTap: () {
//                 Get.toNamed(RouteName.overViewOptionScreen);
//               },
//
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
//                 Get.toNamed(RouteName.overViewOptionScreen);
//               },
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