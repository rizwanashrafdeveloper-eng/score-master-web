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
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: activeSessions.length,
          itemBuilder: (context, index) {
            final session = activeSessions[index];
            final sessionId = session.id ?? 0;
            final isPaused = (session.status ?? '').toUpperCase() == 'PAUSED';
            final isActive = (session.status ?? '').toUpperCase() == 'ACTIVE';

            // ✅ ADD DEBUG PRINT FOR EACH SESSION
            print("📱 Web - Building UI for Session $sessionId - Status: ${session.status}, isPaused: $isPaused, isActive: $isActive");

            return Padding(
              padding: EdgeInsets.all( 20),
              child: CustomDashboardContainer(
                // In the onTap handler of CustomDashboardContainer:
                onTap: () async {
                  if (session.id != null) {
                    print("🟢 Facilitator Web tapped session ID: ${session.id}");

                    // Save session ID
                    await SharedPrefServices.saveSessionId(session.id!);
                    print("💾 Saved session ID ${session.id} to SharedPreferences");

                    // Get and save facilitator ID
                    final facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;
                    if (facilitatorId == 0) {
                      // Try to get from user profile
                      final profile = await SharedPrefServices.getUserProfile();
                      if (profile != null && profile['id'] != null) {
                        final id = profile['id'] is int ? profile['id'] : int.tryParse(profile['id'].toString()) ?? 0;
                        await SharedPrefServices.saveFacilitatorId(id);
                        print("💾 Saved facilitator ID: $id from profile");
                      }
                    }

                    final role = await SharedPrefServices.getUserRole() ?? '';
                    print("🟢 Navigating with role: $role");

                    // Navigate with all necessary data
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
                icon1: isPaused ? Icons.play_arrow : Icons.pause,
                text5: "${session.totalPlayers ?? 0} Players",
                text6: "${session.remainingTime ?? 0} sec left",
                color1: AppColors.redColor,
                color2: isPaused ? Colors.green : Colors.orange,
                ishow: true,
                arrowshow: true,
                mainWidth: MediaQuery.of(context).size.width * 0.9,
              ),
            );
          },
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
// // Import your API controllers
// import 'package:scorer_web/api/api_controllers/facilitator_schedule_and_active_controller.dart';
// import 'package:scorer_web/api/api_controllers/session_action_controller.dart';
//
// import '../../shared_preference/shared_preference.dart';
//
//
// class ActiveSessionScreen extends StatelessWidget {
//   const ActiveSessionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get controllers
//     final facilitatorController = Get.find<FacilitatorScheduleAndActiveSessionController>();
//     final sessionActionController = Get.find<SessionActionController>();
//
//     return Obx(() {
//       if (facilitatorController.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       final activeSessions = facilitatorController
//           .facilitatorScheduleAndActiveSession.value.activeSessions ?? [];
//
//       // ✅ ADD DEBUGGING FOR SESSIONS
//       print("📱 Web - Active sessions count: ${activeSessions.length}");
//       for (var session in activeSessions) {
//         print("📱 Web - Session ${session.id} - Status: ${session.status}, Title: ${session.sessionTitle}");
//       }
//
//       if (activeSessions.isEmpty) {
//         return Center(
//           child: Text(
//             "No active sessions available",
//             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
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
//                 ...activeSessions.map((session) {
//                   final sessionId = session.id ?? 0;
//                   final isPaused = (session.status ?? '').toUpperCase() == 'PAUSED';
//                   final isActive = (session.status ?? '').toUpperCase() == 'ACTIVE';
//
//                   // ✅ ADD DEBUG PRINT FOR EACH SESSION
//                   print("📱 Web - Building UI for Session $sessionId - Status: ${session.status}, isPaused: $isPaused, isActive: $isActive");
//
//                   return Column(
//                     children: [
//                       CustomDashboardContainer(
//                         // In the onTap handler of CustomDashboardContainer:
//                         onTap: () async {
//                           if (session.id != null) {
//                             print("🟢 Facilitator Web tapped session ID: ${session.id}");
//
//                             // Save session ID
//                             await SharedPrefServices.saveSessionId(session.id!);
//                             print("💾 Saved session ID ${session.id} to SharedPreferences");
//
//                             // Get and save facilitator ID
//                             final facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;
//                             if (facilitatorId == 0) {
//                               // Try to get from user profile
//                               final profile = await SharedPrefServices.getUserProfile();
//                               if (profile != null && profile['id'] != null) {
//                                 final id = profile['id'] is int ? profile['id'] : int.tryParse(profile['id'].toString()) ?? 0;
//                                 await SharedPrefServices.saveFacilitatorId(id);
//                                 print("💾 Saved facilitator ID: $id from profile");
//                               }
//                             }
//
//                             final role = await SharedPrefServices.getUserRole() ?? '';
//                             print("🟢 Navigating with role: $role");
//
//                             // Navigate with all necessary data
//                             Get.toNamed(
//                               RouteName.overViewOptionScreen,
//                               arguments: {
//                                 'sessionId': session.id,
//                                 'role': role,
//                               },
//                             );
//                           }
//                         },
//
//                         // onTap: () async {
//                         //   if (session.id != null) {
//                         //     print("🟢 Facilitator Web tapped session ID: ${session.id}");
//                         //     await SharedPrefServices.saveSessionId(session.id!);
//                         //     print("💾 Saved session ID ${session.id} to SharedPreferences");
//                         //
//                         //     final role = await SharedPrefServices.getUserRole() ?? '';
//                         //     print("🟢 Navigating with role: $role");
//                         //
//                         //     Get.toNamed(
//                         //       RouteName.overViewOptionScreen,
//                         //       arguments: {
//                         //         'sessionId': session.id,
//                         //         'role': role,
//                         //       },
//                         //     );
//                         //   }
//                         // },
//
//                         onTapResume: () async {
//                           print("🎯 Web Button tapped - Session: $sessionId, Current Status: ${session.status}");
//
//                           // Show loading indicator
//                           Get.dialog(
//                             const Center(child: CircularProgressIndicator()),
//                             barrierDismissible: false,
//                           );
//
//                           try {
//                             if (isPaused) {
//                               print("🔄 Web Attempting to RESUME session $sessionId");
//                               final success = await sessionActionController.resumeSession(sessionId);
//                               if (success) {
//                                 print("✅ Web Resume successful - refreshing data...");
//                                 // ✅ Refresh the data to update UI
//                                 facilitatorController.updateSessionStatus(sessionId, 'ACTIVE');
//                                 print("✅ Web UI refreshed after resume");
//                               } else {
//                                 print("❌ Web Resume failed");
//                               }
//                             } else if (isActive) {
//                               print("⏸️ Web Attempting to PAUSE session $sessionId");
//                               final success = await sessionActionController.pauseSession(sessionId);
//                               if (success) {
//                                 print("✅ Web Pause successful - refreshing data...");
//                                 // ✅ Refresh the data to update UI
//                                 facilitatorController.updateSessionStatus(sessionId, 'PAUSED');
//                                 print("✅ Web UI refreshed after pause");
//                               } else {
//                                 print("❌ Web Pause failed");
//                               }
//                             } else {
//                               Get.snackbar(
//                                 '⚠️ Invalid State',
//                                 'Cannot perform action. Status: ${session.status}',
//                                 snackPosition: SnackPosition.TOP,
//                                 backgroundColor: Colors.orange,
//                                 colorText: Colors.white,
//                               );
//                             }
//                           } finally {
//                             // Close loading dialog
//                             Get.back();
//                           }
//                         },
//
//                         heading: session.sessionTitle ?? "Session",
//                         text1: "Total Phases: ${session.totalPhases ?? 0}",
//                         text2: "Status: ${session.status ?? 'Unknown'}",
//                         description: session.description ?? "",
//                         text3: isPaused ? "Resume" : "Pause",
//                         //text4: "Next Phase",
//                         icon1: isPaused ? Icons.play_arrow : Icons.pause,
//                        // icon2: Icons.fast_forward,
//                         text5: "${session.totalPlayers ?? 0} Players",
//                         text6: "${session.remainingTime ?? 0} sec left",
//                         color1: AppColors.redColor,
//                         color2: isPaused ? Colors.green : Colors.orange,
//                         ishow: true,
//                         arrowshow: true,
//                         //
//                         // onTapNextPhase: sessionActionController.isLoading.value ? null : () async {
//                         //   await sessionActionController.nextPhase(sessionId);
//                         // },
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
//
//
//
