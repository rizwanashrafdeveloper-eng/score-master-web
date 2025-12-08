import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';

// Import your API controllers
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
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // ✅ Use filtered sessions based on search
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
                    ? 'No scheduled sessions available'
                    : 'No sessions found matching "${controller.searchQuery.value}"',
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

      print("[AdminScheduleScreen] Rendering ${scheduledSessions.length} scheduled sessions");

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
                    CustomDashboardContainer(
                      onTap: () async {
                        if (session.id != null) {
                          print("[AdminScheduleScreen] Container tapped for session ID: ${session.id}");

                          // Save session ID globally
                          await SharedPrefServices.saveSessionId(session.id!);
                          print("[AdminScheduleScreen] ✅ Saved session ID: ${session.id} to SharedPrefs");

                          // Fetch user role
                          final role = await SharedPrefServices.getUserRole() ?? '';

                          // Navigate
                          Get.toNamed(
                            RouteName.adminOverviewOptionScreens,
                            arguments: {'role': role},
                          );
                        }
                      },

                      onTapStartEarly: () async {
                        print("[AdminScheduleScreen] Start Early button tapped for session ID: ${session.id}");
                        if (session.id != null) {
                          await SharedPrefServices.saveSessionId(session.id!);
                          print("[AdminScheduleScreen] Starting session ${session.id} early...");

                          bool success = await sessionController.startSession(session.id!);

                          if (success) {
                            print("[AdminScheduleScreen] Session ${session.id} started early successfully");

                            // ✅ Refresh sessions list to move to active tab
                            await controller.fetchScheduleAndActiveSessions();

                            // ✅ Switch to Active tab
                            controller.changeTabIndex(0);

                            Get.snackbar(
                              '✅ Success',
                              'Session started successfully!',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            print("[AdminScheduleScreen] Failed to start session ${session.id} early");
                            Get.snackbar(
                              'Error',
                              'Failed to start session early',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },

                      heading: session.teamTitle ?? "Eranove Odyssey – Team A",
                      text1: "Phase ${session.totalPhases ?? 1}",
                      ishow: false,
                      text2: "scheduled".tr,
                      description: session.description ?? "Leadership Assessment strengthens teamwork through interactive activities.",
                      text3: "Pause",
                      text7: "start_early".tr,
                      icon3: Icons.fast_forward,
                      color3: AppColors.forwardColor,
                      text5: "${session.totalPlayers ?? 0} Players",
                      text6: _formatStartTime(session.startTime),
                      svg: Appimages.edit,
                    ),
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
    if (startTime == null || startTime.isEmpty) return "No start time";

    try {
      // If backend sends milliseconds since epoch
      if (RegExp(r'^\d+$').hasMatch(startTime)) {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(startTime));
        return DateFormat('EEEE, h:mm a').format(date); // Example: Sunday, 2:00 PM
      }

      // If backend sends ISO format (e.g. 2025-10-12T14:00:00Z)
      final date = DateTime.tryParse(startTime);
      if (date != null) {
        return DateFormat('EEEE, h:mm a').format(date);
      }

      return "Invalid date";
    } catch (e) {
      return "Invalid date";
    }
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
//
// class AdminScheduleScreen extends StatelessWidget {
//   const AdminScheduleScreen({super.key});
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
//
//             CustomDashboardContainer(
//                 onTap: () {
//                Get.toNamed(RouteName.adminOverviewOptionScreens);
//              },
//         text7: "start_early".tr,
//           icon3: Icons.fast_forward,
//           heading: "Team Building Workshop",
//           text1: "Phase 1",
//           // height: 10,
//           text2: "Phase 1",
//           description: "Team Building Workshop strengthens teamwork through interactive activities.",
//           text3: "Resume",
//           text4: "Next Phase",
//           icon1: Icons.play_arrow,
//           text5: "15 Players",
//           text6: "Paused",
//           icon2: Icons.square,
//           ishow: false,
//         ),
//               SizedBox(height: 20.h,),
//                  CustomDashboardContainer(
//               onTap: () {
//                Get.toNamed(RouteName.adminOverviewOptionScreens);
//              },
//           icon3: Icons.fast_forward,
//           heading: "Team Building Workshop",
//           text1: "Phase 1",
//           // height: 10,
//           text2: "Phase 1",
//           description: "Team Building Workshop strengthens teamwork through interactive activities.",
//           text3: "Resume",
//           text4: "Next Phase",
//           icon1: Icons.play_arrow,
//           text5: "15 Players",
//
//           icon2: Icons.square,
//           ishow: false,
//            svg: Appimages.edit,
//        text7: "edit_session".tr,
//           text6: "Friday 2:00 PM," ),
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