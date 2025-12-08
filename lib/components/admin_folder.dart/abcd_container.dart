import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';

class ABCDContainer extends StatelessWidget {
  const ABCDContainer({
    super.key,
    required this.sessionCode,
  });

  final String sessionCode;

  void _copyToClipboard(BuildContext context) {
    print('Copy button tapped - Session code: $sessionCode');

    if (sessionCode.isEmpty || sessionCode == "N/A") {
      print('No valid session code');
      return;
    }

    try {
      Clipboard.setData(ClipboardData(text: sessionCode));
      print('Data set to clipboard');

      // Try multiple methods to see which works
      _tryAllSnackbarMethods(context);
    } catch (e) {
      print('Clipboard error: $e');
    }
  }

  void _tryAllSnackbarMethods(BuildContext context) {
    print('Attempting to show snackbar...');

    // Method 1: GetX Snackbar
    try {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        "Copied!",
        "Session code copied to clipboard",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.forwardColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(20.w),
        duration: const Duration(seconds: 2),
        isDismissible: true,
      );
      print('GetX snackbar shown');
    } catch (e) {
      print('GetX snackbar failed: $e');
    }

    // Method 2: Scaffold Messenger (more reliable)
    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✓ Copied: $sessionCode",
              style: TextStyle(fontSize: 16.sp),
            ),
            backgroundColor: AppColors.forwardColor,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20.w),
            duration: const Duration(seconds: 4),
          ),
        );
        print('Scaffold snackbar shown');
      } catch (e) {
        print('Scaffold snackbar failed: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 131.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.forwardColor,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(60.r),
        color: AppColors.forwardColor.withOpacity(0.1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BoldText(
              text: "team_code".tr,
              fontSize: 32.sp,
              selectionColor: AppColors.blueColor,
            ),
            Row(
              children: [
                MainText(
                  text: sessionCode,
                  color: AppColors.forwardColor,
                  fontSize: 49.sp,
                  fontFamily: "gotham",
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () => _copyToClipboard(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 65.w,
                      height: 65.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.forwardColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Appimages.copy,
                          color: AppColors.whiteColor,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}