import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../../../api/api_controllers/session_controller.dart';
import '../../widgets/useable_text_row.dart'; // Adjust path

class RealTimeMonitorContainer extends StatelessWidget {
  const RealTimeMonitorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    print("📱 [Web RealTimeMonitorContainer] Building...");

    final SessionController controller = Get.put(SessionController());

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Container(
            width: double.infinity,
            height: 350.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyColor,
                width: 1.5.w,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      final session = controller.session.value;
      final engagementRate = session?.engagement ?? 89;

      print("✅ [Web RealTimeMonitorContainer] Engagement: $engagementRate%");

      // Dummy activity data (replace with real API data when available)
      final List<Map<String, String>> recentActivities = [
        {"activity": "Session started successfully", "time": "2m ago", "color": "forward"},
        {"activity": "All players connected", "time": "1m ago", "color": "forward2"},
        {"activity": "Real-time scoring active", "time": "Just now", "color": "forward3"},
      ];

      return Container(
        width: double.infinity,
        height: 400.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyColor,
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              BoldText(
                text: "real_time_monitoring".tr,
                selectionColor: AppColors.blueColor,
                fontSize: 22.sp,
              ),
              SizedBox(height: 25.h),
              LinearProgressIndicator(
                value: engagementRate / 100,
                minHeight: 8.h,
                color: AppColors.forwardColor,
                backgroundColor: AppColors.greyColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainText(
                    text: "player_engagement".tr,
                    fontSize: 20.sp,
                  ),
                  BoldText(
                    text: "$engagementRate%",
                    fontSize: 20.sp,
                    selectionColor: AppColors.blueColor,
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              MainText(
                text: "recent_activity".tr,
                fontSize: 20.sp,
              ),
              SizedBox(height: 20.h),

              // Recent activities list
              ...recentActivities.map((activity) {
                Color color;
                switch (activity["color"]) {
                  case "forward2":
                    color = AppColors.forwardColor2;
                    break;
                  case "forward3":
                    color = AppColors.forwardColor3;
                    break;
                  default:
                    color = AppColors.forwardColor;
                }

                return Column(
                  children: [
                    UseableTextrow(
                      color: color,
                      text: "${activity["activity"]} • ${activity["time"]}",
                      fontSize: 18.sp,
                    ),
                    SizedBox(height: 15.h),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      );
    });
  }
}