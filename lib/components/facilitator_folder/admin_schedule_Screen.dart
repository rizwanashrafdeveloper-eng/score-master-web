import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';
import 'package:scorer_web/api/api_controllers/active_schedule_controller.dart';
import 'package:scorer_web/api/api_controllers/session_action_controller.dart';
import 'package:intl/intl.dart';
import '../../constants/appcolors.dart';
import '../../shared_preference/shared_preference.dart';

class AdminScheduleScreen extends StatelessWidget {
  const AdminScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ActiveAndSessionController controller = Get.find<ActiveAndSessionController>();
    final SessionActionController sessionController = Get.find<SessionActionController>();

    return Obx(() {
      if (controller.isLoading.value && controller.filteredScheduledSessions.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.forwardColor),
        );
      }

      final scheduledSessions = controller.filteredScheduledSessions;

      if (scheduledSessions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64.sp,
                color: AppColors.teamColor,
              ),
              SizedBox(height: 16.h),
              Text(
                controller.searchQuery.value.isEmpty
                    ? 'no_scheduled_sessions'.tr
                    : 'no_sessions_matching'.tr + ' "${controller.searchQuery.value}"',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.teamColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
                ...scheduledSessions.map((session) => Column(
                  children: [
                    Obx(() {
                      final sessionId = session.id ?? 0;
                      final isProcessing = controller.isSessionLoading(sessionId) ||
                          sessionController.isProcessing(sessionId);

                      return CustomDashboardContainer(
                        onTap: isProcessing ? null : () async {
                          if (session.id != null) {
                            await SharedPrefServices.saveSessionId(session.id!);
                            Get.toNamed(RouteName.overViewOptionScreen);
                          }
                        },

                        onTapStartEarly: isProcessing ? null : () async {
                          final sessionId = session.id;
                          if (sessionId == null) return;

                          print("Starting session $sessionId early...");

                          // Check if we can perform action
                          if (!controller.canPerformAction(sessionId)) {
                            return;
                          }

                          // Set loading state
                          controller.setSessionLoading(sessionId, true);
                          controller.updateLastActionTime(sessionId);

                          bool success = await sessionController.startSession(sessionId);

                          if (success) {
                            // Immediate UI update
                            controller.updateSessionStatus(sessionId, 'ACTIVE');

                            // Switch to active tab
                            Future.delayed(Duration(milliseconds: 500), () {
                              controller.changeTabIndex(0);
                            });
                          } else {
                            Get.snackbar(
                              'failed_to_start'.tr,
                              'could_not_start_early'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          }

                          // Clear loading state
                          controller.setSessionLoading(sessionId, false);
                        },

                        heading: session.teamTitle ?? "Session",
                        text1: "phase_1".tr,
                        ishow: false,
                        text2: "scheduled".tr,
                        description: session.description ?? "session_description_default".tr,
                        text3: "start_early".tr,
                        showLoading: isProcessing,
                        icon3: isProcessing ? null : Icons.fast_forward,
                        color3: isProcessing ? Colors.grey : AppColors.forwardColor,
                        text5: "${session.totalPlayers ?? 0} " + "players".tr,
                        text6: _formatStartTime(session.startTime),
                        svg: Appimages.edit,
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                )).toList(),
              ],
            ),
          ],
        ),
      );
    });
  }

  String _formatStartTime(String? startTime) {
    if (startTime == null || startTime.isEmpty) return "no_start_time".tr;

    try {
      // If backend sends ISO format
      final date = DateTime.tryParse(startTime);
      if (date != null) {
        return DateFormat('EEE, MMM d • h:mm a').format(date);
      }

      return "invalid_date".tr;
    } catch (e) {
      return "invalid_date".tr;
    }
  }
}



