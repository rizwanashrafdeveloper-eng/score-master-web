// components/facilitator_folder/count_container_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';

class CountController extends GetxController {
  final RxInt count = 0.obs;
  final RxInt minValue;
  final RxInt maxValue;

  CountController({int initialValue = 0, int min = 0, int max = 99})
      : minValue = RxInt(min), maxValue = RxInt(max) {
    count.value = initialValue.clamp(min, max);
  }

  void increment() {
    if (count.value < maxValue.value) {
      count.value++;
    }
  }

  void decrement() {
    if (count.value > minValue.value) {
      count.value--;
    }
  }

  void reset() {
    count.value = minValue.value;
  }

  void setValue(int value) {
    count.value = value.clamp(minValue.value, maxValue.value);
  }

  bool get canIncrement => count.value < maxValue.value;
  bool get canDecrement => count.value > minValue.value;
}

class CountContainerRow extends StatelessWidget {
  final Function(int)? onCountChanged; // Add this parameter

  const CountContainerRow({
    super.key,
    this.onCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final CountController controller = Get.put(
      CountController(),
      tag: 'CountControllerWeb',
    );

    // Listen for count changes and call callback
    ever(controller.count, (value) {
      onCountChanged?.call(value);
    });

    return Container(
      width: 400.w,
      height: 120.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrement Button
          Obx(() {
            final isEnabled = controller.canDecrement;
            return Expanded(
              child: GestureDetector(
                onTap: isEnabled ? controller.decrement : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 120.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: isEnabled ? AppColors.forwardColor : AppColors.forwardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: isEnabled ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.3),
                      child: Icon(
                        Icons.remove,
                        color: isEnabled ? AppColors.forwardColor : AppColors.forwardColor.withOpacity(0.5),
                        size: 24.r,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Count Display
          Expanded(
            child: SizedBox(
              height: 120.h,
              child: Obx(() => Center(
                child: BoldText(
                  text: controller.count.value.toString().padLeft(2, '0'),
                  fontSize: 48.sp,
                  selectionColor: AppColors.blueColor,
                  textAlign: TextAlign.center,
                ),
              )),
            ),
          ),

          // Increment Button
          Obx(() {
            final isEnabled = controller.canIncrement;
            return Expanded(
              child: GestureDetector(
                onTap: isEnabled ? controller.increment : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 120.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: isEnabled ? AppColors.forwardColor : AppColors.forwardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: isEnabled ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.3),
                      child: Icon(
                        Icons.add,
                        color: isEnabled ? AppColors.forwardColor : AppColors.forwardColor.withOpacity(0.5),
                        size: 24.r,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}