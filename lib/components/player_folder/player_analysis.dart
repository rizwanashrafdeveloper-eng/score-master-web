import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';

class PlayerAnalyasis extends StatelessWidget {
  const PlayerAnalyasis({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 27.h),
                BoldText(
                  text: "ai_analysis_suggestion".tr,
                  fontSize: 30.sp,
                  selectionColor: AppColors.blueColor,
                ),
                SizedBox(height: 28.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -10.w,
                      top: -10.h,
                      child: SvgPicture.asset(Appimages.arrowdown),
                    ),
                    Image.asset(Appimages.ai2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoldText(
                      text: "relevance_score".tr,
                      fontSize: 30.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                    UseableContainer(
                      text: "78",
                      fontFamily: "giory",
                      fontSize: 24.sp,
                      //width: 45.w,
                     // height: 40.h,
                      color: AppColors.orangeColor,
                    )
                  ],
                ),
                MainText(
                  text: "Response directly addresses the prompt with clear objective and actionable strategies.".tr,
                  fontSize: 20.sp,
                  height: 1.3,
                ),
                SizedBox(height: 10.h),
                Divider(
                  color: AppColors.greyColor,
                  thickness: 1.w,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoldText(
                      text: "quality_assessment".tr,
                      fontSize: 30.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                    UseableContainer(
                      text: "high".tr,
                      fontSize: 24.sp,
                    //  width: 80.w,
//height: 40.h,
                      color: AppColors.forwardColor,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                MainText(
                  text:
                      "Well-structured response with specific metrics and measurable outcomes.",
                  fontSize: 20.sp,
                  height: 1.3,
                )
              ],
            ),
          ),
          Positioned(
            bottom: -100.h,
            left: 70.w,
            right: 70.w,
            child: Container(
              height: 230.w,
              width: 230.w,
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
                      text: "89/100",
                      fontSize: 35.sp,
                      selectionColor: AppColors.createBorderColor,
                    ),
                    SizedBox(height: 4.h),
                    BoldText(
                      text: "final_score".tr,
                      fontSize: 25.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
