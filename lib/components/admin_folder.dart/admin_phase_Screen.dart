import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scorer_web/components/facilitator_folder/phases_container.dart';
import 'package:scorer_web/components/facilitator_folder/real_time_monitor_Container.dart';
import 'package:scorer_web/components/facilitator_folder/stages_row.dart';
import 'package:scorer_web/components/facilitator_folder/team_progress_container.dart';
import 'package:scorer_web/components/responsive_fonts.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/controller/stage_controller.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_stratgy_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/pause_container.dart';
import 'package:scorer_web/widgets/useable_text_row.dart';

// Import API controllers
import '../../api/api_controllers/add_phase_controller.dart';
import '../../api/api_controllers/game_format_phase.dart';

class AdminPhaseScreen extends StatelessWidget {
  final StageController stageController = Get.put(StageController());
  final AddPhaseController addPhaseController = Get.put(AddPhaseController());
  final GameFormatPhaseController gameFormatController = Get.put(GameFormatPhaseController());

  final int? sessionId;

  AdminPhaseScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    // Initialize phase controller with session ID
    if (sessionId != null && gameFormatController.sessionId.value == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameFormatController.setSessionId(sessionId!);
      });
    }

    return Obx(() {
      if (gameFormatController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (gameFormatController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 60.sp, color: Colors.red),
              SizedBox(height: 20.h),
              Text(
                gameFormatController.errorMessage.value,
                style: TextStyle(fontSize: 22.sp, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              LoginButton(
                text: "Retry",
                fontSize: 20.sp,
                onTap: () => gameFormatController.refreshPhases(),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Center(
              child: CreateContainer(
                text: gameFormatController.currentPhase?.name ?? "Current Phase",
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

            // Current Phase Timer (Dynamic from API)
            Center(
              child: CircularPercentIndicator(
                radius: 120.r,
                lineWidth: 5.0,
                percent: gameFormatController.currentPhaseProgress,
                animation: true,
                animationDuration: 500,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
                progressColor: AppColors.forwardColor,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoldText(
                      text: gameFormatController.getRemainingTime(
                          gameFormatController.currentPhase?.timeDuration ?? 0
                      ),
                      fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 40.sp,
                          smallSize: 18
                      ),
                      selectionColor: AppColors.blueColor,
                    ),
                    MainText(
                      text: "remaining".tr,
                      fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 28.sp,
                          smallSize: 12
                      ),
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Dynamic Phases Row (Horizontal Scroll - like mobile app)
            Obx(() {
              final phases = gameFormatController.allPhases;
              if (phases.isEmpty) {
                return Container(
                  height: 150.h,
                  margin: EdgeInsets.symmetric(horizontal: 50.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: AppColors.greyColor),
                  ),
                  child: Center(
                    child: MainText(
                      text: "No phases available",
                      fontSize: 22.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 200.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  itemCount: phases.length,
                  itemBuilder: (context, index) {
                    final phase = phases[index];
                    final isCurrent = index == gameFormatController.currentPhaseIndex.value;
                    final isCompleted = index < gameFormatController.currentPhaseIndex.value;
                    final isPending = index > gameFormatController.currentPhaseIndex.value;

                    return Container(
                      width: 180.w,
                      margin: EdgeInsets.only(right: index < phases.length - 1 ? 10.w : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: isCompleted
                            ? AppColors.forwardColor
                            : (isCurrent ? AppColors.orangeColor : Colors.transparent),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.orangeColor
                              : (isCompleted ? AppColors.forwardColor : AppColors.greyColor),
                          width: 1.7.w,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? AppColors.whiteColor
                                  : (isCurrent ? AppColors.orangeColor : AppColors.greyColor),
                              border: Border.all(
                                color: isCompleted ? AppColors.forwardColor : Colors.transparent,
                                width: 1.5.w,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? Icon(
                                Icons.check,
                                color: AppColors.forwardColor,
                                size: 35.sp,
                              )
                                  : MainText(
                                text: "${index + 1}",
                                fontSize: 30.sp,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: BoldText(
                              text: phase.name ?? "Phase ${index + 1}",
                              fontSize: 20.sp,
                              selectionColor: isCompleted
                                  ? AppColors.whiteColor
                                  : (isCurrent ? AppColors.orangeColor : AppColors.greyColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (isCompleted || isCurrent) ...[
                            SizedBox(height: 10.h),
                            MainText(
                              text: "${phase.timeDuration ?? 0} min",
                              fontSize: 18.sp,
                              color: isCompleted ? AppColors.whiteColor : AppColors.orangeColor,
                            ),
                          ],
                          SizedBox(height: 20.h),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),

            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar for current phase
                  Obx(() {
                    final totalPhases = gameFormatController.totalPhasesCount;
                    final currentIndex = gameFormatController.currentPhaseIndex.value;
                    final progress = totalPhases > 0 ? (currentIndex + 1) / totalPhases : 0.0;

                    return LinearProgressIndicator(
                      value: progress,
                      minHeight: 8.h,
                      color: AppColors.selectLangugaeColor,
                      backgroundColor: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(10.r),
                    );
                  }),

                  SizedBox(height: 20.h),

                  Obx(() {
                    final currentPhase = gameFormatController.currentPhase;
                    final timeRemaining = currentPhase != null
                        ? gameFormatController.getRemainingTime(currentPhase.timeDuration ?? 0)
                        : "00:00";

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoldText(
                          fontSize: 24.sp,
                          text: timeRemaining,
                          selectionColor: AppColors.blueColor,
                        ),
                        MainText(
                          fontSize: 22.sp,
                          text: "remaining".tr,
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 30.h),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: PauseContainer(
                          onTap: () => gameFormatController.previousPhase(),
                          text: "back".tr,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: PauseContainer(
                          onTap: () => gameFormatController.nextPhase(),
                          text: "assign_score".tr,
                          icon: Icons.fast_forward,
                          color: AppColors.assignColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Team Progress Container
                  TeamProgressContainer(sessionId: sessionId),

                  SizedBox(height: 20.h),

                  RealTimeMonitorContainer(),

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
                      Obx(() => BoldText(
                        text: "${gameFormatController.totalPhasesCount} Phases",
                        fontSize: 22.sp,
                        selectionColor: AppColors.greyColor,
                      )),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Dynamic Phases List from API
                  Obx(() {
                    final phases = gameFormatController.allPhases;

                    if (phases.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyColor),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: MainText(
                            text: "No phases available",
                            fontSize: 22.sp,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: phases.asMap().entries.map((entry) {
                        final index = entry.key;
                        final phase = entry.value;

                        return Column(
                          children: [
                            CustomStratgyContainer(
                              value: gameFormatController.currentPhaseIndex.value / gameFormatController.totalPhasesCount,
                              iconContainer: gameFormatController.getPhaseStatusColor(index),
                              icon: gameFormatController.getPhaseStatusIcon(index),
                              text1: phase.name ?? "Phase ${phase.order}",
                              text2: "${phase.description ?? ''} • ${phase.timeDuration} min",
                              text3: gameFormatController.getPhaseStatus(index),
                              smallContainer: gameFormatController.getPhaseStatusColor(index),
                              largeConatiner: gameFormatController.getPhaseStatusColor(index),
                              flex: index > gameFormatController.currentPhaseIndex.value ? 4 : 3,
                              flex1: 0,
                            ),
                            if (index < phases.length - 1) SizedBox(height: 10.h),
                          ],
                        );
                      }).toList(),
                    );
                  }),

                  SizedBox(height: 30.h),

                  // Session Timeline (Dynamic from API)
                  Obx(() {
                    final totalDuration = gameFormatController.totalTimeDuration;
                    final elapsedSeconds = gameFormatController.allPhases
                        .asMap()
                        .entries
                        .where((entry) => entry.key < gameFormatController.currentPhaseIndex.value)
                        .fold(0, (sum, entry) => sum + (entry.value.timeDuration ?? 0) * 60) +
                        (gameFormatController.currentPhase?.timeDuration ?? 0) * 60 -
                        gameFormatController.remainingSeconds.value;
                    final progress = totalDuration > 0 ? (elapsedSeconds / (totalDuration * 60)).clamp(0.0, 1.0) : 0.0;
                    final sessionStart = DateTime.now().subtract(Duration(seconds: elapsedSeconds));
                    final currentTime = DateTime.now();
                    final estimatedEnd = sessionStart.add(Duration(minutes: totalDuration));

                    return Container(
                      width: double.infinity,
                      height: 300.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyColor, width: 1.5.w),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 31.h),
                            BoldText(
                              text: "Session Timeline",
                              fontSize: 32.sp,
                              selectionColor: AppColors.blueColor,
                            ),
                            SizedBox(height: 20.h),
                            UseableTextrow(
                              color: AppColors.forwardColor,
                              text: "Session Start: ${sessionStart.hour}:${sessionStart.minute.toString().padLeft(2, '0')} ${sessionStart.hour >= 12 ? 'PM' : 'AM'}",
                            ),
                            UseableTextrow(
                              color: AppColors.forwardColor2,
                              text: "Current Time: ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')} ${currentTime.hour >= 12 ? 'PM' : 'AM'}",
                            ),
                            UseableTextrow(
                              color: AppColors.forwardColor3,
                              text: "Estimated End: ${estimatedEnd.hour}:${estimatedEnd.minute.toString().padLeft(2, '0')} ${estimatedEnd.hour >= 12 ? 'PM' : 'AM'}",
                            ),
                            SizedBox(height: 20.h),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 8.h,
                              color: AppColors.forwardColor,
                              backgroundColor: AppColors.greyColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainText(
                                  text: "${(progress * 100).toStringAsFixed(0)}% Complete",
                                  fontSize: 24.sp,
                                ),
                                BoldText(
                                  text: "${((totalDuration * 60 - elapsedSeconds) / 60).toStringAsFixed(0)} minutes remaining",
                                  fontSize: 24.sp,
                                  selectionColor: AppColors.blueColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 50.h),

                  Center(
                    child: LoginButton(
                      fontSize: 20.sp,
                      text: "add_phases".tr,
                      ishow: true,
                      icon: Icons.add,
                      onTap: () {
                        Get.snackbar(
                          'Info',
                          'Add phases feature coming soon',
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Center(
                    child: LoginButton(
                      fontSize: 22.sp,
                      text: "view_responses".tr,
                      color: AppColors.forwardColor,
                      ishow: true,
                      image: Appimages.eye,
                      onTap: () {
                        try {
                          Get.toNamed(
                            RouteName.viewResponsesScreen,
                            arguments: {
                              'sessionId': sessionId ?? gameFormatController.sessionId.value,
                              'phaseId': gameFormatController.currentPhase?.id ?? 1,
                              'role': 'facilitator',
                            },
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to navigate to responses screen: $e',
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      },
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
}