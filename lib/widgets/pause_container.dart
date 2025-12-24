import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart';

class PauseContainer extends StatelessWidget {
  final Color? color;
  final IconData? icon;
  final String? svgPath;
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final String? loadingText;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;

  const PauseContainer({
    super.key,
    this.color,
    this.icon,
    this.svgPath,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.loadingText,
    this.margin,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: isLoading
            ? Colors.grey
            : (color ?? AppColors.selectLangugaeColor),
        borderRadius: BorderRadius.circular(100), // pill shape
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(100),
          child: IntrinsicWidth( // ✅ CONTENT-BASED WIDTH
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Center(
                child: isLoading
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    MainText(
                      text: loadingText ?? "Processing...",
                      color: Colors.white,
                      fontSize: fontSize ?? 14,
                    ),
                  ],
                )
                    : Row(
                  mainAxisSize: MainAxisSize.min, // ✅ SHRINK TO CONTENT
                  children: [
                    if (svgPath != null)
                      SvgPicture.asset(
                        svgPath!,
                        height: 18,
                        width: 18,
                        color: Colors.white,
                      )
                    else if (icon != null)
                      Icon(
                        icon,
                        size: 18,
                        color: Colors.white,
                      ),
                    if (icon != null || svgPath != null)
                      const SizedBox(width: 8),
                    MainText(
                      text: text,
                      color: Colors.white,
                      fontSize: fontSize ?? 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/widgets/main_text.dart';
//
// class PauseContainer extends StatelessWidget {
//   final Color? color;
//   final IconData? icon;
//   final String? svgPath;
//   final String text;
//   final double? height;
//   final double? width;
//   final VoidCallback? onTap;
//   final double? fontSize;
//   final bool isLoading;
//   final String? loadingText;
//   final bool isFullWidth; // ✅ NEW: Make container full width of parent
//   final double? maxWidth; // ✅ NEW: Maximum width constraint
//   final EdgeInsetsGeometry? margin; // ✅ NEW: Custom margin
//
//   const PauseContainer({
//     super.key,
//     this.color,
//     this.icon,
//     this.svgPath,
//     this.text = "",
//     this.height,
//     this.width,
//     this.onTap,
//     this.fontSize,
//     this.isLoading = false,
//     this.loadingText,
//     this.isFullWidth = false, // ✅ NEW: Default to false
//     this.maxWidth,
//     this.margin,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 600;
//     final isTablet = screenWidth < 1024 && screenWidth >= 600;
//
//     return Container(
//       margin: margin,
//       constraints: BoxConstraints(
//         maxWidth: maxWidth ?? (isFullWidth ? double.infinity : 500.w),
//       ),
//       height: height ?? (isMobile ? 60.h : isTablet ? 70.h : 80.h),
//       width: width ?? (isFullWidth ? double.infinity : (isMobile ? 200.w : isTablet ? 250.w : 287.w)),
//       child: GestureDetector(
//         onTap: isLoading ? null : onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             color: isLoading
//                 ? Colors.grey
//                 : (color ?? AppColors.selectLangugaeColor),
//             borderRadius: BorderRadius.circular(
//               isMobile ? 20.r : isTablet ? 24.r : 28.r,
//             ),
//           ),
//           child: Center(
//             child: isLoading
//                 ? Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: isMobile ? 16.w : 20.w,
//                   height: isMobile ? 16.h : 20.h,
//                   child: CircularProgressIndicator(
//                     strokeWidth: isMobile ? 1.5.w : 2.w,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: isMobile ? 6.w : 8.w),
//                 Flexible(
//                   child: MainText(
//                     text: loadingText ?? "Processing...",
//                     color: AppColors.whiteColor,
//                     fontSize: (fontSize ?? (isMobile ? 20.sp : isTablet ? 24.sp : 28.sp)),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             )
//                 : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (svgPath != null) ...[
//                   SvgPicture.asset(
//                     svgPath!,
//                     height: isMobile ? 12.h : 16.h,
//                     width: isMobile ? 12.w : 16.w,
//                     color: AppColors.whiteColor,
//                   ),
//                   SizedBox(width: isMobile ? 6.w : 8.w),
//                 ] else if (icon != null) ...[
//                   Icon(
//                     icon,
//                     color: AppColors.whiteColor,
//                     size: isMobile ? 24.sp : 40.sp,
//                   ),
//                   SizedBox(width: isMobile ? 4.w : 5.w),
//                 ],
//                 Flexible(
//                   child: MainText(
//                     text: text,
//                     color: AppColors.whiteColor,
//                     fontSize: (fontSize ?? (isMobile ? 20.sp : isTablet ? 24.sp : 28.sp)),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
