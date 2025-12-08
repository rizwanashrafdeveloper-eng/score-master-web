import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/create_container.dart';

// Import your controller
import '../../api/api_controllers/join_session_controller.dart';

class JoinSessionWidget extends StatelessWidget {
  final JoinSessionController controller = Get.put(JoinSessionController());
  final int playerId;

  JoinSessionWidget({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: AppColors.greyColor,
          width: 1.5.w,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20.h,
            right: 20.w,
            child: Obx(() {
              return CreateContainer(
                arrowW: 35.w,
                arrowh: 40.h,
                top: -40.h,
                text: controller.isLoading.value ? "Joining..." : "Join with Code",
                width: 387.w,
                height: 64.h,
                borderW: 2.9.w,
                onTap: controller.isLoading.value
                    ? null
                    : () => controller.joinSession(
                  playerId,
                  controller.codeController.value,
                ),
              );
            }),
          ),
          Center(
            child: SizedBox(
              width: 400.w,
              child: TextField(
                onChanged: (val) => controller.codeController.value = val,
                decoration: InputDecoration(
                  hintText: "Enter Code",
                  hintStyle: TextStyle(
                    fontSize: 42.sp,
                    fontFamily: "gotham",
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42.sp,
                  fontFamily: "gotham",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}