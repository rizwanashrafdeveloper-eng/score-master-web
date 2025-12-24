import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';

class ViewResponseStackContainer extends StatelessWidget {
  const ViewResponseStackContainer({
    super.key,
    this.controller,
    required this.tabs,
  });

  final dynamic controller;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    final RxInt selectedIndex = controller?.selectedIndex ?? 0.obs;
    final Function(int) changeTab =
        controller?.changeTab ?? (i) => selectedIndex.value = i;

    return Obx(() {
      final int currentIndex = selectedIndex.value;

      return Container(
        height: 70.h, // 🔹 reduced slightly for better scaling
        decoration: BoxDecoration(
          color: AppColors.settingColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;
            final double tabWidth = totalWidth / tabs.length;

            return Stack(
              children: [
                /// Highlight bar
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: tabWidth * currentIndex,
                  width: tabWidth,
                  top: 6.h,
                  bottom: 6.h,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),

                /// Tabs
                Row(
                  children: List.generate(tabs.length, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => changeTab(index),
                        child: Center(
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp, // 🔹 adaptive
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




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
//
// class ViewResponseStackContainer extends StatelessWidget {
//   const ViewResponseStackContainer({
//     super.key,
//     this.controller, // ✅ optional
//     required this.tabs,
//   });
//
//   final dynamic controller; // koi bhi controller aa skhta ya null ho skhta
//   final List<String> tabs;
//
//   double _getTabWidth(int index) {
//     switch (index) {
//       case 0:
//         return 231.w;
//       case 1:
//         return 267.w;
//       default:
//         return 200.w;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // agar controller nahi mila to ek default bana lo
//     final RxInt selectedIndex = controller?.selectedIndex ?? 0.obs;
//     final Function(int)? changeTab =
//         controller?.changeTab ?? (i) => selectedIndex.value = i;
//
//     return Obx(() {
//       final int currentIndex = selectedIndex.value;
//
//       return Container(
//         height: 103.h,
//         decoration: BoxDecoration(
//           color: AppColors.settingColor,
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double totalWidth = constraints.maxWidth;
//
//             final double spacing = tabs.length > 1
//                 ? (totalWidth -
//                           List.generate(
//                             tabs.length,
//                             (i) => _getTabWidth(i),
//                           ).reduce((a, b) => a + b)) /
//                       (tabs.length - 1)
//                 : 0;
//
//             double leftPosition = 0;
//             for (int i = 0; i < currentIndex; i++) {
//               leftPosition += _getTabWidth(i) + spacing;
//             }
//
//             return Stack(
//               children: [
//                 /// Highlight bar
//                 AnimatedPositioned(
//                   duration: const Duration(milliseconds: 250),
//                   curve: Curves.easeInOut,
//                   left: leftPosition,
//                   width: _getTabWidth(currentIndex),
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
//
//                 /// Tabs
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(tabs.length, (index) {
//                     return GestureDetector(
//                       onTap: () => changeTab!(index),
//                       child: SizedBox(
//                         width: _getTabWidth(index),
//                         child: Center(
//                           child: Text(
//                             tabs[index],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 25.sp,
//                               fontWeight: FontWeight.w500,
//                               color: currentIndex == index
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
