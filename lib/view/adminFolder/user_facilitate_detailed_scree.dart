import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import '../../api/api_controllers/stat_user_management.dart';
import '../../components/admin_folder.dart/account_info_column.dart';
import '../gradient_background.dart';
import '../gradient_color.dart';

class UserFacilitateDetailedScree extends StatelessWidget {

  final String userId; // ✅ Changed to String
  final StatsUserManagementController controller = Get.put(StatsUserManagementController());

  UserFacilitateDetailedScree({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchStatsUserManagement(userId, 'facilitator'); // ✅ Now matches method name
    });
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(height: 56.h),

            GradientColor(
              height: 200.h,
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
                      top: 50.h,
                      left: -40.w,
                      child: ForwardButtonContainer(
                        imageH: 20.h,
                        imageW: 23.5.w,
                        height1: 90.h,
                        height2: 65.h,
                        width1: 90.w,
                        width2: 65.w,
                        image: Appimages.arrowback,
                        onTap: () => Get.back(),
                      ),
                    ),
                    Positioned(
                      top: -140,
                      right: 312.w,
                      left: 312.w,
                      child: CustomStackImage(
                        image: Appimages.prince2,
                        text: "Administrator",
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: BoldText(
                            text: "Users Management",
                            fontSize: 48.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ),
                        MainText(
                          text: "Securely manage roles, permissions, and\naccess.",
                          fontSize: 22.sp,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
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
                  child: Obx(() {
                    final data = controller.statsUserManagement.value;
                    final user = data.user;
                    final playerInfo = data.playerInfo;
                    final sessionStats = data.sessionStats;
                    final recentSessions = data.recentSessions ?? [];

                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              Appimages.facil2,
                              width: 197.w,
                              height: 263.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          BoldText(
                            text: playerInfo?.name ?? "Unknown User",
                            fontSize: 30.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                          MainText(
                            text: playerInfo?.email ?? "No email",
                            fontSize: 26.sp,
                            height: 1.4,
                          ),

                          /// Last login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MainText(
                                text: "last_login".tr,
                                fontSize: 26.sp,
                                color: AppColors.redColor,
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                width: 17.w,
                                height: 17.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.redColor,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              MainText(
                                text: user?.createdAt?.split("T")[0] ?? "N/A",
                                fontSize: 26.sp,
                                color: AppColors.redColor,
                              ),
                            ],
                          ),

                          SizedBox(height: 30.h),
                          UseableContainer(
                            text: "active".tr,
                            color: AppColors.forwardColor,
                          ),
                          SizedBox(height: 41.h),
                          /// Stats Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 74.w),
                            child: Row(
                              children: [
                                _statBox(
                                  value: "${sessionStats?.totalSessions ?? 0}",
                                  label: recentSessions.isNotEmpty ? "Sessions Led" : "Total Sessions",
                                  color: AppColors.redColor,
                                ),
                                SizedBox(width: 10.w),
                                _statBox(
                                  value: "${recentSessions.length}",
                                  label: recentSessions.isNotEmpty ? "Managed\nPlayers" : "Active\nSessions",
                                  color: AppColors.forwardColor,
                                ),
                                SizedBox(width: 10.w),
                                _statBox(
                                  value: recentSessions.isNotEmpty
                                      ? "${sessionStats?.avgScore?.toStringAsFixed(1) ?? '0'}%"
                                      : "0%",
                                  label: "Success\nRate",
                                  color: AppColors.redColor,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // Pass dynamic data to AccountInfoClumn
                          AccountInfoClumn(
                            email: user?.email ?? playerInfo?.email,
                            phone: user?.phone ?? "N/A",
                            joinDate: user?.createdAt?.split("T")[0] ?? "N/A",
                            //levelText: "Level 3",
                          ),

                          SizedBox(height: 30.h),
                          BoldText(
                            text: "recent_sessions".tr,
                            selectionColor: AppColors.blueColor,
                            fontSize: 30.sp,
                          ),
                          SizedBox(height: 30.h),

                          recentSessions.isNotEmpty
                              ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Column(
                              children: recentSessions.map((session) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 18.h),
                                  child: CustomDashboardContainer(
                                    mainWidth: double.infinity,
                                    right: -30.w,
                                    color2: AppColors.forwardColor,
                                    color1: AppColors.orangeColor,
                                    heading: session.sessionName ?? "Unnamed Session",
                                    text1: "Phase ${session.totalPhases ?? 0}",
                                    text2: session.status ?? "active",
                                    text6: "${session.rank ?? ''}",
                                    smallImage: Appimages.Crown,
                                    description: session.sessionDescription ?? "",
                                    icon1: Icons.play_arrow,
                                    text5: "${session.totalPlayers ?? 0} Players",
                                    isshow: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                              : _buildNoSessionsWidget("No sessions facilitated yet"),

                          // SizedBox(height: 40.h),
                          // LoginButton(
                          //   text: "delete_facilitator".tr,
                          //   ishow: true,
                          //   image: Appimages.delete,
                          //   color: AppColors.redColor,
                          // ),
                          // SizedBox(height: 20.h),
                          // LoginButton(
                          //   text: "edit_facilitator".tr,
                          //   ishow: true,
                          //   icon: Icons.edit,
                          //   color: AppColors.forwardColor,
                          // ),
                          // SizedBox(height: 100.h),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        width: 201.w,
        height: 223.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor, width: 1.7.w),
          borderRadius: BorderRadius.circular(46.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoldText(
              text: value,
              selectionColor: color,
              fontSize: 46.sp,
            ),
            BoldText(
              textAlign: TextAlign.center,
              text: label,
              fontSize: 30.sp,
              selectionColor: AppColors.blueColor,
            ),
          ],
        ),
      ),
    );
  }
}


Widget _buildNoSessionsWidget(String message) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
    padding: EdgeInsets.all(40.w),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(30.r),
      border: Border.all(color: AppColors.greyColor.withOpacity(0.3), width: 1.5.w),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.play_disabled_outlined,
          size: 80.sp,
          color: AppColors.greyColor.withOpacity(0.6),
        ),
        SizedBox(height: 25.h),
        BoldText(
          text: message,
          fontSize: 32.sp,
          selectionColor: AppColors.greyColor,
        ),
        SizedBox(height: 15.h),
        MainText(
          text: "When sessions are available, they will appear here",
          fontSize: 24.sp,
          color: AppColors.greyColor.withOpacity(0.8),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}



//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/admin_folder.dart/account_info_column.dart';
// import 'package:scorer_web/components/facilitator_folder/active_Session_screen.dart';
// import 'package:scorer_web/components/facilitator_folder/analysis_container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_session_Container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_time_row.dart';
// import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
// import 'package:scorer_web/components/facilitator_folder/feedback_container.dart';
// import 'package:scorer_web/components/facilitator_folder/phase_breakdown_container.dart';
// import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
// import 'package:scorer_web/components/facilitator_folder/schedule_Screen.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/controller/facil_dashboard_controller.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
// import 'package:scorer_web/widgets/custom_response_container.dart';
// import 'package:scorer_web/widgets/custom_sloder_row.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/players_containers.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// import 'package:scorer_web/widgets/useable_text_row.dart';
// // import 'package:syncfusion_flutter_sliders/sliders.dart';
//
// class UserFacilitateDetailedScree extends StatelessWidget {
//     // final FacilDashboardController controller = Get.put(FacilDashboardController());
//
//
//    UserFacilitateDetailedScree({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Column(
//           children: [
//             /// ✅ Fixed Appbar
//             CustomAppbar(),
//             SizedBox(height: 56.h),
//
//             /// ✅ Fixed Top Container
//             GradientColor(
//               height: 200.h,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40.r),
//                     topRight: Radius.circular(40.r)
//                   ),
//                 // color: AppColors.whiteColor,
//
//                 ),
//                 // color: AppColors.whiteColor,
//                 width: 794.w,
//                 height: 235.h,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Positioned(
//                       top: 50.h,
//                       left: -40.w,
//                       child: ForwardButtonContainer(
//                         imageH: 20.h,
//                         imageW: 23.5.w,
//                         height1: 90.h,
//                         height2: 65.h,
//                         width1: 90.w,
//                         width2: 65.w,
//                         image: Appimages.arrowback,
//                         onTap: () => Get.back(),
//                       ),
//                     ),
//                     Positioned(
//                       top: -140,
//                       right: 312.w,
//                       left: 312.w,
//                       child: CustomStackImage(
//                         image: Appimages.prince2,
//                         text: "Administrator",
//                       ),
//                     ),
//                  Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                        Center(
//                       child: BoldText(
//                         text: "Users Management",
//                         fontSize: 48.sp,
//                         selectionColor: AppColors.blueColor,
//                       ),
//                     ),
//                      MainText(text: "Securely manage roles, permissions, and\naccess.",fontSize: 22.sp,
//                      textAlign: TextAlign.center,
//                      )
//
//                   ],
//                  )
//                   ],
//                 ),
//               ),
//             ),
//
//             /// ✅ Scrollable Area
//             Expanded(
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
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//
//                             Center(
//                               child: Image.asset(
//                                 Appimages.facil2,
//                                 width: 197.w ,
//                                 height: 263.h,
//                                 fit: BoxFit.contain,
//                               ),),
//                                 BoldText(
//                         text: "John Smith",
//                         fontSize: 30.sp,
//                         selectionColor: AppColors.blueColor,
//                       ),
//                       MainText(
//                         text: "john.smith@company.com",
//                         fontSize: 26.sp,
//                         height: 1.4,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           MainText(
//                                                 text: "last_login".tr,
//
//                             fontSize: 26.sp,
//                             color: AppColors.redColor,
//                           ),
//                           SizedBox(width: 3 .w),
//                           Container(
//                             width: 17.w,
//                             height: 17.h,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: AppColors.redColor,
//                             ),
//                           ),
//                           SizedBox(width: 3 .w),
//                           MainText(
//                             text: "Jan 15, 2025",
//                             fontSize: 26.sp,
//                             color: AppColors.redColor,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 30.h,),
//
//                         UseableContainer(
//                                           text: "active".tr,
//
//
//                         color: AppColors.forwardColor,
//                         // height: 20,
//                       ),
//                       SizedBox(height: 41.h,),
//
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 74.w),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 width: 201.w,
//                                 height: 223.h,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: AppColors.greyColor, width: 1.7.w),
//                                   borderRadius: BorderRadius.circular(46.r),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     BoldText(
//                                       text: "47",
//                                       selectionColor: AppColors.redColor,
//                                       fontSize: 46.sp, // sp me convert
//                                     ),
//                                     BoldText(
//                                       textAlign: TextAlign.center,
//                                       text: "sessions_led".tr,
//                                       fontSize: 30.sp,
//                                       selectionColor: AppColors.blueColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Expanded(
//                               child: Container(
//                                 width: 201.w,
//                                 height: 223.h,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: AppColors.greyColor, width: 1.7.w),
//                                   borderRadius: BorderRadius.circular(46.r),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     BoldText(
//                                       text: "285",
//                                       selectionColor: AppColors.forwardColor,
//                                       fontSize: 46.sp,
//                                     ),
//                                     BoldText(
//                                       textAlign: TextAlign.center,
//                                       text: "Manage\nPlayers".tr,
//                                       fontSize: 30.sp,
//                                       selectionColor: AppColors.blueColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Expanded(
//                               child: Container(
//                                 width: 201.w,
//                                 height: 223.h,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: AppColors.greyColor, width: 1.7.w),
//                                   borderRadius: BorderRadius.circular(46.r),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     BoldText(
//                                       text: "96%",
//                                       selectionColor: AppColors.redColor,
//                                       fontSize: 46.sp,
//                                     ),
//                                     BoldText(
//                                       textAlign: TextAlign.center,
//                                       text: "Success\nRate".tr,
//                                       fontSize: 30.sp,
//                                       selectionColor: AppColors.blueColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 40.h,),
//
//                       AccountInfoClumn(),
//
//
//                          SizedBox(height: 30.h,),
//                            BoldText(
//                                                          text:  "recent_sessions".tr,
//
//                       selectionColor: AppColors.blueColor,
//                       fontSize: 30.sp,
//                     ),
//
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 40.w),
//                       child: Column(
//                         children: [
//
//                   CustomDashboardContainer(
//                         padding: 12.w,
//                         mainWidth: double.infinity,
//                         right: -30 .w,
//                         mainHeight: 470 .h,
//                       color2: AppColors.forwardColor,
//                       color1: AppColors.orangeColor,
//                       heading: "Team Building Workshop",
//                       text1: "Phase 2",
//                        height: 90.h,
//                       text2: "active".tr,
//                       text6: "2nd Position",
//                       smallImage: Appimages.Crown,
//                       description: "Eranove Odyssey sessions immerse teams in fast-paced, collaborative challenges with real-time scoring and progression.",
//                       icon1: Icons.play_arrow,
//                       text5: "12 Players",
//                       isshow: true,
//                     ),
//
//
//
//
//                       SizedBox(height: 18.h,),
//                         CustomDashboardContainer(
//                     padding: 12.w,
//                         mainWidth: double.infinity,
//                         right: -30 .w,
//                         // mainHeight: 450 .h,
//                         mainHeight: 470 .h,
//
//                       color2: AppColors.forwardColor,
//                       color1: AppColors.orangeColor,
//                       heading: "Team Building Workshop",
//                       text1: "Phase 2",
//                       height: 90.h,
//                       text2: "aative".tr,
//                       text6: "2nd Position",
//                       smallImage: Appimages.Crown,
//                       description: "Eranove Odyssey sessions immerse teams in fast-paced, collaborative challenges with real-time scoring and progression.",
//                       icon1: Icons.play_arrow,
//                       text5: "12 Players",
//                       isshow: true,
//                     ),
//                        SizedBox(height: 40 .h),
//                 LoginButton(text: "delete_facilitator".tr,ishow: true,image: Appimages.delete,color: AppColors.redColor,),
//                    SizedBox(height: 20 .h),
//                 LoginButton(text: "edit_facilitator".tr,ishow: true,icon: Icons.edit,color: AppColors.forwardColor,),
//
//                         ],
//                       ),
//                     ),
//
//
//
//
//                       SizedBox(
//                         height: 100,
//                       )
//
//
//
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
