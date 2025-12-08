import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/responsive_fonts.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/validator.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/main_text.dart';

import '../api/api_controllers/login_controller_web.dart';

class AdminLgin extends StatefulWidget {
  const AdminLgin({super.key});

  @override
  State<AdminLgin> createState() => _AdminLginState();
}

class _AdminLginState extends State<AdminLgin> with TickerProviderStateMixin {
  final LoginControllerWeb loginController = Get.put(LoginControllerWeb());

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
    )..forward();

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
              /// Back Button (fade-in)
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
                      /// Left Side Image + Floating Text Container
                      SlideTransition(
                        position: _slideImage,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              Appimages.prince2,
                              width: 472.w,
                              height: 641.h,
                            ),
                            Positioned(
                              right: -235,
                              top: 130,
                              child: FadeTransition(
                                opacity: _fadeController,
                                child: CreateContainer(
                                  text: "Administrator Login",
                                  fontsize2: 30.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Right Side Login Form
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
                              child: Column(
                                children: [
                                  SizedBox(height: 9.h),
                                  LoginTextfield(
                                    controller:
                                    loginController.emailController,
                                    text: "enter_email".tr,
                                    validator: Validators.email,
                                  ),
                                  SizedBox(height: 9.h),
                                  LoginTextfield(
                                    controller:
                                    loginController.passwordController,
                                    text: "enter_password".tr,
                                    validator: Validators.password,
                                    isPassword: true,

                                  ),

                                  SizedBox(height: 20.h),

                                  /// ✅ Remember me + forgot password
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

                                  /// ✅ Login button with loader + role check
                                  Obx(() => LoginButton(
                                    text: loginController.isLoading.value
                                        ? "Logging in..."
                                        : "login".tr,
                                    fontSize: 20,
                                    onTap: loginController.isLoading.value
                                        ? null
                                        : () async {
                                      await loginController.login(
                                        expectedRole: 'admin',
                                      );
                                    },
                                  )),
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

              const Spacer(),

              /// Bottom SVG Animation
              Padding(
                padding: EdgeInsets.only(left: 50.w),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(-50 * (1 - value), 0),
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
