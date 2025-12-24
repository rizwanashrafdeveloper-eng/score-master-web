// ============================================
// UNIFIED OVERVIEW OPTION SCREEN
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/leader_board_Screen.dart';
import 'package:scorer_web/components/facilitator_folder/overview_screen.dart';
import 'package:scorer_web/components/facilitator_folder/phases_Screen.dart';
import 'package:scorer_web/components/facilitator_folder/players_Screen.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/controller/filter_controller.dart';
import 'package:scorer_web/controller/over_view_controller.dart';
import 'package:scorer_web/view/FacilitatorFolder/facil_over_view_stack_container.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/filter_useable_container.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/team_alpha_container.dart';
import 'package:scorer_web/widgets/useable_container.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';
import 'package:scorer_web/api/api_controllers/session_controller.dart';
import 'package:scorer_web/api/api_controllers/game_format_phase.dart';

class OverViewOptionScreen extends StatefulWidget {
  const OverViewOptionScreen({super.key});

  @override
  State<OverViewOptionScreen> createState() => _OverViewOptionScreenState();
}

class _OverViewOptionScreenState extends State<OverViewOptionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(OverviewController());
  final controller1 = Get.put(FilterController());
  final sessionController = Get.put(SessionController());
  final phaseController = Get.put(GameFormatPhaseController());

  String userRole = '';
  int? sessionId;
  bool isLoading = true;

  final List<String> tabs = [
    "Overview".tr,
    "Phases".tr,
    "Players".tr,
    "Leaderboard".tr,
  ];

  @override
  void initState() {
    super.initState();
    print("🔵 [OverViewOptionScreen] initState called");
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      print("🔵 [OverViewOptionScreen] Initializing...");

      // Get sessionId from arguments first, then SharedPreferences
      final args = Get.arguments;
      sessionId = args?['sessionId'];

      if (sessionId == null) {
        sessionId = await SharedPrefServices.getSessionId();
        print("📦 [OverViewOptionScreen] Loaded sessionId from SharedPref: $sessionId");
      } else {
        print("📦 [OverViewOptionScreen] Loaded sessionId from arguments: $sessionId");
        // Save to SharedPreferences for future use
        await SharedPrefServices.saveSessionId(sessionId!);
      }

      // Get user role
      userRole = await SharedPrefServices.getUserRole() ?? 'facilitator';
      print("👤 [OverViewOptionScreen] User role: $userRole");

      if (sessionId != null && sessionId! > 0) {
        print("🎯 [OverViewOptionScreen] Starting data fetch for session: $sessionId");

        // Initialize session controller FIRST
        await sessionController.fetchSession(sessionId!);
        print("✅ [OverViewOptionScreen] Session data fetched");

        // Initialize phase controller AFTER session is loaded
        phaseController.setSessionId(sessionId!);

        // Manually trigger phase fetch after a short delay
        await Future.delayed(Duration(milliseconds: 500));
        await phaseController.fetchGameFormatPhases();
        print("✅ [OverViewOptionScreen] Phase data fetched");

      } else {
        print("❌ [OverViewOptionScreen] Invalid sessionId: $sessionId");
      }

      setState(() {
        isLoading = false;
      });
      print("✅ [OverViewOptionScreen] Initialization complete");
    } catch (e, stackTrace) {
      print("❌ [OverViewOptionScreen] Error initializing: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to load session: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.forwardColor),
              SizedBox(height: 20.h),
              BoldText(
                text: "Loading session details...",
                fontSize: 24.sp,
                selectionColor: AppColors.blueColor,
              ),
            ],
          ),
        ),
      );
    }

    final List<Widget> screens = [
      OverviewScreen(sessionId: sessionId),
      PhasesScreen(sessionId: sessionId),
      PlayersScreen(sessionId: sessionId),
      LeaderBoardScreen(
        sessionId: sessionId,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: GradientBackground(
        child: Stack(
          children: [
            Positioned(
              top: 700.h,
              right: 0,
              child: TeamAlphaContainer(),
            ),
            Column(
              children: [
                CustomAppbar(ishow: true),
                SizedBox(height: 56.h),
                Expanded(
                  child: Container(
                    width: 794.w,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
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
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 10.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          FacilOverViewStackContainer(
                                            controller: controller,
                                            tabs: tabs,
                                          ),
                                          SizedBox(height: 20.h),
                                          Expanded(
                                            child: Obx(() => screens[
                                            controller.selectedIndex.value]),
                                          ),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final session = sessionController.session.value;
      final currentPhase = phaseController.currentPhase;
      final isScheduled = session?.status?.toUpperCase() == 'SCHEDULED';

      // Determine role display
      final roleDisplay = userRole.toLowerCase() == 'admin' ||
          userRole.toLowerCase() == 'administrator'
          ? 'Administrator'
          : 'Facilitator';

      // Debug log
      print("📊 [Header] Session status: ${session?.status}, Phases count: ${phaseController.allPhases.length}");
      print("📊 [Header] Current phase: ${currentPhase?.name}, ID: ${currentPhase?.id}");

      return GradientColor(
        height: 225.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
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
                child: CustomStackImage(
                  image: userRole.toLowerCase() == 'admin' ||
                      userRole.toLowerCase() == 'administrator'
                      ? Appimages.prince2
                      : null,
                  text: roleDisplay,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: BoldText(
                      text: session?.sessiontitle ??
                          session?.description?.split('.').first ??
                          "Session Details",
                      fontSize: 48.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (session?.joinCode != null)
                    Column(
                      children: [
                        MainText(
                          text: "Session Code: ${session?.joinCode}",
                          fontSize: 20.sp,
                          color: AppColors.teamColor,
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Phase indicator
                      if (currentPhase != null && !isScheduled) ...[
                        UseableContainer(
                          text: currentPhase.name ?? "Phase ${currentPhase.order}",
                          color: AppColors.orangeColor,
                          fontFamily: "abz",
                        ),
                        SizedBox(width: 26.w),
                      ],
                      // Status indicator
                      UseableContainer(
                        text: isScheduled ? "Scheduled" : session?.status ?? "Active",
                        fontFamily: "abz",
                        color: isScheduled
                            ? AppColors.purpleColor
                            : (session?.status?.toUpperCase() == 'PAUSED'
                            ? AppColors.orangeColor
                            : AppColors.forwardColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDrawer() {
    return SizedBox(
      width: 412.w,
      child: Drawer(
        backgroundColor: AppColors.whiteColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.w),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoldText(
                        text: "filter".tr,
                        fontSize: 30.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: MainText(
                          text: "cancel".tr,
                          fontSize: 24.sp,
                          color: AppColors.forwardColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 34.h),

                  // Phase filters
                  Center(
                    child: BoldText(
                      text: "by_phase".tr,
                      fontSize: 32.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Obx(() {
                    final phases = phaseController.allPhases;
                    if (phases.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(20.w),
                        child: MainText(
                          text: "No phases available",
                          fontSize: 20.sp,
                          color: AppColors.greyColor,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Column(
                      children: phases.take(3).toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final phase = entry.value;
                        return Column(
                          children: [
                            Obx(() => FilterUseableContainer(
                              height: 100.h,
                              onTap: () => controller1.select(index),
                              isSelected: controller1.selectedIndex.value == index,
                              text: phase.name ?? "Phase ${phase.order}",
                            )),
                            SizedBox(height: 10.h),
                          ],
                        );
                      }).toList(),
                    );
                  }),

                  SizedBox(height: 40.h),

                  // Stage filters (keeping original for now)
                  Center(
                    child: BoldText(
                      text: "by_stage".tr,
                      fontSize: 32.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Obx(() => FilterUseableContainer(
                    height: 100.h,
                    onTap: () => controller1.selectStage(0),
                    isSelected: controller1.selectedstage.value == 0,
                    text: "stage_1".tr,
                  )),
                  SizedBox(height: 10.h),
                  Obx(() => FilterUseableContainer(
                    height: 100.h,
                    onTap: () => controller1.selectStage(1),
                    isSelected: controller1.selectedstage.value == 1,
                    text: "stage_2".tr,
                  )),
                  SizedBox(height: 10.h),
                  Obx(() => FilterUseableContainer(
                    height: 100.h,
                    onTap: () => controller1.selectStage(2),
                    isSelected: controller1.selectedstage.value == 2,
                    text: "Stage 3",
                  )),
                  SizedBox(height: 40.h),

                  // Action buttons
                  Center(
                    child: LoginButton(
                      text: "clear_filter".tr,
                      color: AppColors.redColor,
                      onTap: () {
                        controller1.select(-1);
                        controller1.selectStage(-1);
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: LoginButton(
                      text: "apply_filter".tr,
                      color: AppColors.forwardColor,
                      onTap: () {
                        Get.back();
                        Get.snackbar(
                          'Filter Applied',
                          'Your filters have been applied',
                          snackPosition: SnackPosition.TOP,
                          duration: Duration(seconds: 2),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





// // ============================================
// // UNIFIED OVERVIEW OPTION SCREEN
// // Works for both Admin and Facilitator
// // ============================================
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/facilitator_folder/leader_board_Screen.dart';
// import 'package:scorer_web/components/facilitator_folder/overview_screen.dart';
// import 'package:scorer_web/components/facilitator_folder/phases_Screen.dart';
// import 'package:scorer_web/components/facilitator_folder/players_Screen.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/controller/filter_controller.dart';
// import 'package:scorer_web/controller/over_view_controller.dart';
// import 'package:scorer_web/view/FacilitatorFolder/facil_over_view_stack_container.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/filter_useable_container.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/team_alpha_container.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// import 'package:scorer_web/shared_preference/shared_preference.dart';
// import 'package:scorer_web/api/api_controllers/session_controller.dart';
// import 'package:scorer_web/api/api_controllers/game_format_phase.dart';
//
// class OverViewOptionScreen extends StatefulWidget {
//   const OverViewOptionScreen({super.key});
//
//   @override
//   State<OverViewOptionScreen> createState() => _OverViewOptionScreenState();
// }
//
// class _OverViewOptionScreenState extends State<OverViewOptionScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final controller = Get.put(OverviewController());
//   final controller1 = Get.put(FilterController());
//   final sessionController = Get.put(SessionController());
//   final phaseController = Get.put(GameFormatPhaseController());
//
//   String userRole = '';
//   int? sessionId;
//   bool isLoading = true;
//
//   final List<String> tabs = [
//     "Overview".tr,
//     "Phases".tr,
//     "Players".tr,
//     "Leaderboard".tr,
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeScreen();
//   }
//
//   Future<void> _initializeScreen() async {
//     try {
//       print("🔵 [OverViewOptionScreen] Initializing...");
//
//       // Get sessionId from arguments first, then SharedPreferences
//       final args = Get.arguments;
//       sessionId = args?['sessionId'];
//
//       if (sessionId == null) {
//         sessionId = await SharedPrefServices.getSessionId();
//         print("📦 [OverViewOptionScreen] Loaded sessionId from SharedPref: $sessionId");
//       } else {
//         print("📦 [OverViewOptionScreen] Loaded sessionId from arguments: $sessionId");
//         // Save to SharedPreferences for future use
//         await SharedPrefServices.saveSessionId(sessionId!);
//       }
//
//       // Get user role
//       userRole = await SharedPrefServices.getUserRole() ?? 'facilitator';
//       print("👤 [OverViewOptionScreen] User role: $userRole");
//
//       if (sessionId != null && sessionId! > 0) {
//         // Initialize session controller
//         await sessionController.fetchSession(sessionId!);
//
//         // Initialize phase controller
//         phaseController.setSessionId(sessionId!);
//       }
//
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print("❌ [OverViewOptionScreen] Error initializing: $e");
//       setState(() {
//         isLoading = false;
//       });
//       Get.snackbar(
//         'Error',
//         'Failed to load session: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(color: AppColors.forwardColor),
//               SizedBox(height: 20.h),
//               BoldText(
//                 text: "Loading session...",
//                 fontSize: 24.sp,
//                 selectionColor: AppColors.blueColor,
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final List<Widget> screens = [
//       OverviewScreen(sessionId: sessionId),
//       PhasesScreen(sessionId: sessionId),
//       PlayersScreen(sessionId: sessionId),
//       LeaderBoardScreen(
//         sessionId: sessionId,
//         onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
//       ),
//     ];
//
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: _buildDrawer(),
//       body: GradientBackground(
//         child: Stack(
//           children: [
//             Positioned(
//               top: 700.h,
//               right: 0,
//               child: TeamAlphaContainer(),
//             ),
//             Column(
//               children: [
//                 CustomAppbar(ishow: true),
//                 SizedBox(height: 56.h),
//                 Expanded(
//                   child: Container(
//                     width: 794.w,
//                     decoration: BoxDecoration(
//                       color: AppColors.whiteColor,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40.r),
//                         topRight: Radius.circular(40.r),
//                       ),
//                     ),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildHeader(),
//                             Expanded(
//                               child: GradientColor(
//                                 ishow: false,
//                                 child: Container(
//                                   width: 794.w,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       bottomLeft: Radius.circular(40.r),
//                                       bottomRight: Radius.circular(40.r),
//                                     ),
//                                   ),
//                                   child: ScrollConfiguration(
//                                     behavior: ScrollConfiguration.of(context)
//                                         .copyWith(scrollbars: false),
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 20.w,
//                                         vertical: 10.h,
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                         children: [
//                                           FacilOverViewStackContainer(
//                                             controller: controller,
//                                             tabs: tabs,
//                                           ),
//                                           SizedBox(height: 20.h),
//                                           Expanded(
//                                             child: Obx(() => screens[
//                                             controller.selectedIndex.value]),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Obx(() {
//       final session = sessionController.session.value;
//       final currentPhase = phaseController.currentPhase;
//       final isScheduled = session?.status?.toUpperCase() == 'SCHEDULED';
//
//       // Determine role display
//       final roleDisplay = userRole.toLowerCase() == 'admin' ||
//           userRole.toLowerCase() == 'administrator'
//           ? 'Administrator'
//           : 'Facilitator';
//
//       return GradientColor(
//         height: 225.h,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40.r),
//               topRight: Radius.circular(40.r),
//             ),
//           ),
//           width: 794.w,
//           height: 235.h,
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Positioned(
//                 top: 50.h,
//                 left: -40.w,
//                 child: ForwardButtonContainer(
//                   onTap: () => Get.back(),
//                   imageH: 20.h,
//                   imageW: 23.5.w,
//                   height1: 90.h,
//                   height2: 65.h,
//                   width1: 90.w,
//                   width2: 65.w,
//                   image: Appimages.arrowback,
//                 ),
//               ),
//               Positioned(
//                 top: -140,
//                 right: 312.w,
//                 left: 312.w,
//                 child: CustomStackImage(
//                   image: userRole.toLowerCase() == 'admin' ||
//                       userRole.toLowerCase() == 'administrator'
//                       ? Appimages.prince2
//                       : null,
//                   text: roleDisplay,
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: BoldText(
//                       text: session?.sessiontitle ??
//                           session?.description?.split('.').first ??
//                           "Session Details",
//                       fontSize: 48.sp,
//                       selectionColor: AppColors.blueColor,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Phase indicator
//                       if (currentPhase != null && !isScheduled) ...[
//                         UseableContainer(
//                           text: currentPhase.name ?? "Phase ${currentPhase.order}",
//                           color: AppColors.orangeColor,
//                           fontFamily: "abz",
//                         ),
//                         SizedBox(width: 26.w),
//                       ],
//                       // Status indicator
//                       UseableContainer(
//                         text: isScheduled ? "Scheduled" : session?.status ?? "Active",
//                         fontFamily: "abz",
//                         color: isScheduled
//                             ? AppColors.purpleColor
//                             : (session?.status?.toUpperCase() == 'PAUSED'
//                             ? AppColors.orangeColor
//                             : AppColors.forwardColor),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildDrawer() {
//     return SizedBox(
//       width: 412.w,
//       child: Drawer(
//         backgroundColor: AppColors.whiteColor,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 38.w),
//           child: ScrollConfiguration(
//             behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 30.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       BoldText(
//                         text: "filter".tr,
//                         fontSize: 30.sp,
//                         selectionColor: AppColors.blueColor,
//                       ),
//                       GestureDetector(
//                         onTap: () => Get.back(),
//                         child: MainText(
//                           text: "cancel".tr,
//                           fontSize: 24.sp,
//                           color: AppColors.forwardColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 34.h),
//
//                   // Phase filters
//                   Center(
//                     child: BoldText(
//                       text: "by_phase".tr,
//                       fontSize: 32.sp,
//                       selectionColor: AppColors.blueColor,
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//
//                   Obx(() {
//                     final phases = phaseController.allPhases;
//                     if (phases.isEmpty) {
//                       return Container(
//                         padding: EdgeInsets.all(20.w),
//                         child: MainText(
//                           text: "No phases available",
//                           fontSize: 20.sp,
//                           color: AppColors.greyColor,
//                           textAlign: TextAlign.center,
//                         ),
//                       );
//                     }
//
//                     return Column(
//                       children: phases.take(3).toList().asMap().entries.map((entry) {
//                         final index = entry.key;
//                         final phase = entry.value;
//                         return Column(
//                           children: [
//                             Obx(() => FilterUseableContainer(
//                               height: 100.h,
//                               onTap: () => controller1.select(index),
//                               isSelected: controller1.selectedIndex.value == index,
//                               text: phase.name ?? "Phase ${phase.order}",
//                             )),
//                             SizedBox(height: 10.h),
//                           ],
//                         );
//                       }).toList(),
//                     );
//                   }),
//
//                   SizedBox(height: 40.h),
//
//                   // Stage filters (keeping original for now)
//                   Center(
//                     child: BoldText(
//                       text: "by_stage".tr,
//                       fontSize: 32.sp,
//                       selectionColor: AppColors.blueColor,
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   Obx(() => FilterUseableContainer(
//                     height: 100.h,
//                     onTap: () => controller1.selectStage(0),
//                     isSelected: controller1.selectedstage.value == 0,
//                     text: "stage_1".tr,
//                   )),
//                   SizedBox(height: 10.h),
//                   Obx(() => FilterUseableContainer(
//                     height: 100.h,
//                     onTap: () => controller1.selectStage(1),
//                     isSelected: controller1.selectedstage.value == 1,
//                     text: "stage_2".tr,
//                   )),
//                   SizedBox(height: 10.h),
//                   Obx(() => FilterUseableContainer(
//                     height: 100.h,
//                     onTap: () => controller1.selectStage(2),
//                     isSelected: controller1.selectedstage.value == 2,
//                     text: "Stage 3",
//                   )),
//                   SizedBox(height: 40.h),
//
//                   // Action buttons
//                   Center(
//                     child: LoginButton(
//                       text: "clear_filter".tr,
//                       color: AppColors.redColor,
//                       onTap: () {
//                         controller1.select(-1);
//                         controller1.selectStage(-1);
//                         Get.back();
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Center(
//                     child: LoginButton(
//                       text: "apply_filter".tr,
//                       color: AppColors.forwardColor,
//                       onTap: () {
//                         Get.back();
//                         Get.snackbar(
//                           'Filter Applied',
//                           'Your filters have been applied',
//                           snackPosition: SnackPosition.TOP,
//                           duration: Duration(seconds: 2),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 30.h),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================
// // UPDATED SESSION CONTROLLER INITIALIZATION
// // ============================================
// // Add this to your SessionController if not already present
//
// extension SessionControllerExtension on SessionController {
//   /// Initialize with explicit sessionId
//   Future<void> initializeWithId(int sessionId) async {
//     this.sessionId.value = sessionId;
//     await fetchSession(sessionId);
//   }
// }
//
// // ============================================
// // UPDATED PHASE CONTROLLER INITIALIZATION
// // ============================================
// // Add this to your GameFormatPhaseController if not already present
//
// extension PhaseControllerExtension on GameFormatPhaseController {
//   /// Initialize with explicit sessionId
//   void initializeWithId(int sessionId) {
//     this.sessionId.value = sessionId;
//     fetchGameFormatPhases();
//   }
// }