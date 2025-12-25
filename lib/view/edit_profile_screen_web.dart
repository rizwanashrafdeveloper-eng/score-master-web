import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';

import '../api/api_controllers/user_profile_controller.dart';

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

  late final UserProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(UserProfileController());
    _loadProfileData();
  }

  void _loadProfileData() {
    // Listen to controller changes and update text fields
    ever(_profileController.userName, (value) {
      if (_nameController.text != value) {
        _nameController.text = value;
      }
    });

    ever(_profileController.userEmail, (value) {
      if (_emailController.text != value) {
        _emailController.text = value;
      }
    });

    ever(_profileController.userPhone, (value) {
      if (_phoneController.text != value) {
        _phoneController.text = value;
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final success = await _profileController.updateUserProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(ishow: true),
              SizedBox(height: 56.h),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 794.w,
                      maxHeight: MediaQuery.of(context).size.height - 180.h,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Top Section
                          SizedBox(
                            height: 180.h,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Back Button
                                Positioned(
                                  top: 25.h,
                                  left: -30.w,
                                  child: ForwardButtonContainer(
                                    onTap: () => Get.back(),
                                    imageH: 18.h,
                                    imageW: 21.w,
                                    height1: 80.h,
                                    height2: 60.h,
                                    width1: 80.w,
                                    width2: 60.w,
                                    image: Appimages.arrowback,
                                  ),
                                ),

                                // Profile Image
                                Positioned(
                                  top: -90.h,
                                  right: 312.w,
                                  left: 312.w,
                                  child: Image.asset(
                                    Appimages.prince2,
                                    height: 180.h,
                                  ),
                                ),

                                // Title
                                Positioned(
                                  bottom: 5.h,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      BoldText(
                                        text: 'edit_profile'.tr,
                                        fontSize: 42.sp,
                                        selectionColor: AppColors.blueColor,
                                      ),
                                      SizedBox(height: 5.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                                        child: Text(
                                          'update_your_personal_information'.tr,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: AppColors.teamColor,
                                            height: 1.3,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Form Section
                          Expanded(
                            child: Obx(() {
                              if (_profileController.isLoading.value) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.blueColor,
                                  ),
                                );
                              }

                              return ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(
                                  scrollbars: false,
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 90.w,
                                    vertical: 25.h,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        // /// Profile Picture
                                        // Stack(
                                        //   children: [
                                        //     Container(
                                        //       width: 110.w,
                                        //       height: 110.h,
                                        //       decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         color: AppColors.forwardColor.withOpacity(0.2),
                                        //       ),
                                        //       child: Icon(
                                        //         Icons.person,
                                        //         size: 55.sp,
                                        //         color: AppColors.forwardColor,
                                        //       ),
                                        //     ),
                                        //     Positioned(
                                        //       bottom: 0,
                                        //       right: 0,
                                        //       child: Container(
                                        //         padding: EdgeInsets.all(7.w),
                                        //         decoration: BoxDecoration(
                                        //           color: AppColors.forwardColor,
                                        //           shape: BoxShape.circle,
                                        //           border: Border.all(
                                        //             color: Colors.white,
                                        //             width: 2.w,
                                        //           ),
                                        //         ),
                                        //         child: Icon(
                                        //           Icons.camera_alt,
                                        //           color: Colors.white,
                                        //           size: 22.sp,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        SizedBox(height: 25.h),

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

                                        SizedBox(height: 18.h),

                                        SizedBox(height: 18.h),

                                        /// Phone Field
                                        LoginTextfield(
                                          controller: _phoneController,
                                          text: 'phone_number'.tr,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value != null && value.isNotEmpty) {
                                              if (value.length < 10) {
                                                return 'phone_must_be_10_digits'.tr;
                                              }
                                            }
                                            return null;
                                          },
                                        ),

                                        SizedBox(height: 35.h),

                                        /// Save Button
                                        Obx(() => LoginButton(
                                          text: _profileController.isLoading.value
                                              ? 'saving'.tr
                                              : 'save_changes'.tr,
                                          ishow: true,
                                          icon: _profileController.isLoading.value
                                              ? null
                                              : Icons.save,
                                          onTap: _profileController.isLoading.value
                                              ? null
                                              : _saveProfile,
                                        )),

                                        SizedBox(height: 25.h),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}