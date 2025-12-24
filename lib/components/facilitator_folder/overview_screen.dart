import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/facilitator_folder/engagement_Container.dart';
import 'package:scorer_web/components/facilitator_folder/new_session_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../../../api/api_controllers/session_controller.dart';
import '../../widgets/useable_text_row.dart';

class OverviewScreen extends StatelessWidget {
  final int? sessionId;
  const OverviewScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    final SessionController controller = Get.find<SessionController>();

    // Initialize with passed sessionId if available
    if (sessionId != null && controller.sessionId.value != sessionId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchSession(sessionId!);
      });
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
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
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
              SizedBox(height: 20.h),
              Text(
                "Error: ${controller.errorMessage.value}",
                style: TextStyle(fontSize: 20.sp, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              LoginButton(
                text: "Retry",
                fontSize: 20.sp,
                onTap: () => controller.initializeSession(),
              ),
            ],
          ),
        );
      }

      final session = controller.session.value;
      if (session == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 60.sp, color: AppColors.greyColor),
              SizedBox(height: 20.h),
              Text(
                "No session data available",
                style: TextStyle(fontSize: 24.sp, color: AppColors.greyColor),
              ),
            ],
          ),
        );
      }

      // Determine if session is scheduled (not started)
      final isScheduled = session.status?.toUpperCase() == 'SCHEDULED';

      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Session Status Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoldText(
                          text: "session_info".tr,
                          selectionColor: AppColors.blueColor,
                          fontSize: 32.sp,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(session.status),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            session.status?.toUpperCase() ?? "UNKNOWN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Session Description
                    MainText(
                      fontSize: 26.sp,
                      text: session.description ??
                          "${session.sessiontitle ?? 'Session'} ${isScheduled ? 'is scheduled' : 'is in progress'} with ${session.totalPlayers} ${session.totalPlayers == 1 ? 'participant' : 'participants'}.",
                    ),
                    SizedBox(height: 30.h),

                    // Session Details Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor,
                          width: 1.5.w,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BoldText(
                            text: "session_details".tr,
                            fontSize: 28.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                          SizedBox(height: 15.h),
                          UseableTextrow(
                            color: AppColors.forwardColor,
                            text: "ID: ${session.id}",
                          ),
                          UseableTextrow(
                            color: AppColors.forwardColor,
                            text: "Join Code: ${session.joinCode ?? 'N/A'}",
                          ),
                          UseableTextrow(
                            color: AppColors.forwardColor,
                            text: "Created: ${_formatDateTime(session.createdAt)}",
                          ),
                          UseableTextrow(
                            color: AppColors.forwardColor,
                            text: "Duration: ${session.duration ?? 0} minutes",
                          ),
                          if (session.startTime != null)
                            UseableTextrow(
                              color: AppColors.forwardColor,
                              text: "Start Time: ${_formatDateTime(session.startTime!)}",
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Show engagement and session container only if session is active
              if (!isScheduled) ...[
                EngagementContainer(),
                SizedBox(height: 40.h),
                NewSessionContainer(sessionId: session.id),
                SizedBox(height: 40.h),
              ],

              // If scheduled, show scheduled info
              if (isScheduled) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(25.w),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.orangeColor,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 60.sp,
                          color: AppColors.orangeColor,
                        ),
                        SizedBox(height: 20.h),
                        BoldText(
                          text: "Session Scheduled",
                          fontSize: 28.sp,
                          selectionColor: AppColors.orangeColor,
                        ),
                        SizedBox(height: 10.h),
                        MainText(
                          text: "This session is scheduled to start soon. Session details are available, but interactive features will be enabled once the session starts.",
                          fontSize: 20.sp,
                          color: AppColors.teamColor,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],

              // System Activity
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(25.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.greyColor,
                      width: 1.5.w,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldText(
                        text: "system_activity".tr,
                        fontSize: 28.sp,
                        selectionColor: AppColors.blueColor,
                      ),
                      SizedBox(height: 20.h),
                      UseableTextrow(
                        color: AppColors.forwardColor,
                        text: "Session ${session.status?.toLowerCase() ?? 'created'}",
                        fontSize: 22.sp,
                      ),
                      UseableTextrow(
                        color: AppColors.forwardColor2,
                        text: "${session.totalPlayers} ${session.totalPlayers == 1 ? 'player' : 'players'} registered",
                        fontSize: 22.sp,
                      ),
                      if (!isScheduled)
                        UseableTextrow(
                          color: AppColors.forwardColor3,
                          text: "Real-time monitoring active",
                          fontSize: 22.sp,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      );
    });
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.greyColor;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppColors.forwardColor;
      case 'PAUSED':
        return AppColors.orangeColor;
      case 'COMPLETED':
        return AppColors.blueColor;
      case 'SCHEDULED':
        return AppColors.purpleColor;
      default:
        return AppColors.greyColor;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}