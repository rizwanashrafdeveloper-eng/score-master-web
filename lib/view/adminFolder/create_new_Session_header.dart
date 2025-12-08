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
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            CustomAppbar(ishow: true, ishow3: true),
            SizedBox(height: 56.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
                color: AppColors.whiteColor,
              ),
              width: 794.w,
              height: 235.h,
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
                      height: 150.h,
                    ),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "Add Ne".tr,
                            style: TextStyle(
                              fontSize: 48.sp,
                              color: AppColors.blueColor,
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xff8DC046),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  "w".tr,
                                  style: TextStyle(
                                    fontSize: 48.sp,
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
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.forwardColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 4, right: 10),
                                  child: Text(
                                    selectedRoleText.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48.sp,
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: 794.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoginTextfield(
                        text: "Enter Player Name",
                        height: 130.h,
                        fontsize: 42.sp,
                        controller: nameController,
                      ),
                      SizedBox(height: 20.h),
                      LoginTextfield(
                        text: "Enter Player Email Address",
                        height: 130.h,
                        fontsize: 42.sp,
                        controller: emailController,
                      ),
                      SizedBox(height: 20.h),
                      LoginTextfield(
                        text: "Enter Password",
                        height: 130.h,
                        fontsize: 42.sp,
                        controller: passwordController,
                        isPassword: true,
                      ),
                      SizedBox(height: 20.h),
                      DropdownButtonFormField<int>(
                        value: selectedRoleId,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26.r),
                            borderSide: BorderSide(
                              color: AppColors.selectLangugaeColor
                                  .withOpacity(0.1),
                              width: 3.w,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 2, child: Text("Facilitator")),
                          DropdownMenuItem(value: 3, child: Text("Player")),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedRoleId = val!;
                            selectedRoleText =
                            val == 2 ? "facilitator" : "player";
                          });
                        },
                      ),
                      SizedBox(height: 40.h),
                      Obx(() => registrationController.isLoading.value
                          ? const CircularProgressIndicator()
                          : LoginButton(
                        text: "Save",
                        ishow: true,
                        image: Appimages.save,
                        onTap: () async {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            Get.snackbar("Error", "All fields are required",
                                backgroundColor: AppColors.forwardColor,
                                colorText: AppColors.whiteColor);
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
                      SizedBox(height: 20.h),
                      LoginButton(
                        text: "Cancel",
                        color: AppColors.forwardColor,
                        onTap: () => Get.back(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}







// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/facilitator_folder/additional_setting_column.dart';
// import 'package:scorer_web/components/facilitator_folder/analysis_container.dart';
// import 'package:scorer_web/components/facilitator_folder/count_container_row.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_phase_container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_session_Container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_time_row.dart';
// import 'package:scorer_web/components/facilitator_folder/feedback_container.dart';
// import 'package:scorer_web/components/facilitator_folder/phase_breakdown_container.dart';
// import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_response_container.dart';
// import 'package:scorer_web/widgets/custom_sloder_row.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/filter_useable_container.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/game_select_useable_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/players_containers.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// // import 'package:syncfusion_flutter_sliders/sliders.dart';
//
// class CreateNewSessionHeader extends StatelessWidget {
//   final bool isSelected;
//
//   const CreateNewSessionHeader({super.key, this.isSelected = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Column(
//           children: [
//             /// ✅ Fixed Appbar
//             CustomAppbar(ishow: true, ishow3: true),
//             SizedBox(height: 56.h),
//
//             /// ✅ Fixed Top Container
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40.r),
//                   topRight: Radius.circular(40.r),
//                 ),
//                 color: AppColors.whiteColor,
//               ),
//               // color: AppColors.whiteColor,
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
//                     child: CustomStackImage(
//                       image: Appimages.prince2,
//                       text: "Administrator",
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Center(
//                         child: RichText(
//                           text: TextSpan(
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                             children: [
//                               TextSpan(
//                                 text: "Add Ne".tr,
//
//                                 style: TextStyle(
//                                   fontSize: 48.sp,
//                                   color: AppColors.blueColor,
//                                 ),
//                               ),
//                               WidgetSpan(
//                                 alignment: PlaceholderAlignment.middle,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(bottom: 14.h),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Color(0xff8DC046),
//                                       borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(30),
//                                         bottomLeft: Radius.circular(30),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "w".tr,
//                                       style: TextStyle(
//                                         fontSize: 48.sp,
//                                         color: AppColors.blueColor,
//
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               WidgetSpan(
//                                 alignment: PlaceholderAlignment.middle,
//                                 child: Padding(
//                                   // padding: EdgeInsets.all(8.0),\
//                                   padding: EdgeInsets.only(bottom: 14.h),
//
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: AppColors.forwardColor,
//                                       borderRadius: const BorderRadius.only(
//                                         topRight: Radius.circular(30),
//                                         bottomRight: Radius.circular(30),
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.only(
//                                         left: 4.0,
//                                         right: 10.0,
//                                       ),
//                                       child: Text(
//                                         "player".tr,
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 48.sp,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             /// ✅ Scrollable Area
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
//                 child: ScrollConfiguration(
//                   behavior: ScrollConfiguration.of(context).copyWith(
//                     scrollbars: false, // ✅ ye side wali scrollbar hatayega
//                   ),
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 20.w,
//                       vertical: 10.h,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 36.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(height: 40.h),
//                           LoginTextfield(
//                             text: "Enter Player Name",
//                             height: 130.h,
//                             fontsize: 42.sp,
//                           ),
//                           SizedBox(height: 20.h),
//                           LoginTextfield(
//                             text: "Enter Player Email Address",
//                             height: 130.h,
//                             fontsize: 42.sp,
//                           ),
//                           SizedBox(height: 20.h),
//                           Center(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10.w),
//                               height: 130.h,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(26.r),
//                                 border: Border.all(
//                                   color: AppColors.selectLangugaeColor
//                                       .withOpacity(0.1),
//                                   width: 3.w,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   BoldText(text: "role".tr, fontSize: 42.sp),
//                                   Row(
//                                     children: [
//                                       BoldText(
//                                         text: "facilitator".tr,
//                                         selectionColor: AppColors.blueColor,
//                                         fontSize: 42.sp,
//                                       ),
//                                       Icon(
//                                         Icons.keyboard_arrow_down_rounded,
//                                         color: AppColors.forwardColor,
//                                         size: 50.sp,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           SizedBox(height: 40.h),
//
//                           LoginButton(
//                             // fontSize: 20,
//                             text: "save".tr,
//                             ishow: true,
//                             image: Appimages.save,
//                           ),
//                           SizedBox(height: 13.h),
//                           LoginButton(
//                             // fontSize: 20,
//                             text: "cancel".tr,
//                             color: AppColors.forwardColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
