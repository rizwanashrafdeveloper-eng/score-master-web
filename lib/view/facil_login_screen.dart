import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/api/api_controllers/login_controller_web.dart';
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

class FacilLoginScreen extends StatefulWidget {
  const FacilLoginScreen({super.key});

  @override
  State<FacilLoginScreen> createState() => _FacilLoginScreenState();
}

class _FacilLoginScreenState extends State<FacilLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginControllerWeb());

  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<double> _imageOpacity;
  late Animation<Offset> _imageOffset;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textOffset;

  @override
  void initState() {
    super.initState();

    _imageController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _textController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _imageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );
    _imageOffset = Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textOffset = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _imageController.forward().then((_) => _textController.forward());


  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    loginController.dispose();
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
              Padding(
                padding: EdgeInsets.only(left: 50.w, top: 50.h),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: ForwardButtonContainer(image: Appimages.arrowback),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 60.w, right: 159.w),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
// Animated left side (image)
                      FadeTransition(
                        opacity: _imageOpacity,
                        child: SlideTransition(
                          position: _imageOffset,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(
                                Appimages.facil2,
                                width: 472.w,
                                height: 641.h,
                              ),
                              Positioned(
                                right: -235,
                                top: 130,
                                child: CreateContainer(
                                  text: "Facilitator Login",
                                  fontsize2: 30.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Animated right side (form)
                      FadeTransition(
                        opacity: _textOpacity,
                        child: SlideTransition(
                          position: _textOffset,
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
                                      text: "enter_email".tr,
                                      controller: loginController.emailController,
                                      validator: Validators.email,
                                    ),
                                    SizedBox(height: 9.h),
                                    LoginTextfield(
                                      text: "enter_password".tr,
                                      controller: loginController.passwordController,
                                      validator: Validators.password,
                                      isPassword: true,

                                    ),
                                    SizedBox(height: 20.h),

                                    // Remember Me + Forgot Password
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
                                                    ? const Icon(Icons.check,
                                                    size: 20,
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

                                    // Login Button
                                    Obx(() => LoginButton(
                                      text: loginController.isLoading.value
                                          ? "Logging in..."
                                          : "login".tr,
                                      fontSize: 20,
                                      onTap: loginController.isLoading.value
                                          ? null
                                          : () {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          loginController.login(
                                              expectedRole:
                                              "facilitator");
                                        }
                                      },
                                    )),
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

              // Bottom splash logo fade-in
              Padding(
                padding: EdgeInsets.only(left: 50.w, bottom: 50.h),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
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
}












// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_navigation/src/extension_navigation.dart';
// // import 'package:get/instance_manager.dart';
// // import 'package:scorer_web/components/responsive_fonts.dart';
// // import 'package:scorer_web/constants/appcolors.dart';
// // import 'package:scorer_web/constants/appimages.dart';
// // import 'package:scorer_web/view/gradient_background.dart';
// // import 'package:scorer_web/widgets/create_container.dart';
// // import 'package:scorer_web/widgets/forward_button_container.dart';
// // import 'package:scorer_web/widgets/login_button.dart';
// // import 'package:scorer_web/widgets/login_textfield.dart';
// // import 'package:scorer_web/widgets/main_text.dart';
//
// // class FacilLoginScreen extends StatelessWidget {
// //   const FacilLoginScreen({super.key});
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(body: GradientBackground(child: SafeArea(child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // SizedBox(height: 50.h,),
// // Padding(
// //   padding: EdgeInsets.only(left: 50.w,top: 50.h),
// //   child: InkWell(
// //     onTap: () => Get.back(),
// //     child: ForwardButtonContainer(image: Appimages.arrowback,)),
// // ),
//
//
// // Padding(
// //   padding:  EdgeInsets.only(left: 60.w,right: 159.w),
// //   child: Center(
// //     child: Row(
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Container(
// //           child: Stack(
// //             clipBehavior: Clip.none,
// //             children: [
//
// //               Image.asset(
// //                                  Appimages.facil2,
// //                                   width: 472.w,
// //                height: 641.h,
// //                                  // height: 180 ,
// //                                ),
// //                                 Positioned(
// //                 right: -235,
// //                 top: 130,
// //                 child: CreateContainer(text: "Facilitator Login",fontsize2: 30.sp,)),
// //             ],
// //           ),
// //         ),
//
// //         Container(
// //           width: 686.w,
// //           height: 490.h,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(40.r),
// //             color: AppColors.whiteColor
// //           ),
// //           child: Padding(
// //             padding:  EdgeInsets.symmetric(horizontal: 32.w,vertical: 32.h),
// //             child: Column(
// //               children: [
// //                 LoginTextfield(text:"enter_full_name".tr,),
// //                 SizedBox(height: 9.h,),
// //                  LoginTextfield(text:  "enter_email".tr,),
// //                 SizedBox(height: 9.h,),
// //                  LoginTextfield(text:  "enter_password".tr,),
// //                 SizedBox(height: 20.h,),
// //                  Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Row(
// //                                 children: [
// //                                   Container(
// //                                     height: 37.h,
// //                                     width: 37.w,
// //                                     decoration: BoxDecoration(
// //                                       shape: BoxShape.circle,
// //                                       border: Border.all(
// //                                         color: AppColors.rememberColor,
// //                                         width: 1 .w,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   SizedBox(width: 6 .w),
// //                                   MainText(
// //                                     text: "remember_me".tr,
//
// //                                       fontSize: ResponsiveFont.getFontSizeCustom(
// //     defaultSize: 18.sp,
// //     smallSize: 11.sp,
//
// //                                     ),
//
// //                                     color: AppColors.languageTextColor,
// //                                   ),
// //                                 ],
// //                               ),
// //                               MainText(
// //                                 text: "forget_password".tr,
// //                                 fontFamily: "gotham",
// //                                  fontSize: ResponsiveFont.getFontSizeCustom(
// //     defaultSize: 20.sp,
// //     smallSize: 11.sp,
//
// //                                     ),
// //                                 color: AppColors.selectLangugaeColor,
// //                               ),
// //                             ],
// //                           ),
// //                           SizedBox(height: 49.h,),
//
// //                             LoginButton(
// //                             text: "login".tr,
// //                             fontSize: 20,
// //                             onTap: () {
// //                               // Get.toNamed(RouteName.bottomNavigation);
// //                             },
// //                           ),
//
// //               ],
// //             ),
// //           ),
// //         )
// //       ],
// //     ),
// //   ),
// // ),
// // Spacer(),
// //  Padding(
// //    padding: EdgeInsets.only(left: 50.w),
// //    child: SizedBox(
// //      width: 136.w,
// //      height: 118.h,
// //      child: SvgPicture.asset(Appimages.splash),
// //    ),
// //  ),
//
//
//
// //       ],
// //     ))),);
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/main_text.dart';
//
// class FacilLoginScreen extends StatefulWidget {
//   const FacilLoginScreen({super.key});
//
//   @override
//   State<FacilLoginScreen> createState() => _FacilLoginScreenState();
// }
//
// class _FacilLoginScreenState extends State<FacilLoginScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _imageController;
//   late AnimationController _textController;
//   late Animation<double> _imageOpacity;
//   late Animation<Offset> _imageOffset;
//   late Animation<double> _textOpacity;
//   late Animation<Offset> _textOffset;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Image animation (slide + fade)
//     _imageController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
//     _imageOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
//     );
//     _imageOffset = Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));
//
//     // Text animation (slide up + fade)
//     _textController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
//     _textOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _textController, curve: Curves.easeOut),
//     );
//     _textOffset = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
//
//     // Trigger animations in sequence
//     _imageController.forward().then((_) => _textController.forward());
//   }
//
//   @override
//   void dispose() {
//     _imageController.dispose();
//     _textController.dispose();
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
//               Padding(
//                 padding: EdgeInsets.only(left: 50.w, top: 50.h),
//                 child: InkWell(
//                   onTap: () => Get.back(),
//                   child: ForwardButtonContainer(image: Appimages.arrowback),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left: 60.w, right: 159.w),
//                 child: Center(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Animated image + title
//                       FadeTransition(
//                         opacity: _imageOpacity,
//                         child: SlideTransition(
//                           position: _imageOffset,
//                           child: Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               Image.asset(
//                                 Appimages.facil2,
//                                 width: 472.w,
//                                 height: 641.h,
//                               ),
//                               Positioned(
//                                 right: -235,
//                                 top: 130,
//                                 child: CreateContainer(
//                                   text: "Facilitator Login",
//                                   fontsize2: 30.sp,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // Animated login form
//                       FadeTransition(
//                         opacity: _textOpacity,
//                         child: SlideTransition(
//                           position: _textOffset,
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
//                                             color:
//                                                 AppColors.languageTextColor,
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
//                                       // Get.toNamed(RouteName.bottomNavigation);
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
//               const Spacer(),
//                 Positioned(
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
// }
