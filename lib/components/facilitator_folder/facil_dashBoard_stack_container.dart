
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:scorer/constants/appcolors.dart';
// import 'package:scorer/controllers/facil_dashboard_controller.dart';
// import 'package:scorer/widgets/main_text.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/controller/facil_dashboard_controller.dart';
import 'package:scorer_web/widgets/main_text.dart';

import '../responsive_fonts.dart';


class FacilDashBoardStackContainer extends StatelessWidget {
  const FacilDashBoardStackContainer({
    super.key,
    required this.controller,
  });

  final FacilDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ READ RX HERE (IMPORTANT)
      final int selectedIndex = controller.selectedIndex.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double indicatorWidth = totalWidth / 2;

          return Container(
            height: 70.h,
            constraints: BoxConstraints(
              maxWidth: 650.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.settingColor,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Stack(
              children: [
                /// Sliding indicator
                AnimatedAlign(
                  alignment: selectedIndex == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    height: 60.h,
                    width: indicatorWidth,
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                ),

                /// Tabs
                Row(
                  children: [
                    _buildTab(
                      text: "active_sessions".tr,
                      isSelected: selectedIndex == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    _buildTab(
                      text: "scheduled".tr,
                      isSelected: selectedIndex == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildTab({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Center(
        child: MainText(
          text: text,
          onTap: onTap,
          color: isSelected
              ? AppColors.whiteColor
              : AppColors.languageColor,
          fontSize: ResponsiveFont.getFontSizeCustom(
            defaultSize: 24.sp,
            smallSize: 16.sp,
          ),
        ),
      ),
    );
  }
}




//
  // import 'package:flutter/material.dart';
  // import 'package:flutter_screenutil/flutter_screenutil.dart';
  // import 'package:get/get.dart';
  // // import 'package:scorer/constants/appcolors.dart';
  // // import 'package:scorer/controllers/facil_dashboard_controller.dart';
  // // import 'package:scorer/widgets/main_text.dart';
  // import 'package:scorer_web/constants/appcolors.dart';
  // import 'package:scorer_web/controller/facil_dashboard_controller.dart';
  // import 'package:scorer_web/widgets/main_text.dart';
  //
  // class FacilDashBoardStackContainer extends StatelessWidget {
  //   const FacilDashBoardStackContainer({
  //     super.key, required this.controller,
  //
  //   });
  //
  //
  //   final FacilDashboardController controller;
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Obx(()=>Container(
  //       height: 80.h,
  //       width: 650.w,
  //       decoration: BoxDecoration(
  //         color: AppColors.settingColor,
  //         borderRadius: BorderRadius.circular(25.r),
  //       ),
  //       child: Stack(
  //         children: [
  //           AnimatedAlign(
  //             alignment: controller.selectedIndex.value == 0
  //                 ? Alignment.centerLeft
  //                 : Alignment.centerRight,
  //             duration: const Duration(milliseconds: 250),
  //             child: Container(
  //               height: 70 .h,
  //               width: 300 .w,
  //               margin: EdgeInsets.symmetric(horizontal: 6 .w),
  //               decoration: BoxDecoration(
  //                 color: AppColors.forwardColor,
  //                 borderRadius: BorderRadius.circular(25 .r),
  //               ),
  //             ),
  //           ),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Center(
  //                   child: MainText(
  //                     onTap: () {
  //                       controller.changeTab(0);
  //                     },
  //                     text: "active_sessions".tr,
  //                     color: controller.selectedIndex.value == 0
  //                         ? AppColors.whiteColor
  //                         : AppColors.languageColor,
  //                     fontSize: 28 .sp,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Center(
  //                   child: MainText(
  //                     text: "scheduled".tr,
  //                     fontSize: 28 .sp,
  //                     color: controller.selectedIndex.value == 0
  //                         ? AppColors.languageColor
  //                         : AppColors.whiteColor,
  //                     onTap: () {
  //                       controller.changeTab(1);
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ));
  //   }
  // }
