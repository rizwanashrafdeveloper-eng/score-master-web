import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:scorer_web/components/responsive_fonts.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/add_one_Container.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/pause_container.dart';
import 'package:scorer_web/widgets/useable_container.dart';

class CustomDashboardContainer extends StatelessWidget {
  final String heading;
  final String text1;
  final String text2;
  final Color? color1;
  final Color? color2;
  final String description;
  final IconData? icon1;
  final IconData? icon2;
  final String? text3;
  final String? text4;
  final String? text5;
  final String? text6;
  final bool ishow;
  final String? text7;
  final Color? color3;
  final IconData? icon3;
  final String? svg;
  final double? height1;
  final double? height2;
  final double? width;
  final double? width2;
  final bool isshow;
  final String? smallImage;
  final double? right;
  final double? horizontal;
  final double? mainWidth;
  final bool arrowshow;
  final VoidCallback? onTap;
  final bool showLoading;
  final String? loadingText;
  final VoidCallback? onTapResume;
  final VoidCallback? onTapNextPhase;
  final VoidCallback? onTapPause;
  final VoidCallback? onTapStartEarly;
  final VoidCallback? onTapAction;

  const CustomDashboardContainer({
    super.key,
    required this.heading,
    required this.text1,
    required this.text2,
    this.color1,
    this.color2,
    required this.description,
    this.icon1,
    this.icon2,
    this.text3,
    this.text4,
    this.text5,
    this.text6,
    this.ishow = true,
    this.text7,
    this.icon3,
    this.color3,
    this.svg,
    this.height1,
    this.height2,
    this.width,
    this.width2,
    this.isshow = false,
    this.smallImage,
    this.right,
    this.horizontal,
    this.mainWidth,
    this.arrowshow = true,
    this.onTap,
    this.onTapResume,
    this.onTapNextPhase,
    this.onTapPause,
    this.onTapStartEarly,
    this.onTapAction,
    this.showLoading = false,
    this.loadingText,
  });

  bool get isSpanish => Get.locale?.languageCode == "es";

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: mainWidth ?? 698.w,
          constraints: BoxConstraints(
            minHeight: 300.h,
            maxHeight: 650.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.greyColor,
              width: 3.3.w,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 29.h),

              // ✅ Heading
              if (heading.isNotEmpty) ...[
                BoldText(
                  text: heading,
                  selectionColor: AppColors.blueColor,
                  fontSize: 32.sp,
                ),
                SizedBox(height: 27.h),
              ],

