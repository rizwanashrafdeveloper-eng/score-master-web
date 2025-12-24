import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart';

class CustomSloderRow extends StatelessWidget {
  final String text;
  final String text2;
  final double? fontSize;
  final double? height;
  final double? width;
  final double? value;
  final Color? color;
  final double? width1;
  final double? progress; // ✅ ADD THIS OPTIONAL PARAMETER

  const CustomSloderRow({
    super.key,
    required this.text,
    required this.text2,
    this.fontSize,
    this.height,
    this.width,
    this.value,
    this.color,
    this.width1,
    this.progress, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Use progress parameter if provided, otherwise use value or default
    final sliderValue = progress ?? value ?? 20;
    final sliderMax = progress != null ? 1.0 : 30.0; // If using progress (0-1), max is 1

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainText(
          text: text,
          fontSize: fontSize ?? 22.sp,
        ),
        Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: width ?? 175.w,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: height ?? 4.h,
                      activeTrackColor: color ?? AppColors.forwardColor,
                      inactiveTrackColor: AppColors.greyColor,
                      thumbColor: color ?? AppColors.forwardColor,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 6.w,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: sliderValue,
                      onChanged: (_) {},
                      min: 0,
                      max: sliderMax, // ✅ Use dynamic max based on progress/value
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: width1 ?? 10.w),
            MainText(
              text: text2,
              fontSize: fontSize ?? 20.sp,
            )
          ],
        )
      ],
    );
  }
}