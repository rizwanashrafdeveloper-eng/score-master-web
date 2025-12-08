// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get_state_manager/get_state_manager.dart';

// // import 'package:scorer_web/constants/appcolors.dart';
// // import 'package:scorer_web/controller/stage_controller.dart';

// // class ViewResponseStackContainer extends StatelessWidget {
// //   const ViewResponseStackContainer({
// //     super.key,
// //    required this.controller,
// //     required this.tabs,
// //   });

// //   final StageController controller;
// //   double _getTabWidth(int index) {
// //     switch (index) {
// //       // case 0: // Overview
// //       //   return 170.w;
// //       // case 1: // Phases
// //       // case 2: // Players
// //       //   return 155.w;
// //       // case 3: // Leaderboard
// //       //   return 200.w;
// //       // default:
// //       //   return 180.w;
// //          case 0:
// //         return 231.w; // Overview
// //       case 1:
// //         return 267.w; // Phases
// //         }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx((){

// //       return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 21.w),
// //       child: Container(
// //       height: 103.h,
// //       // width: totalWidth,
// //       decoration: BoxDecoration(
// //         color: AppColors.settingColor,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: LayoutBuilder(
// //             builder: (context, constraints) {
// //               final double totalWidth = constraints.maxWidth;
// //               final double spacing = (totalWidth -
// //                       (_getTabWidth(0) +
// //                           _getTabWidth(1) +
// //                           _getTabWidth(2) +
// //                           _getTabWidth(3))) /
// //                   (tabs.length - 1);

// //               // Calculate left position based on index
// //               double leftPosition = 0;
// //               for (int i = 0; i < selectedIndex; i++) {
// //                 leftPosition += _getTabWidth(i) + spacing;
// //               }

// //       return Stack(
// //           children: [

// //             AnimatedPositioned(
// //               duration: Duration(milliseconds: 250),
// //               curve: Curves.easeInOut,
// //                     width: _getTabWidth(selectedIndex),

// //               left: left+4,
// //               top: 5.5,
// //               child: Container(
// //                         height: 42,
// //               //  width: tabWidth - 8,
// //                         decoration: BoxDecoration(
// //             color: AppColors.forwardColor,
// //             borderRadius: BorderRadius.circular(12),
// //                         ),
// //               ),
// //             ),

// //             Row(
// //               children: List.generate(tabs.length, (index) {
// //                         return SizedBox(
// //             width: tabWidth,
// //             child: GestureDetector(
// //         onTap: () => controller.changeTab(index),
// //         child: Center(
// //           child: Text(
// //             tabs[index],
// //             style: TextStyle(
// //               fontSize: 14,
// //               color: controller.selectedIndex.value == index
// //                   ? AppColors.whiteColor
// //                   : AppColors.languageColor,
// //             ),
// //           ),
// //         ),
// //             ),
// //                         );
// //               }),
// //             )
// //           ],

// //         );
// //             }
// //       ),
// //     ),
// //       );
// //     });
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/controller/stage_controller.dart';

// class ViewResponseStackContainer extends StatelessWidget {
//   const ViewResponseStackContainer({
//     super.key,
//     required this.controller,
//     required this.tabs,
//   });

//   final StageController controller;
//   final List<String> tabs;

//   double _getTabWidth(int index) {
//     switch (index) {
//       case 0:
//         return 231.w; // Tab 1
//       case 1:
//         return 267.w; // Tab 2
//       default:
//         return 200.w;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final int selectedIndex = controller.selectedIndex.value;

//       return Container(
//         height: 103.h,
//         decoration: BoxDecoration(
//           color: AppColors.settingColor,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double totalWidth = constraints.maxWidth;

//             // Agar 2 tabs se zyada hain to spacing calculate karega warna 0
//             final double spacing = tabs.length > 1
//                 ? (totalWidth -
//                         List.generate(tabs.length, (i) => _getTabWidth(i))
//                             .reduce((a, b) => a + b)) /
//                     (tabs.length - 1)
//                 : 0;

//             // Calculate left position based on selectedIndex
//             double leftPosition = 0;
//             for (int i = 0; i < selectedIndex; i++) {
//               leftPosition += _getTabWidth(i) + spacing;
//             }

//             return Stack(
//               children: [
//                 /// Highlight bar
//                 AnimatedPositioned(
//                   duration: const Duration(milliseconds: 250),
//                   curve: Curves.easeInOut,
//                   left: leftPosition,
//                   width: _getTabWidth(selectedIndex),
//                   top: 5.5.h,
//                   bottom: 5.5.h,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(
//                       horizontal: 6.w,
//                       vertical: 8.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.forwardColor,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                 ),

//                 /// Tabs
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(tabs.length, (index) {
//                     return GestureDetector(
//                       onTap: () => controller.changeTab(index),
//                       child: SizedBox(
//                         width: _getTabWidth(index),
//                         child: Center(
//                           child: Text(
//                             tabs[index],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 25.sp,
//                               fontWeight: FontWeight.w500,
//                               color: selectedIndex == index
//                                   ? AppColors.whiteColor
//                                   : AppColors.languageColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';

class ViewResponseStackContainer extends StatelessWidget {
  const ViewResponseStackContainer({
    super.key,
    this.controller, // ✅ optional
    required this.tabs,
  });

  final dynamic controller; // koi bhi controller aa skhta ya null ho skhta
  final List<String> tabs;

  double _getTabWidth(int index) {
    switch (index) {
      case 0:
        return 231.w;
      case 1:
        return 267.w;
      default:
        return 200.w;
    }
  }

  @override
  Widget build(BuildContext context) {
    // agar controller nahi mila to ek default bana lo
    final RxInt selectedIndex = controller?.selectedIndex ?? 0.obs;
    final Function(int)? changeTab =
        controller?.changeTab ?? (i) => selectedIndex.value = i;

    return Obx(() {
      final int currentIndex = selectedIndex.value;

      return Container(
        height: 103.h,
        decoration: BoxDecoration(
          color: AppColors.settingColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;

            final double spacing = tabs.length > 1
                ? (totalWidth -
                          List.generate(
                            tabs.length,
                            (i) => _getTabWidth(i),
                          ).reduce((a, b) => a + b)) /
                      (tabs.length - 1)
                : 0;

            double leftPosition = 0;
            for (int i = 0; i < currentIndex; i++) {
              leftPosition += _getTabWidth(i) + spacing;
            }

            return Stack(
              children: [
                /// Highlight bar
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: leftPosition,
                  width: _getTabWidth(currentIndex),
                  top: 5.5.h,
                  bottom: 5.5.h,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),

                /// Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(tabs.length, (index) {
                    return GestureDetector(
                      onTap: () => changeTab!(index),
                      child: SizedBox(
                        width: _getTabWidth(index),
                        child: Center(
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w500,
                              color: currentIndex == index
                                  ? AppColors.whiteColor
                                  : AppColors.languageColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
