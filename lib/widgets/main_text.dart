


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
class MainText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final Color? color;
  final double? height;
  final String? fontFamily;
  final VoidCallback? onTap;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final TextStyle? style;

  const MainText({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.height,
    this.color,
    this.fontFamily,
    this.onTap,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.style,
  });

  double _responsiveFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) return fontSize ?? 14;
    if (width < 1024) return fontSize ?? 16;
    return fontSize ?? 18;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.visible,
        softWrap: softWrap ?? true,
        textAlign: textAlign,
        textDirection: textDirection,
        style: style ??
            TextStyle(
              fontFamily: fontFamily ?? "refsan",
              fontWeight: fontWeight ?? FontWeight.w400,
              color: color ?? AppColors.languageColor,
              fontSize: _responsiveFontSize(context),
              height: height ?? 1.25,
              letterSpacing: -0.2,
            ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// // import 'package:scorer/constants/appcolors.dart';
// class MainText extends StatelessWidget {
//   final String text;
//   final double? fontSize;
//   final TextAlign? textAlign;
//   final Color? color;
//   final double? height;
//   final String? fontFamily;
//   final VoidCallback? onTap;
//   final FontWeight? fontWeight;
//   final int? maxLines;
//   final TextOverflow? overflow;
//   final bool? softWrap; // ✅ Optional softWrap
//   final TextDirection? textDirection; // ✅ Optional text direction
//   final TextStyle? style; // ✅ Optional complete style override
//
//   const MainText({
//     super.key,
//     required this.text,
//     this.fontSize,
//     this.textAlign,
//     this.height,
//     this.color,
//     this.fontFamily,
//     this.onTap,
//     this.fontWeight,
//     this.maxLines,
//     this.overflow,
//     this.softWrap, // ✅ NEW
//     this.textDirection, // ✅ NEW
//     this.style, // ✅ NEW
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Text(
//         text,
//         style: style ?? TextStyle( // ✅ Use provided style or create default
//           fontFamily: fontFamily ?? "refsan",
//           fontWeight: fontWeight ?? FontWeight.w400,
//           color: color ?? AppColors.languageColor,
//           fontSize: fontSize ?? 18.sp,
//           letterSpacing: -0.1,
//           height: height ?? 2.0.h,
//         ),
//         textAlign: textAlign,
//         softWrap: softWrap ?? true, // ✅ Use provided softWrap or default to true
//         overflow: overflow ?? TextOverflow.visible,
//         maxLines: maxLines,
//         textDirection: textDirection, // ✅ Use provided textDirection
//       ),
//     );
//   }
// }