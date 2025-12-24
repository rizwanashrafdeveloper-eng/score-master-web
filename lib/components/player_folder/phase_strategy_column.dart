import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/controller/game_select_controller.dart';
import 'package:scorer_web/widgets/custom_stratgy_container.dart';

class PhaseStrategyColumn extends StatelessWidget {
  const PhaseStrategyColumn({
    super.key,
    required this.controller,
  });

  final GameSelectController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questionData = controller.questionController.questionData.value;

      if (questionData == null) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20.h),
            child: Text("Loading phases..."),
          ),
        );
      }

      final phases = questionData.phases;

      if (phases.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20.h),
            child: Text("no_phases_available".tr),
          ),
        );
      }

      return Column(
        children: List.generate(phases.length, (index) {
          final phase = phases[index];
          final phaseNumber = index + 1;
          final phaseTimeMin = (phase.timeDuration / 60).ceil();
          final isCurrentPhase = index == controller.currentPhase.value;
          final isPhaseComplete = controller.isCurrentPhaseComplete() && isCurrentPhase;
          final isPastPhase = index < controller.currentPhase.value;

          Color iconContainerColor;
          IconData icon;
          String text2;
          String text3;
          Color smallContainerColor;
          Color largeContainerColor;
          double value;

          if (isPastPhase || isPhaseComplete) {
            iconContainerColor = AppColors.forwardColor;
            icon = Icons.check;
            text2 = "Completed • $phaseTimeMin min";
            text3 = "completed".tr;
            smallContainerColor = AppColors.forwardColor;
            largeContainerColor = AppColors.forwardColor;
            value = 1.0;
          } else if (isCurrentPhase) {
            iconContainerColor = AppColors.selectLangugaeColor;
            icon = Icons.play_arrow_sharp;
            text2 = "Active • ${controller.remainingTime.value}";
            text3 = "active".tr;
            smallContainerColor = AppColors.selectLangugaeColor;
            largeContainerColor = AppColors.selectLangugaeColor;
            value = controller.timeProgress.value;
          } else {
            iconContainerColor = AppColors.watchColor;
            icon = Icons.watch_later;
            text2 = "Upcoming • $phaseTimeMin min";
            text3 = "pending".tr;
            smallContainerColor = AppColors.watchColor;
            largeContainerColor = AppColors.greyColor;
            value = 0.0;
          }

          return Column(
            children: [
              CustomStratgyContainer(
                value: value,
                iconContainer: iconContainerColor,
                icon: icon,
                text1: "Phase $phaseNumber: ${phase.name}",
                text2: text2,
                text3: text3,
                smallContainer: smallContainerColor,
                largeConatiner: largeContainerColor,
              ),
              SizedBox(height: 10.h),
            ],
          );
        }),
      );
    });
  }
}