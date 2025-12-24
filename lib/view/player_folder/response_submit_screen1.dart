import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/admin_folder.dart/admin_team_progress_contaner.dart';
import 'package:scorer_web/components/player_folder/scenerio_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/controller/game_select_controller.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/custom_stratgy_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';
import 'package:scorer_web/widgets/useable_text_row.dart';
import 'package:scorer_web/api/api_controllers/question_for_sessions_controller.dart';

class ResponseSubmitScreen1 extends StatelessWidget {
  final questionController = Get.find<QuestionForSessionsController>();
  late final GameSelectController controller;

  ResponseSubmitScreen1({super.key}) {
    controller = GameSelectController(questionController: questionController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 700.h,
                right: 0,
                child: TeamAlphaContainer(),
              ),
              Column(
                children: [
                  CustomAppbar(ishow4: true, ishow: true),
                  SizedBox(height: 56.h),

                  /// Top fixed container
                  GradientColor(
                    height: 180.h,
                    child: Container(
                      width: 794.w,
                      height: 150.h,
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
                                  text: "Team Alpha",
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
                            bottomRight: Radius.circular(40.r),
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
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        height: 570.h,
                                        width: 570.w,
                                        child: Image.asset(
                                          Appimages.ok,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 110.h,
                                        right: 80.w,
                                        child: Obx(() => CreateContainer(
                                          fontsize2: 12,
                                          text: "${questionController.questionData.value?.phases.length ?? 0} Phases",
                                          top: -25.h,
                                          right: 2.w,
                                          width: 172.w,
                                          borderW: 2.w,
                                          arrowW: 30.w,
                                          arrowh: 35.h,
                                          height: 63.h,
                                        )),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20.h),
                                  BoldText(
                                    text: "Response Submitted!".tr,
                                    fontSize: 30.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  Center(
                                    child: MainText(
                                      height: 1.2,
                                      text: "team_decision_recorded".tr,
                                      fontSize: 20.sp,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.greyColor,
                                        width: 1.5.w,
                                      ),
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 30.h),
                                          BoldText(
                                            text: "your_submission".tr,
                                            selectionColor: AppColors.blueColor,
                                            fontSize: 30.sp,
                                          ),
                                          SizedBox(height: 15.h),
                                          // You can display the actual submitted answer here
                                          // For now, showing a placeholder
                                          MainText(
                                            height: 1.5,
                                            text: "Your submitted answer will appear here",
                                            fontSize: 20.sp,
                                          ),
                                          SizedBox(height: 15.h),
                                          BoldText(
                                            text: "reasoning".tr,
                                            selectionColor: AppColors.redColor,
                                            fontSize: 30.sp,
                                          ),
                                          SizedBox(height: 10.h),
                                          MainText(
                                            text: "Your reasoning will appear here...",
                                            fontSize: 20.sp,
                                            height: 1.5,
                                          ),
                                          SizedBox(height: 20.h),
                                          UseableTextrow(
                                            color: AppColors.forwardColor,
                                            text: "submitted_at".tr,
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  AdminTeamProgress(),
                                  SizedBox(height: 30.h),
                                  Image.asset(
                                    Appimages.timeout3,
                                    height: 200.h,
                                    width: 200.w,
                                  ),
                                  BoldText(
                                    text: "waiting_for_team".tr,
                                    fontSize: 30.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  SizedBox(height: 15.h),

                                  Center(
                                    child: MainText(
                                      height: 1.2,
                                      text: "waiting_for_member".tr,
                                      fontSize: 20.sp,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 10.h,
                                        width: 10.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.forwardColor,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: 10.h,
                                        width: 10.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.forwardColor2,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        height: 10.h,
                                        width: 10.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.forwardColor3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    child: Column(
                                      children: [
                                        CustomStratgyContainer(
                                          iconContainer: AppColors.forwardColor,
                                          icon: Icons.check,
                                          text1: "phase1_strategy".tr,
                                          text2: "Completed • 20 min",
                                          text3: "completed".tr,
                                          smallContainer: AppColors.forwardColor,
                                          largeConatiner: AppColors.forwardColor,
                                          value: 1,
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomStratgyContainer(
                                          iconContainer: AppColors.forwardColor,
                                          icon: Icons.check,
                                          text1: "phase2_strategy".tr,
                                          text2: "Active • 30 min",
                                          text3: "completed".tr,
                                          smallContainer: AppColors.forwardColor,
                                          largeConatiner: AppColors.forwardColor,
                                          value: 1,
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomStratgyContainer(
                                          iconContainer: AppColors.watchColor,
                                          icon: Icons.watch_later,
                                          text1: "phase3_implementation".tr,
                                          text2: "Upcoming • 15 min",
                                          text3: "pending".tr,
                                          smallContainer: AppColors.watchColor,
                                          largeConatiner: AppColors.greyColor,
                                        ),
                                        SizedBox(height: 10.h),
                                        CustomStratgyContainer(
                                          iconContainer: AppColors.watchColor,
                                          icon: Icons.watch_later,
                                          text1: "phase4_evaluation".tr,
                                          text2: "Upcoming • 15 min",
                                          text3: "pending".tr,
                                          smallContainer: AppColors.watchColor,
                                          largeConatiner: AppColors.greyColor,
                                        ),
                                        SizedBox(height: 30.h),
                                        LoginButton(
                                          onTap: () => Get.toNamed(RouteName.submitResponseScreen2),
                                          fontSize: 20,
                                          text: "review_ai_score".tr,
                                          color: AppColors.forwardColor,
                                          ishow: true,
                                          image: Appimages.ai2,
                                          imageHeight: 32.h,
                                          imageWidth: 32.w,
                                        ),
                                        SizedBox(height: 40.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamAlphaContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}