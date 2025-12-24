import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart';

class UseableTextrow extends StatelessWidget {
  final Color color;
  final String text;
  final String? text1;
  final double? height;
  final bool ishow;
  final double? fontsize11;
  final double? fontSize;
  const UseableTextrow({
    super.key,
    required this.color,
    required this.text,
    this.text1,
    this.height,
    this.ishow = false,
    this.fontsize11,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // All dimensions are now based on flutter_screenutil
    final double dotSize = 13.w;
    final double horizontalSpace = 10.w;
    final double fontSize = 20.sp;
    final double fontSize1 = 16.sp;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ishow
                ? Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.forwardColor,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: AppColors.whiteColor,
                        size: 10.w,
                      ),
                    ),
                  )
                : Container(
                    height: dotSize,
                    width: dotSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
            SizedBox(width: horizontalSpace),
            MainText(
              text: text,
              color: AppColors.teamColor,
              fontSize: fontsize11 ?? fontSize,
              height: height ?? 1,
            )
          ],
        ),
        MainText(
          text: text1 ?? "",
          fontSize: fontSize1,
        )
      ],
    );
  }
}
