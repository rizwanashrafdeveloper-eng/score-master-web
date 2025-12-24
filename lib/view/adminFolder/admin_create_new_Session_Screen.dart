
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/additional_setting_column.dart';
import 'package:scorer_web/components/facilitator_folder/analysis_container.dart';
import 'package:scorer_web/components/facilitator_folder/count_container_row.dart';
import 'package:scorer_web/components/facilitator_folder/custom_phase_container.dart';
import 'package:scorer_web/components/facilitator_folder/custom_session_Container.dart';
import 'package:scorer_web/components/facilitator_folder/custom_time_row.dart';
import 'package:scorer_web/components/facilitator_folder/feedback_container.dart';
import 'package:scorer_web/components/facilitator_folder/phase_breakdown_container.dart';
import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
import 'package:scorer_web/components/responsive_fonts.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_response_container.dart';
import 'package:scorer_web/widgets/custom_sloder_row.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/filter_useable_container.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/game_select_useable_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/players_containers.dart';
import 'package:scorer_web/widgets/useable_container.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

class AdminCreateNewSessionScreen extends StatelessWidget {
  final bool isSelected;

  const AdminCreateNewSessionScreen({super.key,this.isSelected = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            /// ✅ Fixed Appbar
            CustomAppbar(ishow: true),
            SizedBox(height: 56.h),

            /// ✅ Fixed Top Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r)
                ),
              color: AppColors.whiteColor,

              ),
              // color: AppColors.whiteColor,
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
                    top: -110,
                    right: 312.w,
                    left: 312.w,
                    child: Image.asset(Appimages.game,height: 249.h,width: 249.w,),
                  ),
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Center(
                     child: RichText(
                                            text: TextSpan(
                                              style:  TextStyle(
                                               
                                               
                                          
                                              fontWeight: FontWeight.bold),
                                              children: [
                     TextSpan(
                      text: "create_new".tr,
                      
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
                          
                          decoration: BoxDecoration(
                            color: Color(0xff8DC046),
                            borderRadius: const BorderRadius.only(
                                         topLeft: Radius.circular(30),
                                         bottomLeft: Radius.circular(30),
                            ),
                          ),
                          child:  Text(
                           "session".tr,
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
                        // padding: EdgeInsets.all(8.0),\
                        padding: EdgeInsets.only(bottom: 14.h),

                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.forwardColor,
                            borderRadius: const BorderRadius.only(
                                         topRight: Radius.circular(30),
                                         bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.only(left: 4.0, right: 10.0),
                            child:  Text(
                                        "session".tr,
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
               )
                ],
              ),
            ),

            /// ✅ Scrollable Area
            Expanded(
              child: Container(
                width: 794.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r)
                  ),
                ),
                child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
    scrollbars: false, // ✅ ye side wali scrollbar hatayega
  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      // / SizedBox(height: 20.h),
                       Container(
  height: 137.h,
  child: TextFormField(
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 42.sp,
      fontWeight: FontWeight.w600,
    ),
    decoration: InputDecoration(
      hintText: "enter_session_name".tr,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.languageTextColor,
      ),
      isDense: false, // 👈 ye add karo
      contentPadding: EdgeInsets.symmetric(
        vertical: 40.h, // 👈 isko barhao
        horizontal: 16.w,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(
          color: AppColors.assignColor,
          width: 2.w,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(
          color: AppColors.assignColor,
          width: 2.w,
        ),
      ),
    ),
  ),
),
   SizedBox(height: 50 .h),
                      BoldText(
                text:   "select_game_format".tr, 
                        selectionColor: AppColors.blueColor,
                        fontSize: 28.sp,
                      ),
                      SizedBox(height: 30.h,),
//                            GameSelectUseableContainer(
//
// // fontSize:ResponsiveFont.getFontSizeCustom(defaultSize: 13*widthScaleFactor,smallSize: 10*widthScaleFactor),
//                        text1: "odyssee_des_okr".tr,
//   text2: "strategic_goal_workshop".tr,
//                         isSelected: isSelected,
//                       ),
//                          SizedBox(height: 20.h),
//                       GameSelectUseableContainer(
//
// // fontSize:ResponsiveFont.getFontSizeCustom(defaultSize: 13*widthScaleFactor,smallSize: 10*widthScaleFactor),
//
//                       text1: "feedloop".tr,
//   text2: "feedback_collab_game".tr,
//                         isSelected: false,
//                       ),
//                       SizedBox(height: 20.h),
//                       GameSelectUseableContainer(
//
//
// // fontSize:ResponsiveFont.getFontSizeCustom(defaultSize: 13*widthScaleFactor,smallSize: 10*widthScaleFactor),
//
//                       text1: "innovation_challenge".tr,
//   text2: "creative_problem_workshop".tr,
//                         isSelected: isSelected,
//                       ),

                       SizedBox(height: 31 .h),
                      BoldText(
                        
  text: "number_of_phases".tr,
                        fontSize: 30.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      SizedBox(height: 14 .h),
                      MainText(
  text: "phase_structure_adapts".tr,
                        color: AppColors.teamColor,
                        textAlign: TextAlign.center,
                        height: 1.4,
                        fontSize: 24.sp,
                      ),
                      SizedBox(height: 50.h,),
                      CountContainerRow(),
                                            SizedBox(height: 30 .h),
                      BoldText(
                        text: "enter_details_phase_1".tr,
                        selectionColor: AppColors.blueColor,
                        fontSize: 30.sp,
                      ),
                                            SizedBox(height: 30 .h),
CustomPhaseContainer(text1: "name_phase_1".tr, text2: "Strategy"),
                      SizedBox(height: 10.h),
CustomPhaseContainer(text1: "no_of_stages".tr, text2: "03"),
                      SizedBox(height: 10.h),
CustomPhaseContainer(text1: "duration".tr, text2: "15 min"),
SizedBox(height: 50.h,),
   BoldText(
  text: "phase_1_stages".tr,
  selectionColor: AppColors.blueColor,
  fontSize: 30.sp,
),
                      SizedBox(height: 25 .h),
                      FilterUseableContainer(
  
  isSelected: true, text: "mcq".tr, onTap: () {}),
                      SizedBox(height: 20.h),
FilterUseableContainer(isSelected: false, text: "open_ended".tr, onTap: () {}),
                      SizedBox(height: 20.h),
FilterUseableContainer(isSelected: true, text: "puzzle".tr, onTap: () {}),
                      SizedBox(height: 20.h),
FilterUseableContainer(isSelected: false, text: "simulation".tr, onTap: () {}),
   SizedBox(height: 24 .h),
                      LoginButton(
                        text: "move_to_phase2".tr,
                        // height: 45 * scaleFactor,
                        color: AppColors.forwardColor,
                        // radius: 12 * scaleFactor,
                        // fontSize: 14 * scaleFactor,
                        fontFamily: "refsan",
                      ),
                      SizedBox(height: 50 .h),
                      BoldText(
                        text: "player_capacity".tr,
                        selectionColor: AppColors.blueColor,
                        fontSize: 30.sp,
                      ),
                      SizedBox(height: 50.h,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Column(
                            children: [
                              Image.asset(Appimages.pas, width: 190 .w, height: 150 .h),
                              // SizedBox(height: 10 .h),
                              BoldText(text: "20-50", fontSize: 24.sp, selectionColor: AppColors.blueColor),
MainText(text: "small".tr, fontSize: 20.sp, height: 1.7, color: AppColors.teamColor),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(Appimages.pas, width: 190 .w, height: 150 .h),
                              // SizedBox(height: 10 .h),
                              BoldText(text: "20-50", fontSize: 24.sp, selectionColor: AppColors.blueColor),
MainText(text: "medium".tr, fontSize: 20.sp, height: 1.7, color: AppColors.teamColor),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(Appimages.pas, width: 190 .w, height: 150 .h),
                              // SizedBox(height: 10 .h),
                              BoldText(text: "20-50", fontSize: 24.sp, selectionColor: AppColors.blueColor),
MainText(text: "large".tr, fontSize: 20.sp, height: 1.7, color: AppColors.teamColor),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                        Container(
                        height: 90.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: AppColors.greyColor, width: 1.5 .w),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10 .w,vertical: 10.h),
                          child: TextFormField(
                            cursorColor: AppColors.languageTextColor,
                            decoration: InputDecoration(
                              hintText: "enter_custom_number".tr,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 24.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),

                            ),
                          ),
                        ),
                      ),
                        ),
                         SizedBox(height: 40 .h),
                      BoldText(
                        text: "badge_labeling".tr,
                        fontSize: 30.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      SizedBox(height: 16 .h),
                      Image.asset(Appimages.badge, width: 250.w, height: 200.h),
                      SizedBox(height: 20.h),
                      CustomPhaseContainer(
                        text1: "badge_name".tr,
                        text2: "Gold Achiever",
                        // fontSize: ,
                        color: AppColors.forwardColor,
                      ),
                      SizedBox(height: 20 .sp),
                      CustomPhaseContainer(
                        text1:  "required_score".tr,
                        text2: "90+",
                        // fontSize: 16 * scaleFactor,
                        color: AppColors.forwardColor,
                      ),
                      SizedBox(height: 30.sp),
                      LoginButton(
                        text:  "add_more_badges".tr,
                        // height: 45 * scaleFactor,
                        color: AppColors.forwardColor,
                        // radius: 12 * scaleFactor,
                        // fontSize: 14 * scaleFactor,
                        fontFamily: "refsan",
                      ),

                      SizedBox(height: 100.h,),
                         Container(
                        // width: 337 * scaleFactor
                        // ,
                        width: double.infinity,
                        height: 100.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyColor, width: 1.5 .w),
                          borderRadius: BorderRadius.circular(24 .r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 11.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(Appimages.ai2, width: 80.w, height: 80.h),
                                  SizedBox(width: 10.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    MainText(text: "ai_scoring".tr, fontSize: 24.sp),
MainText(text: "enable_ai_scoring".tr, fontSize: 18.sp, color: AppColors.teamColor, height: 1.2),
                               ],
                                  ),
                                ],
                              ),
                              FlutterSwitch(
                                value: true,
                                onToggle: (val) {},
                                height: 30.sp,
                                width: 50 .sp,
                                activeColor: AppColors.forwardColor,
                                inactiveColor: AppColors.forwardColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 80.h,),
                      AdditionalSettingColumn(),
                      SizedBox(height: 80.h,),
                        LoginButton(
            
                        
                        text: "start_immediately".tr,
                        ishow: true,
                        icon: Icons.play_arrow_rounded,
                      
                      ),
                      SizedBox(height: 13 .h),
                      LoginButton(
               

                   text:      "schedule_for_later".tr, 
                        image: Appimages.calender,
                        ishow: true,
                        color: AppColors.forwardColor,
                      ),
                      SizedBox(height: 50 .h),
                   
                     
                    
               
                   
// FilterUseableConta

                   
                                        
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
    );
  }
}
