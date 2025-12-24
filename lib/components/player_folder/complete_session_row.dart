import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/controller/game_select_controller.dart';
import 'package:scorer_web/widgets/main_text.dart';

class CompleteSessionRow extends StatelessWidget {
  const CompleteSessionRow({
    super.key,
    required this.controller,
  });

  final GameSelectController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questionData = controller.questionController.questionData.value;

      if (questionData == null) {
        return const SizedBox.shrink();
      }

      final phases = questionData.phases;
      final currentPhase = controller.currentPhase.value;

      if (phases.isEmpty) {
        return const SizedBox.shrink();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < phases.length; i++) ...[
            Container(
              height: 30.w,
              width: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < currentPhase || (i == currentPhase && controller.isCurrentPhaseComplete())
                    ? AppColors.forwardColor
                    : i == currentPhase
                    ? AppColors.orangeColor
                    : AppColors.greyColor,
              ),
              child: Center(
                child: i < currentPhase || (i == currentPhase && controller.isCurrentPhaseComplete())
                    ? Icon(
                  Icons.check,
                  size: 20.w,
                  color: AppColors.whiteColor,
                )
                    : MainText(
                  text: "${i + 1}",
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                ),
              ),
            ),

            if (i < phases.length - 1)
              Expanded(
                child: Container(
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 7.w),
                  decoration: BoxDecoration(
                    color: i < currentPhase ? AppColors.forwardColor : AppColors.greyColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
          ],
        ],
      );
    });
  }
}