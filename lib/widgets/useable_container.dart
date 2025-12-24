import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart';

class UseableContainer extends StatelessWidget {
  final String text;
  final Color? color;
  final double? height;
  final double? width;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
  final bool isSmallScreen;
  final double? maxWidth; // ✅ NEW: Maximum width constraint
  final double? minHeight; // ✅ NEW: Minimum height constraint
  final EdgeInsetsGeometry? padding; // ✅ NEW: Custom padding
  final BoxConstraints? constraints; // ✅ NEW: Additional constraints

  const UseableContainer({
    super.key,
    this.color,
    required this.text,
    this.height,
    this.width,
    this.textColor,
    this.fontFamily,
    this.fontSize,
    this.isSmallScreen = false,
    this.maxWidth,
    this.minHeight,
    this.padding,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      constraints: constraints ?? BoxConstraints(
        maxWidth: maxWidth ?? (isSmallScreen ? 200.w : 300.w),
        minHeight: minHeight ?? (isSmallScreen ? 35.h : 42.h),
      ),
      width: width ?? (isMobile
          ? 100.w
          : isSmallScreen ? 129.w : 150.w),
      height: height ?? (isMobile
          ? 35.h
          : isSmallScreen ? 42.h : 48.h),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8.w : 12.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80.r),
        color: color,
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: MainText(
            text: text,
            fontFamily: fontFamily ?? "abz",
            fontSize: (fontSize ?? (isMobile
                ? 12.sp
                : isSmallScreen ? 14.sp : 18.sp)).clamp(10.sp, 22.sp).toDouble(),
            color: textColor ?? AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/widgets/main_text.dart';
//
// class UseableContainer extends StatelessWidget {
//   final String text;
//   final Color? color;
//   final double? height;
//   final double? width;
//   final Color? textColor;
//   final String? fontFamily;
//   final double? fontSize;
//
//   const UseableContainer({
//     super.key,
//     this.color,
//     required this.text,
//     this.height,
//     this.width,
//     this.textColor,
//     this.fontFamily,
//     this.fontSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Container(
//       width: (width ?? 129.w) .w,
//       height: (height ?? 42.h) .h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(80 .r),
//         color: color,
//       ),
//       child: Center(
//         child: MainText(
//           text: text,
//           fontFamily: fontFamily ?? "abz",
//           fontSize: (fontSize ?? 18) .sp,
//           color: textColor ?? AppColors.whiteColor,
//         ),
//       ),
//     );
//   }
// }



