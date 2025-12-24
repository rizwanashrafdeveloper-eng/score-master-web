import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';

class MetricesContainer extends StatelessWidget {
  const MetricesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.7.w),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25.h),
            BoldText(
              text: "engagement_metrics".tr,
              fontSize: 24.sp,
              selectionColor: AppColors.blueColor,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    BoldText(
                      text: "85%",
                      fontSize: 36.sp,
                      selectionColor: AppColors.forwardColor,
                    ),
                    BoldText(
                      text: "participation".tr,
                      fontSize: 22.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ],
                ),
                Column(
                  children: [
                    BoldText(
                      text: "92%",
                      fontSize: 36.sp,
                      selectionColor: AppColors.forwardColor,
                    ),
                    BoldText(
                      text: "accuracy".tr,
                      fontSize: 22.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25.h),
            LinearProgressIndicator(
              value: 0.85,
              minHeight: 8.h,
              color: AppColors.forwardColor,
              backgroundColor: AppColors.greyColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  text: "active_players".tr,
                  fontSize: 20.sp,
                ),
                BoldText(
                  text: "10/12",
                  fontSize: 22.sp,
                  selectionColor: AppColors.blueColor,
                )
              ],
            ),
            SizedBox(height: 20.h),
            LinearProgressIndicator(
              value: 10 / 12,
              minHeight: 8.h,
              color: AppColors.forwardColor,
              backgroundColor: AppColors.greyColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  text: "avg_response_time".tr,
                  fontSize: 20.sp,
                ),
                BoldText(
                  text: "32s",
                  fontSize: 22.sp,
                  selectionColor: AppColors.blueColor,
                )
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}