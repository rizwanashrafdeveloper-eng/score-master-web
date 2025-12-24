import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/metrices_container.dart';
import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/players_containers.dart';

class AdminLeaderboardScreen extends StatelessWidget {
    final VoidCallback? onOpenDrawer; // 👈 callback
  const AdminLeaderboardScreen({super.key, this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
  final RxBool isTeamSelected = false.obs;

    return SingleChildScrollView(
      child: Column(
        
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 60.w),
            child: Column(
              children: [
                SizedBox(height: 50.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                   Container(
                            width: 25.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.visitingColor,
                            ),
                          ),
                          SizedBox(width: 18.w,),
                                MainText(
                                        text: "live_updates".tr,
                                        color: AppColors.visitingColor,
                                        fontSize: 31.sp
                                      ),
                              ],
                            ),
              CreateContainer(
              containerColor: AppColors.forwardColor.withOpacity(0.3),
              text: "overall".tr,
              // width: screenWidth * 0.18,
              textColor: AppColors.forwardColor,
              borderColor: AppColors.forwardColor,
              // width: 150.w,
              // height: 70.h,
              // borderW: 1.97.w,
              // fontsize2: 31.sp,
              ishow: false,
            ),
                  ],
                ),
                SizedBox(height: 70.h,),
            
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Row(
                          children: [
                            BoldText(
                              text: "players".tr,
                              selectionColor: isTeamSelected.value
                                  ? AppColors.playerColo1r
                                  : AppColors.blueColor,
                              fontSize: 31.sp,
                            ),
                                            SizedBox(width: 18.w),
            
                            FlutterSwitch(
                              value: isTeamSelected.value,
                              onToggle: (val) {
                                isTeamSelected.value = val;
                              },
                              height: 52.h,
                              width: 75.w,
                              activeColor: AppColors.forwardColor,
                              inactiveColor: AppColors.forwardColor,
                            ),
                            SizedBox(width: 18.w),
                            BoldText(
                              text: "teams".tr,
                              selectionColor: isTeamSelected.value
                                  ? AppColors.blueColor
                                  : AppColors.playerColo1r,
                              fontSize: 31.sp
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                           onOpenDrawer?.call(); //
                        },
                        child: CreateContainer(
                          text: "use_filter".tr,
                          width: 173.w,
                          height: 61.h,
                          arrowh: 40.h,
                          arrowW: 34.w,
                          borderW: 1.97.w,
                          top: -33.h,
                          right: 10.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 120.h,),
                    Obx(() => PlayersRow(isTeamSelected: isTeamSelected.value)),
            SizedBox(height: 37.h,),
                       Obx(
                    () => PlayersContainers(
                      text1: "1",
                      text2: isTeamSelected.value ? "team_alpha".tr : "Alex M.",
                      image: Appimages.facil2,
                      icon: Icons.keyboard_arrow_up_outlined,
                      iconColor: AppColors.arrowColor,
                      text4: "2,890 pts",
                      ishow: true,
                      containerColor: AppColors.yellowColor,
                              leftPadding: 20.w
            
                    ),
                  ),
                  SizedBox(height: 20.h),
                    
                  // SizedBox(height: screenHeight * 0.018),
                  Obx(
                    () => PlayersContainers(
                      text1: "2",
                      text2: isTeamSelected.value ? "Team Rock" : "Sarah J.",
                      image: Appimages.play2,
                      icon: Icons.keyboard_arrow_down_outlined,
                      iconColor: AppColors.brownColor,
                      text4: "2,890 pts",
                      ishow: true,
                      containerColor: AppColors.greyColor,
                           leftPadding: 20.w
            
                    ),
                  ),
                  SizedBox(height: 20.h),
                    
                  // SizedBox(height: screenHeight * 0.018),
                  Obx(
                    () => PlayersContainers(
                      text1: "3",
                      text2: isTeamSelected.value ? "Team Beta" : "Mike C.",
                      image: Appimages.play5,
                      icon: Icons.keyboard_arrow_down_outlined,
                      iconColor: AppColors.brownColor,
                      text4: "2,180 pts",
                      ishow: true,
                      containerColor: AppColors.orangeColor,
                              leftPadding: 20.w
            
                    ),
                  ),
                  SizedBox(height: 20.h),
                  PlayersContainers(
                    text1: "4",
                    text2: "Mike C.",
                    image: Appimages.play3,
                    icon: Icons.keyboard_arrow_down_outlined,
                    iconColor: AppColors.brownColor,
                    text4: "1,760 pts",
                    ishow: true,
                    containerColor: AppColors.playerColor,
                            leftPadding: 20.w
            
                  ),
                  SizedBox(height: 20.h),
                    
                  // SizedBox(height: screenHeight * 0.018),
                  PlayersContainers(
                    text1: "5",
                    text2: "Mike C.",
                    image: Appimages.play4,
                    icon: Icons.keyboard_arrow_up_outlined,
                    iconColor: AppColors.forwardColor,
                    text4: "1,760 pts",
                    ishow: true,
                    containerColor: AppColors.playerColor,
                    leftPadding: 20.w
                  ),
               
                 
              ],
            ),
          ),
SizedBox(height: 30.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: MetricesContainer(),
          ),
          SizedBox(height: 35.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 60.w),
              child: Column(
                children: [
                    LoginButton(
                fontSize:24 ,
              
                onTap: () {
                      // Get.toNamed(RouteName.endSessionScreen);
              },
                text: "end_session".tr,
                color: AppColors.redColor,
                icon: Icons.square_sharp,
                ishow: true,
                
              ),
              SizedBox(height: 15.h),
              LoginButton(
                text: "share_results".tr,
                fontSize:24 ,
                color: AppColors.forwardColor,
                image: Appimages.move,
                ishow: true,
              ),
              SizedBox(height: 15.h),

              LoginButton(
                fontSize:24 ,

  text: "export_by_phase".tr,
  ishow: true,
  image: Appimages.export,
  // fontSize: 18,
),
SizedBox(height: 100.h,)
                ],
              ),
            )
        
        ],
      ),
    );
  }
}