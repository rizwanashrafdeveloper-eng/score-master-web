import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_dashboard_container.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/main_text.dart';

// Import your controllers
import '../../api/api_controllers/join_session_controller.dart';
import '../../api/api_controllers/login_controller_web.dart';
import '../../api/api_controllers/session_list_controller.dart';
import '../../shared_preference/shared_preference.dart';
import '../../widgets/player_side/join_session_widget.dart';

class PlayerDashboardScreen extends StatefulWidget {
  const PlayerDashboardScreen({super.key});

  @override
  State<PlayerDashboardScreen> createState() => _PlayerDashboardScreenState();
}

class _PlayerDashboardScreenState extends State<PlayerDashboardScreen> {
  final JoinSessionController joinController = Get.put(JoinSessionController());
  final SessionsListController sessionsController = Get.put(SessionsListController());
  int _fallbackPlayerId = 0;

  AuthController get authController => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _loadFallbackId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });

    if (sessionsController.scheduledSessions.isEmpty &&
        sessionsController.activeSessions.isEmpty) {
      sessionsController.fetchSessions();
    }
  }

  Future<void> _loadFallbackId() async {
    final savedId = await SharedPrefServices.getUserId();
    if (savedId != null) {
      setState(() {
        _fallbackPlayerId = int.tryParse(savedId) ?? 0;
      });
      print("🔄 [PlayerDashboard] Loaded fallback ID: $_fallbackPlayerId");
    }
  }

  Future<void> _initializeUser() async {
    print('🔄 [PlayerDashboard] Initializing user data...');

    if (authController.user.value == null) {
      print('🔄 [PlayerDashboard] User is null, loading from storage...');
      await authController.loadUserFromStorage();
    }

    if (authController.user.value == null) {
      print('⚠️ [PlayerDashboard] User data not found, redirecting to login...');
      Get.snackbar(
        "session_expired".tr,
        "please_login_again".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed('/login');
      });
    }
  }

  int get playerId {
    final user = authController.user.value;
    if (user == null) {
      print("❌ [PlayerDashboard] User is null in authController");
      return _fallbackPlayerId;
    }
    print("✅ [PlayerDashboard] Player ID from controller: ${user.id}");
    return user.id;
  }

  String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
    )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine screen size
              final isSmallScreen = constraints.maxWidth < 600;
              final isMediumScreen = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

              // Responsive dimensions
              final mainWidth = isSmallScreen
                  ? constraints.maxWidth * 0.95
                  : isMediumScreen
                  ? constraints.maxWidth * 0.85
                  : 794.w;

              return Column(
                children: [
                  CustomAppbar(
                    onNotificationTap: () {
                      Get.toNamed(RouteName.notificationScreen);
                    },
                    onSettingsTap: () {
                      Get.toNamed(RouteName.settingsScreen);
                    },
                    ishow4: true,
                  ),
                  SizedBox(height: isSmallScreen ? 30.h : 56.h),

                  /// Top fixed container - FIXED VERSION
                  GradientColor(
                    height: isSmallScreen ? 220.h : 260.h,
                    child: Container(
                      width: mainWidth,
                      constraints: BoxConstraints(
                        minHeight: isSmallScreen ? 220.h : 260.h,
                        maxWidth: 794,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSmallScreen ? 25.r : 40.r),
                          topRight: Radius.circular(isSmallScreen ? 25.r : 40.r),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Character Image - Positioned OUTSIDE container
                          Positioned(
                            top: isSmallScreen ? -100.h : -140.h,
                            right: isSmallScreen ? 100.w : 312.w,
                            left: isSmallScreen ? 100.w : 312.w,
                            child: CustomStackImage(
                              image: Appimages.player2,
                              text: "player".tr,
                              isSmallScreen: isSmallScreen,
                            ),
                          ),

                          // Text Content - Positioned with proper spacing
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: isSmallScreen ? 90.h : 110.h, // Space for image
                                left: isSmallScreen ? 15.w : 20.w,
                                right: isSmallScreen ? 15.w : 20.w,
                                bottom: isSmallScreen ? 15.h : 20.h,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Welcome Title
                                  BoldText(
                                    text: "welcome_scoremaster".tr,
                                    fontSize: isSmallScreen ? 24.sp : isMediumScreen ? 34.sp : 42.sp,
                                    selectionColor: AppColors.blueColor,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    height: 1.2,
                                  ),
                                  SizedBox(height: 8.h),

                                  // Welcome Message
                                  Flexible(
                                    child: MainText(
                                      text: "player_welcome_message".tr,
                                      fontSize: isSmallScreen ? 12.sp : isMediumScreen ? 16.sp : 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      height: 1.3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Expanded scrollable part
                  Expanded(
                    child: GradientColor(
                      ishow: false,
                      child: Container(
                        width: mainWidth,
                        constraints: BoxConstraints(
                          maxWidth: 794,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(isSmallScreen ? 25.r : 40.r),
                            bottomRight: Radius.circular(isSmallScreen ? 25.r : 40.r),
                          ),
                        ),
                        child: RefreshIndicator(
                          onRefresh: sessionsController.refreshSessions,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 20.w : 70.w,
                                vertical: isSmallScreen ? 20.h : 30.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: isSmallScreen ? 20.h : 30.h),

                                  // Join Session Widget
                                  Obx(() {
                                    if (authController.user.value == null) {
                                      return Column(
                                        children: [
                                          Text(
                                            "loading_user_data".tr,
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 16.sp : 20.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          CircularProgressIndicator(),
                                        ],
                                      );
                                    }
                                    return JoinSessionWidget(
                                      playerId: playerId,
                                    );
                                  }),

                                  SizedBox(height: isSmallScreen ? 30.h : 40.h),

                                  // Sessions data
                                  Obx(() {
                                    if (sessionsController.isLoading.value) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(80.h),
                                          child: CircularProgressIndicator(
                                            color: AppColors.forwardColor,
                                            strokeWidth: 3.w,
                                          ),
                                        ),
                                      );
                                    }

                                    final activeSessions = sessionsController.activeSessions;
                                    final scheduledSessions = sessionsController.scheduledSessions;

                                    if (activeSessions.isEmpty && scheduledSessions.isEmpty) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 80.h),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.event_busy,
                                                size: isSmallScreen ? 60.sp : 80.sp,
                                                color: AppColors.greyColor,
                                              ),
                                              SizedBox(height: 20.h),
                                              MainText(
                                                text: "no_sessions_available".tr,
                                                fontSize: isSmallScreen ? 20.sp : 28.sp,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 10.h),
                                              MainText(
                                                text: "wait_facilitator_schedule".tr,
                                                fontSize: isSmallScreen ? 14.sp : 20.sp,
                                                color: Colors.grey,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (activeSessions.isNotEmpty) ...[
                                          BoldText(
                                            text: "active_sessions_title".tr,
                                            fontSize: isSmallScreen ? 24.sp : 32.sp,
                                            selectionColor: AppColors.blueColor,
                                          ),
                                          SizedBox(height: 20.h),
                                          ...activeSessions.map((session) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: 25.h),
                                              child: CustomDashboardContainer(
                                                onTap: () {
                                                  if (playerId == 0) {
                                                    Get.snackbar(
                                                      "error".tr,
                                                      "unable_get_player_info".tr,
                                                      backgroundColor: Colors.red,
                                                      colorText: Colors.white,
                                                    );
                                                    return;
                                                  }
                                                  joinController.joinSession(
                                                    playerId,
                                                    session.joinCode,
                                                  );
                                                },
                                                arrowshow: false,
                                                horizontal: 0,
                                                width2: isSmallScreen ? 120.w : 150.w,
                                                color2: AppColors.forwardColor,
                                                heading: capitalizeEachWord(session.teamTitle),
                                                text1: "phase".tr + " ${session.totalPhases}",
                                                ishow: false,
                                                text2: "active".tr,
                                                color1: AppColors.orangeColor,
                                                description: session.description,
                                                text7: "join_session_btn".tr,
                                                icon3: Icons.play_arrow,
                                                color3: AppColors.forwardColor,
                                                text5: "${session.totalPlayers} " + "players_count".tr,
                                                text6: (session.remainingTime != null && session.remainingTime! > 0)
                                                    ? "${session.remainingTime} " + "min_left".tr
                                                    : "in_progress".tr,
                                                smallImage: Appimages.timeout2,
                                              ),
                                            );
                                          }),
                                        ],

                                        if (scheduledSessions.isNotEmpty) ...[
                                          SizedBox(height: 30.h),
                                          BoldText(
                                            text: "scheduled_sessions_title".tr,
                                            fontSize: isSmallScreen ? 24.sp : 32.sp,
                                            selectionColor: AppColors.blueColor,
                                          ),
                                          SizedBox(height: 20.h),
                                          ...scheduledSessions.map((session) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: 25.h),
                                              child: CustomDashboardContainer(
                                                onTap: () {
                                                  Get.snackbar(
                                                    "not_started".tr,
                                                    "session_not_started_yet".tr,
                                                    snackPosition: SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.redAccent,
                                                    colorText: Colors.white,
                                                    duration: const Duration(seconds: 2),
                                                  );
                                                },
                                                arrowshow: false,
                                                horizontal: 0,
                                                width2: isSmallScreen ? 120.w : 150.w,
                                                color2: AppColors.scheColor,
                                                heading: capitalizeEachWord(session.teamTitle),
                                                text1: "phase".tr + " ${session.totalPhases}",
                                                ishow: false,
                                                text2: "scheduled".tr,
                                                color1: AppColors.orangeColor,
                                                description: session.description,
                                                text7: "join_session_btn".tr,
                                                icon3: Icons.schedule,
                                                color3: AppColors.scheColor,
                                                text5: "${session.totalPlayers} " + "players_count".tr,
                                                text6: session.startTime != null
                                                    ? "starts_at".tr + " ${DateFormat('hh:mm a').format(session.startTime!)}"
                                                    : "starts_soon".tr,
                                                smallImage: Appimages.timeout2,
                                              ),
                                            );
                                          }),
                                        ],
                                      ],
                                    );
                                  }),

                                  SizedBox(height: 50.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}