
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';

class CustomStratgyContainer extends StatelessWidget {
  final double? value;
  final Color iconContainer;
  final IconData icon;
  final String text1;
  final String text2;
  final String text3;
  final Color smallContainer;
  final Color largeConatiner;
  final Color? borderColor;
  final double? width1;
  final double? width2;
  final double? width3;
  final double? containerHeight;
  final bool isshow;
  final double? containerWidth;
  final double? spaceHeight;
  final String? extra;
  final double? fontSize;
  final double? mainHeight;
  final double? spaceHeight2;
  final int? flex1;
  final int? flex;
  final double? fontSize2;
  final double? fontSize3;
  final double? circleH;
  final double? circleW;
  final double? circleS;

  const CustomStratgyContainer({
    super.key,
    required this.iconContainer,
    required this.icon,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.smallContainer,
    required this.largeConatiner,
    this.borderColor,
    this.width1,
    this.width2,
    this.width3,
    this.containerHeight,
    this.containerWidth,
    this.isshow = false,
    this.spaceHeight,
    this.extra,
    this.fontSize,
    this.mainHeight,
    this.spaceHeight2,
    this.flex1,
    this.flex,
    this.fontSize2,
    this.fontSize3,
    this.circleH,
    this.circleW,
    this.circleS,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth ?? double.infinity,
      height: containerHeight ?? 150.h,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Container(
                        width: circleW ?? 30.w,
                        height: circleH ?? 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconContainer,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.whiteColor,
                          size: circleS ?? 19.2.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 7.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(text: text1, fontSize: fontSize2 ?? 24.sp),
                        SizedBox(height: 10.h),
                        MainText(text: text2, fontSize: 20.sp, color: AppColors.teamColor, height: 1),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: smallContainer,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      text3,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isshow) SizedBox(height: spaceHeight ?? 5.h),
            if (isshow)
              MainText(
                text: extra ?? "",
                height: mainHeight,
                fontSize: fontSize ?? 14.sp,
              ),
            SizedBox(height: spaceHeight2 ?? 25.h),
            LinearProgressIndicator(
              value: value ?? 0.4,
              minHeight: 8.h,
              color: largeConatiner ?? AppColors.forwardColor,
              backgroundColor: AppColors.greyColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ],
        ),
      ),
    );
  }
}