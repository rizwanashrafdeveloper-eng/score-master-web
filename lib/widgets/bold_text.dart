import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';

class BoldText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? selectionColor;
  final TextAlign? textAlign;
  final String? fontFamily;
  final double? height;
  final int? maxLines; // ✅ Added maxLines parameter
  final TextOverflow? overflow; // ✅ Added overflow parameter

  const BoldText({
    super.key,
    required this.text,
    this.selectionColor,
    this.textAlign,
    this.fontSize,
    this.height,
    this.fontFamily,
    this.maxLines, // ✅ Added to constructor
    this.overflow, // ✅ Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily ?? "giory",
        fontSize: fontSize ?? 22.sp,
        letterSpacing: -0.3,
        fontWeight: FontWeight.w400,
        height: height,
        color: selectionColor ?? AppColors.languageTextColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines, // ✅ Pass maxLines to Text widget
      overflow: overflow, // ✅ Pass overflow to Text widget
    );
  }
}