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
import 'package:scorer_web/widgets/custom_stack_image.dart';
import '../../api/api_controllers/stat_user_management.dart';
import '../../components/admin_folder.dart/account_info_column.dart';
import '../../widgets/useable_text_row.dart';
import '../gradient_background.dart';
import '../gradient_color.dart';

enum UserRole { player, facilitator, admin }

class UserDetailedScreen extends StatelessWidget {
  final StatsUserManagementController controller = Get.put(StatsUserManagementController());
  final UserRole userRole;
  final String? userId;

  UserDetailedScreen({
    super.key,
    required this.userRole,
    this.userId,
  });

  // Role-based configuration
  Map<UserRole, Map<String, dynamic>> get _roleConfig => {
    UserRole.player: {
      'image': Appimages.player2,
      'roleText': 'Player',
      'statsLabels': ['Sessions Led', 'Managed Players', 'Success Rate'],
    },
    UserRole.facilitator: {
      'image': Appimages.facil2,
      'roleText': 'Facilitator',
      'statsLabels': ['sessions_led'.tr, 'Manage\nPlayers', 'Success\nRate'],
    },
    UserRole.admin: {
      'image': Appimages.prince2,
      'roleText': 'Administrator',
      'statsLabels': ['sessions_led'.tr, 'Manage\nPlayers', 'Success\nRate'],
    },
  };

  @override
  Widget build(BuildContext context) {
    final config = _roleConfig[userRole]!;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(height: 56.h),

            // Header Section
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
                    ),
                  ],
                ),
              ),
            ),

            // Content Section
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

                    return _buildContent(
                      config: config,
                      user: user,
                      playerInfo: playerInfo,
                      sessionStats: sessionStats,
                      recentSessions: recentSessions,
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

  Widget _buildContent({
    required Map<String, dynamic> config,
    required dynamic user,
    required dynamic playerInfo,
    required dynamic sessionStats,
    required List<dynamic> recentSessions,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          Center(
            child: Image.asset(
              config['image'],
              width: 197.w,
              height: 263.h,
              fit: BoxFit.contain,
            ),
          ),

          // User Name
          BoldText(
            text: playerInfo?.name ?? user?.name ?? "Unknown User",
            fontSize: 30.sp,
            selectionColor: AppColors.blueColor,
          ),

          // Email
          MainText(
            text: playerInfo?.email ?? user?.email ?? "No email",
            fontSize: 26.sp,
            height: 1.4,
          ),

          // Last Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainText(
                text: "Last login:",
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

          // Stats Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 74.w),
            child: Row(
              children: [
                _statBox(
                  value: "${sessionStats?.totalSessions ?? 0}",
                  label: config['statsLabels'][0],
                  color: AppColors.redColor,
                ),
                SizedBox(width: 10.w),
                _statBox(
                  value: "${recentSessions.length}",
                  label: config['statsLabels'][1],
                  color: AppColors.forwardColor,
                ),
                SizedBox(width: 10.w),
                _statBox(
                  value: "${sessionStats?.avgScore?.toStringAsFixed(1) ?? '0'}%",
                  label: config['statsLabels'][2],
                  color: AppColors.redColor,
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),

          // Account Info
          AccountInfoClumn(
            email: user?.email ?? playerInfo?.email,
            phone: user?.phone ?? "N/A",
            joinDate: user?.createdAt?.split("T")[0] ?? "N/A",
          ),

          // Additional sections based on role
          if (userRole == UserRole.admin) ..._buildAdminSections(),

          // Recent Sessions
          SizedBox(height: 30.h),
          BoldText(
            text: "recent_sessions".tr,
            selectionColor: AppColors.blueColor,
            fontSize: 30.sp,
          ),
          SizedBox(height: 30.h),

          Padding(
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
          ),

          // Action Buttons (commented out as in original)
          // _buildActionButtons(),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  List<Widget> _buildAdminSections() {
    return [
      SizedBox(height: 30.h),

      // Recent Activity
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Container(
          height: 220.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor, width: 1.5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                MainText(text: "recent_activity".tr, fontSize: 28.sp),
                SizedBox(height: 20.h),
                UseableTextrow(
                  height: 1,
                  color: AppColors.forwardColor,
                  text: "Alex submitted response • 1m ago",
                ),
                SizedBox(height: 10.h),
                UseableTextrow(
                  height: 1,
                  color: AppColors.forwardColor2,
                  text: "Sarah joined team discussion • 2m ago",
                ),
                SizedBox(height: 10.h),
                UseableTextrow(
                  height: 1,
                  color: AppColors.forwardColor3,
                  text: "Mike went inactive • 5m ago",
                ),
              ],
            ),
          ),
        ),
      ),

      SizedBox(height: 30.h),

      // Current Permissions
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Container(
          height: 220.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor, width: 1.5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                MainText(text: "current_permissions".tr, fontSize: 28.sp),
                SizedBox(height: 20.h),
                UseableTextrow(
                  ishow: true,
                  height: 1,
                  color: AppColors.forwardColor,
                  text: "manage_users".tr,
                ),
                SizedBox(height: 10.h),
                UseableTextrow(
                  ishow: true,
                  height: 1,
                  color: AppColors.forwardColor2,
                  text: "create_sessions".tr,
                ),
                SizedBox(height: 10.h),
                UseableTextrow(
                  ishow: true,
                  height: 1,
                  color: AppColors.forwardColor3,
                  text: "view_analytics".tr,
                ),
              ],
            ),
          ),
        ),
      ),
    ];
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