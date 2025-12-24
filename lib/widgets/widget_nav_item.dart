import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/controller/bottom_navigation_controller.dart';
import 'package:scorer_web/widgets/create_container.dart';

class SideNavBar extends StatelessWidget {
  final BottomNavController controller;

  SideNavBar({super.key, required this.controller});

  final List<Map<String, dynamic>> items = [
    {"icon": Appimages.house1, "label": "home".tr},
    {"icon": Appimages.game, "label": "game".tr},
    {"icon": Appimages.group, "label": "users".tr},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: 200.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
                (index) => GestureDetector(
              onTap: () => controller.changeIndex(index),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  children: [
                    Image.asset(
                      items[index]["icon"],
                      height: 150.h,
                      width: 200.w,
                    ),
                    SizedBox(height: 10.h),
                    CreateContainer(
                      fontsize2: 30.sp,
                      top: -45.h,
                      arrowW: 37.w,
                      arrowh: 45.h,
                      width: 140.w,
                      height: 68.h,
                      borderW: 2.w,
                      text: items[index]["label"],
                      textColor: controller.selectedIndex.value == index
                          ? AppColors.forwardColor
                          : AppColors.createBorderColor,
                      containerColor:
                      controller.selectedIndex.value == index
                          ? AppColors.selectionColor.withOpacity(0.25)
                          : AppColors.createColor,
                      borderColor: controller.selectedIndex.value == index
                          ? AppColors.forwardColor
                          : AppColors.createBorderColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}





//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/controller/bottom_navigation_controller.dart';
// import 'package:scorer_web/widgets/create_container.dart';
//
//
// class SideNavBar extends StatelessWidget {
//   final BottomNavController controller;
//
//    SideNavBar({super.key, required this.controller});
//
//   final List<Map<String, dynamic>> items = [
//     {"icon": Appimages.house1, "label": "home".tr},
//     {"icon": Appimages.game, "label": "game".tr},
//     {"icon": Appimages.group, "label": "users".tr},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           width: 200.w,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               items.length,
//               (index) => GestureDetector(
//                 onTap: () => controller.changeIndex(index),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20.h),
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         items[index]["icon"],
//                         height: 150.h,
//                         width: 200.w,
//                       ),
//                       SizedBox(height: 10.h),
//                       CreateContainer(
//                         fontsize2: 30.sp,
//                         top: -35.h,
//                         arrowW: 37.w,
//                         arrowh: 45.h,
//                         width: 140.w,
//                         height: 68.h,
//                         borderW: 2.w,
//                         text: items[index]["label"],
//                         textColor: controller.selectedIndex.value == index
//                             ? AppColors.forwardColor
//                             : AppColors.createBorderColor,
//                         containerColor:
//                             controller.selectedIndex.value == index
//                                 ? AppColors.selectionColor.withOpacity(0.25)
//                                 : AppColors.createColor,
//                         borderColor: controller.selectedIndex.value == index
//                             ? AppColors.forwardColor
//                             : AppColors.createBorderColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
