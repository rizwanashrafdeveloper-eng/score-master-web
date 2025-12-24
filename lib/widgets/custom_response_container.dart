// lib/widgets/custom_response_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';

class CustomResponseContainer extends StatelessWidget {
  final String? text;
  final bool ishow;
  final Color? color1;
  final String? text1;
  final String? image;
  final Color? textColor;
  final double? containerHeight;
  final double? containerWidth;
  final bool ishow1;
  final VoidCallback? onTap;

  final String? playerName;
  final String? questionText;
  final String? answer;
  final int? questionPoints;
  final int? score;
  final bool? isScored;
  final VoidCallback? onEvaluateTap;
  final VoidCallback? onViewScoreTap;
  final bool? showEvaluate;
  final bool? showViewScore;
  final String? teamName;
  final String? submittedTime;

  const CustomResponseContainer({
    super.key,
    this.text,
    this.ishow = false,
    this.color1,
    this.text1,
    this.image,
    this.textColor,
    this.containerHeight,
    this.containerWidth,
    this.ishow1 = true,
    this.onTap,
    this.playerName,
    this.questionText,
    this.answer,
    this.questionPoints,
    this.score,
    this.isScored = false,
    this.onEvaluateTap,
    this.onViewScoreTap,
    this.showEvaluate = false,
    this.showViewScore = false,
    this.teamName,
    this.submittedTime,
  });

  @override
  Widget build(BuildContext context) {
    bool isSpanish = Get.locale?.languageCode == 'es';

    final bool isResponseScored = isScored ?? false;
    final String buttonText = isResponseScored ? (text1 ?? "View Score") : (text1 ?? "Evaluate");
    final String statusText = isResponseScored ? (text ?? "Scored") : (text ?? "Pending");
    final Color statusColor = isResponseScored ? (color1 ?? AppColors.forwardColor) : (color1 ?? AppColors.yellowColor);
    final Color buttonColor = isResponseScored ? AppColors.forwardColor : AppColors.greyColor;

    final bool shouldShowEvaluate = showEvaluate ?? !isResponseScored;
    final bool shouldShowViewScore = showViewScore ?? isResponseScored;
    final VoidCallback? buttonAction = isResponseScored ? onViewScoreTap : onEvaluateTap;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap ?? buttonAction,
          child: Container(
            height: containerHeight ?? 300.h,
            width: containerWidth ?? double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: AppColors.greyColor, width: 1.7.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            Appimages.blackgirl,
                            height: 60.h,
                            width: 60.w,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                text: playerName ?? "Sarah Johnson",
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              MainText(
                                text: "${teamName ?? "Team Beta"} • ${submittedTime ?? "3:42 PM"}",
                                color: AppColors.teamColor,
                                fontSize: 20.sp,
                                height: 1,
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UseableContainer(
                            text: statusText,
                            color: statusColor,
                            textColor: textColor ?? (isResponseScored ? Colors.white : AppColors.languageTextColor),
                            fontSize: isSpanish ? 10.sp : 12.sp,
                          ),
                          SizedBox(width: 8.w),
                          if (score != null && isResponseScored)
                            UseableContainer(
                              text: "$score",
                              fontFamily: "giory",
                              fontSize: 16.sp,
                              //width: 50.w,
                            //  height: 42.h,
                              color: AppColors.orangeColor,
                              textColor: Colors.white,
                            )
                          else if (questionPoints != null)
                            UseableContainer(
                              text: "${questionPoints}P",
                              fontFamily: "giory",
                              fontSize: 16.sp,
                              //width: 50.w,
                             // height: 42.h,
                              color: AppColors.greyColor,
                              textColor: Colors.white,
                            )
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 20.h),

                  MainText(
                    text: questionText ?? "Define your team's primary objective for the next quarter and identify three key strategies to achieve it.",
                    fontSize: 22.sp,
                    height: 1.4.h,
                    color: AppColors.blueColor,
                  ),

                  SizedBox(height: 15.h),

                  if (answer != null && answer!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          text: "Answer:",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: MainText(
                            text: answer!,
                            fontSize: 20.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 15.h),
                      ],
                    ),

                  const Spacer(),

                  if (ishow1 && (shouldShowEvaluate || shouldShowViewScore))
                    Center(
                      child: LoginButton(
                        fontSize: 22.sp,
                        fontFamily: "refsan",
                        imageHeight: 25.h,
                        imageWidth: 25.w,
                        text: buttonText,
                        height: 60.h,
                        width: 250.w,
                        radius: 12.r,
                        image: image ?? (isResponseScored ? Appimages.eye : Appimages.star),
                        ishow: true,
                        color: buttonColor,
                        onTap: buttonAction,
                      ),
                    )
                  else if (ishow1)
                    const SizedBox.shrink(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),

        if (ishow)
          Positioned(
            top: 70.h,
            right: 14.w,
            child: Image.asset(
              Appimages.ai2,
              height: 58.h,
              width: 58.w,
            ),
          ),

        if (ishow)
          Positioned(
            top: 60.h,
            right: -6.w,
            child: SvgPicture.asset(
              Appimages.arrowdown,
              height: 30.h,
              width: 30.w,
            ),
          ),
      ],
    );
  }
}