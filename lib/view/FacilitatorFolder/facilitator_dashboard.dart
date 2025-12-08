import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/active_Session_screen.dart';
import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
import 'package:scorer_web/components/facilitator_folder/schedule_Screen.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/controller/facil_dashboard_controller.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/add_one_Container.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/setting_container.dart';

// Import your API controllers
import 'package:scorer_web/api/api_controllers/facilitator_schedule_and_active_controller.dart';
import 'package:scorer_web/api/api_controllers/session_action_controller.dart';


class FacilitatorDashboard extends StatelessWidget {
  final FacilDashboardController controller = Get.put(FacilDashboardController());
  final facilSessionController = Get.put(FacilitatorScheduleAndActiveSessionController());

  // ✅ Add Session Action Controller
  final sessionActionController = Get.put(SessionActionController());

  FacilitatorDashboard({super.key}) {
    // 🔹 Log initialization for debugging
    print("✅ FacilitatorDashboard Web initialized");

    // 🔹 Fetch data when dashboard opens
    facilSessionController.fetchFacilitatorSessions();
  }

  final List<Widget> screens = [
    ActiveSessionScreen(),
    ScheduleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ✅ Custom AppBar
              CustomAppbar(
                width3: 205.w,
                height3: 61.h,
                borderW: 1.96.w,
                text: "Create New",
                right2: -30.w,
                right: 20.w,
                top: -30.h,
                onTap: () {
                  Get.toNamed(RouteName.createNewSessionScreen);
                },
              ),

              SizedBox(height: 56.h),

              // ✅ Top Gradient Welcome Section
              GradientColor(
                height: 235.h,
                child: Container(
                  width: 794.w,
                  height: 100.h,
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
                        child: CustomStackImage(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: BoldText(
                              text: "Welcome back, Adam!",
                              fontSize: 48.sp,
                              selectionColor: AppColors.blueColor,
                            ),
                          ),
                          Center(
                            child: MainText(
                              fontSize: 22.sp,
                              textAlign: TextAlign.center,
                              text:
                              "You've just entered a company in crisis. Every\ndecision you make could change its future.",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ Main Content Area
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
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      // ✅ Add search functionality if needed
                                      // facilSessionController.searchQuery.value = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search sessions...',
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

                              SizedBox(width: 12.w),

                              // Refresh Button
                              Obx(() => GestureDetector(
                                onTap: facilSessionController.isLoading.value
                                    ? null
                                    : () async {
                                  await facilSessionController.fetchFacilitatorSessions();
                                },
                                child: Container(
                                  width: 50.h,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.blueColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: facilSessionController.isLoading.value
                                      ? Center(
                                    child: SizedBox(
                                      width: 24.sp,
                                      height: 24.sp,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  )
                                      : Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                        FacilDashBoardStackContainer(controller: controller),
                        SizedBox(height: 20.h),

                        // ✅ Switchable screens without layout issue
                        Expanded(
                          child: Obx(() => screens[controller.selectedIndex.value]),
                        ),
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
//
//
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
// class FacilitatorDashboard extends StatelessWidget {
//   final FacilDashboardController controller = Get.put(FacilDashboardController());
//   FacilitatorDashboard({super.key});
//
//   final List<Widget> screens = [
//     ActiveSessionScreen(),
//     ScheduleScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Column(
//             children: [
//               // ✅ Custom AppBar
//               CustomAppbar(
//                 width3: 205.w,
//                 height3: 61.h,
//                 borderW: 1.96.w,
//                 text: "Create New",
//                 right2: -30.w,
//                 right: 20.w,
//                 top: -30.h,
//                 onTap: () {
//                   Get.toNamed(RouteName.createNewSessionScreen);
//                 },
//               ),
//
//               SizedBox(height: 56.h),
//
//               // ✅ Top Gradient Welcome Section
//               GradientColor(
//                 height: 235.h,
//                 child: Container(
//                   width: 794.w,
//                   height: 100.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40.r),
//                       topRight: Radius.circular(40.r),
//                     ),
//                   ),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Positioned(
//                         top: -140,
//                         right: 312.w,
//                         left: 312.w,
//                         child: CustomStackImage(),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Center(
//                             child: BoldText(
//                               text: "Welcome back, Adam!",
//                               fontSize: 48.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                           ),
//                           Center(
//                             child: MainText(
//                               fontSize: 22.sp,
//                               textAlign: TextAlign.center,
//                               text:
//                                   "You’ve just entered a company in crisis. Every\ndecision you make could change its future.",
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // ✅ Main Content Area
//               Expanded(
//                 child: GradientColor(
//                   ishow: false,
//                   child: Container(
//                     width: 794.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(40.r),
//                         bottomRight: Radius.circular(40.r),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 20.h),
//                         FacilDashBoardStackContainer(controller: controller),
//                         SizedBox(height: 20.h),
//
//                         // ✅ Switchable screens without layout issue
//                         Expanded(
//                           child: Obx(() => screens[controller.selectedIndex.value]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
