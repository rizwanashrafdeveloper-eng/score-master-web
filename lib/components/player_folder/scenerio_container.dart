import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';

class ScenerioContainer extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;

  const ScenerioContainer({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 480.h,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            BoldText(
              text: "scenario".tr,
              selectionColor: AppColors.blueColor,
              fontSize: fontSize ?? 30.sp,
            ),
            SizedBox(height: 15.h),
            MainText(
              height: 1.5,
              text: text,
              fontSize: (fontSize ?? 30.sp) - 6.sp, // Slightly smaller than title
            ),
          ],
        ),
      ),
    );
  }
}