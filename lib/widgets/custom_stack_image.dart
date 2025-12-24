import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/create_container.dart';

class CustomStackImage extends StatelessWidget {
  final String? image;
  final String? text;
  final bool isSmallScreen;

  const CustomStackImage({
    super.key,
    this.image,
    this.text,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSmallScreen ? 180.h : 225.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image ?? Appimages.facil2),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: isSmallScreen ? -10.h : -17.h,
            left: isSmallScreen ? 15.w : 30.w,
            child: CreateContainer(
              borderW: isSmallScreen ? 1.2.w : 1.7.w,
              top: isSmallScreen ? -15.h : -25.h,
              width: isSmallScreen ? 120.w : 156.w,
              height: isSmallScreen ? 45.h : 57.h,
              text: text ?? "facilitator".tr,
              fontsize2: isSmallScreen ? 14.sp : 17.sp,
              right: isSmallScreen ? -15.w : -22.w,
              arrowh: isSmallScreen ? 25.h : 35.h,
              arrowW: isSmallScreen ? 22.w : 29.w,
            ),
          )

        ],

      ),


    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/create_container.dart';
//
// class CustomStackImage extends StatelessWidget {
//   final String? image;
//   final String? text;
//   final bool isSmallScreen; // ✅ ADD THIS PARAMETER
//
//   const CustomStackImage({
//     super.key,
//     this.image,
//     this.text,
//     this.isSmallScreen = false, // ✅ DEFAULT VALUE
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: isSmallScreen ? 180.h : 225.h,
//       decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(image ?? Appimages.facil2),
//           )
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             bottom: isSmallScreen ? -10.h : -17.h,
//             left: isSmallScreen ? 15.w : 30.w,
//             child: CreateContainer(
//               borderW: isSmallScreen ? 1.2.w : 1.7.w,
//               top: isSmallScreen ? -15.h : -25.h,
//               width: isSmallScreen ? 120.w : 156.w,
//               height: isSmallScreen ? 45.h : 57.h,
//               text: text ?? "facilitator".tr,
//               fontsize2: isSmallScreen ? 14.sp : 17.sp,
//               right: isSmallScreen ? -15 : -22,
//               arrowh: isSmallScreen ? 25.h : 35.h,
//               arrowW: isSmallScreen ? 22.w : 29.w,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