              // ✅ Phase containers
              if (text1.isNotEmpty && text2.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UseableContainer(
                      //height: 42.h,
                    //  width: width ?? 129.w,
                      fontSize: 22.sp,
                      text: text1,
                      color: color1 ?? AppColors.orangeColor,
                    ),
                    SizedBox(width: 6.w),
                    UseableContainer(
                     // height: 42.h,
                      //width: width ?? 129.w,
                      fontSize: 22.sp,
                      text: text2,
                      color: color2 ?? AppColors.forwardColor,
                    ),
                  ],
                ),
                SizedBox(height: 27.h),
              ],

              // ✅ Description
              if (description.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: MainText(
                    text: description,
                    textAlign: TextAlign.center,
                    height: 1.3,
                    fontSize: 28.sp,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 27.h),
              ],

              // ✅ Players & Time row
              if ((text5?.isNotEmpty ?? false) || (text6?.isNotEmpty ?? false)) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Players section
                    if (text5?.isNotEmpty ?? false) ...[
                      Row(
                        children: [
                          Image.asset(
                            Appimages.player2,
                            height: 54.h,
                            width: 40.w,
                          ),
                          SizedBox(width: 8.w),
                          MainText(
                            text: text5!,
                            fontSize: 28.sp,
                          ),
                        ],
                      ),
                      SizedBox(width: 30.w),
                    ],

                    // Time section
                    if (text6?.isNotEmpty ?? false)
                      Row(
                        children: [
                          if (smallImage?.endsWith('.svg') ?? false)
                            SvgPicture.asset(
                              smallImage!,
                              height: 59.h,
                              width: 59.w,
                            )
                          else
                            Image.asset(
                              smallImage ?? Appimages.timeout2,
                              height: 59.h,
                              width: 59.w,
                            ),
                          SizedBox(width: 8.w),
                          MainText(
                            text: text6!,
                            fontSize: 28.sp,
                            color: AppColors.redColor,
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 28.h),
              ],
              SizedBox(height: 8.h),

              // ✅ Action buttons section
              if (!isshow) ...[
                ishow
                    ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ✅ Pause/Resume button
                      if (text3?.isNotEmpty ?? false)
                        Expanded(
                          child: PauseContainer(
                            onTap: onTapResume ?? onTapPause ?? onTapAction,
                            fontSize: ResponsiveFont.getFontSizeCustom(),
                            text: text3!,
                            icon: icon1,
                          ),
                        ),

                      // ✅ Add spacing only if both buttons exist
                      if ((text3?.isNotEmpty ?? false) && (text4?.isNotEmpty ?? false))
                        SizedBox(width: 20.w),

                      // ✅ Next Phase button
                      if (text4?.isNotEmpty ?? false)
                        Expanded(
                          child: PauseContainer(
                            onTap: onTapNextPhase,
                            fontSize: ResponsiveFont.getFontSizeCustom(),
                            color: AppColors.forwardColor,
                            text: text4!,
                            icon: icon2,
                          ),
                        ),
                    ],
                  ),
                )
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: PauseContainer(
                    onTap: onTapStartEarly ?? onTap,
                    //width: double.infinity,
                    color: color3,
                    text: text7 ?? "",
                    icon: icon3,
                    svgPath: svg,
                  ),
                ),
                SizedBox(height: 46.h),
              ] else ...[
                SizedBox(height: 46.h),
              ],
            ],
          ),
        ),

        // ✅ Arrow button
        if (arrowshow && onTap != null)
          Positioned(
            top: 72.h,
            right: right ?? -30.w,
            child: AddOneContainer(
              onTap: onTap,
              svgPath: Appimages.forward,
              width: 20.w,
              height: 20.h,
              height1: 98.h,
              height2: 69.h,
              width1: 98.w,
              width2: 69.w,
            ),
          ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_utils/src/extensions/export.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/add_one_Container.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/pause_container.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
//
// class CustomDashboardContainer extends StatelessWidget {
//   final String heading;
//   final String text1;
//   final String text2;
//   final Color? color1;
//   final Color? color2;
//   final String description;
//   final IconData? icon1;
//   final IconData? icon2;
//   final String? text3;
//   final String? text4;
//   final String? text5;
//   final String? text6;
//   final bool ishow;
//   final String? text7;
//   final Color? color3;
//   final IconData? icon3;
//   final String? svg;
//   final double? height1;
//   final double? height2;
//   final double? width;
//   final double? width2;
//   final bool isshow;
//   final String? smallImage;
//   final double? right;
//   final double? horizontal;
//   final double? mainWidth;
//   final bool arrowshow;
//   final VoidCallback? onTap;
//   final bool showLoading; // ✅ NEW: Show loading on button
//   final String? loadingText; // ✅ NEW: Text when loading
//   // ✅ NEW: Added callback parameters for API functionality
//   final VoidCallback? onTapResume;
//   final VoidCallback? onTapNextPhase;
//   final VoidCallback? onTapPause;
//   final VoidCallback? onTapStartEarly;
//   final VoidCallback? onTapAction;
//
//   const CustomDashboardContainer({
//     super.key,
//     required this.heading,
//     required this.text1,
//     required this.text2,
//     this.color1,
//     this.color2,
//     required this.description,
//     this.icon1,
//     this.icon2,
//     this.text3,
//     this.text4,
//     this.text5,
//     this.text6,
//     this.ishow = true,
//     this.text7,
//     this.icon3,
//     this.color3,
//     this.svg,
//     this.height1,
//     this.height2,
//     this.width,
//     this.width2,
//     this.isshow = false,
//     this.smallImage,
//     this.right,
//     this.horizontal,
//     this.mainWidth,
//     this.arrowshow = true,
//     this.onTap,
//     this.onTapResume,
//     this.onTapNextPhase,
//     this.onTapPause,
//     this.onTapStartEarly,
//     this.onTapAction,
//     this.showLoading = false,
//     this.loadingText,
//   });
//
//   bool get isSpanish => Get.locale?.languageCode == "es";
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           width: mainWidth ?? 698.w,
//           constraints: BoxConstraints(
//             minHeight: 300.h, // Minimum height
//             maxHeight: 650.h, // Maximum height to prevent overflow
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: AppColors.greyColor,
//               width: 3.3.w,
//             ),
//             borderRadius: BorderRadius.circular(24.r),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // ✅ This makes it dynamic
//             children: [
//               SizedBox(height: 29.h),
//
//               // ✅ Heading - Only show if not empty
//               if (heading.isNotEmpty) ...[
//                 BoldText(
//                   text: heading,
//                   selectionColor: AppColors.blueColor,
//                   fontSize: 32.sp,
//                 ),
//                 SizedBox(height: 27.h),
//               ],
//
//               // ✅ Phase containers - Only show if both texts are not empty
//               if (text1.isNotEmpty && text2.isNotEmpty) ...[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     UseableContainer(
//                       height: 42.h,
//                       width: width ?? 129.w,
//                       fontSize: 22.sp,
//                       text: text1,
//                       color: color1 ?? AppColors.orangeColor,
//                     ),
//                     SizedBox(width: 6.w),
//                     UseableContainer(
//                       height: 42.h,
//                       width: width ?? 129.w,
//                       fontSize: 22.sp,
//                       text: text2,
//                       color: color2 ?? AppColors.forwardColor,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 27.h),
//               ],
//
//               // ✅ Description - Only show if not empty
//               if (description.isNotEmpty) ...[
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40.w),
//                   child: MainText(
//                     text: description,
//                     textAlign: TextAlign.center,
//                     height: 1.3,
//                     fontSize: 28.sp,
//
//                     maxLines: 3, // Limit description lines
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 SizedBox(height: 27.h),
//               ],
//
//               // ✅ Players & Time row - Only show if either text5 or text6 is not empty
//               if ((text5?.isNotEmpty ?? false) || (text6?.isNotEmpty ?? false)) ...[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Players section - Only show if text5 is not empty
//                     if (text5?.isNotEmpty ?? false) ...[
//                       Row(
//                         children: [
//                           Image.asset(
//                             Appimages.player2,
//                             height: 54.h,
//                             width: 40.w,
//                           ),
//                           SizedBox(width: 8.w),
//                           MainText(
//                             text: text5!,
//                             fontSize: 28.sp,
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 30.w), // Space between players and time
//                     ],
//
//                     // Time section - Only show if text6 is not empty
//                     if (text6?.isNotEmpty ?? false)
//                       Row(
//                         children: [
//                           if (smallImage?.endsWith('.svg') ?? false)
//                             SvgPicture.asset(
//                               smallImage!,
//                               height: 59.h,
//                               width: 59.w,
//                             )
//                           else
//                             Image.asset(
//                               smallImage ?? Appimages.timeout2,
//                               height: 59.h,
//                               width: 59.w,
//                             ),
//                           SizedBox(width: 8.w),
//                           MainText(
//                             text: text6!,
//                             fontSize: 28.sp,
//                             color: AppColors.redColor,
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 28.h),
//               ],
//               SizedBox(height: 8.h),
//               // ✅ Action buttons section - Only show if needed
//               if (!isshow) ...[
//
//                 ishow
//                     ? Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // ✅ Pause/Resume button - Only show if text3 is not empty
//                       if (text3?.isNotEmpty ?? false)
//                         Expanded(
//                           child: PauseContainer(
//                             onTap: onTapResume ?? onTapPause ?? onTapAction,
//                             fontSize: ResponsiveFont.getFontSizeCustom(),
//                             text: text3!,
//                             icon: icon1,
//                           ),
//                         ),
//
//                       // ✅ Add spacing only if both buttons exist
//                       if ((text3?.isNotEmpty ?? false) && (text4?.isNotEmpty ?? false))
//                         SizedBox(width: 20.w),
//
//                       // ✅ Next Phase button - Only show if text4 is not empty
//                       if (text4?.isNotEmpty ?? false)
//                         Expanded(
//                           child: PauseContainer(
//                             onTap: onTapNextPhase,
//                             fontSize: ResponsiveFont.getFontSizeCustom(),
//                             color: AppColors.forwardColor,
//                             text: text4!,
//                             icon: icon2,
//                           ),
//                         ),
//                     ],
//                   ),
//                 )
//                     : Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40.w),
//                   child: PauseContainer(
//                     // ✅ Start Early button
//                     onTap: onTapStartEarly ?? onTap,
//                     width: double.infinity,
//                     color: color3,
//                     text: text7 ?? "",
//                     icon: icon3,
//                     svgPath: svg,
//                   ),
//                 ),
//                 SizedBox(height: 46.h),
//               ] else ...[
//                 SizedBox(height: 46.h),
//               ],
//             ],
//           ),
//         ),
//
//         // ✅ Arrow button - Only show if arrowshow is true and onTap is provided
//         if (arrowshow && onTap != null)
//           Positioned(
//             top: 72.h,
//             right: right ?? -30.w,
//             child: AddOneContainer(
//               onTap: onTap,
//               svgPath: Appimages.forward,
//               width: 20.w,
//               height: 20.h,
//               height1: 98.h,
//               height2: 69.h,
//               width1: 98.w,
//               width2: 69.w,
//             ),
//           ),
//       ],
//     );
//   }
// }