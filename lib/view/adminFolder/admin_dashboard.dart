import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/admin_folder.dart/admin_active_session.dart';
import 'package:scorer_web/components/facilitator_folder/admin_schedule_Screen.dart';
import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/controller/bottom_navigation_controller.dart';
import 'package:scorer_web/controller/facil_dashboard_controller.dart';
import 'package:scorer_web/view/adminFolder/game_Screen_Adminside.dart';
import 'package:scorer_web/view/adminFolder/user_managemnet_screen.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/widget_nav_item.dart';

// Import your API controllers
import 'package:scorer_web/api/api_controllers/active_schedule_controller.dart';
import 'package:scorer_web/api/api_controllers/session_action_controller.dart';

import '../../widgets/custom_stack_image.dart';

class AdminDashboard extends StatelessWidget {
  final BottomNavController controller1 = Get.put(BottomNavController());
  final FacilDashboardController controller = Get.put(
    FacilDashboardController(),
  );

  // ✅ Add API Controllers
  final ActiveAndSessionController activeSessionController = Get.put(
    ActiveAndSessionController(),
  );
  final SessionActionController sessionActionController = Get.put(
    SessionActionController(),
  );

  AdminDashboard({super.key});

  final List<Widget> screens = [AdminActiveSession(), AdminScheduleScreen()];

  // 👇 Ye method har index ke hisab se full column data return karega
  Widget getFullColumn(int index) {
    switch (index) {
      case 0:
        return Column(
          children: [
            GradientColor(
              height: 220.h,
              child: Container(
                width: 794.w,
                height: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -150.h,
                      right: 312.w,
                      left: 312.w,
                      child: CustomStackImage(
                        image: Appimages.prince2,
                        text: "administrator".tr,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),

                        Center(
                          child: BoldText(
                            text: "hello_administrator_chris".tr,
                            fontSize: 44.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ),
                        Center(
                          child: MainText(
                            fontSize: 20.sp,
                            textAlign: TextAlign.center,
                            text: "welcome_admin_access".tr,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),

                      // ✅ Search Bar and Refresh Button for Web
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Row(
                          children: [
                            // Search Bar
                            Expanded(
                              child: Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8.r,
                                      offset: Offset(0, 2.h),
                                    ),
                                  ],
                                ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: TextField(
                                    onChanged: (value) {
                                      activeSessionController
                                              .searchQuery
                                              .value =
                                          value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'search_sessions'.tr,
                                      hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.teamColor,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: AppColors.blueColor,
                                        size: 24.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                        horizontal: 16.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // Refresh Button
                            Obx(
                              () => GestureDetector(
                                onTap: activeSessionController.isLoading.value
                                    ? null
                                    : () async {
                                        await activeSessionController
                                            .fetchScheduleAndActiveSessions();
                                      },
                                child: Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.blueColor.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 8.r,
                                        offset: Offset(0, 2.h),
                                      ),
                                    ],
                                  ),
                                  child: activeSessionController.isLoading.value
                                      ? Center(
                                          child: SizedBox(
                                            width: 24.sp,
                                            height: 24.sp,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.w,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: 28.sp,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),
                      FacilDashBoardStackContainer(controller: controller),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: Obx(
                          () => screens[controller.selectedIndex.value],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case 1:
        return GameScreenAdminside();

      case 2:
        return UserManagementScreen();

      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ✅ AppBar
              Obx(() {
                if (controller1.selectedIndex.value == 0) {
                  return CustomAppbar(
                    width3: 160.w,
                    height3: 61.h,
                    borderW: 1.96.w,
                    text: "create".tr,
                    right2: -10.w,
                    right: 0.w,
                    top: -30.h,
                    onTap: () {
                      Get.toNamed(RouteName.createNewSessionScreen);
                    },
                    onNotificationTap: () {
                      Get.toNamed(RouteName.notificationScreen);
                    },
                    onSettingsTap: () {
                      Get.toNamed(RouteName.settingsScreen);
                    },
                  );
                }
                // Agar User Management screen hai (index = 2)
                if (controller1.selectedIndex.value == 2) {
                  return CustomAppbar(
                    right2: 5.w,
                    height3: 61.h,
                    right: -30.w,
                    isShow: true,
                    onTap: () {
                      Get.toNamed(RouteName.createNewSessionHeader);
                    },
                    onSettingsTap: () {
                      Get.toNamed(RouteName.settingsScreen);
                    },
                  );
                } else {
                  // Default AppBar for all other screens
                  return CustomAppbar(
                    width3: 205.w,
                    height3: 61.h,
                    borderW: 1.96.w,
                    text: "create_new_game".tr,
                    right2: -30.w,
                    right: -20.w,
                    top: -30.h,
                    onTap: () {
                      Get.toNamed(RouteName.game2Screen);
                    },
                    onSettingsTap: () {
                      Get.toNamed(RouteName.settingsScreen);
                    },
                  );
                }
              }),

              SizedBox(height: 56.h),

              // ✅ Main layout
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 100.w),
                      child: SideNavBar(controller: controller1),
                    ),

                    // ✅ Ye poora center column ab reactive hoga
                    Expanded(
                      child: Center(
                        child: Obx(
                          () => getFullColumn(controller1.selectedIndex.value),
                        ),
                      ),
                    ),

                    SizedBox(width: 200.w),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
