import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/pause_container.dart';
import 'package:scorer_web/widgets/useable_container.dart';
import '../../../api/api_controllers/game_format_phase.dart';
import '../../../api/api_controllers/session_controller.dart';

class NewSessionContainer extends StatelessWidget {
  final int? sessionId;

  const NewSessionContainer({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Get.find<SessionController>();
    final GameFormatPhaseController phaseController = Get.put(GameFormatPhaseController());

    // Initialize phase controller if needed
    if (sessionId != null && phaseController.sessionId.value != sessionId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        phaseController.setSessionId(sessionId!);
      });
    }

    return Obx(() {
      if (sessionController.isLoading.value || phaseController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final session = sessionController.session.value;
      final currentPhase = phaseController.currentPhase;
      final totalPhases = phaseController.totalPhasesCount;
      final currentPhaseIndex = phaseController.currentPhaseIndex.value;
      final remainingSeconds = phaseController.remainingSeconds.value;

      // Check if session is scheduled
      final isScheduled = session?.status?.toUpperCase() == 'SCHEDULED';

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            // Session Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor, width: 1.5.w),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  _buildSessionInfoRow(
                    "session_code".tr,
                    session?.joinCode ?? "N/A",
                    Icons.copy,
                  ),
                  SizedBox(height: 10.h),
                  _buildSessionInfoRow(
                    "join_link".tr,
                    session?.joinLink ?? "N/A",
                    Icons.link,
                  ),
                  SizedBox(height: 10.h),
                  _buildSessionInfoRow(
                    "started".tr,
                    session?.startTime != null
                        ? _formatDateTime(session!.startTime!)
                        : "Not started",
                    null,
                  ),
                  SizedBox(height: 10.h),
                  _buildSessionInfoRow(
                    "duration".tr,
                    "${session?.duration ?? 0} minutes",
                    null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Phase Info Card (only if not scheduled and phases exist)
            if (!isScheduled && totalPhases > 0) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor, width: 1.5.w),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoldText(
                                text: "current_phase".tr,
                                fontSize: 24.sp,
                                selectionColor: AppColors.blueColor,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  UseableContainer(
                                    text: currentPhase?.name ?? "Phase ${currentPhaseIndex + 1}",
                                    color: AppColors.orangeColor,
                                   // height: 35,
                                    //width: null,
                                  ),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: MainText(
                                      text: currentPhase?.description ?? "",
                                      fontSize: 18.sp,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              MainText(
                                text: "Phase ${currentPhaseIndex + 1} of $totalPhases",
                                fontSize: 16.sp,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.w),
                        // Professional Circular Progress Indicator
                        _buildCircularProgressIndicator(
                          currentPhase: currentPhase,
                          remainingSeconds: remainingSeconds,
                          phaseController: phaseController,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Progress bar for overall phase completion
                    LinearProgressIndicator(
                      value: totalPhases > 0 ? (currentPhaseIndex + 1) / totalPhases : 0.0,
                      minHeight: 6.h,
                      color: AppColors.forwardColor,
                      backgroundColor: AppColors.greyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainText(
                          text: "Overall Progress",
                          fontSize: 16.sp,
                          color: AppColors.greyColor,
                        ),
                        BoldText(
                          text: "${((currentPhaseIndex + 1) / totalPhases * 100).round()}%",
                          fontSize: 16.sp,
                          selectionColor: AppColors.blueColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Phase controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: PauseContainer(
                            icon: Icons.pause,
                            text: "pause".tr,
                            fontSize: 18.sp,
                            onTap: () {
                              Get.snackbar(
                                'Info',
                                'Pause functionality coming soon',
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: PauseContainer(
                            text: "next_phase".tr,
                            icon: Icons.fast_forward,
                            color: AppColors.forwardColor,
                            fontSize: 18.sp,
                            onTap: () {
                              if (currentPhaseIndex < totalPhases - 1) {
                                phaseController.nextPhase();
                              } else {
                                Get.snackbar(
                                  'Info',
                                  'This is the last phase',
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ] else if (!isScheduled && totalPhases == 0) ...[
              // No phases available
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withOpacity(0.1),
                  border: Border.all(color: AppColors.orangeColor, width: 1.5.w),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  children: [
                    Icon(Icons.layers_outlined, size: 60.sp, color: AppColors.orangeColor),
                    SizedBox(height: 20.h),
                    BoldText(
                      text: "No Phases Configured",
                      fontSize: 24.sp,
                      selectionColor: AppColors.orangeColor,
                    ),
                    SizedBox(height: 10.h),
                    MainText(
                      text: "This session doesn't have any phases configured yet.",
                      fontSize: 18.sp,
                      color: AppColors.teamColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20.h)
          ],
        ),
      );
    });
  }

  Widget _buildCircularProgressIndicator({
    required dynamic currentPhase,
    required int remainingSeconds,
    required GameFormatPhaseController phaseController,
  }) {
    final currentPhaseDuration = currentPhase?.timeDuration ?? 0;
    final totalSeconds = currentPhaseDuration * 60;
    final elapsedSeconds = totalSeconds - remainingSeconds;
    final progressValue = totalSeconds > 0
        ? (elapsedSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return SizedBox(
      width: 120.w,
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyColor.withOpacity(0.1),
            ),
          ),

          // Progress indicator
          SizedBox(
            width: 110.w,
            height: 110.h,
            child: CircularProgressIndicator(
              value: progressValue,
              backgroundColor: AppColors.greyColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.forwardColor),
              strokeWidth: 6.w,
              strokeCap: StrokeCap.round,
            ),
          ),

          // Timer text in center
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoldText(
                text: _formatRemainingTime(remainingSeconds),
                fontSize: 22.sp,
                selectionColor: AppColors.blueColor,
              ),
              MainText(
                text: "remaining".tr,
                fontSize: 14.sp,
                height: 1,
                color: AppColors.greyColor,
              ),
              SizedBox(height: 4.h),
              if (currentPhaseDuration > 0)
                MainText(
                  text: "of ${currentPhaseDuration}m",
                  fontSize: 12.sp,
                  color: AppColors.greyColor,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfoRow(String label, String value, IconData? icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MainText(
            text: label,
            fontSize: 20.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: BoldText(
                  text: value,
                  fontSize: 18.sp,
                  selectionColor: AppColors.blueColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 8.w),
                Icon(icon, size: 18.sp, color: AppColors.blueColor),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatRemainingTime(int seconds) {
    final minutes = (seconds ~/ 60).clamp(0, 99);
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/pause_container.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// import '../../../api/api_controllers/game_format_phase.dart';
// import '../../../api/api_controllers/session_controller.dart';
//
// class NewSessionContainer extends StatelessWidget {
//   final int? sessionId;
//
//   const NewSessionContainer({super.key, this.sessionId});
//
//   @override
//   Widget build(BuildContext context) {
//     final SessionController sessionController = Get.find<SessionController>();
//     final GameFormatPhaseController phaseController = Get.put(GameFormatPhaseController());
//
//     // Initialize phase controller if needed
//     if (sessionId != null && phaseController.sessionId.value != sessionId) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         phaseController.setSessionId(sessionId!);
//       });
//     }
//
//     return Obx(() {
//       if (sessionController.isLoading.value || phaseController.isLoading.value) {
//         return Center(child: CircularProgressIndicator());
//       }
//
//       final session = sessionController.session.value;
//       final currentPhase = phaseController.currentPhase;
//       final totalPhases = phaseController.totalPhasesCount;
//       final currentPhaseIndex = phaseController.currentPhaseIndex.value;
//
//       // Check if session is scheduled
//       final isScheduled = session?.status?.toUpperCase() == 'SCHEDULED';
//
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//           children: [
//             // Session Info Card
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20.w),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.greyColor, width: 1.5.w),
//                 borderRadius: BorderRadius.circular(24.r),
//               ),
//               child: Column(
//                 children: [
//                   _buildSessionInfoRow(
//                     "session_code".tr,
//                     session?.joinCode ?? "N/A",
//                     Icons.copy,
//                   ),
//                   SizedBox(height: 10.h),
//                   _buildSessionInfoRow(
//                     "join_link".tr,
//                     session?.joinLink ?? "N/A",
//                     Icons.link,
//                   ),
//                   SizedBox(height: 10.h),
//                   _buildSessionInfoRow(
//                     "started".tr,
//                     session?.startTime != null
//                         ? _formatDateTime(session!.startTime!)
//                         : "Not started",
//                     null,
//                   ),
//                   SizedBox(height: 10.h),
//                   _buildSessionInfoRow(
//                     "duration".tr,
//                     "${session?.duration ?? 0} minutes",
//                     null,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20.h),
//
//             // Phase Info Card (only if not scheduled and phases exist)
//             if (!isScheduled && totalPhases > 0) ...[
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(20.w),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.greyColor, width: 1.5.w),
//                   borderRadius: BorderRadius.circular(24.r),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             BoldText(
//                               text: "current_phase".tr,
//                               fontSize: 24.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                             SizedBox(height: 10.h),
//                             Row(
//                               children: [
//                                 UseableContainer(
//                                   text: currentPhase?.name ?? "Phase ${currentPhaseIndex + 1}",
//                                   color: AppColors.orangeColor,
//                                 ),
//                                 SizedBox(width: 7.w),
//                                 MainText(
//                                   text: currentPhase?.description ?? "",
//                                   fontSize: 22.sp,
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         CircularPercentIndicator(
//                           radius: 70.r,
//                           lineWidth: 5.0.w,
//                           percent: phaseController.currentPhaseProgress,
//                           animation: true,
//                           animationDuration: 500,
//                           circularStrokeCap: CircularStrokeCap.round,
//                           backgroundColor: Colors.transparent,
//                           progressColor: AppColors.forwardColor,
//                           center: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               BoldText(
//                                 text: phaseController.getRemainingTime(
//                                     currentPhase?.timeDuration ?? 0),
//                                 fontSize: 21.sp,
//                                 selectionColor: AppColors.blueColor,
//                               ),
//                               MainText(
//                                 text: "remaining".tr,
//                                 fontSize: 18.sp,
//                                 height: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20.h),
//
//                     // Progress bar
//                     LinearProgressIndicator(
//                       value: totalPhases > 0 ? (currentPhaseIndex + 1) / totalPhases : 0.0,
//                       minHeight: 8.h,
//                       color: AppColors.forwardColor,
//                       backgroundColor: AppColors.greyColor,
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     SizedBox(height: 15.h),
//
//                     // Phase controls
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: PauseContainer(
//                             icon: Icons.pause,
//                             text: "pause".tr,
//                             fontSize: 20.sp,
//                             onTap: () {
//                               Get.snackbar(
//                                 'Info',
//                                 'Pause functionality coming soon',
//                                 snackPosition: SnackPosition.TOP,
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 20.w),
//                         Expanded(
//                           child: PauseContainer(
//                             text: "next_phase".tr,
//                             icon: Icons.fast_forward,
//                             color: AppColors.forwardColor,
//                             fontSize: 20.sp,
//                             onTap: () {
//                               if (currentPhaseIndex < totalPhases - 1) {
//                                 phaseController.nextPhase();
//                               } else {
//                                 Get.snackbar(
//                                   'Info',
//                                   'This is the last phase',
//                                   snackPosition: SnackPosition.TOP,
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ] else if (!isScheduled && totalPhases == 0) ...[
//               // No phases available
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(40.w),
//                 decoration: BoxDecoration(
//                   color: AppColors.orangeColor.withOpacity(0.1),
//                   border: Border.all(color: AppColors.orangeColor, width: 1.5.w),
//                   borderRadius: BorderRadius.circular(24.r),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(Icons.layers_outlined, size: 60.sp, color: AppColors.orangeColor),
//                     SizedBox(height: 20.h),
//                     BoldText(
//                       text: "No Phases Configured",
//                       fontSize: 24.sp,
//                       selectionColor: AppColors.orangeColor,
//                     ),
//                     SizedBox(height: 10.h),
//                     MainText(
//                       text: "This session doesn't have any phases configured yet.",
//                       fontSize: 18.sp,
//                       color: AppColors.teamColor,
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//             SizedBox(height: 20.h)
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildSessionInfoRow(String label, String value, IconData? icon) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         MainText(text: label, fontSize: 24.sp),
//         Row(
//           children: [
//             BoldText(
//               text: value,
//               fontSize: 22.sp,
//               selectionColor: AppColors.blueColor,
//             ),
//             if (icon != null) ...[
//               SizedBox(width: 10.w),
//               Icon(icon, size: 20.sp, color: AppColors.blueColor),
//             ],
//           ],
//         ),
//       ],
//     );
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
//     final minute = dateTime.minute.toString().padLeft(2, '0');
//     final amPm = dateTime.hour < 12 ? 'AM' : 'PM';
//     return '$hour:$minute $amPm';
//   }
// }