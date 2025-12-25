import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/responsive_fonts.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/validator.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../api/api_controllers/login_controller_web.dart';
import '../constants/route_name.dart';

class PlayerLoginScreen extends StatefulWidget {
  const PlayerLoginScreen({super.key});

  @override
  State<PlayerLoginScreen> createState() => _PlayerLoginScreenState();
}

class _PlayerLoginScreenState extends State<PlayerLoginScreen>
    with TickerProviderStateMixin {
  final AuthController loginController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _formController;

  late Animation<Offset> _slideImage;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formOffset;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideImage = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _formOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );

    _formOffset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );

    _slideController.forward().then((_) => _formController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              Padding(
                padding: EdgeInsets.only(left: 50.w, top: 50.h),
                child: FadeTransition(
                  opacity: _fadeController,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: ForwardButtonContainer(image: Appimages.arrowback),
                  ),
                ),
              ),

              /// Main Content
              Padding(
                padding: EdgeInsets.only(left: 60.w, right: 159.w),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Left Image + Title
                      SlideTransition(
                        position: _slideImage,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              Appimages.player2,
                              width: 472.w,
                              height: 641.h,
                            ),
                            Positioned(
                              right: -200.w,
                              top: 180.h,
                              child: FadeTransition(
                                opacity: _fadeController,
                                child: CreateContainer(
                                  width: 299.w,
                                  text: "player_login".tr,
                                  fontsize2: 30.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Right Form
                      FadeTransition(
                        opacity: _formOpacity,
                        child: SlideTransition(
                          position: _formOffset,
                          child: Container(
                            width: 686.w,
                            height: 490.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              color: AppColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32.w, vertical: 32.h),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    LoginTextfield(
                                      controller:
                                      loginController.emailController,
                                      text: "enter_email".tr,
                                      validator: Validators.email,
                                      fontsize: 21.sp,
                                      //height: 70.h,
                                      isPassword: false,
                                    ),
                                    SizedBox(height: 9.h),
                                    LoginTextfield(
                                      controller:
                                      loginController.passwordController,
                                      text: "enter_password".tr,
                                      validator: Validators.password,
                                      fontsize: 21.sp,
                                      //height: 70.h,
                                      isPassword: true,
                                    ),
                                    SizedBox(height: 20.h),

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() => GestureDetector(
                                          onTap: () {
                                            loginController.rememberMe.value =
                                            !loginController
                                                .rememberMe.value;
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 37.h,
                                                width: 37.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors
                                                        .rememberColor,
                                                    width: 1.w,
                                                  ),
                                                  color: loginController
                                                      .rememberMe.value
                                                      ? AppColors
                                                      .selectLangugaeColor
                                                      : Colors.transparent,
                                                ),
                                                child: loginController
                                                    .rememberMe.value
                                                    ? Icon(Icons.check,
                                                    size: 20.sp,
                                                    color: Colors.white)
                                                    : null,
                                              ),
                                              SizedBox(width: 6.w),
                                              MainText(
                                                text: "remember_me".tr,
                                                fontSize: ResponsiveFont
                                                    .getFontSizeCustom(
                                                  defaultSize: 18.sp,
                                                  smallSize: 11.sp,
                                                ),
                                                color: AppColors
                                                    .languageTextColor,
                                              ),
                                            ],
                                          ),
                                        )),

                                        MainText(
                                          text: "forget_password".tr,
                                          fontFamily: "gotham",
                                          fontSize:
                                          ResponsiveFont.getFontSizeCustom(
                                            defaultSize: 20.sp,
                                            smallSize: 11.sp,
                                          ),
                                          color: AppColors.selectLangugaeColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 49.h),

                                    /// Login Button
                                    Obx(() => LoginButton(
                                      text: loginController.isLoading.value
                                          ? "loading".tr
                                          : "login".tr,
                                      fontSize: 20.sp,
                                      onTap: () {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          loginController.login(
                                              expectedRole: 'player');
                                        }
                                      },
                                    )),


                                    SizedBox(height: 20.h),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed(RouteName.playerRegistrationScreen);
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "dont_have_account".tr + " ", // Translation key
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "signup".tr, // Translation key
                                                style: TextStyle(
                                                  color: AppColors.forwardColor, // green
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// Bottom Animation
              Padding(
                padding: EdgeInsets.only(left: 50.w, bottom: 50.h),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(-50.w * (1 - value), 0),
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
}















// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/main_text.dart';
//
// class PlayerLoginScreen extends StatefulWidget {
//   const PlayerLoginScreen({super.key});
//
//   @override
//   State<PlayerLoginScreen> createState() => _PlayerLoginScreenState();
// }
//
// class _PlayerLoginScreenState extends State<PlayerLoginScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late AnimationController _formController;
//
//   late Animation<Offset> _slideImage;
//   late Animation<double> _formOpacity;
//   late Animation<Offset> _formOffset;
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
//       duration: const Duration(milliseconds: 1100),
//     );
//
//     _formController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//
//     _slideImage = Tween<Offset>(
//       begin: const Offset(-0.3, 0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
//     );
//
//     _formOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _formController, curve: Curves.easeOut),
//     );
//
//     _formOffset = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _formController, curve: Curves.easeOut),
//     );
//
//     // Sequential animation: first slide image, then form
//     _slideController.forward().then((_) => _formController.forward());
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _formController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// 🔙 Back Button (Fade)
//               Padding(
//                 padding: EdgeInsets.only(left: 50.w, top: 50.h),
//                 child: FadeTransition(
//                   opacity: _fadeController,
//                   child: InkWell(
//                     onTap: () => Get.back(),
//                     child: ForwardButtonContainer(image: Appimages.arrowback),
//                   ),
//                 ),
//               ),
//
//               /// 🧍‍♂️ Main Content
//               Padding(
//                 padding: EdgeInsets.only(left: 60.w, right: 159.w),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       /// 🎯 Left Image + Title Animation
//                       SlideTransition(
//                         position: _slideImage,
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             Image.asset(
//                               Appimages.player2,
//                               width: 472.w,
//                               height: 641.h,
//                             ),
//                             Positioned(
//                               right: -120,
//                               top: 180,
//                               child: FadeTransition(
//                                 opacity: _fadeController,
//                                 child: CreateContainer(
//                                   width: 299.w,
//                                   text: "Player Login",
//                                   fontsize2: 30.sp,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       /// 📝 Right Form Animation
//                       FadeTransition(
//                         opacity: _formOpacity,
//                         child: SlideTransition(
//                           position: _formOffset,
//                           child: Container(
//                             width: 686.w,
//                             height: 490.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(40.r),
//                               color: AppColors.whiteColor,
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 32.w, vertical: 32.h),
//                               child: Column(
//                                 children: [
//                                  // LoginTextfield(text: "enter_full_name".tr),
//                                   SizedBox(height: 9.h),
//                                   LoginTextfield(text: "enter_email".tr),
//                                   SizedBox(height: 9.h),
//                                   LoginTextfield(text: "enter_password".tr),
//                                   SizedBox(height: 20.h),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Container(
//                                             height: 37.h,
//                                             width: 37.w,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                 color: AppColors.rememberColor,
//                                                 width: 1.w,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 6.w),
//                                           MainText(
//                                             text: "remember_me".tr,
//                                             fontSize:
//                                                 ResponsiveFont.getFontSizeCustom(
//                                               defaultSize: 18.sp,
//                                               smallSize: 11.sp,
//                                             ),
//                                             color: AppColors.languageTextColor,
//                                           ),
//                                         ],
//                                       ),
//                                       MainText(
//                                         text: "forget_password".tr,
//                                         fontFamily: "gotham",
//                                         fontSize:
//                                             ResponsiveFont.getFontSizeCustom(
//                                           defaultSize: 20.sp,
//                                           smallSize: 11.sp,
//                                         ),
//                                         color: AppColors.selectLangugaeColor,
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 49.h),
//                                   LoginButton(
//                                     text: "login".tr,
//                                     fontSize: 20,
//                                     onTap: () {
//                                       Get.toNamed(RouteName.bottomNavigation);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const Spacer(),
//
//               /// 🌊 Bottom SVG Animation
//               Padding(
//                 padding: EdgeInsets.only(left: 50.w),
//                 child: TweenAnimationBuilder<double>(
//                   duration: const Duration(milliseconds: 1500),
//                   tween: Tween<double>(begin: 0.0, end: 1.0),
//                   builder: (context, value, child) {
//                     return Opacity(
//                       opacity: value,
//                       child: Transform.translate(
//                         offset: Offset(-50 * (1 - value), 0),
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
// }
