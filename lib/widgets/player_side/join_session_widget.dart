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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine screen size
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Container(
          constraints: BoxConstraints(
            minHeight: isSmallScreen ? 80.h : 100.h,
          ),
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
                top: isSmallScreen ? -35.h : -40.h,
                right: isSmallScreen ? 10.w : 20.w,
                child: Obx(() {
                  return CreateContainer(
                    arrowW: isSmallScreen ? 25.w : 35.w,
                    arrowh: isSmallScreen ? 30.h : 40.h,
                    top: isSmallScreen ? -35.h : -40.h,
                    text: controller.isLoading.value
                        ? "joining_session".tr
                        : "join_with_code".tr,
                    width: isSmallScreen ? 280.w : isMediumScreen ? 320.w : 387.w,
                    height: isSmallScreen ? 54.h : 64.h,
                    borderW: 2.9.w,
                    fontsize2: isSmallScreen ? 16.sp : isMediumScreen ? 18.sp : 22.sp,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10.w : 20.w,
                    vertical: isSmallScreen ? 10.h : 0,
                  ),
                  child: TextField(
                    onChanged: (val) => controller.codeController.value = val,
                    decoration: InputDecoration(
                      hintText: "enter_code".tr,
                      hintStyle: TextStyle(
                        fontSize: isSmallScreen ? 28.sp : isMediumScreen ? 35.sp : 42.sp,
                        fontFamily: "gotham",
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10.w : 20.w,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28.sp : isMediumScreen ? 35.sp : 42.sp,
                      fontFamily: "gotham",
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}






//




