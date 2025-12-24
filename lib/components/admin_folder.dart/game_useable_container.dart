import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';

// Import your model
import '../../api/api_models/show_all_game_model.dart';

class GameUseAbleContainer extends StatelessWidget {
  final GameModel game;
  final VoidCallback? onTap;

  const GameUseAbleContainer({
    super.key,
    required this.game,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print for web
    print("🎨 Web - Building GameUseAbleContainer for '${game.displayName}' → timeDuration: ${game.timeDuration} | Formatted: ${_formatTimeDuration(game.timeDuration)}");

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 330.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.greyColor,
            width: 3.33.w,
          ),
          borderRadius: BorderRadius.circular(25.r),
          color: AppColors.forwardColor.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 10.h,
              left: -70.w,
              child: Image.asset(
                Appimages.game,
                width: 135.w,
                height: 135.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 70.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),

                  // Game Name
                  MainText(
                    text: game.displayName,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 17.h),

                  // Game Description
                  MainText(
                    text: game.displayDescription,
                    fontSize: 24.sp,
                    height: 1.3,
                    color: AppColors.teamColor,
                   // isEllipsis: true,
                    maxLines: 2,
                  ),

                  SizedBox(height: 17.h),

                  // Status badges
                  Row(
                    children: [
                      UseableContainer(
                        fontSize: 18.sp,
                        //height: 50.h,
                        text: game.scoringTypeDisplay,
                        color: _getScoringTypeColor(game.scoringType),
                        //width: 120.w,
                      ),
                      SizedBox(width: 12.w),
                      UseableContainer(
                        fontSize: 18.sp,
                        text: game.statusText,
                        //height: 50.h,
                        color: game.isActive ? AppColors.forwardColor : Colors.grey,
                       // width: 120.w,
                      ),
                      SizedBox(width: 12.w),
                      UseableContainer(
                        fontSize: 18.sp,
                        text: game.modeDisplayText,
                       // height: 50.h,
                        color: game.mode == 'team' ? AppColors.blueColor : AppColors.orangeColor,
                        //width: 120.w,
                      ),
                    ],
                  ),

                  SizedBox(height: 36.h),

                  // Game stats
                  Row(
                    children: [
                      // Phases count
                      Row(
                        children: [
                          Image.asset(
                            Appimages.player2,
                            height: 56.h,
                            width: 41.w,
                          ),
                          SizedBox(width: 12.w),
                          MainText(
                            text: "${game.totalPhases} " + "phases".tr,
                            fontSize: 24.sp,
                          ),
                        ],
                      ),
                      SizedBox(width: 40.w),

                      // Time duration indicator
                      Row(
                        children: [
                          Image.asset(
                            Appimages.timeout2,
                            height: 56.h,
                            width: 41.w,
                          ),
                          SizedBox(width: 12.w),
                          MainText(
                            text: _formatTimeDuration(game.timeDuration),
                            fontSize: 24.sp,
                            color: AppColors.redColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Active status indicator
            if (game.isActive)
              Positioned(
                top: 25.h,
                right: 25.w,
                child: Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
// Update the _formatTimeDuration method:
  String _formatTimeDuration(int durationInMinutes) {
    final formatted = durationInMinutes <= 0
        ? 'no_time_limit'.tr // ✅ Changed from 'No time limit'
        : '${durationInMinutes} ' + 'minutes'.tr; // ✅ Changed from 'min'
    print("⏱️ Web - _formatTimeDuration DEBUG → Input: $durationInMinutes → Output: $formatted");
    return formatted;
  }

  Color _getScoringTypeColor(String scoringType) {
    switch (scoringType) {
      case 'AI':
        return AppColors.orangeColor;
      case 'MANUAL':
        return AppColors.blueColor;
      case 'HYBRID':
        return AppColors.forwardColor;
      default:
        return AppColors.orangeColor;
    }
  }
}





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
//
// class GameUseAbleContainer extends StatelessWidget {
//   const GameUseAbleContainer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 1.sw, // full screen width
//       height: 330.h, // responsive height
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: AppColors.greyColor,
//           width: 3.33.w, // responsive border width
//         ),
//         borderRadius: BorderRadius.circular(25.r), // responsive radius
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             top: 10.h,
//             left: -70.w,
//             child: Image.asset(
//               Appimages.game,
//               width: 135.w,
//               height: 135.h,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 70.w, right: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 30.h),
//                 MainText(
//                   text: "odyssee_des_okr".tr,
//                   fontSize: 30.sp.sp,
//                 ),
//                 SizedBox(height: 17.h),
//                 MainText(
//                   text: "Objective & Key Result alignment\nthrough decision-making".tr,
//                   fontSize: 30.sp.sp,
//                   height: 1.3,
//                   color: AppColors.teamColor,
//                 ),
//                 SizedBox(height: 17.h),
//                 Row(
//                   children: [
//                     UseableContainer(
//
//                       text: "ai_based".tr,
//                       color: AppColors.orangeColor,
//
//                     ),
//                     SizedBox(width: 7.w),
//                     UseableContainer(
//
//                       text: "active".tr,
//
//                       color: AppColors.forwardColor,
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 36.h),
//                 Row(
//                   children: [
//                     Row(
//                       children: [
//                         Image.asset(
//                           Appimages.player2,
//                           height: 56.h,
//                           width: 41.w,
//                         ),
//                         SizedBox(width: 5.w),
//                         MainText(
//                           text: "12 Players",
//                           fontSize: 30.sp,
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 17.w),
//                     Row(
//                       children: [
//                         Image.asset(
//                           Appimages.timeout2,
//                           height: 56.h,
//                           width: 41.w,
//                         ),
//                         SizedBox(width: 6.w),
//                         MainText(
//                           text: "60 min duration",
//                           fontSize: 30.sp,
//                           color: AppColors.redColor,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
