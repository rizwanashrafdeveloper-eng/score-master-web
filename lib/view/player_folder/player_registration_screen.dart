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
import '../../api/api_controllers/register_controller.dart';
import '../../api/api_models/registration_model.dart';

class PlayerRegistrationScreen extends StatefulWidget {
  const PlayerRegistrationScreen({super.key});

  @override
  State<PlayerRegistrationScreen> createState() => _PlayerRegistrationScreenState();
}

class _PlayerRegistrationScreenState extends State<PlayerRegistrationScreen>
    with TickerProviderStateMixin {
  final RegistrationController regController = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Confirm password validator
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_confirm_password'.tr; // You'll need to add this translation
    }
    if (value != passwordController.text) {
      return 'passwords_do_not_match'.tr; // You'll need to add this translation
    }
    return null;
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
                                  text: "player_registration".tr,
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
                            height: 640.h,
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
                                    /// Full Name Field
                                    LoginTextfield(
                                      controller: nameController,
                                      text: "enter_full_name".tr,
                                      validator: Validators.isRequired,
                                      fontsize: 21.sp,
                                      isPassword: false,
                                    ),
                                    SizedBox(height: 15.h),

                                    /// Email Field
                                    LoginTextfield(
                                      controller: emailController,
                                      text: "enter_email".tr,
                                      validator: Validators.email,
                                      fontsize: 21.sp,
                                      isPassword: false,
                                    ),
                                    SizedBox(height: 15.h),

                                    /// Password Field
                                    LoginTextfield(
                                      controller: passwordController,
                                      text: "enter_password".tr,
                                      validator: Validators.password,
                                      fontsize: 21.sp,
                                      isPassword: true,
                                    ),
                                    SizedBox(height: 15.h),

                                    /// Confirm Password Field
                                    LoginTextfield(
                                      controller: confirmPasswordController,
                                      text: "confirm_password".tr, // Add this translation
                                      validator: _validateConfirmPassword,
                                      fontsize: 21.sp,
                                      isPassword: true,
                                    ),
                                    SizedBox(height: 30.h),

                                    /// Register Button
                                    Obx(() => LoginButton(
                                      text: regController.isLoading.value
                                          ? "loading".tr
                                          : "register".tr,
                                      fontSize: 20.sp,
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          final user = RegistrationModel(
                                            name: nameController.text.trim(),
                                            email: emailController.text.trim(),
                                            password: passwordController.text.trim(),
                                            role: "player",
                                            roleId: 3,
                                          );
                                          regController.register(user, isAdmin: false);
                                        }
                                      },
                                    )),
                                    SizedBox(height: 20.h),

                                    /// Already have an account? Login
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        MainText(
                                          text: "already_have_account".tr,
                                          fontSize: ResponsiveFont.getFontSizeCustom(
                                            defaultSize: 18.sp,
                                            smallSize: 11.sp,
                                          ),
                                          color: AppColors.languageTextColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        InkWell(
                                          onTap: () {
                                            // Navigate to login screen
                                            Get.back(); // Or use your route name: Get.offNamed(RouteName.playerLoginScreen);
                                          },
                                          child: MainText(
                                            text: "login".tr,
                                            fontSize: ResponsiveFont.getFontSizeCustom(
                                              defaultSize: 18.sp,
                                              smallSize: 11.sp,
                                            ),
                                            color: AppColors.selectLangugaeColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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