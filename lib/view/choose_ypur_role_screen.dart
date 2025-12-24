

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
    // ✅ Detect device type
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isSmallHeight = screenHeight < 700;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: isMobile
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context, isTablet, isSmallHeight),
        ),
      ),
    );
  }

  // ==================== MOBILE LAYOUT ====================
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Logo at top
            SvgPicture.asset(
              Appimages.splash,
              width: 100.w,
              height: 80.h,
            ),
            SizedBox(height: 20.h),

            // Title
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoldText(
                        text: "choose_your".tr,
                        fontSize: 24.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      SizedBox(width: 8.w),
                      RoleTextContainer(),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  MainText(
                    fontSize: 14.sp,
                    textAlign: TextAlign.center,
                    text: "select_participation".tr,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // Role selection cards
            _buildAnimatedRoleContainer(
              index: 0,
              delay: 0,
              image: Appimages.prince1,
              image2: Appimages.admin,
              text: "administrator".tr,
              text2: 'admin_description'.tr,
            ),
            SizedBox(height: 12.h),

            _buildAnimatedRoleContainer(
              index: 1,
              delay: 200,
              image: Appimages.blackman,
              image2: Appimages.facil,
              text: "facilitator".tr,
              text2: 'facilitator_description'.tr,
            ),
            SizedBox(height: 12.h),

            _buildAnimatedRoleContainer(
              index: 2,
              delay: 400,
              image: Appimages.blackgirl,
              image2: Appimages.player,
              text: "player".tr,
              text2: 'player_description'.tr,
              width: 160.w,
            ),

            SizedBox(height: 30.h),

            // Forward button
            ForwardButtonContainer(
              onTap: _handleRoleSelection,
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // ==================== DESKTOP/TABLET LAYOUT ====================
  Widget _buildDesktopLayout(BuildContext context, bool isTablet, bool isSmallHeight) {
    final containerWidth = isTablet ? 900.w : 1320.w;
    final containerHeight = isSmallHeight ? 380.h : (isTablet ? 400.h : 440.h);

    return Stack(
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
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30.r,
                    spreadRadius: 5.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ✅ Left side content with proper constraints
                  Positioned(
                    left: 0,
                    right: isTablet ? 350.w : 500.w, // Reserve space for right panel
                    top: 0,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 30.w : 50.w,
                        vertical: isTablet ? 40.h : 55.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with role badge
                          TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 600),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: Transform.translate(
                                  offset: Offset(-50.w * (1 - value.clamp(0.0, 1.0)), 0),
                                  child: child,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                BoldText(
                                  text: "choose_your".tr,
                                  fontSize: isTablet ? 28.sp : 40.sp,
                                  selectionColor: AppColors.blueColor,
                                ),
                                SizedBox(width: 12.w),
                                Flexible(
                                  child: TweenAnimationBuilder<double>(
                                    duration: Duration(milliseconds: 800),
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    builder: (context, double value, child) {
                                      return Transform.rotate(
                                        angle: -0.1 * value.clamp(0.0, 1.0),
                                        child: Opacity(
                                          opacity: value.clamp(0.0, 1.0),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: RoleTextContainer(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isTablet ? 15.h : 23.h),

                          // Subtitle
                          TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: Transform.translate(
                                  offset: Offset(0, 30.h * (1 - value.clamp(0.0, 1.0))),
                                  child: child,
                                ),
                              );
                            },
                            child: MainText(
                              fontSize: isTablet ? 16.sp : 24.sp,
                              textAlign: TextAlign.left,
                              text: "select_participation".tr,
                              maxLines: 2,
                            ),
                          ),

                          Spacer(),

                          // Forward button
                          TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 1000),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: Transform.translate(
                                  offset: Offset(0, 40.h * (1 - value.clamp(0.0, 1.0))),
                                  child: child,
                                ),
                              );
                            },
                            child: ForwardButtonContainer(
                              onTap: _handleRoleSelection,
                              height1: isTablet ? 50.h : null,
                              height2: isTablet ? 35.h : null,
                              width1: isTablet ? 50.w : null,
                              width2: isTablet ? 35.w : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ Right side role selection panel - Fixed positioning
                  Positioned(
                    right: isTablet ? -40.w : -70.w,
                    top: isSmallHeight ? -100.h : -150.h,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: isTablet ? 400.w : 560.w,
                      height: isSmallHeight ? 600.h : (isTablet ? 700.h : 800.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55.r),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff000000).withOpacity(0.15),
                            blurRadius: 89.62.r,
                            offset: Offset(0, 3.44.h),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(isTablet ? 12.w : 8.w),
                        child: Column(
                          children: [
                            SizedBox(height: isSmallHeight ? 80.h : 100.h), // Space for overflow

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
                              width: 160.w,
                            ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom logo - only show on desktop
        if (!isTablet)
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
                    offset: Offset(-50.w * (1 - clampedValue), 0),
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: 100.w,
                height: 90.h,
                child: SvgPicture.asset(Appimages.splash),
              ),
            ),
          ),
      ],
    );
  }

  // ==================== ROLE CONTAINER BUILDER ====================
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
          offset: Offset(50.w * (1 - clampedValue), 0),
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

  // ==================== HANDLE ROLE SELECTION ====================
  void _handleRoleSelection() {
    if (controller.selectedIndex.value == 0) {
      Get.toNamed(RouteName.adminLoginScreen);
    } else if (controller.selectedIndex.value == 1) {
      Get.toNamed(RouteName.facilLoginScreen);
    } else if (controller.selectedIndex.value == 2) {
      Get.toNamed(RouteName.playerLoginScreen);
    } else {
      Get.snackbar(
        "selection_required".tr,
        "please_select_role".tr,
        backgroundColor: AppColors.forwardColor,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20.w),
      );
    }
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
//               Center(
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
//                       borderRadius: BorderRadius.circular(40.r),
//                       color: AppColors.whiteColor,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 30.r,
//                           spreadRadius: 5.r,
//                           offset: Offset(0, 10.h),
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
//                               Padding(
//                                 padding: EdgeInsets.only(left: 246.w),
//                                 child: TweenAnimationBuilder<double>(
//                                   duration: Duration(milliseconds: 600),
//                                   tween: Tween<double>(begin: 0.0, end: 1.0),
//                                   builder: (context, double value, child) {
//                                     final clampedValue = value.clamp(0.0, 1.0);
//                                     return Opacity(
//                                       opacity: clampedValue,
//                                       child: Transform.translate(
//                                         offset: Offset(-50.w * (1 - clampedValue), 0),
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
//                                           top: -30.h,
//                                           right: -55.w,
//                                           child: TweenAnimationBuilder<double>(
//                                             duration: Duration(milliseconds: 800),
//                                             tween: Tween<double>(begin: 0.0, end: 1.0),
//                                             builder: (context, double value, child) {
//                                               final clampedValue = value.clamp(0.0, 1.0);
//                                               return Transform.rotate(
//                                                 angle: -0.1 * clampedValue,
//                                                 child: Opacity(
//                                                   opacity: clampedValue,
//                                                   child: child,
//                                                 ),
//                                               );
//                                             },
//                                             child: RoleTextContainer(),
//                                           ),
//                                         ),
//                                         BoldText(
//                                           text: "choose_your".tr,
//                                           fontSize: 40.sp,
//                                           selectionColor: AppColors.blueColor,
//                                           height: 0.2.h,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 23.h),
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
//                                         offset: Offset(0, 30.h * (1 - clampedValue)),
//                                         child: child,
//                                       ),
//                                     );
//                                   },
//                                   child: MainText(
//                                     fontSize: 24.sp,
//                                     height: 0,
//                                     textAlign: TextAlign.center,
//                                     text: "select_participation".tr,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 50.h),
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
//                                         offset: Offset(0, 40.h * (1 - clampedValue)),
//                                         child: child,
//                                       ),
//                                     );
//                                   },
//                                   child: ForwardButtonContainer(
//                                     onTap: () {
//                                       final controller = Get.find<RoleSelectionController>();
//                                       if (controller.selectedIndex.value == 0) {
//                                         Get.toNamed(RouteName.adminLoginScreen);
//                                       } else if (controller.selectedIndex.value == 1) {
//                                         Get.toNamed(RouteName.facilLoginScreen);
//                                       } else if (controller.selectedIndex.value == 2) {
//                                         Get.toNamed(RouteName.playerLoginScreen);
//                                       } else {
//                                         Get.snackbar(
//                                           "selection_required".tr,
//                                           "please_select_role".tr,
//                                           backgroundColor: AppColors.forwardColor,
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
//                         /// ✅ FIX: Right container with role selection - Scrollable
//                         Positioned(
//                           right: -70.w,
//                           top: -150.h,
//                           child: Container(
//                             clipBehavior: Clip.hardEdge,
//                             width: 560.w,
//                             height: 800.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(55.r),
//                               color: AppColors.whiteColor,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0xff000000).withOpacity(0.15),
//                                   blurRadius: 89.62.r,
//                                   offset: Offset(0, 3.44.h),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: SingleChildScrollView(
//                                 physics: const BouncingScrollPhysics(),
//                                 child: Column(
//                                   children: [
//                                     _buildAnimatedRoleContainer(
//                                       index: 0,
//                                       delay: 0,
//                                       image: Appimages.prince1,
//                                       image2: Appimages.admin,
//                                       text: "administrator".tr,
//                                       text2: 'admin_description'.tr,
//                                     ),
//
//                                     SizedBox(height: 5.h),
//
//                                     _buildAnimatedRoleContainer(
//                                       index: 1,
//                                       delay: 200,
//                                       image: Appimages.blackman,
//                                       image2: Appimages.facil,
//                                       text: "facilitator".tr,
//                                       text2: 'facilitator_description'.tr,
//                                     ),
//
//                                     SizedBox(height: 5.h),
//
//                                     _buildAnimatedRoleContainer(
//                                       index: 2,
//                                       delay: 400,
//                                       image: Appimages.blackgirl,
//                                       image2: Appimages.player,
//                                       text: "player".tr,
//                                       text2: 'player_description'.tr,
//                                       width: 160.w,
//                                     ),
//
//                                     SizedBox(height: 20.h),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Bottom logo
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
//                         offset: Offset(-50.w * (1 - clampedValue), 0),
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
//           offset: Offset(50.w * (1 - clampedValue), 0),
//           child: Opacity(opacity: clampedValue, child: child),
//         );
//       },
//       child: Obx(
//             () => RoleSelectionContainer(
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










