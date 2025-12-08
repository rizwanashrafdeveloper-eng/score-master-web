import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/role_Selection_container.dart';
import 'package:scorer_web/components/role_text_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/controller/role_selection_controller.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/main_text.dart';

class ChooseYpurRoleScreen extends StatelessWidget {
  final RoleSelectionController controller = Get.put(RoleSelectionController());

  ChooseYpurRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 1320.w,
                    height: 440.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80.h, bottom: 55.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 246.w),
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 600),
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  builder: (context, double value, child) {
                                    final clampedValue =
                                    value.clamp(0.0, 1.0);
                                    return Opacity(
                                      opacity: clampedValue,
                                      child: Transform.translate(
                                        offset: Offset(
                                            -50 * (1 - clampedValue), 0),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 350.w,
                                    height: 50.h,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          top: -30,
                                          right: -55,
                                          child:
                                          TweenAnimationBuilder<double>(
                                            duration:
                                            Duration(milliseconds: 800),
                                            tween: Tween<double>(
                                                begin: 0.0, end: 1.0),
                                            builder: (context, double value,
                                                child) {
                                              final clampedValue =
                                              value.clamp(0.0, 1.0);
                                              return Transform.rotate(
                                                angle: -0.1 * clampedValue,
                                                child: Opacity(
                                                  opacity: clampedValue,
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: RoleTextContainer(),
                                          ),
                                        ),
                                        BoldText(
                                          text: "Choose Your",
                                          fontSize: 48.sp,
                                          selectionColor:
                                          AppColors.blueColor,
                                          height: 0.2.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 23.h),
                              Padding(
                                padding: EdgeInsets.only(left: 207.w),
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 800),
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  builder: (context, double value, child) {
                                    final clampedValue =
                                    value.clamp(0.0, 1.0);
                                    return Opacity(
                                      opacity: clampedValue,
                                      child: Transform.translate(
                                        offset: Offset(
                                            0, 30 * (1 - clampedValue)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: MainText(
                                    fontSize: 24.sp,
                                    height: 0,
                                    textAlign: TextAlign.center,
                                    text:
                                    "Select how you want to participate in the session",
                                  ),
                                ),
                              ),
                              SizedBox(height: 50.h),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 421.w,
                                  right: 701.w,
                                ),
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 1000),
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  builder: (context, double value, child) {
                                    final clampedValue =
                                    value.clamp(0.0, 1.0);
                                    return Opacity(
                                      opacity: clampedValue,
                                      child: Transform.translate(
                                        offset: Offset(
                                            0, 40 * (1 - clampedValue)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: ForwardButtonContainer(
                                    onTap: () {
                                      final controller =
                                      Get.find<RoleSelectionController>();
                                      if (controller
                                          .selectedIndex.value ==
                                          0) {
                                        Get.toNamed(
                                            RouteName.adminLoginScreen);
                                      } else if (controller
                                          .selectedIndex.value ==
                                          1) {
                                        Get.toNamed(
                                            RouteName.facilLoginScreen);
                                      } else if (controller
                                          .selectedIndex.value ==
                                          2) {
                                        Get.toNamed(
                                            RouteName.playerLoginScreen);
                                      } else {
                                        Get.snackbar(
                                          "selection_required".tr,
                                          "please_select_role".tr,
                                          backgroundColor:
                                          AppColors.forwardColor,
                                          colorText:
                                          AppColors.whiteColor,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ✅ FIX: Prevent Positioned container from blocking taps
                        Positioned(
                          right: -70,
                          top: -150,
                          child: IgnorePointer(
                            ignoring: false,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              width: 560.w,
                              height: 925.h,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(55.r),
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff000000)
                                        .withOpacity(0.15),
                                    blurRadius: 89.62.r,
                                    offset: Offset(0, 3.44),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 16.h),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildAnimatedRoleContainer(
                                      index: 0,
                                      delay: 0,
                                      image: Appimages.prince1,
                                      image2: Appimages.admin,
                                      text: "administrator".tr,
                                      text2: 'admin_description'.tr,
                                    ),
                                    SizedBox(height: 5.h),
                                    _buildAnimatedRoleContainer(
                                      index: 1,
                                      delay: 200,
                                      image: Appimages.blackman,
                                      image2: Appimages.facil,
                                      text: "facilitator".tr,
                                      text2: 'facilitator_description'.tr,
                                    ),
                                    SizedBox(height: 5.h),
                                    _buildAnimatedRoleContainer(
                                      index: 2,
                                      delay: 400,
                                      image: Appimages.blackgirl,
                                      image2: Appimages.player,
                                      text: "player".tr,
                                      text2: 'player_description'.tr,
                                      width: 160,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 54.h,
                left: 54.w,
                child: TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 1500),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, double value, child) {
                    final clampedValue = value.clamp(0.0, 1.0);
                    return Opacity(
                      opacity: clampedValue,
                      child: Transform.translate(
                        offset: Offset(-50 * (1 - clampedValue), 0),
                        child: child,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 136.w,
                    height: 118.h,
                    child: SvgPicture.asset(Appimages.splash),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }

  Widget _buildAnimatedRoleContainer({
    required int index,
    required int delay,
    required String image,
    required String image2,
    required String text,
    required String text2,
    double? width,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(50 * (1 - clampedValue), 0),
          child: Opacity(opacity: clampedValue, child: child),
        );
      },
      child: Obx(
            () => RoleSelectionContainer(
          onTap: () => controller.changeTab(index),
          isSelected: controller.selectedIndex.value == index,
          image: image,
          image2: image2,
          text: text,
          text2: text2,
          width: width,
        ),
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/role_Selection_container.dart';
// import 'package:scorer_web/components/role_text_container.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/controller/role_selection_controller.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/page_changed_container.dart';
//
// class ChooseYpurRoleScreen extends StatelessWidget {
//   final RoleSelectionController controller = Get.put(RoleSelectionController());
//
//   ChooseYpurRoleScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               /// Center me container with entrance animation
//               Center(
//
//                 child: TweenAnimationBuilder<double>(
//                   duration: Duration(milliseconds: 1000),
//                   tween: Tween<double>(begin: 0.8, end: 1.0),
//                   curve: Curves.elasticOut,
//                   builder: (context, double value, child) {
//                     return Transform.scale(scale: value, child: child);
//                   },
//                   child: Container(
//                     width: 1320.w,
//                     height: 440.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(40),
//                       color: AppColors.whiteColor,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 30,
//                           spreadRadius: 5,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 80.h, bottom: 55.h),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Animated Title
//                               Padding(
//                                 padding: EdgeInsets.only(left: 246.w),
//                                 child: TweenAnimationBuilder<double>(
//                                   duration: Duration(milliseconds: 600),
//                                   tween: Tween<double>(begin: 0.0, end: 1.0),
//                                   builder: (context, double value, child) {
//                                     // Clamp the opacity value to ensure it's between 0.0 and 1.0
//                                     final clampedValue = value.clamp(0.0, 1.0);
//                                     return Opacity(
//                                       opacity: clampedValue,
//                                       child: Transform.translate(
//                                         offset: Offset(
//                                           -50 * (1 - clampedValue),
//                                           0,
//                                         ),
//                                         child: child,
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     width: 350.w,
//                                     height: 50.h,
//                                     child: Stack(
//                                       clipBehavior: Clip.none,
//                                       children: [
//                                         Positioned(
//                                           top: -30,
//                                           right: -55,
//                                           child: TweenAnimationBuilder<double>(
//                                             duration: Duration(
//                                               milliseconds: 800,
//                                             ),
//                                             tween: Tween<double>(
//                                               begin: 0.0,
//                                               end: 1.0,
//                                             ),
//                                             builder:
//                                                 (context, double value, child) {
//                                                   final clampedValue = value
//                                                       .clamp(0.0, 1.0);
//                                                   return Transform.rotate(
//                                                     angle: -0.1 * clampedValue,
//                                                     child: Opacity(
//                                                       opacity: clampedValue,
//                                                       child: child,
//                                                     ),
//                                                   );
//                                                 },
//                                             child: RoleTextContainer(),
//                                           ),
//                                         ),
//                                         BoldText(
//                                           text: "Choose Your",
//                                           fontSize: 48.sp,
//                                           selectionColor: AppColors.blueColor,
//                                           height: 0.2.h,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 23.h),
//
//                               // Animated Description
//                               Padding(
//                                 padding: EdgeInsets.only(left: 207.w),
//                                 child: TweenAnimationBuilder<double>(
//                                   duration: Duration(milliseconds: 800),
//                                   tween: Tween<double>(begin: 0.0, end: 1.0),
//                                   builder: (context, double value, child) {
//                                     final clampedValue = value.clamp(0.0, 1.0);
//                                     return Opacity(
//                                       opacity: clampedValue,
//                                       child: Transform.translate(
//                                         offset: Offset(
//                                           0,
//                                           30 * (1 - clampedValue),
//                                         ),
//                                         child: child,
//                                       ),
//                                     );
//                                   },
//                                   child: MainText(
//                                     fontSize: 24.sp,
//                                     height: 0,
//                                     textAlign: TextAlign.center,
//                                     text:
//                                         "Select how you want to participate in the session",
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 50.h),
//
//                               // Animated Button
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   left: 421.w,
//                                   right: 701.w,
//                                 ),
//                                 child: TweenAnimationBuilder<double>(
//                                   duration: Duration(milliseconds: 1000),
//                                   tween: Tween<double>(begin: 0.0, end: 1.0),
//                                   builder: (context, double value, child) {
//                                     final clampedValue = value.clamp(0.0, 1.0);
//                                     return Opacity(
//                                       opacity: clampedValue,
//                                       child: Transform.translate(
//                                         offset: Offset(
//                                           0,
//                                           40 * (1 - clampedValue),
//                                         ),
//                                         child: child,
//                                       ),
//                                     );
//                                   },
//                                   child: ForwardButtonContainer(
//                                     onTap: () {
//                                       final controller =
//                                           Get.find<RoleSelectionController>();
//                                       if (controller.selectedIndex.value == 0) {
//                                         Get.toNamed(RouteName.adminLoginScreen);
//                                       } else if (controller
//                                               .selectedIndex
//                                               .value ==
//                                           1) {
//                                         Get.toNamed(RouteName.facilLoginScreen);
//                                       } else if (controller
//                                               .selectedIndex
//                                               .value ==
//                                           2) {
//                                         Get.toNamed(
//                                           RouteName.playerLoginScreen,
//                                         );
//                                       } else {
//                                         Get.snackbar(
//                                           "selection_required".tr,
//                                           "please_select_role".tr,
//                                           backgroundColor:
//                                               AppColors.forwardColor,
//                                           colorText: AppColors.whiteColor,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Animated Role Selection Cards Container
//                         Positioned(
//                           right: -70,
//                           top: -150,
//                           child: TweenAnimationBuilder<double>(
//                             duration: Duration(milliseconds: 1200),
//                             tween: Tween<double>(begin: 0.0, end: 1.0),
//                             curve: Curves.elasticOut,
//                             builder: (context, double value, child) {
//                               final clampedValue = value.clamp(0.0, 1.0);
//                               return Transform.scale(
//                                 scale: clampedValue,
//                                 child: Opacity(
//                                   opacity: clampedValue,
//                                   child: child,
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               width: 560.w,
//                               height: 925.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(55.r),
//                                 color: AppColors.whiteColor,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color(0xff000000).withOpacity(0.15),
//                                     blurRadius: 89.62.r,
//                                     offset: Offset(0, 3.44),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 16.h),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     // Animated Role Selection Containers
//                                     _buildAnimatedRoleContainer(
//                                       index: 0,
//                                       delay: 0,
//                                       image: Appimages.prince1,
//                                       image2: Appimages.admin,
//                                       text: "administrator".tr,
//                                       text2: 'admin_description'.tr,
//                                     ),
//                                     SizedBox(height: 5.h),
//                                     _buildAnimatedRoleContainer(
//                                       index: 1,
//                                       delay: 200,
//                                       image: Appimages.blackman,
//                                       image2: Appimages.facil,
//                                       text: "facilitator".tr,
//                                       text2: 'facilitator_description'.tr,
//                                     ),
//                                     SizedBox(height: 5.h),
//                                     _buildAnimatedRoleContainer(
//                                       index: 2,
//                                       delay: 400,
//                                       image: Appimages.blackgirl,
//                                       image2: Appimages.player,
//                                       text: "player".tr,
//                                       text2: 'player_description'.tr,
//                                       width: 160,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// Bottom me SVG with animation
//               Positioned(
//                 bottom: 54.h,
//                 left: 54.w,
//                 child: TweenAnimationBuilder<double>(
//                   duration: Duration(milliseconds: 1500),
//                   tween: Tween<double>(begin: 0.0, end: 1.0),
//                   builder: (context, double value, child) {
//                     final clampedValue = value.clamp(0.0, 1.0);
//                     return Opacity(
//                       opacity: clampedValue,
//                       child: Transform.translate(
//                         offset: Offset(-50 * (1 - clampedValue), 0),
//                         child: child,
//                       ),
//                     );
//                   },
//                   child: SizedBox(
//                     width: 136.w,
//                     height: 118.h,
//                     child: SvgPicture.asset(Appimages.splash),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedRoleContainer({
//     required int index,
//     required int delay,
//     required String image,
//     required String image2,
//     required String text,
//     required String text2,
//     double? width,
//   }) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 600 + delay),
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       curve: Curves.easeOutBack,
//       builder: (context, double value, child) {
//         final clampedValue = value.clamp(0.0, 1.0);
//         return Transform.translate(
//           offset: Offset(50 * (1 - clampedValue), 0),
//           child: Opacity(opacity: clampedValue, child: child),
//         );
//       },
//       child: Obx(
//         () => RoleSelectionContainer(
//           onTap: () => controller.changeTab(index),
//           isSelected: controller.selectedIndex.value == index,
//           image: image,
//           image2: image2,
//           text: text,
//           text2: text2,
//           width: width,
//         ),
//       ),
//     );
//   }
// }
