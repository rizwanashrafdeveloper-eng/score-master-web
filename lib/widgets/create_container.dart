import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';

class CreateContainer extends StatelessWidget {
  final String? text;
  final double? height;
  final Color? borderColor;
  final Color? containerColor;
  final Color? textColor;
  final double? width;
  final double? right;
  final double? top;
  final double? arrowh;
  final double? arrowW;
  final double? fontsize2;
  final double? borderW;
  final bool ishow;
  final VoidCallback? onTap;
  final bool? isSmallScreen;
  final bool? isFullWidth; // ✅ NEW: Allow container to take full width
  final double? maxWidth; // ✅ NEW: Maximum width constraint
  final double? minWidth; // ✅ NEW: Minimum width constraint
  final EdgeInsetsGeometry? padding; // ✅ NEW: Custom padding
  final MainAxisAlignment? contentAlignment; // ✅ NEW: Content alignment
  final double? borderRadius; // ✅ NEW: Custom border radius
  final BoxConstraints? constraints; // ✅ NEW: Additional constraints

  const CreateContainer({
    super.key,
    this.text,
    this.height,
    this.width,
    this.borderColor,
    this.containerColor,
    this.textColor,
    this.right,
    this.ishow = true,
    this.top,
    this.fontsize2,
    this.arrowh,
    this.arrowW,
    this.borderW,
    this.onTap,
    this.isSmallScreen,
    this.isFullWidth = false, // ✅ NEW
    this.maxWidth,
    this.minWidth,
    this.padding,
    this.contentAlignment = MainAxisAlignment.center, // ✅ NEW
    this.borderRadius,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive dimensions based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth < 1024 && screenWidth >= 600;

    // Responsive sizing logic
    final responsiveWidth = width ?? (isMobile
        ? 250.w
        : isTablet ? 300.w : 400.w);

    final responsiveHeight = height ?? (isMobile
        ? 60.h
        : isTablet ? 70.h : 80.h);

    final responsiveFontSize = fontsize2 ?? (isMobile
        ? 24.sp
        : isTablet ? 32.sp : 42.sp);

    final responsiveArrowHeight = arrowh ?? (isMobile
        ? 40.h
        : isTablet ? 55.h : 69.h);

    final responsiveArrowWidth = arrowW ?? (isMobile
        ? 50.w
        : isTablet ? 65.w : 83.w);

    final responsiveTop = top ?? (isMobile
        ? -25.h
        : isTablet ? -40.h : -50.h);

    final responsiveRight = right ?? (isMobile
        ? -10.w
        : isTablet ? -15.w : -20.w);

    final responsiveBorderWidth = borderW ?? (isMobile
        ? 2.w
        : isTablet ? 3.w : 4.05.w);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: constraints ?? BoxConstraints(
          maxWidth: maxWidth ?? (isFullWidth! ? double.infinity : 600.w),
          minWidth: minWidth ?? 130.w,
        ),
        width: isFullWidth! ? double.infinity : responsiveWidth,
        height: responsiveHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
                color: containerColor ?? AppColors.createColor,
                border: Border.all(
                  color: borderColor ?? AppColors.createBorderColor,
                  width: responsiveBorderWidth,
                ),
              ),
              child: Padding(
                padding: padding ?? EdgeInsets.symmetric(
                  horizontal: isMobile ? 8.w : isTablet ? 12.w : 20.w,
                ),
                child: Row(
                  mainAxisAlignment: contentAlignment!,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text ?? "create".tr,
                          style: TextStyle(
                            fontFamily: "gotham",
                            fontSize: responsiveFontSize.clamp(14.sp, 48.sp),
                            color: textColor ?? AppColors.createBorderColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (ishow)
              Positioned(
                top: responsiveTop,
                right: responsiveRight,
                child: SvgPicture.asset(
                  Appimages.arrowdown,
                  height: responsiveArrowHeight,
                  width: responsiveArrowWidth,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
//
// class CreateContainer extends StatelessWidget {
//   final String? text;
//   final double? height;
//   final Color? borderColor;
//   final Color? containerColor;
//   final Color? textColor;
//   final double? width;
//   final double? right;
//   final double? top;
//   final double? arrowh;
//   final double? arrowW;
//   final double? fontsize2;
//   final double? borderW;
//   final bool ishow;
//   final VoidCallback? onTap; // ✅ ADD THIS
//   final bool? isSmallScreen;
//   const CreateContainer({
//     super.key,
//     this.text,
//     this.height,
//     this.width,
//     this.borderColor,
//     this.containerColor,
//     this.textColor,
//     this.right,
//     this.ishow = true,
//     this.top,
//     this.fontsize2,
//     this.arrowh,
//     this.arrowW,
//     this.borderW,
//     this.onTap, this.isSmallScreen, // ✅ ADD THIS
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap, // ✅ ADD GESTURE DETECTOR
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             width: (width ?? 431).w,
//             height: (height ?? 100).h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(80),
//               color: containerColor ?? AppColors.createColor,
//               border: Border.all(
//                   color: borderColor ?? AppColors.createBorderColor,
//                   width: borderW ?? 4.05.w
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Center(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       text ?? "create".tr,
//                       style: TextStyle(
//                         fontFamily: "gotham",
//                         fontSize: fontsize2 ?? 42.sp,
//                         color: textColor ?? AppColors.createBorderColor,
//                       ),
//                     ),
//                   )
//               ),
//             ),
//           ),
//           ishow
//               ? Positioned(
//             top: top ?? -50.h,
//             right: (right ?? -20).w,
//             child: SvgPicture.asset(
//               Appimages.arrowdown,
//               height: arrowh ?? 69.h,
//               width: arrowW ?? 83.w,
//             ),
//           )
//               : SizedBox()
//         ],
//       ),
//     );
//   }
// }