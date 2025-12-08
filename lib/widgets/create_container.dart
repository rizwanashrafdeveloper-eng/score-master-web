import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';

class CreateContainer extends StatelessWidget {
  final String? text;
  final double? height;
  final Color? borderColor;
  final Color? containerColor;
  final Color? textColor;
  final double? width;
  final double? right;
  final double? top;
  final double? arrowh;
  final double? arrowW;
  final double? fontsize2;
  final double? borderW;
  final bool ishow;
  final VoidCallback? onTap; // ✅ ADD THIS

  const CreateContainer({
    super.key,
    this.text,
    this.height,
    this.width,
    this.borderColor,
    this.containerColor,
    this.textColor,
    this.right,
    this.ishow = true,
    this.top,
    this.fontsize2,
    this.arrowh,
    this.arrowW,
    this.borderW,
    this.onTap, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ ADD GESTURE DETECTOR
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: (width ?? 431).w,
            height: (height ?? 100).h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              color: containerColor ?? AppColors.createColor,
              border: Border.all(
                  color: borderColor ?? AppColors.createBorderColor,
                  width: borderW ?? 4.05.w
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text ?? "create".tr,
                      style: TextStyle(
                        fontFamily: "gotham",
                        fontSize: fontsize2 ?? 42.sp,
                        color: textColor ?? AppColors.createBorderColor,
                      ),
                    ),
                  )
              ),
            ),
          ),
          ishow
              ? Positioned(
            top: top ?? -50.h,
            right: (right ?? -20).w,
            child: SvgPicture.asset(
              Appimages.arrowdown,
              height: arrowh ?? 69.h,
              width: arrowW ?? 83.w,
            ),
          )
              : SizedBox()
        ],
      ),
    );
  }
}