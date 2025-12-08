import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';

// Import your controllers and services
import '../../api/api_controllers/player_team_controller.dart';
import '../../shared_preference/shared_preference.dart';

class PlayerLoginSide extends StatefulWidget {
  const PlayerLoginSide({super.key});

  @override
  State<PlayerLoginSide> createState() => _PlayerLoginSideState();
}

class _PlayerLoginSideState extends State<PlayerLoginSide> {
  final TextEditingController nicknameController = TextEditingController();
  final PlayerTeamController teamController = Get.put(PlayerTeamController());

  Future<void> _createTeamAndProceed() async {
    final nickname = nicknameController.text.trim();

    if (nickname.isEmpty) {
      Get.snackbar("Error", "Please enter a nickname");
      return;
    }

    // ✅ Get gameFormatId from join session response stored in SharedPrefs
    final gameFormatId = await SharedPrefServices.getGameId();
    if (gameFormatId == null) {
      Get.snackbar("Error", "Game Format ID missing. Cannot create team.");
      return;
    }

    // Call API
    await teamController.createTeam(
      nickname: nickname,
      gameFormatId: gameFormatId,
    );

    if (teamController.team.value != null) {
      await SharedPrefServices.saveTeamId(teamController.team.value!.id);
      Get.toNamed(RouteName.playerDashboardScreen2);
    } else {
      Get.snackbar("Error", "Failed to create/join team. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(ishow4: true),
              SizedBox(height: 56.h),

              /// Top fixed container
              GradientColor(
                height: 180.h,
                child: Container(
                  width: 794.w,
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
                        top: -140,
                        right: 312.w,
                        left: 312.w,
                        child: CustomStackImage(
                          image: Appimages.player2,
                          text: "Player",
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: BoldText(
                              text: "Player Nickname",
                              fontSize: 48.sp,
                              selectionColor: AppColors.blueColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GradientColor(
                  ishow: false,
                  child: Container(
                    width: 794.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.r),
                          bottomRight: Radius.circular(40.r)
                      ),
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 36.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Nickname TextField
                              LoginTextfield(
                                controller: nicknameController,
                                text: "Enter Nick Name",
                                height: 120.h,
                                fontsize: 35.sp,
                              ),
                              SizedBox(height: 20.h),

                              // Team Nickname TextField (if needed, otherwise remove)
                              // LoginTextfield(
                              //   text: "Enter Team Nick Name",
                              //   height: 120.h,
                              //   fontsize: 35.sp
                              // ),
                              // SizedBox(height: 30.h),

                              // Continue Button
                              Obx(() {
                                return LoginButton(
                                  text: teamController.isLoading.value
                                      ? "Loading..."
                                      : "Continue",
                                  color: AppColors.forwardColor,
                                  onTap: teamController.isLoading.value
                                      ? null
                                      : _createTeamAndProceed,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
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
// import 'package:scorer_web/components/facilitator_folder/active_Session_screen.dart';
// import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
// import 'package:scorer_web/components/facilitator_folder/schedule_Screen.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/controller/facil_dashboard_controller.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/add_one_Container.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/setting_container.dart';
//
//
// class PlayerLoginSide extends StatelessWidget {
//
//
//   PlayerLoginSide({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Column(
//             children: [
//               CustomAppbar(ishow4: true),
//               SizedBox(height: 56.h),
//
//               /// Top fixed container
//               GradientColor(
//                 height: 180.h,
//                 child: Container(
//                   width: 794.w,
//                   height: 235.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40.r),
//                       topRight: Radius.circular(40.r),
//                     ),
//                     // color: AppColors.whiteColor,
//                   ),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Positioned(
//                         top: -140,
//                         right: 312.w,
//                         left: 312.w,
//                         child: CustomStackImage(
//                           image: Appimages.player2,
//                           text: "Player",
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Center(
//                             child: BoldText(
//                               text: "Player Nickname",
//                               fontSize: 48.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//
//                Expanded(
//               child: GradientColor(
//                 ishow: false,
//                 child: Container(
//                   width: 794.w,
//                   decoration: BoxDecoration(
//                     // color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40.r),
//                       bottomRight: Radius.circular(40.r)
//                     ),
//                   ),
//                   child: ScrollConfiguration(
//                       behavior: ScrollConfiguration.of(context).copyWith(
//                     scrollbars: false, // ✅ ye side wali scrollbar hatayega
//                   ),
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 36.w),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//
//                          LoginTextfield(text: "Enter Nick Name",height: 120.h,fontsize: 35.sp,),
//                           SizedBox(height: 20.h,),
//                           LoginTextfield(text: "Enter Team Nick Name",height: 120.h,fontsize: 35.sp,),
//                           SizedBox(height: 30.h,),
//                           LoginButton(text: "Continue",color: AppColors.forwardColor,onTap: () {
//                             Get.toNamed(RouteName.playerDashboardScreen2);
//                           },
//
//                           ),
//
//
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 30.h,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
