// components/admin_folder.dart/default_time_container.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/api/api_controllers/create_game_controller.dart';

class DefaultTimeContainer extends StatelessWidget {
  final CreateGameController controller;

  const DefaultTimeContainer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600.w,
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.forwardColor.withOpacity(0.1), width: 2.0),
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.grey.shade100.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Header Row ---
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.blueColor, size: 36.r),
              SizedBox(width: 16.w),
              BoldText(
                text: "total_game_time_minutes".tr,
                selectionColor: AppColors.blueColor,
                fontSize: 28.sp,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          /// --- Input for total time ---
          SizedBox(
            width: 400.w,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.timeDuration.value = 0;
                  return;
                }

                final time = int.tryParse(value);
                if (time == null) {
                  Get.snackbar(
                    "Invalid Input".tr,
                    "Only numbers are acceptable".tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    margin: EdgeInsets.all(16.r),
                    borderRadius: 8.r,
                  );
                  controller.timeDuration.value = 0;
                } else {
                  controller.timeDuration.value = time;
                }
              },
              decoration: InputDecoration(
                hintText: "enter_total_time".tr,
                prefixIcon: Icon(Icons.timer, color: AppColors.orangeColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 16.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          /// --- Selected time text ---
          Obx(() => Text(
            "Selected time: ${controller.timeDuration.value} minutes".tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.teamColor,
            ),
          )),
        ],
      ),
    );
  }
}