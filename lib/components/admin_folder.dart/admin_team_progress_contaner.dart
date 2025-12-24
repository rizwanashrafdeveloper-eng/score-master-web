import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/players_containers.dart';
import 'package:scorer_web/api/api_controllers/team_view_controller.dart';

class AdminTeamProgress extends StatelessWidget {
  const AdminTeamProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final teamController = Get.find<TeamViewController>();

    return Container(
      width: double.infinity,
      height: 0.69.sh,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Obx(() {
            if (teamController.isLoading.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: CircularProgressIndicator(color: AppColors.blueColor),
                ),
              );
            }

            final team = teamController.teamView.value?.teams.isNotEmpty == true
                ? teamController.teamView.value!.teams.first
                : null;

            final players = team?.players ?? [];
            final totalPlayers = players.length;
            final submittedPlayers = players.where((p) => p['hasSubmitted'] == true).length;
            final progress = totalPlayers > 0 ? submittedPlayers / totalPlayers : 0.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                BoldText(
                  text: "team_progress".tr,
                  selectionColor: AppColors.blueColor,
                  fontSize: 30.sp,
                ),
                SizedBox(height: 15.h),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  color: AppColors.forwardColor,
                  backgroundColor: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(10),
                ),

                SizedBox(height: 15.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    BoldText(
                      text: "$submittedPlayers of $totalPlayers submitted",
                      fontSize: 14.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                if (players.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.h),
                      child: BoldText(
                        text: "No team members yet",
                        fontSize: 16.sp,
                        selectionColor: AppColors.teamColor,
                      ),
                    ),
                  )
                else
                  ...List.generate(players.length, (index) {
                    final player = players[index];
                    final isSubmitted = player['hasSubmitted'] == true;
                    final playerName = player['name']?.toString() ?? 'Player ${index + 1}';

                    return Column(
                      children: [
                        PlayersContainers(
                          text1: "${index + 1}",
                          text2: playerName,
                          image: Appimages.play1,
                          color: isSubmitted ? AppColors.forwardColor : AppColors.yellowColor,
                          text3: isSubmitted ? "submitted".tr : "working".tr,
                        ),
                        if (index < players.length - 1) SizedBox(height: 14.h),
                      ],
                    );
                  }),
                SizedBox(height: 20.h),
              ],
            );
          }),
        ),
      ),
    );
  }
}