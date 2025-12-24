import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/create_container.dart';

class AddOneContainer extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final double? height;
  final double? width;
  final double? height1;
  final double? width1;
  final double? height2;
  final double? width2;
  final VoidCallback? onTap;
  final bool isShow;
  final double? top;
  final double? right;
  final double? height3;
  final double? width3;
  final double? borderW;
  final double? arrowH;
  final double? arrowW;
  final String? text;
  final double? right2;
  final double? padding1;
  final bool? isSmallScreen;
  final double? minSize;
  final double? maxSize;
  final BoxConstraints? constraints;
  final Color? plusColor;
  final Color? forwardColor;
  final Color? iconColor;

  const AddOneContainer({
    super.key,
    this.icon,
    this.svgPath,
    this.height,
    this.width,
    this.height1,
    this.width1,
    this.height2,
    this.width2,
    this.onTap,
    this.isShow = false,
    this.top,
    this.right,
    this.height3,
    this.width3,
    this.borderW,
    this.arrowH,
    this.arrowW,
    this.text,
    this.right2,
    this.padding1,
    this.isSmallScreen,
    this.minSize = 60,
    this.maxSize = 120,
    this.constraints,
    this.plusColor,
    this.forwardColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine device type
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth < 1024 && screenWidth >= 600;
    final isSmallHeight = screenHeight < 700;

    // Calculate responsive sizes
    final containerSize = isMobile
        ? (isSmallHeight ? 70.w : 80.w)
        : isTablet ? 90.w : 101.w;

    final innerContainerSize = containerSize * 0.68; // 68% of outer container
    final iconSize = innerContainerSize * 0.49; // 49% of inner container

    // Responsive calculations
    final responsiveHeight1 = height1 ?? containerSize;
    final responsiveWidth1 = width1 ?? containerSize;
    final responsiveHeight2 = height2 ?? innerContainerSize;
    final responsiveWidth2 = width2 ?? innerContainerSize;
    final responsiveIconHeight = height ?? iconSize;
    final responsiveIconWidth = width ?? iconSize;

    // Calculate responsive CreateContainer dimensions
    final createContainerHeight = height3 ?? (isMobile ? 45.h : isTablet ? 55.h : 61.h);
    final createContainerWidth = width3 ?? (isMobile ? 80.w : isTablet ? 90.w : 102.w);
    final createContainerTop = top ?? (isMobile ? -20.h : isTablet ? -25.h : -28.h);
    final createContainerRight = right ?? (isMobile ? -35.w : isTablet ? -45.w : -50.w);
    final createContainerArrowH = arrowH ?? (isMobile ? 30.h : isTablet ? 35.h : 40.h);
    final createContainerArrowW = arrowW ?? (isMobile ? 25.w : isTablet ? 30.w : 33.w);
    final createContainerBorderW = borderW ?? (isMobile ? 1.5.w : isTablet ? 1.8.w : 1.97.w);
    final createContainerRight2 = right2 ?? (isMobile ? -15.w : isTablet ? -25.w : -30.w);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: constraints?.maxWidth ?? responsiveWidth1 + (isShow ? createContainerWidth * 0.3 : 0),
        height: constraints?.maxHeight ?? responsiveHeight1 + (isShow ? createContainerHeight * 0.3 : 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // CreateContainer (when isShow is true)
            if (isShow)
              Positioned(
                bottom: -createContainerHeight * 0.6,
                right: createContainerRight2,
                child: CreateContainer(
                  top: createContainerTop,
                  right: createContainerRight,
                  text: text ?? "Add",
                  height: createContainerHeight,
                  width: createContainerWidth,
                  borderW: createContainerBorderW,
                  arrowW: createContainerArrowW,
                  arrowh: createContainerArrowH,
                  fontsize2: isMobile ? 20.sp : isTablet ? 24.sp : 28.sp,
                  onTap: onTap,
                  isSmallScreen: isMobile,
                  constraints: BoxConstraints(
                    maxWidth: createContainerWidth * 1.5,
                    minWidth: 60.w,
                  ),
                ),
              ),

            // Main circular container
            Positioned(
              bottom: 0,
              right: isShow ? createContainerWidth * 0.15 : 0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: maxSize!.w,
                  maxHeight: maxSize!.h,
                  minWidth: minSize!.w,
                  minHeight: minSize!.h,
                ),
                height: responsiveHeight1,
                width: responsiveWidth1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: plusColor ?? AppColors.plusColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    height: responsiveHeight2,
                    width: responsiveWidth2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: forwardColor ?? AppColors.forwardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.r,
                          offset: Offset(0, 1.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: svgPath != null
                          ? SvgPicture.asset(
                        svgPath!,
                        colorFilter: ColorFilter.mode(
                            iconColor ?? AppColors.whiteColor,
                            BlendMode.srcIn
                        ),
                        height: responsiveIconHeight,
                        width: responsiveIconWidth,
                        fit: BoxFit.contain,
                      )
                          : icon != null
                          ? Icon(
                        icon,
                        color: iconColor ?? AppColors.whiteColor,
                        size: responsiveIconHeight,
                      )
                          : Icon(
                        Icons.add,
                        color: iconColor ?? AppColors.whiteColor,
                        size: responsiveIconHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// // import 'package:scorer/constants/appcolors.dart';
//
// class AddOneContainer extends StatelessWidget {
//   final IconData? icon;
//   final String? svgPath;
//   final double? height;
//   final double? width;
//   final double? height1;
//   final double? width1;
//   final double? height2;
//   final double? width2;
//   final VoidCallback?onTap;
//   final bool isShow;
// final double? top;
// final double?right;
// final double ?height3;
// final double?width3;
// final double?borderW;
// final double?arrowH;
// final double?arrowW;
// final String?text;
// final double?right2;
// final double?padding1;
//
//   const AddOneContainer({
//     super.key,
//     this.icon,
//     this.svgPath,
//     this.height,
//     this.width,
//     this.height1,
//     this.width1,
//     this.height2,
//     this.width2, this.onTap, this.isShow=false, this.top, this.right, this.height3, this.width3, this.borderW, this.arrowH, this.arrowW, this.text, this.right2, this.padding1
//     ,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//           clipBehavior: Clip.none,
//                                       // CreateContainer(text: "Add",height: 61.h,width: 102.w,borderW: 1.97.w,arrowW: 33.w,arrowh: 40.h,)
//
//         children: [
//       Positioned(
//             bottom: -60.h,
//             right:right2 ,
//
//             child:
//                                     isShow?      CreateContainer(
//                                         top:top?? -28.h,
//                                         right:right?? -50.w,
//                                         text:text?? "Add",height:height3?? 61.h,width:width3?? 102.w,borderW:borderW?? 1.97.w,arrowW:arrowW?? 33.w,arrowh:arrowH?? 40.h,):SizedBox()
//           //
//           ),
//           Container(
//             // clipBehavior: Clip.none,
//             height: (height1 ?? 86.31).h,
//             width: (width1 ?? 86.31) .w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.plusColor,
//             ),
//             child: Center(
//               child: Container(
//                 height: (height2 ?? 59) .h,
//                 width: (width2 ?? 59) .w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.forwardColor,
//                 ),
//                 child: Center(
//                   child: svgPath != null
//                       ? SvgPicture.asset(
//                           svgPath!,
//                           colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
//                           height: (height ?? 29) .h,
//                           width: (width ?? 29) .w,
//                         )
//                       : icon != null
//                           ? Icon(
//                               icon,
//                               color: AppColors.whiteColor,
//                               size: (height ?? 24) .h,
//                             )
//                           : const SizedBox(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