// // admin_schedule_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
// import 'package:scorer_web/api/api_controllers/active_schedule_controller.dart';
// import 'package:scorer_web/api/api_controllers/session_action_controller.dart';
// import 'package:intl/intl.dart';
// import '../../constants/appcolors.dart';
// import '../../shared_preference/shared_preference.dart';
//
// class AdminScheduleScreen extends StatelessWidget {
//   const AdminScheduleScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ActiveAndSessionController controller = Get.find<ActiveAndSessionController>();
//     final SessionActionController sessionController = Get.find<SessionActionController>();
//
//     return Obx(() {
//       if (controller.isLoading.value && controller.filteredScheduledSessions.isEmpty) {
//         return Center(
//           child: CircularProgressIndicator(color: AppColors.forwardColor),
//         );
//       }
//
//       final scheduledSessions = controller.filteredScheduledSessions;
//
//       if (scheduledSessions.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.search_off,
//                 size: 64.sp,
//                 color: AppColors.teamColor,
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 controller.searchQuery.value.isEmpty
//                     ? 'no_scheduled_sessions'.tr // ✅ Changed from 'No scheduled sessions available'
//                     : 'no_sessions_matching'.tr + ' "${controller.searchQuery.value}"', // ✅ Already updated
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   color: AppColors.teamColor,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//
//             ],
//           ),
//         );
//       }
//
//       return ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(
//           scrollbars: false,
//         ),
//         child: ListView(
//           physics: BouncingScrollPhysics(),
//           children: [
//             Column(
//               children: [
//                 ...scheduledSessions.map((session) => Column(
//                   children: [
//                     Obx(() {
//                       final sessionId = session.id ?? 0;
//                       final isProcessing = controller.isSessionLoading(sessionId) ||
//                           sessionController.isProcessing(sessionId);
//
//                       return CustomDashboardContainer(
//                         onTap: isProcessing ? null : () async {
//                           if (session.id != null) {
//                             await SharedPrefServices.saveSessionId(session.id!);
//                             Get.toNamed(RouteName.overViewOptionScreen);
//                           }
//                         },
//
//                         onTapStartEarly: isProcessing ? null : () async {
//                           final sessionId = session.id;
//                           if (sessionId == null) return;
//
//                           print("Starting session $sessionId early...");
//
//                           // Check if we can perform action
//                           if (!controller.canPerformAction(sessionId)) {
//                             return;
//                           }
//
//                           // Set loading state
//                           controller.setSessionLoading(sessionId, true);
//                           controller.updateLastActionTime(sessionId);
//
//                           bool success = await sessionController.startSession(sessionId);
//
//                           if (success) {
//                             // Immediate UI update
//                             controller.updateSessionStatus(sessionId, 'ACTIVE');
//
//                             // Switch to active tab
//                             Future.delayed(Duration(milliseconds: 500), () {
//                               controller.changeTabIndex(0);
//                             });
//                           } else {
//                             Get.snackbar(
//                               'failed_to_start'.tr, // ✅ Changed from 'Failed to Start'
//                               'could_not_start_early'.tr, // ✅ Changed from 'Could not start session early'
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.orange,
//                               colorText: Colors.white,
//                               duration: Duration(seconds: 2),
//                             );
//                           }
//
//                           // Clear loading state
//                           controller.setSessionLoading(sessionId, false);
//                         },
//
//                         heading: session.teamTitle ?? "Session",
//                         text1: "phase_1".tr, // ✅ Changed from "Phase 1"
//                         ishow: false,
//                         text2: "scheduled".tr, // ✅ Changed from "Scheduled"
//                         description: session.description ?? "session_description_default".tr, // ✅ Changed from "Session description"
//                         text3: "start_early".tr, // ✅ Changed from "Start Early"
//                         showLoading: isProcessing, // ✅ Show loading on button
//                         icon3: isProcessing ? null : Icons.fast_forward,
//                         color3: isProcessing ? Colors.grey : AppColors.forwardColor,
//                         text5: "${session.totalPlayers ?? 0} " + "players".tr, // ✅ Already exists from previous
//                         text6: _formatStartTime(session.startTime),
//                         svg: Appimages.edit,
//                       );
//                     }),
//                     SizedBox(height: 20.h),
//                   ],
//                 )).toList(),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   String _formatStartTime(String? startTime) {
//     if (startTime == null || startTime.isEmpty) return "no_start_time".tr; // ✅ Changed from "No start time"
//
//     try {
//       // If backend sends ISO format
//       final date = DateTime.tryParse(startTime);
//       if (date != null) {
//         return DateFormat('EEE, MMM d • h:mm a').format(date);
//       }
//
//       return "invalid_date".tr; // ✅ Changed from "Invalid date"
//     } catch (e) {
//       return "invalid_date".tr; // ✅ Changed from "Invalid date"
//     }
//   }
// }
//
//
