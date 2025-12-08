import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:scorer_web/components/responsive_fonts.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/main_text.dart';

class AccountInfoClumn extends StatelessWidget {
  const AccountInfoClumn({
    super.key,
    this.text,
    this.email,
    this.phone,
    this.joinDate,
    //this.levelText,
  });

  final String? text;
  final String? email;
  final String? phone;
  final String? joinDate;
  //final String? levelText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoldText(
          text: "account_information".tr,
          selectionColor: AppColors.blueColor,
          fontSize: 30.sp,
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: AppColors.greyColor, width: 1.5.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainText(
                        text: "email".tr,
                        fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 24.sp,
                          smallSize: 12.sp,
                        ),
                      ),
                      BoldText(
                        text: email ?? "N/A",
                        fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 24.sp,
                          smallSize: 12.sp,
                        ),
                        selectionColor: AppColors.blueColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainText(
                        text: "phone".tr,
                        fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 24.sp,
                          smallSize: 12.sp,
                        ),
                      ),
                      BoldText(
                        text: phone ?? "N/A",
                        fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 24.sp,
                          smallSize: 12.sp,
                        ),
                        selectionColor: AppColors.blueColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainText(
                        text: "join_date".tr,
                        fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 24.sp,
                          smallSize: 12.sp,
                        ),
                      ),
                      BoldText(
                        text: joinDate ?? "N/A",
                        fontSize: ResponsiveFont.getFontSizeCustom(
                          defaultSize: 24.sp,
                          smallSize: 12.sp,
                        ),
                        selectionColor: AppColors.blueColor,
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     MainText(
                  //       text: text ?? "Facilitator Level",
                  //       fontSize: ResponsiveFont.getFontSizeCustom(
                  //         defaultSize: 24.sp,
                  //         smallSize: 12.sp,
                  //       ),
                  //     ),
                  //     CreateContainer(
                  //       width: 130.w,
                  //       height: 60.h,
                  //       borderW: 2.w,
                  //       arrowW: 25.w,
                  //       arrowh: 30.h,
                  //       text: levelText ?? "Level 3",
                  //       top: 8.h,
                  //       right: -30.w,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}