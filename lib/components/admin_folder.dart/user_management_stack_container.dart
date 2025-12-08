// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/controller/user_management_controller.dart';
// class UserManagementStackContainer extends StatelessWidget {
//   const UserManagementStackContainer({
//     super.key,
//     required this.totalWidth,
//     required this.left,
//     required this.tabWidth,
//     required this.tabs,
//     required this.controller,
//   });

//   final double totalWidth;
//   final double left;
//   final double tabWidth;
//   final List<String> tabs;
//   final UserManagmentController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 53.h,
//       width: totalWidth,
//       decoration: BoxDecoration(
//         color: AppColors.settingColor,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Stack(
//         children: [
//           // AnimatedPositioned(
//           //   duration: const Duration(milliseconds: 250),
//           //   curve: Curves.easeInOut,
//           //   left: left + 4.w,
//           //   top: 5.5.h,
//           //   child: Container(
//           //     height: 42.h,
//           //     width: tabWidth - 8.w,
//           //     decoration: BoxDecoration(
//           //       color: AppColors.forwardColor,
//           //       borderRadius: BorderRadius.circular(12.r),
//           //     ),
//           //   ),
//           // ),
// AnimatedPositioned(
//   duration: Duration(milliseconds: 250),
//   curve: Curves.easeInOut,
//   left: left + (tabWidth * 0.1), // ✅ thoda andar shift
//   top: 8.h,
//   child: Container(
//     height: 36.h, // ✅ chota height
//     width: 231.w, // ✅ width thodi kam
//     decoration: BoxDecoration(
//       color: AppColors.forwardColor,
//       borderRadius: BorderRadius.circular(10.r),
//     ),
//   ),
// ),

//           /// ✅ Instead of fixed `SizedBox(width: tabWidth)` → use Expanded
//           Row(
//             children: List.generate(tabs.length, (index) {
//               return Expanded(
//                 child: GestureDetector(
//                   onTap: () => controller.changeTab(index),
//                   child: Center(
//                     child: Text(
//                       tabs[index],
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: controller.selectedIndex.value == index
//                             ? AppColors.whiteColor
//                             : AppColors.languageColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           )
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/controller/user_management_controller.dart';

class UserManagementStackContainer extends StatelessWidget {
  const UserManagementStackContainer({
    super.key,
    required this.totalWidth,
    required this.left,
    required this.tabWidth,
    required this.tabs,
    required this.controller,
  });

  final double totalWidth;
  final double left;
  final double tabWidth;
  final List<String> tabs;
  final UserManagementController controller;

  // Define consistent padding for the animated selector
  static const double horizontalPadding = 4.0; // 4.w on left, 4.w on right
  static const double selectorHeight = 42.0;    // Selector height
  static const double containerHeight = 53.0;   // Parent height

  @override
  Widget build(BuildContext context) {
    // Top inset calculation: (Parent Height - Selector Height) / 2
    final double topInset = (containerHeight.h - selectorHeight.h) / 2;

    return Container(
      height: containerHeight.h,
      width: totalWidth,
      decoration: BoxDecoration(
        color: AppColors.settingColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          // The Sliding Selector Container (AnimatedPositioned)
          Obx(() => AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            // FIX: Set left position: start of tab (left) + horizontalPadding (4.w)
            left: controller.selectedIndex.value * tabWidth + horizontalPadding.w,
            // Set top position to perfectly center the selector
            top: topInset,
            child: Container(
              height: selectorHeight.h,
              // FIX: Set width: tabWidth - (2 * horizontalPadding)
              width: tabWidth - (horizontalPadding * 2).w,
              decoration: BoxDecoration(
                color: AppColors.forwardColor,
                borderRadius: BorderRadius.circular(12.r), // Use 12.r for smoother match
              ),
            ),
          )),
          
          // The Tab Buttons (Text)
          Row(
            children: List.generate(tabs.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: controller.selectedIndex.value == index
                            ? AppColors.whiteColor
                            : AppColors.languageColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
