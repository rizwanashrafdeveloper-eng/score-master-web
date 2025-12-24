import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import '../../../api/api_controllers/players_controller.dart';
import '../../widgets/useable_text_row.dart'; // Adjust path

class TeamDistributionContainer extends StatelessWidget {
  final int? sessionId;

  const TeamDistributionContainer({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    print("📱 [Web TeamDistributionContainer] Building with sessionId: $sessionId");

    final AdminPlayerController controller = Get.find<AdminPlayerController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Container(
            width: double.infinity,
            height: 300.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyColor,
                width: 1.7.w,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      if (controller.teams.isEmpty) {
        return Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.greyColor,
              width: 1.7.w,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group, size: 40.sp, color: AppColors.greyColor),
                SizedBox(height: 10.h),
                Text(
                  "No teams formed yet",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      print("✅ [Web TeamDistributionContainer] Displaying ${controller.teams.length} teams");

      final teamColors = [
        AppColors.forwardColor,
        AppColors.forwardColor2,
        AppColors.forwardColor3,
        AppColors.orangeColor,
        AppColors.purpleColor,
      ];

      return Container(
        width: double.infinity,
        height: (controller.teams.length * 80 + 100).h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyColor,
            width: 1.7.w,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18.75.w,
            vertical: 8.12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BoldText(
                    text: "team_distribution".tr,
                    selectionColor: AppColors.blueColor,
                    fontSize: 24.sp,
                  ),
                  BoldText(
                    text: "${controller.teams.length} Teams",
                    selectionColor: AppColors.greyColor,
                    fontSize: 20.sp,
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Teams list with player counts
              ...controller.teams.asMap().entries.map((entry) {
                final index = entry.key;
                final team = entry.value;
                final teamColor = teamColors[index % teamColors.length];
                final playerCount = team.players.length;

                return Column(
                  children: [
                    UseableTextrow(
                      color: teamColor,
                      text: team.nickname ?? "Team ${index + 1}",
                      text1: "$playerCount ${playerCount == 1 ? 'Player' : 'Players'}",
                      fontSize: 20.sp,
                    ),
                    if (index < controller.teams.length - 1) SizedBox(height: 15.h),
                  ],
                );
              }).toList(),

              SizedBox(height: 10.h),

              // Total players summary
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.forwardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoldText(
                      text: "Total Players",
                      selectionColor: AppColors.blueColor,
                      fontSize: 20.sp,
                    ),
                    BoldText(
                      text: "${controller.activePlayersCount.value + controller.inactivePlayersCount.value}",
                      selectionColor: AppColors.forwardColor,
                      fontSize: 22.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}