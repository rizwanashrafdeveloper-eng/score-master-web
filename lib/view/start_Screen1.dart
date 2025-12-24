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

class StartScreen1 extends StatefulWidget {
  const StartScreen1({super.key});

  @override
  State<StartScreen1> createState() => _StartScreen1State();
}

class _StartScreen1State extends State<StartScreen1>
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
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideImage = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 150), () {
      _scaleController.forward();
      _slideController.forward();
      _fadeController.forward();
    });
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
            child: Center(
              child: Container(
                // ✅ Minimum height to fill screen
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
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
                            width: 1330.w,
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
                                  left: -190.w,
                                  top: -100.h,
                                  child: SlideTransition(
                                    position: _slideImage,
                                    child: SizedBox(
                                      height: 528.h,
                                      width: 408.w,
                                      child: Image.asset(
                                        Appimages.man1,
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
                                            mainAxisSize: MainAxisSize.min, // ✅ Don't force expansion
                                            children: [
                                              // Title
                                              Center(
                                                child: BoldText(
                                                  text: "gamify_training_title".tr,
                                                  textAlign: TextAlign.center,
                                                  fontSize: 48.sp,
                                                  selectionColor: AppColors.blueColor,
                                                  height: 1.2,
                                                ),
                                              ),
                                              SizedBox(height: 15.h),

                                              // Description
                                              Center(
                                                child: MainText(
                                                  textAlign: TextAlign.center,
                                                  text: "gamify_training_description".tr,
                                                  fontSize: 16.sp,
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
                                                    color: AppColors.forwardColor,
                                                    width: 31.4.w,
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
                                                    color: AppColors.pageColor,
                                                    width: 11.w,
                                                    height: 8.h,
                                                  ),
                                                ],
                                              ),

                                              // Forward button
                                              FadeTransition(
                                                opacity: _fadeController,
                                                child: ForwardButtonContainer(
                                                  onTap: () {
                                                    Get.toNamed(RouteName.startScreen2);
                                                  },
                                                ),
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
// class StartScreen1 extends StatefulWidget {
//   const StartScreen1({super.key});
//
//   @override
//   State<StartScreen1> createState() => _StartScreen1State();
// }
//
// class _StartScreen1State extends State<StartScreen1>
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
//     // Fade animation controller
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..forward();
//
//     // Slide animation controller
//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     // Scale animation controller
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     // Image slide from left
//     _slideImage = Tween<Offset>(
//       begin: const Offset(-0.3, 0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _slideController,
//         curve: Curves.easeOut,
//       ),
//     );
//
//     // Start animations with delay
//     Future.delayed(const Duration(milliseconds: 150), () {
//       _scaleController.forward();
//       _slideController.forward();
//       _fadeController.forward();
//     });
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
//                           left: -190.w,
//                           top: -240.h,
//                           child: SlideTransition(
//                             position: _slideImage,
//                             child: SizedBox(
//                               height: 728.h,
//                               width: 638.w,
//                               child: Image.asset(
//                                 Appimages.man1,
//                                 fit: BoxFit.contain, // ✅ This ensures the image scales properly
//                               ),
//                             ),
//                           ),
//                         ),
//
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
//                                           text: "gamify_training_title".tr,
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
//                                           text: "gamify_training_description".tr,
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
//                                             color: AppColors.forwardColor,
//                                             width: 31.4.w,  // ✅ Responsive
//                                             height: 8.h,    // ✅ Responsive
//                                           ),
//                                           SizedBox(width: 10.w), // ✅ Responsive
//                                           PageChangedContainer(
//                                             color: AppColors.pageColor,
//                                             width: 11.w,   // ✅ Responsive
//                                             height: 8.h,   // ✅ Responsive
//                                           ),
//                                           SizedBox(width: 10.w),
//                                           PageChangedContainer(
//                                             color: AppColors.pageColor,
//                                             width: 11.w,
//                                             height: 8.h,
//                                           ),
//                                         ],
//                                       ),
//
//                                       // Forward button
//                                       FadeTransition(
//                                         opacity: _fadeController,
//                                         child: ForwardButtonContainer(
//                                           onTap: () {
//                                             Get.toNamed(RouteName.startScreen2);
//                                           },
//                                         ),
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
//                 bottom: 54.h,
//                 left: 54.w,
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
//                     width: 136.w,
//                     height: 118.h,
//                     child: SvgPicture.asset(
//                       Appimages.splash,
//                       fit: BoxFit.contain, // ✅ Add fit property
//                     ),
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
//
