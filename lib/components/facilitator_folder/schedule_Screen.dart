import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';

// Import your API controllers
import 'package:scorer_web/api/api_controllers/facilitator_schedule_and_active_controller.dart';
import 'package:scorer_web/api/api_controllers/session_action_controller.dart';
import 'package:scorer_web/constants/route_name.dart';

import '../../constants/appcolors.dart';
import '../../shared_preference/shared_preference.dart';


class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facilitatorController = Get.find<FacilitatorScheduleAndActiveSessionController>();
    final sessionController = Get.find<SessionActionController>();

    return Obx(() {
      if (facilitatorController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final scheduledSessions = facilitatorController
          .facilitatorScheduleAndActiveSession.value.scheduledSessions ?? [];

      if (scheduledSessions.isEmpty) {
        return Center(
          child: Text(
            "No scheduled sessions available",
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
                ...scheduledSessions.map((session) {
                  // ✅ Format the date/time properly here
                  String formattedTime = 'Unknown time';
                  if (session.startTime != null && session.startTime!.isNotEmpty) {
                    try {
                      final date = DateTime.tryParse(session.startTime!);
                      if (date != null) {
                        formattedTime = DateFormat('EEE, hh:mm a').format(date);
                      }
                    } catch (e) {
                      formattedTime = 'Invalid date';
                    }
                  }

                  return Column(
                    children: [
                      CustomDashboardContainer(
                        onTap: () async {
                          if (session.id != null) {
                            print("🟢 Facilitator Web tapped SCHEDULED session ID: ${session.id}");

                            await SharedPrefServices.saveSessionId(session.id!);
                            print("💾 Saved session ID ${session.id} to SharedPreferences (Scheduled Screen)");

                            final role = await SharedPrefServices.getUserRole() ?? '';
                            print("🟢 Navigating from Scheduled Screen with role: $role");

                            Get.toNamed(
                              RouteName.overViewOptionScreen,
                              arguments: {
                                'sessionId': session.id,
                                'role': role,
                              },
                            );
                          } else {
                            print("⚠️ Schedule session has null ID");
                          }
                        },

                        onTapStartEarly: () async {
                          print("🟡 Facilitator Web Start Early tapped for session ID: ${session.id}");
                          if (session.id != null) {
                            await SharedPrefServices.saveSessionId(session.id!);
                            print("🟡 Starting session ${session.id} early...");

                            bool success = await sessionController.startSession(session.id!);
                            if (success) {
                              print("🟢 Session ${session.id} started early successfully");

                              // Refresh the data
                              await facilitatorController.fetchFacilitatorSessions();

                              Get.snackbar(
                                'Success',
                                'Session started early!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } else {
                              print("🔴 Failed to start session ${session.id}");
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

                        heading: session.sessionTitle ?? "Session",
                        description: session.description ?? "",
                        text1: "Total Phases: ${session.totalPhases ?? 0}",
                        text2: "Players: ${session.totalPlayers ?? 0}",
                        text3: "Start",
                        text7: "start_early".tr,
                        icon1: Icons.play_arrow,
                        icon2: Icons.square,
                        icon3: Icons.fast_forward,
                        text5: "${session.totalPlayers ?? 0} Players",
                        text6: formattedTime,
                        color2: AppColors.scheColor,
                        svg: Appimages.edit,
                        ishow: false,
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
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
//
// class ScheduleScreen extends StatelessWidget {
//   const ScheduleScreen({super.key});
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
//
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