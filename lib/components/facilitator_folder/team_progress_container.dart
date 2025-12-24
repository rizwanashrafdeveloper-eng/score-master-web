import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/players_containers.dart';
import '../../../api/api_controllers/players_controller.dart';

class TeamProgressContainer extends StatelessWidget {
  final int? sessionId;

  const TeamProgressContainer({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    final AdminPlayerController controller = Get.put(AdminPlayerController());

    if (sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.teams.isEmpty && !controller.isLoading.value) {
          controller.fetchTeams(sessionId!);
        }
      });
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingContainer();
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorContainer(controller.errorMessage.value);
      }

      final totalPlayers = controller.activePlayersCount.value +
          controller.inactivePlayersCount.value;
      final submittedCount = controller.activePlayersCount.value;

      return Container(
        width: double.infinity,
        height: 690.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                BoldText(
                  text: "team_progress".tr,
                  selectionColor: AppColors.blueColor,
                  fontSize: 24.sp,
                ),
                SizedBox(height: 12.h),
                LinearProgressIndicator(
                  value: totalPlayers > 0 ? submittedCount / totalPlayers : 0.0,
                  minHeight: 8.h,
                  color: AppColors.forwardColor,
                  backgroundColor: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    BoldText(
                      text: "$submittedCount of $totalPlayers active",
                      fontSize: 20.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                ..._buildPlayersList(controller),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLoadingContainer() {
    return Container(
      width: double.infinity,
      height: 690.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5.w),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorContainer(String error) {
    return Container(
      width: double.infinity,
      height: 690.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5.w),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 60.sp, color: Colors.red),
            SizedBox(height: 20.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlayersList(AdminPlayerController controller) {
    List<Widget> playersList = [];
    int playerIndex = 1;

    for (final team in controller.teams) {
      for (final player in team.players) {
        playersList.add(
          Column(
            children: [
              PlayersContainers(
                text1: "${playerIndex++}",
                text2: player.name ?? "Player",
                image: _getPlayerImage(playerIndex),
                color: AppColors.forwardColor,
                text3: "active".tr,
                delay: Duration(milliseconds: (playerIndex * 100)),
              ),
              SizedBox(height: 21.h),
            ],
          ),
        );
      }
    }

    if (playersList.isEmpty) {
      playersList.add(Center(child: _buildEmptyState()));
    }

    return playersList;
  }

  String _getPlayerImage(int index) {
    final images = [
      Appimages.play1,
      Appimages.play2,
      Appimages.play3,
      Appimages.play4,
      Appimages.play5,
    ];
    return images[(index - 1) % images.length];
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        SizedBox(height: 50.h),
        Icon(Icons.group, size: 120.w, color: AppColors.greyColor),
        SizedBox(height: 20.h),
        BoldText(
          text: "No players yet",
          fontSize: 24.sp,
          selectionColor: AppColors.blueColor,
        ),
        SizedBox(height: 10.h),
        Text(
          "Players will appear here when they join",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, color: AppColors.greyColor),
        ),
      ],
    );
  }
}