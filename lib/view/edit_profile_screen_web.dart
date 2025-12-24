import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';

class EditProfileScreenWeb extends StatefulWidget {
  const EditProfileScreenWeb({super.key});

  @override
  State<EditProfileScreenWeb> createState() => _EditProfileScreenWebState();
}

class _EditProfileScreenWebState extends State<EditProfileScreenWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await SharedPrefServices.getUserName() ?? '';
    final email = await SharedPrefServices.getUserEmail() ?? '';

    setState(() {
      _nameController.text = name;
      _emailController.text = email;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await SharedPrefServices.saveUserName(_nameController.text);
      await SharedPrefServices.saveUserEmail(_emailController.text);

      Get.back();

      Get.snackbar(
        'profile_updated'.tr,
        'profile_updated_success'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            CustomAppbar(ishow: true),
            SizedBox(height: 56.h),

            Container(
              width: 794.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Column(
                children: [
                  /// Top Section
                  Container(
                    height: 235.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 50.h,
                          left: -40.w,
                          child: ForwardButtonContainer(
                            onTap: () => Get.back(),
                            imageH: 20.h,
                            imageW: 23.5.w,
                            height1: 90.h,
                            height2: 65.h,
                            width1: 90.w,
                            width2: 65.w,
                            image: Appimages.arrowback,
                          ),
                        ),
                        Positioned(
                          top: -140,
                          right: 312.w,
                          left: 312.w,
                          child: Image.asset(
                            Appimages.prince2,
                            height: 225.h,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: BoldText(
                                text: 'edit_profile'.tr,
                                fontSize: 48.sp,
                                selectionColor: AppColors.blueColor,
                              ),
                            ),
                            Center(
                              child: Text(
                                'update_your_personal_information'.tr,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: AppColors.teamColor,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Form Section
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.r),
                          bottomRight: Radius.circular(40.r),
                        ),
                      ),
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 40.h),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// Profile Picture
                                Stack(
                                  children: [
                                    Container(
                                      width: 150.w,
                                      height: 150.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.forwardColor.withOpacity(0.2),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 70.sp,
                                        color: AppColors.forwardColor,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.forwardColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 50.h),

                                /// Name Field
                                LoginTextfield(
                                  controller: _nameController,
                                  text: 'full_name'.tr,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_name'.tr;
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 20.h),

                                /// Email Field
                                LoginTextfield(
                                  controller: _emailController,
                                  text: 'email'.tr,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_email'.tr;
                                    }
                                    if (!value.contains('@')) {
                                      return 'please_enter_valid_email'.tr;
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 20.h),

                                /// Phone Field
                                LoginTextfield(
                                  controller: _phoneController,
                                  text: 'phone_number'.tr,
                                  keyboardType: TextInputType.phone,
                                ),

                                SizedBox(height: 50.h),

                                /// Save Button
                                LoginButton(
                                  text: 'save_changes'.tr,
                                  ishow: true,
                                  icon: Icons.save,
                                  onTap: _saveProfile,
                                ),

                                SizedBox(height: 20.h),
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
          ],
        ),
      ),
    );
  }
}