import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/start_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Scale animation with elastic effect
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Slide animation from bottom
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start animation
    _controller.forward();

    // Navigate to next screen after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Get.off(() => StartScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 50.h), // ✅ Responsive spacing

            // ==================== ANIMATED LOGO ====================
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SvgPicture.asset(
                    Appimages.splash,
                    height: 350.h, // ✅ Responsive height
                    width: 400.w,  // ✅ Responsive width
                  ),
                ),
              ),
            ),

            // ==================== ANIMATED BOTTOM LOGO ====================
            Padding(
              padding: EdgeInsets.only(bottom: 30.h), // ✅ Responsive padding
              child: SlideTransition(
                position: _slideAnimation,
                child: SvgPicture.asset(
                  Appimages.bottom,
                  width: 138.w,  // ✅ Responsive width
                  height: 42.h,  // ✅ Responsive height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:get/get.dart';
// // // import 'package:scorer/constants/appimages.dart';
// // // import 'package:scorer/view/FacilitateFolder/aa.dart';
// // // import 'package:scorer/view/FacilitateFolder/start_screen.dart';
// // import 'package:scorer_web/constants/appimages.dart';
// // import 'package:scorer_web/view/gradient_background.dart';
// // import 'package:scorer_web/view/start_Screen.dart';
//
//
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
//
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
//
// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
//
//
// //     Future.delayed(const Duration(seconds: 10), () {
// //       // Get.off(() =>  StartScreen());
//
//
//
//
//
//
// //     });
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: GradientBackground(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             const SizedBox(height: 50),
//
//
// //             Center(
// //               child: SvgPicture.asset(
// //                 Appimages.splash,
// //                 height: 350,
// //                 width: 400,
// //               ),
// //             ),
//
//
// //             Padding(
// //               padding: const EdgeInsets.only(bottom: 30),
// //               child: SvgPicture.asset(
// //                 Appimages.bottom,
// //                 width: 138,
// //                 height: 42,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/start_Screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Animation Controller
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//
//     // Animations setup
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.4),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );
//
//     // Start animation
//     _controller.forward();
//
//     // Navigate to next screen after 4 seconds
//     Future.delayed(const Duration(seconds: 4), () {
//       Get.off(() =>  StartScreen());
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: GradientBackground(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(height: 50),
//
//             // Animated Logo
//             Center(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: SvgPicture.asset(
//                     Appimages.splash,
//                     height: 350,
//                     width: 400,
//                   ),
//                 ),
//               ),
//             ),
//
//             // Animated Bottom Logo
//             Padding(
//               padding: const EdgeInsets.only(bottom: 30),
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: SvgPicture.asset(
//                   Appimages.bottom,
//                   width: 138,
//                   height: 42,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
