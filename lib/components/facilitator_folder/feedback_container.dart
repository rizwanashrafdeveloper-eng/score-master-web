// lib/components/facilitator_folder/feedback_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';

class FeedbackContainer extends StatelessWidget {
  final bool ishow;
  final int? finalScore;
  final String? feedback;

  const FeedbackContainer({
    super.key,
    this.ishow = false,
    this.finalScore,
    this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 470.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: AppColors.greyColor, width: 1.7),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                BoldText(
                  text: "AI Feedback",
                  fontSize: 32.sp,
                  selectionColor: AppColors.languageTextColor,
                ),
                SizedBox(height: 20.h),
                MainText(
                  text: feedback ??
                      "Excellent strategic thinking with a comprehensive digital transformation approach. The timeline is realistic and the three-phase implementation shows strong project management skills. Great work on considering both technical and human aspects.",
                  fontSize: 28.sp,
                  height: 1.3,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -160.h,
          left: 0,
          right: 0,
          child: Container(
            height: 270.h,
            width: 270.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.forwardColor,
                  Colors.grey.shade200,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 202, 202, 202),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoldText(
                    text: "${finalScore ?? 89}/100",
                    fontSize: 37.sp,
                    selectionColor: AppColors.createBorderColor,
                  ),
                  SizedBox(height: 4.h),
                  BoldText(
                    text: "final_score".tr,
                    fontSize: 28.sp,
                    selectionColor: AppColors.blueColor,
                  )
                ],
              ),
            ),
          ),
        ),
        if (ishow)
          Positioned(
            top: -175.h,
            left: 380.w,
            child: SvgPicture.asset(
              Appimages.arrowdown,
              height: 38.h,
              width: 31.w,
            ),
          ),
        if (ishow)
          Positioned(
            top: -170.h,
            left: 110.w,
            right: 110.w,
            child: Image.asset(
              Appimages.ai2,
              height: 116.h,
              width: 115.w,
            ),
          ),
      ],
    );
  }
}