import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_stratgy_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/pause_container.dart';
import '../../api/api_controllers/game_format_phase.dart';
import '../../api/api_controllers/session_controller.dart';
import '../../components/facilitator_folder/real_time_monitor_Container.dart';
import '../../components/facilitator_folder/team_progress_container.dart';
import '../../shared_preference/shared_preference.dart';
import '../../widgets/useable_text_row.dart';

class PhasesScreen extends StatelessWidget {
  final int? sessionId;

  PhasesScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    final phaseController = Get.find<GameFormatPhaseController>();
    final sessionController = Get.find<SessionController>();

    // Initialize if sessionId is provided
    if (sessionId != null && phaseController.sessionId.value != sessionId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        phaseController.setSessionId(sessionId!);
      });
    }

    return Obx(() {
      // Check if session is scheduled
      final isScheduled = sessionController.session.value?.status?.toUpperCase() == 'SCHEDULED';

      if (phaseController.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20.h),
              BoldText(
                text: "Loading phases...",
                fontSize: 24.sp,
                selectionColor: AppColors.blueColor,
              ),
            ],
          ),
        );
      }

      if (phaseController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 60.sp, color: Colors.red),
              SizedBox(height: 20.h),
              MainText(
                text: phaseController.errorMessage.value,
                fontSize: 22.sp,
                color: Colors.red,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              LoginButton(
                text: "Retry",
                fontSize: 20.sp,
                onTap: () => phaseController.refreshPhases(),
              ),
            ],
          ),
        );
      }

      if (phaseController.allPhases.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Appimages.pas, width: 200.w, height: 200.h),
              SizedBox(height: 20.h),
              BoldText(
                text: "No phases configured",
                fontSize: 28.sp,
                selectionColor: AppColors.blueColor,
              ),
              SizedBox(height: 10.h),
              MainText(
                text: "This session doesn't have any phases yet",
                fontSize: 22.sp,
                color: AppColors.greyColor,
              ),
            ],
          ),
        );
      }

      // Get current phase
      final currentPhase = phaseController.currentPhase;
      final currentPhaseId = currentPhase?.id ?? 0;
      final currentPhaseName = currentPhase?.name ?? "Unknown";
      final currentPhaseDuration = currentPhase?.timeDuration ?? 0;

      // Calculate progress percentage (0.0 to 1.0)
      final totalSeconds = currentPhaseDuration * 60; // Convert minutes to seconds
      final remainingSeconds = phaseController.remainingSeconds.value;
      final elapsedSeconds = totalSeconds - remainingSeconds;
      final progressValue = totalSeconds > 0
          ? (elapsedSeconds / totalSeconds).clamp(0.0, 1.0)
          : 0.0;

      // If scheduled, show limited view
      if (isScheduled) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Container(
                  padding: EdgeInsets.all(40.w),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withOpacity(0.1),
                    border: Border.all(color: AppColors.orangeColor, width: 1.5.w),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.schedule, size: 60.sp, color: AppColors.orangeColor),
                      SizedBox(height: 20.h),
                      BoldText(
                        text: "Session Scheduled",
                        fontSize: 28.sp,
                        selectionColor: AppColors.orangeColor,
                      ),
                      SizedBox(height: 10.h),
                      MainText(
                        text: "Phase controls will be available once the session starts.",
                        fontSize: 20.sp,
                        color: AppColors.teamColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                // Show phase list without controls
                BoldText(
                  text: "Configured Phases (${phaseController.totalPhasesCount})",
                  fontSize: 28.sp,
                  selectionColor: AppColors.blueColor,
                ),
                SizedBox(height: 20.h),
                ...phaseController.allPhases.asMap().entries.map((entry) {
                  final phase = entry.value;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.greyColor),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: AppColors.blueColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: BoldText(
                                  text: "${entry.key + 1}",
                                  fontSize: 20.sp,
                                  selectionColor: AppColors.blueColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BoldText(
                                    text: phase.name ?? "Phase ${phase.order}",
                                    fontSize: 22.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  MainText(
                                    text: "${phase.description ?? ''} • ${phase.timeDuration} min",
                                    fontSize: 18.sp,
                                    color: AppColors.greyColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  );
                }).toList(),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        );
      }

      // Active session - full phase controls
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Center(
              child: CreateContainer(
                text: currentPhaseName,
                fontsize2: 31.sp,
                width: 260.w,
                height: 70.h,
                borderW: 1.97.w,
                arrowW: 33.w,
                arrowh: 40.h,
                top: -30.h,
                right: -10.w,
              ),
            ),
            SizedBox(height: 27.h),

            // Current Phase Timer with determinate progress
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 240.w,
                    height: 240.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                  ),

                  // Progress indicator
                  SizedBox(
                    width: 240.w,
                    height: 240.h,
                    child: CircularProgressIndicator(
                      value: progressValue,
                      backgroundColor: AppColors.greyColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.forwardColor),
                      strokeWidth: 8.w,
                      strokeCap: StrokeCap.round,
                    ),
                  ),

                  // Timer text in center
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoldText(
                        text: _formatRemainingTime(remainingSeconds),
                        fontSize: 40.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      MainText(
                        text: "remaining".tr,
                        fontSize: 28.sp,
                        height: 1,
                      ),
                      SizedBox(height: 10.h),
                      if (currentPhaseDuration > 0)
                        MainText(
                          text: "of ${currentPhaseDuration} min",
                          fontSize: 18.sp,
                          color: AppColors.greyColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar showing current phase position
                  LinearProgressIndicator(
                    value: (phaseController.currentPhaseIndex.value + 1) /
                        phaseController.totalPhasesCount,
                    minHeight: 8.h,
                    color: AppColors.selectLangugaeColor,
                    backgroundColor: AppColors.greyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoldText(
                        fontSize: 24.sp,
                        text: "${phaseController.currentPhaseIndex.value + 1} of ${phaseController.totalPhasesCount}",
                        selectionColor: AppColors.blueColor,
                      ),
                      MainText(
                        fontSize: 22.sp,
                        text: "Phase",
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PauseContainer(
                          onTap: () => phaseController.previousPhase(),
                          text: "back".tr,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: PauseContainer(
                          onTap: () {
                            if (phaseController.currentPhaseIndex.value <
                                phaseController.totalPhasesCount - 1) {
                              phaseController.nextPhase();
                            }
                          },
                          text: phaseController.currentPhaseIndex.value <
                              phaseController.totalPhasesCount - 1
                              ? "next_phase".tr
                              : "complete".tr,
                          icon: Icons.fast_forward,
                          color: AppColors.assignColor,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  TeamProgressContainer(sessionId: sessionId),
                  SizedBox(height: 49.h),

                  // All Phases List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoldText(
                        text: "all_phases".tr,
                        fontSize: 28.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      BoldText(
                        text: "${phaseController.totalPhasesCount} Phases",
                        fontSize: 22.sp,
                        selectionColor: AppColors.greyColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // Dynamic Phase List
                  ...phaseController.allPhases.asMap().entries.map((entry) {
                    final index = entry.key;
                    final phase = entry.value;

                    return Column(
                      children: [
                        CustomStratgyContainer(
                          value: (phaseController.currentPhaseIndex.value + 1) /
                              phaseController.totalPhasesCount,
                          iconContainer: phaseController.getPhaseStatusColor(index),
                          icon: phaseController.getPhaseStatusIcon(index),
                          text1: phase.name ?? "Phase ${phase.order}",
                          text2: "${phase.description ?? ''} • ${phase.timeDuration} min",
                          text3: phaseController.getPhaseStatus(index),
                          smallContainer: phaseController.getPhaseStatusColor(index),
                          largeConatiner: index <= phaseController.currentPhaseIndex.value
                              ? phaseController.getPhaseStatusColor(index)
                              : AppColors.greyColor,
                          flex: index > phaseController.currentPhaseIndex.value ? 4 : 3,
                          flex1: 0,
                        ),
                        if (index < phaseController.allPhases.length - 1)
                          SizedBox(height: 10.h),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 30.h),

                  RealTimeMonitorContainer(),
                  SizedBox(height: 50.h),

                  Center(
                    child: LoginButton(
                      onTap: () async {
                        print('🔍 Navigating to responses from Phases Screen...');

                        // ✅ Get current session ID
                        final currentSessionId = sessionId ?? phaseController.sessionId.value;
                        if (currentSessionId == 0) {
                          Get.snackbar('Error', 'No session selected');
                          return;
                        }

                        // ✅ Get facilitator ID
                        final facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;
                        if (facilitatorId == 0) {
                          final profile = await SharedPrefServices.getUserProfile();
                          if (profile != null && profile['id'] != null) {
                            final id = profile['id'] is int
                                ? profile['id']
                                : int.tryParse(profile['id'].toString()) ?? 0;

                            if (id > 0) {
                              await SharedPrefServices.saveFacilitatorId(id);
                              print('💾 Saved facilitator ID: $id');
                            } else {
                              Get.snackbar('Error', 'Facilitator information not found');
                              return;
                            }
                          } else {
                            Get.snackbar('Error', 'Please login again');
                            return;
                          }
                        }

                        // ✅ Get current phase ID from controller
                        final phaseId = currentPhaseId;

                        if (phaseId == 0) {
                          print('⚠️ No active phase found');
                          Get.snackbar(
                            'No Active Phase',
                            'Please select or start a phase first',
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        print('🎯 Navigating to responses with REAL IDs:');
                        print('   - Session: $currentSessionId');
                        print('   - Phase: $phaseId ($currentPhaseName)');
                        print('   - Facilitator: $facilitatorId');

                        // ✅ Save all IDs before navigation
                        await SharedPrefServices.saveSessionAndPhaseInfo(
                          sessionId: currentSessionId,
                          phaseId: phaseId,
                          facilitatorId: facilitatorId,
                        );

                        // ✅ Save phase info
                        await SharedPrefServices.saveCurrentPhaseInfo(phaseId, currentPhaseName);

                        Get.toNamed(
                          RouteName.viewResponsesScreen,
                          arguments: {
                            'sessionId': currentSessionId,
                            'phaseId': phaseId,
                            'facilitatorId': facilitatorId,
                            'phaseName': currentPhaseName,
                          },
                        );
                      },
                      fontSize: 22.sp,
                      text: "view_responses".tr,
                      color: AppColors.forwardColor,
                      ishow: true,
                      image: Appimages.eye,
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatRemainingTime(int seconds) {
    final minutes = (seconds ~/ 60).clamp(0, 99);
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_stratgy_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/pause_container.dart';
// import '../../api/api_controllers/game_format_phase.dart';
// import '../../api/api_controllers/session_controller.dart';
// import '../../components/facilitator_folder/real_time_monitor_Container.dart';
// import '../../components/facilitator_folder/team_progress_container.dart';
// import '../../shared_preference/shared_preference.dart';
// import '../../widgets/useable_text_row.dart';
//
// class PhasesScreen extends StatelessWidget {
//   final int? sessionId;
//
//   PhasesScreen({super.key, this.sessionId});
//
//   @override
//   Widget build(BuildContext context) {
//     final phaseController = Get.find<GameFormatPhaseController>();
//     final sessionController = Get.find<SessionController>();
//
//     // Initialize if sessionId is provided
//     if (sessionId != null && phaseController.sessionId.value != sessionId) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         phaseController.setSessionId(sessionId!);
//       });
//     }
//
//     return Obx(() {
//       // Check if session is scheduled
//       final isScheduled = sessionController.session.value?.status?.toUpperCase() == 'SCHEDULED';
//
//       if (phaseController.isLoading.value) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 20.h),
//               BoldText(
//                 text: "Loading phases...",
//                 fontSize: 24.sp,
//                 selectionColor: AppColors.blueColor,
//               ),
//             ],
//           ),
//         );
//       }
//
//       if (phaseController.errorMessage.value.isNotEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error, size: 60.sp, color: Colors.red),
//               SizedBox(height: 20.h),
//               MainText(
//                 text: phaseController.errorMessage.value,
//                 fontSize: 22.sp,
//                 color: Colors.red,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 30.h),
//               LoginButton(
//                 text: "Retry",
//                 fontSize: 20.sp,
//                 onTap: () => phaseController.refreshPhases(),
//               ),
//             ],
//           ),
//         );
//       }
//
//       if (phaseController.allPhases.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(Appimages.pas, width: 200.w, height: 200.h),
//               SizedBox(height: 20.h),
//               BoldText(
//                 text: "No phases configured",
//                 fontSize: 28.sp,
//                 selectionColor: AppColors.blueColor,
//               ),
//               SizedBox(height: 10.h),
//               MainText(
//                 text: "This session doesn't have any phases yet",
//                 fontSize: 22.sp,
//                 color: AppColors.greyColor,
//               ),
//             ],
//           ),
//         );
//       }
//
//       // Get current phase ID
//       final currentPhase = phaseController.currentPhase;
//       final currentPhaseId = currentPhase?.id ?? 0;
//       final currentPhaseName = currentPhase?.name ?? "Unknown";
//
//       // If scheduled, show limited view
//       if (isScheduled) {
//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 50.w),
//             child: Column(
//               children: [
//                 SizedBox(height: 50.h),
//                 Container(
//                   padding: EdgeInsets.all(40.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.orangeColor.withOpacity(0.1),
//                     border: Border.all(color: AppColors.orangeColor, width: 1.5.w),
//                     borderRadius: BorderRadius.circular(24.r),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(Icons.schedule, size: 60.sp, color: AppColors.orangeColor),
//                       SizedBox(height: 20.h),
//                       BoldText(
//                         text: "Session Scheduled",
//                         fontSize: 28.sp,
//                         selectionColor: AppColors.orangeColor,
//                       ),
//                       SizedBox(height: 10.h),
//                       MainText(
//                         text: "Phase controls will be available once the session starts.",
//                         fontSize: 20.sp,
//                         color: AppColors.teamColor,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 // Show phase list without controls
//                 BoldText(
//                   text: "Configured Phases (${phaseController.totalPhasesCount})",
//                   fontSize: 28.sp,
//                   selectionColor: AppColors.blueColor,
//                 ),
//                 SizedBox(height: 20.h),
//                 ...phaseController.allPhases.asMap().entries.map((entry) {
//                   final phase = entry.value;
//                   return Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(20.w),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: AppColors.greyColor),
//                           borderRadius: BorderRadius.circular(16.r),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 50.w,
//                               height: 50.h,
//                               decoration: BoxDecoration(
//                                 color: AppColors.blueColor.withOpacity(0.1),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: BoldText(
//                                   text: "${entry.key + 1}",
//                                   fontSize: 20.sp,
//                                   selectionColor: AppColors.blueColor,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 20.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   BoldText(
//                                     text: phase.name ?? "Phase ${phase.order}",
//                                     fontSize: 22.sp,
//                                     selectionColor: AppColors.blueColor,
//                                   ),
//                                   MainText(
//                                     text: "${phase.description ?? ''} • ${phase.timeDuration} min",
//                                     fontSize: 18.sp,
//                                     color: AppColors.greyColor,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 15.h),
//                     ],
//                   );
//                 }).toList(),
//                 SizedBox(height: 50.h),
//               ],
//             ),
//           ),
//         );
//       }
//
//       // Active session - full phase controls
//       return SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 50.h),
//             Center(
//               child: CreateContainer(
//                 text: currentPhaseName,
//                 fontsize2: 31.sp,
//                 width: 260.w,
//                 height: 70.h,
//                 borderW: 1.97.w,
//                 arrowW: 33.w,
//                 arrowh: 40.h,
//                 top: -30.h,
//                 right: -10.w,
//               ),
//             ),
//             SizedBox(height: 27.h),
//
//             // Current Phase Timer
//             Center(
//               child: CircularPercentIndicator(
//                 radius: 120.r,
//                 lineWidth: 5.0,
//                 percent: phaseController.currentPhaseProgress,
//                 animation: true,
//                 animationDuration: 500,
//                 circularStrokeCap: CircularStrokeCap.round,
//                 backgroundColor: Colors.transparent,
//                 progressColor: AppColors.forwardColor,
//                 center: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     BoldText(
//                       text: phaseController.getRemainingTime(
//                           phaseController.currentPhaseDuration),
//                       fontSize: 40.sp,
//                       selectionColor: AppColors.blueColor,
//                     ),
//                     MainText(
//                       text: "remaining".tr,
//                       fontSize: 28.sp,
//                       height: 1,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.h),
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   LinearProgressIndicator(
//                     value: phaseController.currentPhaseIndex.value /
//                         phaseController.totalPhasesCount,
//                     minHeight: 8.h,
//                     color: AppColors.selectLangugaeColor,
//                     backgroundColor: AppColors.greyColor,
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   SizedBox(height: 20.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       BoldText(
//                         fontSize: 24.sp,
//                         text: "${phaseController.currentPhaseIndex.value + 1} of ${phaseController.totalPhasesCount}",
//                         selectionColor: AppColors.blueColor,
//                       ),
//                       MainText(fontSize: 22.sp, text: "Phase"),
//                     ],
//                   ),
//                   SizedBox(height: 30.h),
//
//                   // Navigation Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: PauseContainer(
//                           onTap: () => phaseController.previousPhase(),
//                           text: "back".tr,
//                           fontSize: 20.sp,
//                         ),
//                       ),
//                       SizedBox(width: 20.w),
//                       Expanded(
//                         child: PauseContainer(
//                           onTap: () {
//                             if (phaseController.currentPhaseIndex.value <
//                                 phaseController.totalPhasesCount - 1) {
//                               phaseController.nextPhase();
//                             }
//                           },
//                           text: phaseController.currentPhaseIndex.value <
//                               phaseController.totalPhasesCount - 1
//                               ? "next_phase".tr
//                               : "complete".tr,
//                           icon: Icons.fast_forward,
//                           color: AppColors.assignColor,
//                           fontSize: 20.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 30.h),
//
//                   TeamProgressContainer(sessionId: sessionId),
//                   SizedBox(height: 49.h),
//
//                   // All Phases List
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       BoldText(
//                         text: "all_phases".tr,
//                         fontSize: 28.sp,
//                         selectionColor: AppColors.blueColor,
//                       ),
//                       BoldText(
//                         text: "${phaseController.totalPhasesCount} Phases",
//                         fontSize: 22.sp,
//                         selectionColor: AppColors.greyColor,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 30.h),
//
//                   // Dynamic Phase List
//                   ...phaseController.allPhases.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final phase = entry.value;
//
//                     return Column(
//                       children: [
//                         CustomStratgyContainer(
//                           value: (phaseController.currentPhaseIndex.value + 1) /
//                               phaseController.totalPhasesCount,
//                           iconContainer: phaseController.getPhaseStatusColor(index),
//                           icon: phaseController.getPhaseStatusIcon(index),
//                           text1: phase.name ?? "Phase ${phase.order}",
//                           text2: "${phase.description ?? ''} • ${phase.timeDuration} min",
//                           text3: phaseController.getPhaseStatus(index),
//                           smallContainer: phaseController.getPhaseStatusColor(index),
//                           largeConatiner: index <= phaseController.currentPhaseIndex.value
//                               ? phaseController.getPhaseStatusColor(index)
//                               : AppColors.greyColor,
//                           flex: index > phaseController.currentPhaseIndex.value ? 4 : 3,
//                           flex1: 0,
//                         ),
//                         if (index < phaseController.allPhases.length - 1)
//                           SizedBox(height: 10.h),
//                       ],
//                     );
//                   }).toList(),
//                   SizedBox(height: 30.h),
//
//                   RealTimeMonitorContainer(),
//                   SizedBox(height: 50.h),
//
//                   Center(
//                     child: LoginButton(
//                       onTap: () async {
//                         print('🔍 Navigating to responses from Phases Screen...');
//
//                         // ✅ Get current session ID
//                         final currentSessionId = sessionId ?? phaseController.sessionId.value;
//                         if (currentSessionId == 0) {
//                           Get.snackbar('Error', 'No session selected');
//                           return;
//                         }
//
//                         // ✅ Get facilitator ID
//                         final facilitatorId = await SharedPrefServices.getFacilitatorId() ?? 0;
//                         if (facilitatorId == 0) {
//                           final profile = await SharedPrefServices.getUserProfile();
//                           if (profile != null && profile['id'] != null) {
//                             final id = profile['id'] is int
//                                 ? profile['id']
//                                 : int.tryParse(profile['id'].toString()) ?? 0;
//
//                             if (id > 0) {
//                               await SharedPrefServices.saveFacilitatorId(id);
//                               print('💾 Saved facilitator ID: $id');
//                             } else {
//                               Get.snackbar('Error', 'Facilitator information not found');
//                               return;
//                             }
//                           } else {
//                             Get.snackbar('Error', 'Please login again');
//                             return;
//                           }
//                         }
//
//                         // ✅ Get current phase ID from controller
//                         final phaseId = currentPhaseId;
//
//                         if (phaseId == 0) {
//                           print('⚠️ No active phase found');
//                           Get.snackbar(
//                             'No Active Phase',
//                             'Please select or start a phase first',
//                             backgroundColor: Colors.orange,
//                             colorText: Colors.white,
//                           );
//                           return;
//                         }
//
//                         print('🎯 Navigating to responses with REAL IDs:');
//                         print('   - Session: $currentSessionId');
//                         print('   - Phase: $phaseId ($currentPhaseName)');
//                         print('   - Facilitator: $facilitatorId');
//
//                         // ✅ Save all IDs before navigation
//                         await SharedPrefServices.saveSessionAndPhaseInfo(
//                           sessionId: currentSessionId,
//                           phaseId: phaseId,
//                           facilitatorId: facilitatorId,
//                         );
//
//                         // ✅ Save phase info
//                         await SharedPrefServices.saveCurrentPhaseInfo(phaseId, currentPhaseName);
//
//                         Get.toNamed(
//                           RouteName.viewResponsesScreen,
//                           arguments: {
//                             'sessionId': currentSessionId,
//                             'phaseId': phaseId,
//                             'facilitatorId': facilitatorId,
//                             'phaseName': currentPhaseName,
//                           },
//                         );
//                       },
//                       fontSize: 22.sp,
//                       text: "view_responses".tr,
//                       color: AppColors.forwardColor,
//                       ishow: true,
//                       image: Appimages.eye,
//                     ),
//                   ),
//                   SizedBox(height: 50.h),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
