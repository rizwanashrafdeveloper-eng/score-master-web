
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/analysis_container.dart';
import 'package:scorer_web/components/facilitator_folder/feedback_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_response_container.dart';
import 'package:scorer_web/widgets/custom_sloder_row.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/team_alpha_container.dart';
import 'package:scorer_web/widgets/useable_container.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

class ViewScoreScreen extends StatelessWidget {
  const ViewScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
 Positioned(
              top:700.h,
              right: 0,
              // left: 0,
              child: TeamAlphaContainer()),
            Column(
              children: [
                /// ✅ Fixed Appbar
                CustomAppbar(ishow: true),
                SizedBox(height: 56.h),
            
                /// ✅ Fixed Top Container
                GradientColor(
                  height: 200.h,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r)
                      ),
                    // color: AppColors.whiteColor,
                              
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
                            onTap: () {
                              Get.back();
                            },
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
                          child: CustomStackImage(),
                        ),
                        Center(
                          child: BoldText(
                            text: "View Score",
                            fontSize: 48.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
                /// ✅ Scrollable Area
                Expanded(
                  child: GradientColor(
                    ishow: false,
                    child: Container(
                      width: 794.w,
                      decoration: BoxDecoration(
                        // color: AppColors.whiteColor,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 371.h, // ScreenUtil().setHeight(171)
                                  // width: 336.w, // ScreenUtil().setWidth(336)
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.greyColor, width: 3.31.w), // ScreenUtil().setWidth(1.7)
                                    borderRadius: BorderRadius.circular(52.r), // Using .r for radius scaling
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 19.w), // ScreenUtil().setWidth(19)
                                    child: Column(
                    children: [
                                SizedBox(height: 16.h), // ScreenUtil().setHeight(16)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                    children: [
                      Image.asset(
                        Appimages.blackgirl,
                        height: 112.h, // ScreenUtil().setHeight(47)
                        width: 80.w, // ScreenUtil().setWidth(35)
                      ),
                      SizedBox(width: 3.w), // ScreenUtil().setWidth(3)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainText(text: "Alex Martinez", fontSize: 30.sp), // ScreenUtil().setSp(14)
                          MainText(
                            text: "Team Alpha",
                            color: AppColors.teamColor,
                            fontSize: 30.sp, // ScreenUtil().setSp(13)
                            height: 1,
                          ),
                        ],
                      )
                    ],
                                    ),
                                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UseableContainer(
                        //height: 61.h, // ScreenUtil().setHeight(28)
                                
                        text: "submitted".tr,
                     fontSize: 20.sp,
                        color: AppColors.forwardColor,
                        textColor: AppColors.whiteColor,
                      ),
                      SizedBox(width: 4.w), // ScreenUtil().setWidth(4)
                      UseableContainer(
                        text: "94",
                        fontFamily: "giory",
                        fontSize: 35.sp, // ScreenUtil().setSp(14)
                        //width: 83.w, // ScreenUtil().setWidth(37)
                       // height: 61.h, // ScreenUtil().setHeight(28)
                        color: AppColors.orangeColor,
                      )
                    ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 50.h), // ScreenUtil().setHeight(25)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                    children: [
                      BoldText(
                        text: "3:42 PM",
                        fontSize: 50.sp, // ScreenUtil().setSp(24)
                        selectionColor: AppColors.forwardColor,
                      ),
                      BoldText(
                        text: "submitted".tr,
                        selectionColor: AppColors.blueColor,
                        fontSize: 35.sp, // ScreenUtil().setSp(16)
                      )
                    ],
                                    ),
                                    SizedBox(width: 100.w), // ScreenUtil().setWidth(40)
                                    Column(
                    children: [
                      BoldText(
                        text: "4:15 PM",
                        fontSize: 50.sp, // ScreenUtil().setSp(24)
                        selectionColor: AppColors.forwardColor,
                      ),
                      BoldText(
                        text: "scored".tr,
                        selectionColor: AppColors.blueColor,
                        fontSize: 30.sp, // ScreenUtil().setSp(16)
                      )
                    ],
                                    )
                                  ],
                                )
                    ],
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 20.h,),
                            AnalysisContainer(height: 700.h, ishow: true,right: 300.w,
                            radius: 50.r,width: 3.31.w,
                            ),
                            SizedBox(height: 150.h,),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26.r),
                                    border: Border.all(color: AppColors.greyColor, width: 1.5.w),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 20.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BoldText(
                                            text: "team_response".tr,
                                            fontSize: 28.sp,
                                            selectionColor: AppColors.blueColor,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                Appimages.timeout2,
                                                height: 30.h,
                                                width: 30.w,
                                              ),
                                              MainText(
                                                text: "2 min read",
                                                fontSize: 24.sp,
                                                color: AppColors.teamColor,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      MainText(
                                        text:
                                            "Primary Objective: Our primary objective is to increase customer satisfaction by 25% through improved service delivery and enhanced user experience across all touchpoints.",
                                        fontSize: 22.sp,
                                        height: 1.2,
                                      ),
                                      SizedBox(height: 20.h),
                                      BoldText(
                                        text: "key_strategies".tr,
                                        fontSize: 28.sp,
                                        selectionColor: AppColors.blueColor,
                                      ),
                                      SizedBox(height: 20.h),
                                      MainText(
                                        text:
                                            "Implement real-time feedback system: Deploy customer feedback tools at every service interaction point to capture immediate responses and identify pain points quickly.".tr,
                                        fontSize: 22.sp,
                                        height: 1.2,
                                      ),
                                      SizedBox(height: 20.h),
                                      MainText(
                                        text:
                                            "Reduce response time to under 2 hours: Streamline our support processes and implement automated routing to ensure faster resolution of customer inquiries.".tr,
                                        fontSize: 22.sp,
                                        height: 1.2,
                                      ),
                                      SizedBox(height: 20.h),
                                      MainText(
                                        text:
                                            "Enhance self-service capabilities: comprehensive FAQ sections, video tutorials, and chatbot assistance to empower customers to resolve common issues independently.".tr,
                                        fontSize: 22.sp,
                                        height: 1.2,
                                      ),
                                      SizedBox(height: 20.h),
                                      MainText(
                                        text:
                                            "These strategies align with our company's customer-centric approach and will be measured through monthly satisfaction surveys, response time analytics, and self-service adoption rates.".tr,
                                        fontSize: 22.sp,
                                        height: 1.2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h,),
                                  LoginButton(
                              onTap: () {
                        Get.toNamed(RouteName.overViewOptionScreen);
                      },
                             text: "move_next_stage".tr,
                          
                              icon: Icons.fast_forward,
                                
                                  ishow: true,
                                  imageHeight: 48.h,
                                  imageWidth: 42.w,
                                  
                            ),
                                SizedBox(height: 15.h,),
                                   LoginButton(
                                    
                                  text: "Share Responses".tr,
                                  color: AppColors.forwardColor,
                                  image: Appimages.move,
                               
                                ),
                                SizedBox(height: 15.h,),
                                 LoginButton(
                          
                              text: "export_pdf".tr,
                               ishow: true,
                                  imageHeight: 48.h,
                                  imageWidth: 42.w,
                              image: Appimages.export,
                              color: AppColors.redColor,
                            ),
                                SizedBox(height: 15.h,),
                                  LoginButton(
                             
                              text: "edit_score_feedback".tr,
                              ishow: true,
                                  imageHeight: 48.h,
                                  imageWidth: 42.w,
                              icon: Icons.edit,
                              color: AppColors.orangeColor,
                            ),
                                
                                
                            SizedBox(height: 100,)
                                
                                  // SizedBox(height: 20.h),
                        
                            ],
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
    );
  }
}
