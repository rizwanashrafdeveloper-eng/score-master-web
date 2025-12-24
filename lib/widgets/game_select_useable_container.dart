import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart'; // Assuming this is a custom Text widget

class GameSelectUseableContainer extends StatelessWidget {
  final String text1;
  final String text2;
  final bool isSelected;
  final double? fontSize;
  final VoidCallback? onTap; // Added onTap parameter

  const GameSelectUseableContainer({
    super.key,
    required this.text1,
    required this.text2,
    required this.isSelected,
    this.fontSize,
    this.onTap, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Wrap with GestureDetector for tap handling
      child: Container(
        // Height and width scaled using .h (height) and .w (width)
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          // Border radius scaled using .r (radius)
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? AppColors.forwardColor : AppColors.greyColor,
            // Border width scaled using .w (width, as a measure of thickness)
            width: isSelected ? 2.w : 1.5.w,
          ),
        ),
        child: Padding(
          // Horizontal padding scaled using .w (width)
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Row(
            children: [
              Container(
                // Checkbox container dimensions scaled
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.forwardColor : AppColors.greyColor,
                    // Border width scaled (0 or 2.w)
                    width: isSelected ? 0 : 2.w,
                  ),
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.forwardColor : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  color: AppColors.whiteColor,
                  // Icon size scaled using .sp (for font/icon size)
                  size: 15.sp,
                )
                    : const SizedBox(),
              ),
              // Horizontal spacing scaled using .w
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MainText(
                      text: text1,
                      // Font size scaled using .sp (scaled pixels)
                      fontSize: 24.sp,
                    ),
                    SizedBox(height: 7.h),
                    MainText(
                      text: text2,
                      // Optional font size scaled, falling back to 20.sp
                      fontSize: fontSize ?? 20.sp,
                      color: AppColors.teamColor,
                      height: 1.5, // Line height is usually not scaled
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
//
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/widgets/main_text.dart'; // Assuming this is a custom Text widget
//
// class GameSelectUseableContainer extends StatelessWidget {
//   final String text1;
//   final String text2;
//   final bool isSelected;
//   final double? fontSize;
//
//   const GameSelectUseableContainer({
//     super.key,
//     required this.text1,
//     required this.text2,
//     required this.isSelected,
//     this.fontSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Note: All hardcoded dimensions (e.g., 74, 334, 12, 1.5, 17, 24, 10)
//     // are now directly replaced with ScreenUtil's extension methods (.h, .w, .r, .sp).
//     // The previous logic using scaleFactor based on baseWidth is completely removed.
//
//     return Container(
//       // Height and width scaled using .h (height) and .w (width)
//       height: 120.h,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         // Border radius scaled using .r (radius)
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(
//           color: AppColors.greyColor,
//           // Border width scaled using .w (width, as a measure of thickness)
//           width: 1.5.w,
//         ),
//       ),
//       child: Padding(
//         // Horizontal padding scaled using .w (width)
//         padding: EdgeInsets.symmetric(horizontal: 17.w),
//         child: Row(
//           children: [
//             Container(
//               // Checkbox container dimensions scaled
//               height: 30.h,
//               width: 30.w,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: isSelected ? AppColors.forwardColor : AppColors.greyColor,
//                   // Border width scaled (0 or 2.w)
//                   width: isSelected ? 0 : 2.w,
//                 ),
//                 shape: BoxShape.circle,
//                 color: isSelected ? AppColors.forwardColor : Colors.transparent,
//               ),
//               child: isSelected
//                   ? Icon(
//                       Icons.check,
//                       color: AppColors.whiteColor,
//                       // Icon size scaled using .sp (for font/icon size)
//                       size: 15.sp,
//                     )
//                   : const SizedBox(),
//             ),
//             // Horizontal spacing scaled using .w
//             SizedBox(width: 20.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 MainText(
//                   text: text1,
//                   // Font size scaled using .sp (scaled pixels)
//                   fontSize: 24.sp,
//                 ),
//                 SizedBox(height: 7.h,),
//                 MainText(
//                   text: text2,
//                   // Optional font size scaled, falling back to 13.sp
//                   fontSize: fontSize ?? 20.sp,
//                   color: AppColors.teamColor,
//                   height: 1.5, // Line height is usually not scaled
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }