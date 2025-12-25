import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';
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
      if (controller.isLoading.value && controller.filteredActiveSessions.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.forwardColor),
        );
      }

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
                    ? 'no_active_sessions'.tr
                    : 'no_sessions_matching'.tr + ' "${controller.searchQuery.value}"',
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

                  // Get status from multiple sources with priority
                  final sessionStatus = session.status ?? 'ACTIVE';
                  final controllerStatus = sessionController.sessionStatuses[sessionId];
                  final currentStatus = controllerStatus ?? sessionStatus;

                  final bool isPaused = currentStatus.toUpperCase() == 'PAUSED';
                  final bool isActive = currentStatus.toUpperCase() == 'ACTIVE';
                  final bool isProcessing = controller.isSessionLoading(sessionId) ||
                      sessionController.isProcessing(sessionId);

                  // Fetch phases for this session if needed
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (sessionId != 0) {
                      // Check if we need to fetch phases for this session
                      final shouldFetchPhases = sessionController.phases.isEmpty ||
                          (sessionController.currentSession.value?.id != sessionId);

                      // if (shouldFetchPhases) {
                      //   sessionController.fetchPhasesForSession(sessionId);
                      // }
                    }
                  });

                  // Get actual phase data for this session
                  final currentPhase = sessionController.phases
                      .indexWhere((phase) => phase['isCurrent'] == true) + 1;
                  final totalPhases = sessionController.phases.length > 0
                      ? sessionController.phases.length
                      : session.totalPhases ?? 0;

                  return Column(
                    children: [
                      CustomDashboardContainer(
                        onTap: isProcessing ? null : () async {
                          print("Navigating to session: $sessionId");
                          await SharedPrefServices.saveSessionId(sessionId);
                          Get.toNamed(RouteName.overViewOptionScreen);
                        },

                        onTapResume: isProcessing ? null : () async {
                          print("Action button tapped - Session: $sessionId, Status: $currentStatus");

                          // Check if we can perform action
                          if (!controller.canPerformAction(sessionId)) {
                            return;
                          }

                          // Set loading state for this specific session
                          controller.setSessionLoading(sessionId, true);
                          controller.updateLastActionTime(sessionId);

                          bool success = false;
                          if (isPaused) {
                            print("Resuming session $sessionId");
                            success = await sessionController.resumeSession(sessionId);
                            if (success) {
                              // Immediate local update
                              controller.updateSessionStatus(sessionId, 'ACTIVE');
                            }
                          } else if (isActive) {
                            print("Pausing session $sessionId");
                            success = await sessionController.pauseSession(sessionId);
                            if (success) {
                              // Immediate local update
                              controller.updateSessionStatus(sessionId, 'PAUSED');
                            }
                          }

                          // Clear loading state
                          controller.setSessionLoading(sessionId, false);

                          // Show subtle feedback only on failure
                          if (!success) {
                            Get.snackbar(
                              'action_failed'.tr,
                              isPaused ? 'could_not_resume'.tr : 'could_not_pause'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          }
                        },

                        heading: session.teamTitle ?? "session_default".tr,
                        text1: "currentphase".tr + " ${currentPhase > 0 ? currentPhase : 1}",
                        text2: "totalphases".tr + " $totalPhases",
                        description: session.description ?? "session_description_default".tr,

                        /// ✅ Dynamic button with loading indicator
                        text3: isProcessing
                            ? "processing".tr
                            : (isPaused ? "resume".tr : "pause".tr),
                        icon1: isProcessing
                            ? null
                            : (isPaused ? Icons.play_circle_filled : Icons.pause_circle_filled),
                        showLoading: isProcessing,

                        text5: "${session.totalPlayers ?? 0} " + "players".tr,
                        text6: currentStatus,

                        /// ✅ Dynamic button colors
                        color1: AppColors.redColor,
                        color2: isProcessing
                            ? Colors.grey
                            : (isPaused ? Colors.green : Colors.orange),
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
// import 'package:scorer_web/api/api_controllers/active_schedule_controller.dart';
// import 'package:scorer_web/api/api_controllers/session_action_controller.dart';
// import '../../shared_preference/shared_preference.dart';
//
// class AdminActiveSession extends StatelessWidget {
//   const AdminActiveSession({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ActiveAndSessionController controller =
//     Get.find<ActiveAndSessionController>();
//     final SessionActionController sessionController =
//     Get.find<SessionActionController>();
//
//     return Obx(() {
//       if (controller.isLoading.value && controller.filteredActiveSessions.isEmpty) {
//         return Center(
//           child: CircularProgressIndicator(color: AppColors.forwardColor),
//         );
//       }
//
//       final activeSessions = controller.filteredActiveSessions;
//
//       if (activeSessions.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.search_off, size: 64.sp, color: AppColors.teamColor),
//               SizedBox(height: 16.h),
//               Text(
//                 controller.searchQuery.value.isEmpty
//                     ? 'no_active_sessions'.tr
//                     : 'no_sessions_matching'.tr + ' "${controller.searchQuery.value}"',
//                 style: TextStyle(fontSize: 16.sp, color: AppColors.teamColor),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         );
//       }
//
//       return ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//         child: ListView(
//           physics: BouncingScrollPhysics(),
//           children: [
//             Column(
//               children: [
//                 ...activeSessions.map((session) {
//                   final int sessionId = session.id ?? 0;
//
//                   // Get status from multiple sources with priority
//                   final sessionStatus = session.status ?? 'ACTIVE';
//                   final controllerStatus = sessionController.sessionStatuses[sessionId];
//                   final currentStatus = controllerStatus ?? sessionStatus;
//
//                   final bool isPaused = currentStatus.toUpperCase() == 'PAUSED';
//                   final bool isActive = currentStatus.toUpperCase() == 'ACTIVE';
//                   final bool isProcessing = controller.isSessionLoading(sessionId) ||
//                       sessionController.isProcessing(sessionId);
//
//                   return Column(
//                     children: [
//                       CustomDashboardContainer(
//                         onTap: isProcessing ? null : () async {
//                           print("Navigating to session: $sessionId");
//                           await SharedPrefServices.saveSessionId(sessionId);
//                           Get.toNamed(RouteName.overViewOptionScreen);
//                         },
//
//                         onTapResume: isProcessing ? null : () async {
//                           print("Action button tapped - Session: $sessionId, Status: $currentStatus");
//
//                           // Check if we can perform action
//                           if (!controller.canPerformAction(sessionId)) {
//                             return;
//                           }
//
//                           // Set loading state for this specific session
//                           controller.setSessionLoading(sessionId, true);
//                           controller.updateLastActionTime(sessionId);
//
//                           bool success = false;
//                           if (isPaused) {
//                             print("Resuming session $sessionId");
//                             success = await sessionController.resumeSession(sessionId);
//                             if (success) {
//                               // Immediate local update
//                               controller.updateSessionStatus(sessionId, 'ACTIVE');
//                             }
//                           } else if (isActive) {
//                             print("Pausing session $sessionId");
//                             success = await sessionController.pauseSession(sessionId);
//                             if (success) {
//                               // Immediate local update
//                               controller.updateSessionStatus(sessionId, 'PAUSED');
//                             }
//                           }
//
//                           // Clear loading state
//                           controller.setSessionLoading(sessionId, false);
//
//                           // Show subtle feedback only on failure
//                           if (!success) {
//                             Get.snackbar(
//                               'action_failed'.tr,
//                               isPaused ? 'could_not_resume'.tr : 'could_not_pause'.tr,
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.orange,
//                               colorText: Colors.white,
//                               duration: Duration(seconds: 2),
//                             );
//                           }
//                         },
//
//                         heading: session.teamTitle ?? "session_default".tr,
//                         text1: "phase".tr + " ${sessionController.currentPhaseId.value}",
//                         text2: "phases_colon".tr + " ${sessionController.phases.length}",
//                         description: session.description ?? "session_description_default".tr,
//
//                         /// ✅ Dynamic button with loading indicator
//                         text3: isProcessing
//                             ? "processing".tr
//                             : (isPaused ? "resume".tr : "pause".tr),
//                         icon1: isProcessing
//                             ? null
//                             : (isPaused ? Icons.play_circle_filled : Icons.pause_circle_filled),
//                         showLoading: isProcessing,
//
//                         text5: "${session.totalPlayers ?? 0} " + "players".tr,
//                         text6: currentStatus,
//
//                         /// ✅ Dynamic button colors
//                         color1: AppColors.redColor,
//                         color2: isProcessing
//                             ? Colors.grey
//                             : (isPaused ? Colors.green : Colors.orange),
//                       ),
//                       SizedBox(height: 20.h),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
