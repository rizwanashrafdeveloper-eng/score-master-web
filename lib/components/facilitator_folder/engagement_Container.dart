import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import '../../../api/api_controllers/session_controller.dart';

class EngagementContainer extends StatelessWidget {
  const EngagementContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController controller = Get.put(SessionController());

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final session = controller.session.value;
      final activePlayers = session?.totalPlayers ?? 0;
      final engagementRate = session?.engagement ?? 0;

      return Padding(
        padding: EdgeInsets.only(right: 30.w, left: 25.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              Appimages.group,
              height: 224.h,
              width: 258.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 3.w),
            Flexible(
              child: Container(
                width: 482.w,
                height: 230.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor, width: 1.5.w),
                  borderRadius: BorderRadius.circular(46.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 42.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          BoldText(
                            text: "$activePlayers",
                            selectionColor: AppColors.forwardColor,
                            fontSize: 46.sp,
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 120.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: BoldText(
                                text: "active_players".tr,
                                selectionColor: AppColors.blueColor,
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BoldText(
                            text: "$engagementRate%",
                            selectionColor: AppColors.forwardColor,
                            fontSize: 46.sp,
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            width: 95.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: AppColors.orangeColor,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: BoldText(
                                text: "engagement".tr,
                                selectionColor: AppColors.blueColor,
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}