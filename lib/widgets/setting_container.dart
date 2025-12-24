import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';

class SettingContainer extends StatelessWidget {
  final IconData icons;
  final bool ishow;
  final double? size; // ✅ NEW - Custom size
  final double? iconSize; // ✅ NEW - Custom icon size
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? dotColor;
  final VoidCallback? onTap;
  final bool showShadow;

  const SettingContainer({
    super.key,
    required this.icons,
    this.ishow = false,
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.dotColor,
    this.onTap,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    // Calculate responsive sizes
    final containerSize = size ??
        (isMobile ? 50.w : (isTablet ? 55.w : 60.w));
    final calculatedIconSize = iconSize ??
        (isMobile ? 24.sp : (isTablet ? 26.sp : 28.sp));
    final dotSize = isMobile ? 10.w : 13.w;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: containerSize * 1.2,
          maxHeight: containerSize * 1.2,
          minWidth: 40.w,
          minHeight: 40.h,
        ),
        height: containerSize,
        width: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? AppColors.whiteColor,
          border: Border.all(
            color: AppColors.settingColor,
            width: isMobile ? 1.5.w : 2.w,
          ),
          boxShadow: showShadow
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ]
              : null,
        ),
        child: Stack(
          children: [
            // Icon
            Center(
              child: Icon(
                icons,
                color: iconColor ?? AppColors.languageColor,
                size: calculatedIconSize,
              ),
            ),

            // Red notification dot
            if (ishow)
              Positioned(
                top: isMobile ? 8.h : 10.h,
                right: isMobile ? 8.w : 10.w,
                child: Container(
                  height: dotSize,
                  width: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor ?? AppColors.redColor,
                    border: Border.all(
                      color: AppColors.whiteColor,
                      width: isMobile ? 1.w : 2.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}