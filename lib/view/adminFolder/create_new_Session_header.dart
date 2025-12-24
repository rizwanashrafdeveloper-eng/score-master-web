import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';

import '../../api/api_controllers/register_controller.dart';
import '../../api/api_models/registration_model.dart';

class CreateNewSessionHeader extends StatefulWidget {
  const CreateNewSessionHeader({super.key});

  @override
  State<CreateNewSessionHeader> createState() => _CreateNewSessionHeaderState();
}

class _CreateNewSessionHeaderState extends State<CreateNewSessionHeader> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegistrationController registrationController =
  Get.put(RegistrationController());

  int selectedRoleId = 2;
  String selectedRoleText = "facilitator";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(ishow: true, ishow3: true),

              // Remove Expanded from here and use flexible height instead
              Container(
                height: isSmallScreen ? 180.h : 235.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSmallScreen ? 20.r : 40.r),
                    topRight: Radius.circular(isSmallScreen ? 20.r : 40.r),
                  ),
                  color: AppColors.whiteColor,
                ),
                width: isSmallScreen ? screenWidth * 0.95 : 794.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Back Button
                    if (!isSmallScreen)
                      Positioned(
                        left: -40.w,
                        top: 50.h,
                        child: ForwardButtonContainer(
                          onTap: () => Get.back(),
                          imageH: isSmallScreen ? 16.h : 20.h,
                          imageW: isSmallScreen ? 19.w : 23.5.w,
                          height1: isSmallScreen ? 70.h : 90.h,
                          height2: isSmallScreen ? 50.h : 65.h,
                          width1: isSmallScreen ? 70.w : 90.w,
                          width2: isSmallScreen ? 50.w : 65.w,
                          image: Appimages.arrowback,
                        ),
                      ),

                    // Character Image
                    Positioned(
                      top: isSmallScreen ? -80.h : -140.h,
                      left: isSmallScreen
                          ? (screenWidth * 0.95 - 150.w) / 2
                          : (794.w - 150.w) / 2,
                      child: Image.asset(
                        Appimages.prince2,
                        height: isSmallScreen ? 120.h : 150.h,
                      ),
                    ),

                    // Title Text - Center it properly
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: isSmallScreen ? 70.h : 100.h,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "Add Ne".tr,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 28.sp : 36.sp,
                                  color: AppColors.blueColor,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isSmallScreen ? 8.h : 10.h,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xff8DC046),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      "w".tr,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 28.sp : 36.sp,
                                        color: AppColors.blueColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isSmallScreen ? 8.h : 10.h,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.forwardColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 4.w : 6.w,
                                        vertical: 2.h,
                                      ),
                                      child: Text(
                                        selectedRoleText.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 28.sp : 36.sp,
                                          fontWeight: FontWeight.bold,
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
                    ),
                  ],
                ),
              ),

              // Form Section - Don't use Expanded, use flexible container
              Flexible(
                child: Container(
                  width: isSmallScreen ? screenWidth * 0.95 : 794.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isSmallScreen ? 20.r : 40.r),
                      bottomRight: Radius.circular(isSmallScreen ? 20.r : 40.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16.w : 36.w,
                      vertical: isSmallScreen ? 24.h : 32.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Name Field
                        LoginTextfield(
                          text: "Enter Player Name".tr,
                          fontsize: isSmallScreen ? 16.sp : 20.sp,
                          controller: nameController,
                        ),
                        SizedBox(height: isSmallScreen ? 16.h : 24.h),

                        // Email Field
                        LoginTextfield(
                          text: "Enter Player Email Address".tr,
                          fontsize: isSmallScreen ? 16.sp : 20.sp,
                          controller: emailController,
                        ),
                        SizedBox(height: isSmallScreen ? 16.h : 24.h),

                        // Password Field
                        LoginTextfield(
                          text: "Enter Password".tr,
                          fontsize: isSmallScreen ? 16.sp : 20.sp,
                          controller: passwordController,
                          isPassword: true,
                        ),
                        SizedBox(height: isSmallScreen ? 16.h : 24.h),

                        // Role Dropdown
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                isSmallScreen ? 12.r : 16.r),
                            border: Border.all(
                              color:
                              AppColors.selectLangugaeColor.withOpacity(0.1),
                              width: 2.w,
                            ),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: selectedRoleId,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12.w : 16.w,
                                vertical: isSmallScreen ? 14.h : 16.h,
                              ),
                              hintText: "Select Role".tr,
                              hintStyle: TextStyle(
                                fontSize: isSmallScreen ? 16.sp : 20.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16.sp : 20.sp,
                              color: Colors.black,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 2,
                                child: Text("Facilitator"),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text("Player"),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                selectedRoleId = val!;
                                selectedRoleText =
                                val == 2 ? "facilitator" : "player";
                              });
                            },
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 24.h : 32.h),

                        // Save Button
                        Obx(() => registrationController.isLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.selectLangugaeColor,
                            ),
                          ),
                        )
                            : LoginButton(
                          text: "Save".tr,
                          ishow: true,
                          image: Appimages.save,
                          onTap: () async {
                            final name = nameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (name.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty) {
                              Get.snackbar(
                                "Error".tr,
                                "All fields are required".tr,
                                backgroundColor: AppColors.forwardColor,
                                colorText: AppColors.whiteColor,
                              );
                              return;
                            }

                            final newUser = RegistrationModel(
                              name: name,
                              email: email,
                              password: password,
                              roleId: selectedRoleId,
                              role: selectedRoleText,
                            );

                            final success = await registrationController
                                .register(newUser, isAdmin: true);

                            if (success) {
                              nameController.clear();
                              emailController.clear();
                              passwordController.clear();
                            }
                          },
                        )),
                        SizedBox(height: isSmallScreen ? 16.h : 20.h),

                        // Cancel Button
                        LoginButton(
                          text: "Cancel".tr,
                          color: AppColors.forwardColor,
                          onTap: () => Get.back(),
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
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
//
// import '../../api/api_controllers/register_controller.dart';
// import '../../api/api_models/registration_model.dart';
//
// class CreateNewSessionHeader extends StatefulWidget {
//   const CreateNewSessionHeader({super.key});
//
//   @override
//   State<CreateNewSessionHeader> createState() => _CreateNewSessionHeaderState();
// }
//
// class _CreateNewSessionHeaderState extends State<CreateNewSessionHeader> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   final RegistrationController registrationController =
//   Get.put(RegistrationController());
//
//   int selectedRoleId = 2;
//   String selectedRoleText = "facilitator";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Column(
//           children: [
//             CustomAppbar(ishow: true, ishow3: true),
//             SizedBox(height: 56.h),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40.r),
//                   topRight: Radius.circular(40.r),
//                 ),
//                 color: AppColors.whiteColor,
//               ),
//               width: 794.w,
//               height: 235.h,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Positioned(
//                     top: 50.h,
//                     left: -40.w,
//                     child: ForwardButtonContainer(
//                       onTap: () => Get.back(),
//                       imageH: 20.h,
//                       imageW: 23.5.w,
//                       height1: 90.h,
//                       height2: 65.h,
//                       width1: 90.w,
//                       width2: 65.w,
//                       image: Appimages.arrowback,
//                     ),
//                   ),
//                   Positioned(
//                     top: -140,
//                     right: 312.w,
//                     left: 312.w,
//                     child: Image.asset(
//                       Appimages.prince2,
//                       height: 150.h,
//                     ),
//                   ),
//                   Center(
//                     child: RichText(
//                       text: TextSpan(
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                         children: [
//                           TextSpan(
//                             text: "Add Ne".tr,
//                             style: TextStyle(
//                               fontSize: 48.sp,
//                               color: AppColors.blueColor,
//                             ),
//                           ),
//                           WidgetSpan(
//                             alignment: PlaceholderAlignment.middle,
//                             child: Padding(
//                               padding: EdgeInsets.only(bottom: 14.h),
//                               child: Container(
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xff8DC046),
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(30),
//                                     bottomLeft: Radius.circular(30),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "w".tr,
//                                   style: TextStyle(
//                                     fontSize: 48.sp,
//                                     color: AppColors.blueColor,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           WidgetSpan(
//                             alignment: PlaceholderAlignment.middle,
//                             child: Padding(
//                               padding: EdgeInsets.only(bottom: 14.h),
//                               child: Container(
//                                 decoration: const BoxDecoration(
//                                   color: AppColors.forwardColor,
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(30),
//                                     bottomRight: Radius.circular(30),
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                   const EdgeInsets.only(left: 4, right: 10),
//                                   child: Text(
//                                     selectedRoleText.tr,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 48.sp,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 width: 794.w,
//                 decoration: BoxDecoration(
//                   color: AppColors.whiteColor,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(40.r),
//                     bottomRight: Radius.circular(40.r),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       LoginTextfield(
//                         text: "Enter Player Name",
//                         height: 130.h,
//                         fontsize: 42.sp,
//                         controller: nameController,
//                       ),
//                       SizedBox(height: 20.h),
//                       LoginTextfield(
//                         text: "Enter Player Email Address",
//                         height: 130.h,
//                         fontsize: 42.sp,
//                         controller: emailController,
//                       ),
//                       SizedBox(height: 20.h),
//                       LoginTextfield(
//                         text: "Enter Password",
//                         height: 130.h,
//                         fontsize: 42.sp,
//                         controller: passwordController,
//                         isPassword: true,
//                       ),
//                       SizedBox(height: 20.h),
//                       DropdownButtonFormField<int>(
//                         value: selectedRoleId,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26.r),
//                             borderSide: BorderSide(
//                               color: AppColors.selectLangugaeColor
//                                   .withOpacity(0.1),
//                               width: 3.w,
//                             ),
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16.w,
//                             vertical: 20.h,
//                           ),
//                         ),
//                         items: const [
//                           DropdownMenuItem(value: 2, child: Text("Facilitator")),
//                           DropdownMenuItem(value: 3, child: Text("Player")),
//                         ],
//                         onChanged: (val) {
//                           setState(() {
//                             selectedRoleId = val!;
//                             selectedRoleText =
//                             val == 2 ? "facilitator" : "player";
//                           });
//                         },
//                       ),
//                       SizedBox(height: 40.h),
//                       Obx(() => registrationController.isLoading.value
//                           ? const CircularProgressIndicator()
//                           : LoginButton(
//                         text: "Save",
//                         ishow: true,
//                         image: Appimages.save,
//                         onTap: () async {
//                           final name = nameController.text.trim();
//                           final email = emailController.text.trim();
//                           final password = passwordController.text.trim();
//
//                           if (name.isEmpty ||
//                               email.isEmpty ||
//                               password.isEmpty) {
//                             Get.snackbar("Error", "All fields are required",
//                                 backgroundColor: AppColors.forwardColor,
//                                 colorText: AppColors.whiteColor);
//                             return;
//                           }
//
//                           final newUser = RegistrationModel(
//                             name: name,
//                             email: email,
//                             password: password,
//                             roleId: selectedRoleId,
//                             role: selectedRoleText,
//                           );
//
//                           final success = await registrationController
//                               .register(newUser, isAdmin: true);
//
//                           if (success) {
//                             nameController.clear();
//                             emailController.clear();
//                             passwordController.clear();
//                           }
//                         },
//                       )),
//                       SizedBox(height: 20.h),
//                       LoginButton(
//                         text: "Cancel",
//                         color: AppColors.forwardColor,
//                         onTap: () => Get.back(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//
//   }
// }
//
//
//
//
//
