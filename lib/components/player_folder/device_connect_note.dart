import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/main_text.dart';

class DeviceConnectNote extends StatelessWidget {
  const DeviceConnectNote({
    super.key,
    this.isSmallScreen = false,
  });

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isSmallScreen ? 80.h : 113.h,
      constraints: BoxConstraints(
        maxHeight: 113.h,
        minHeight: 70.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
          width: isSmallScreen ? 1.w : 1.5.w,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16.r : 24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.w : 18.w,
          vertical: isSmallScreen ? 12.h : 18.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Appimages.bulb,
              height: isSmallScreen ? 18.h : 24.h,
              width: isSmallScreen ? 18.w : 24.w,
            ),
            SizedBox(width: isSmallScreen ? 6.w : 10.w),
            Expanded(
              child: MainText(
                height: 1.6,
                text: "Make sure your device is charged and you have a stable internet connection for the best experience.",
                fontSize: isSmallScreen ? 14.sp : 20.sp,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/main_text.dart';
//
// class DeviceConnectNote extends StatelessWidget {
//   const DeviceConnectNote({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 113.h,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: AppColors.greyColor,
//           width: 1.5.w,
//         ),
//         borderRadius: BorderRadius.circular(24.r),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: 18.w,
//           vertical: 18.h,
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               Appimages.bulb,
//               height: 24.h,
//               width: 24.w,
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: MainText(
//                 height: 1.6,
//                 // text: "device_connection_notice".tr,
//                 text: "Make sure your device is charged and you have a stable internet connection for the best experience.",
//                 fontSize: 20.sp, // text size ScreenUtil se
//                 textAlign: TextAlign.start,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
