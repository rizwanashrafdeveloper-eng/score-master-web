import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/page_changed_container.dart';

class StartScreen3 extends StatefulWidget {
  const StartScreen3({super.key});

  @override
  State<StartScreen3> createState() => _StartScreen3State();
}

class _StartScreen3State extends State<StartScreen3>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideImage;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _slideImage = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            // ✅ Enable scrolling for entire screen
            physics: const BouncingScrollPhysics(),
            child: Container(
              // ✅ Minimum height to fill screen
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Stack(
                children: [
                  // ==================== MAIN CONTENT CARD ====================
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 200.h),
                      child: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _scaleController,
                          curve: Curves.easeOutBack,
                        ),
                        child: Container(
                          width: 1130.w,
                          constraints: BoxConstraints(
                            minHeight: 147.h, // ✅ Minimum height
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15.r,
                                offset: Offset(0, 5.h),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // ==================== ANIMATED IMAGE ====================
                              Positioned(
                                left: -150.w,
                                top: -110.h,
                                child: SlideTransition(
                                  position: _slideImage,
                                  child: SizedBox(
                                    height: 528.h,
                                    width: 408.w,
                                    child: Image.asset(
                                      Appimages.game2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              // ==================== TEXT CONTENT ====================
                              FadeTransition(
                                opacity: _fadeController,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 80.h,
                                    horizontal: 20.w, // ✅ Add horizontal padding
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min, // ✅ Don't force expansion
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 280.w,
                                          right: 208.w,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Title with slightly larger font (increased from 48 to 52)
                                            Center(
                                              child: BoldText(
                                                text: "platform_title".tr,
                                                textAlign: TextAlign.center,
                                                fontSize: 52.sp, // ✅ Increased from 48.sp to 52.sp
                                                selectionColor: AppColors.blueColor,
                                                height: 1.2,
                                              ),
                                            ),
                                            SizedBox(height: 15.h),

                                            // Description with slightly larger font (increased from default to 18)
                                            Center(
                                              child: MainText(
                                                textAlign: TextAlign.center,
                                                text: "platform_description".tr,
                                                fontSize: 18.sp, // ✅ Increased font size
                                                maxLines: 5, // ✅ Allow more lines
                                                height: 1.5, // ✅ Line height
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 25.h),

                                      // ==================== NAVIGATION ROW ====================
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 74.w,
                                          left: 730.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Page indicators
                                            Row(
                                              children: [
                                                PageChangedContainer(
                                                  color: AppColors.pageColor,
                                                  width: 11.w,
                                                  height: 8.h,
                                                ),
                                                SizedBox(width: 10.w),
                                                PageChangedContainer(
                                                  color: AppColors.pageColor,
                                                  width: 11.w,
                                                  height: 8.h,
                                                ),
                                                SizedBox(width: 10.w),
                                                PageChangedContainer(
                                                  color: AppColors.forwardColor,
                                                  width: 31.4.w,
                                                  height: 8.h,
                                                ),
                                              ],
                                            ),

                                            // Navigation buttons
                                            Row(
                                              children: [
                                                ForwardButtonContainer(
                                                  image: Appimages.arrowback,
                                                  onTap: () => Get.back(),
                                                ),
                                                SizedBox(width: 10.w),
                                                ForwardButtonContainer(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      RouteName.chooseYourRoleScreen,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================== BOTTOM LOGO ====================
                  Positioned(
                    bottom: 54.h,
                    left: 54.w,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1500),
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
                        width: 136.w,
                        height: 118.h,
                        child: SvgPicture.asset(
                          Appimages.splash,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/page_changed_container.dart';
//
// class StartScreen3 extends StatefulWidget {
//   const StartScreen3({super.key});
//
//   @override
//   State<StartScreen3> createState() => _StartScreen3State();
// }
//
// class _StartScreen3State extends State<StartScreen3>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late Animation<Offset> _slideImage;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//
//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..forward();
//
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..forward();
//
//     _slideImage = Tween<Offset>(
//       begin: const Offset(-0.3, 0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _slideController,
//         curve: Curves.easeOut,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // ==================== MAIN CONTENT CARD ====================
//               Center(
//                 child: ScaleTransition(
//                   scale: CurvedAnimation(
//                     parent: _scaleController,
//                     curve: Curves.easeOutBack,
//                   ),
//                   child: Container(
//                     width: 1330.w,  // ✅ Responsive width
//                     height: 447.h,  // ✅ Responsive height
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(40.r), // ✅ Responsive radius
//                       color: AppColors.whiteColor,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 15.r,
//                           offset: Offset(0, 5.h),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         // ==================== ANIMATED IMAGE ====================
//                         Positioned(
//                           left: -150.w, // ✅ Responsive positioning
//                           top: -170.h,  // ✅ Responsive positioning
//                           child: SlideTransition(
//                             position: _slideImage,
//                             child: SizedBox(
//                               height: 735.h, // ✅ Responsive
//                               width: 686.w,  // ✅ Responsive
//                               child: Image.asset(Appimages.game2),
//                             ),
//                           ),
//                         ),
//
//                         // ==================== TEXT CONTENT ====================
//                         FadeTransition(
//                           opacity: _fadeController,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                               top: 80.h,    // ✅ Responsive
//                               bottom: 55.h, // ✅ Responsive
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     left: 280.w,  // ✅ Responsive
//                                     right: 208.w, // ✅ Responsive
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       // Title
//                                       Center(
//                                         child: BoldText(
//                                           text: "platform_title".tr,
//                                           textAlign: TextAlign.center,
//                                           fontSize: 48.sp, // ✅ Responsive font
//                                           selectionColor: AppColors.blueColor,
//                                           height: 1.7.h,
//                                         ),
//                                       ),
//                                       SizedBox(height: 23.h), // ✅ Responsive
//
//                                       // Description
//                                       Center(
//                                         child: MainText(
//                                           textAlign: TextAlign.center,
//                                           text: "platform_description".tr,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 30.h), // ✅ Responsive
//
//                                 // ==================== NAVIGATION ROW ====================
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     right: 74.w,  // ✅ Responsive
//                                     left: 730.w,  // ✅ Responsive
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       // Page indicators
//                                       Row(
//                                         children: [
//                                           PageChangedContainer(
//                                             color: AppColors.pageColor,
//                                             width: 11.w,   // ✅ Responsive
//                                             height: 8.h,   // ✅ Responsive
//                                           ),
//                                           SizedBox(width: 10.w), // ✅ Responsive
//                                           PageChangedContainer(
//                                             color: AppColors.pageColor,
//                                             width: 11.w,
//                                             height: 8.h,
//                                           ),
//                                           SizedBox(width: 10.w),
//                                           PageChangedContainer(
//                                             color: AppColors.forwardColor,
//                                             width: 31.4.w, // ✅ Responsive
//                                             height: 8.h,
//                                           ),
//                                         ],
//                                       ),
//
//                                       // Navigation buttons
//                                       Row(
//                                         children: [
//                                           ForwardButtonContainer(
//                                             image: Appimages.arrowback,
//                                             onTap: () => Get.back(),
//                                           ),
//                                           SizedBox(width: 10.w), // ✅ Responsive
//                                           ForwardButtonContainer(
//                                             onTap: () {
//                                               Get.toNamed(
//                                                 RouteName.chooseYourRoleScreen,
//                                               );
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // ==================== BOTTOM LOGO ====================
//               Positioned(
//                 bottom: 54.h,   // ✅ Responsive positioning
//                 left: 54.w,     // ✅ Responsive positioning
//                 child: TweenAnimationBuilder<double>(
//                   duration: const Duration(milliseconds: 1500),
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
//                     width: 136.w,  // ✅ Responsive
//                     height: 118.h, // ✅ Responsive
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
// }
