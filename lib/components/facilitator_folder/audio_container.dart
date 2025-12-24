// lib/components/facilitator_folder/audio_container.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';

class AudioContainer extends StatefulWidget {
  final int barCount;
  final String? feedbackText;

  const AudioContainer({
    super.key,
    this.barCount = 50,
    this.feedbackText,
  });

  @override
  State<AudioContainer> createState() => _AudioContainerState();
}

class _AudioContainerState extends State<AudioContainer> {
  final Random _random = Random();
  bool isPlaying = false;

  late List<int> baseBars;
  late List<int> greenBars;

  @override
  void initState() {
    super.initState();

    baseBars = List.generate(
      widget.barCount,
          (i) => 20 + _random.nextInt(60),
    );

    greenBars = List.generate(baseBars.length, (i) => 5);
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    while (isPlaying) {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        greenBars = List.generate(
          baseBars.length,
              (index) => _random.nextInt(baseBars[index] + 1),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColors.greyColor, width: 1.7.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoldText(
                  text: "Audio Response",
                  fontSize: 30.sp,
                  selectionColor: AppColors.blueColor,
                ),
                Row(
                  children: [
                    Image.asset(
                      Appimages.timeout2,
                      height: 30.h,
                      width: 30.w,
                    ),
                    MainText(
                      text: "2 min read",
                      fontSize: 24.sp,
                      color: AppColors.teamColor,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 30.h),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.forwardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: baseBars.asMap().entries.map((entry) {
                      int index = entry.key;
                      int baseHeight = entry.value;
                      int greenHeight = greenBars[index];

                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 3,
                            height: baseHeight.toDouble(),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20.r)
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 3,
                            height: greenHeight.toDouble(),
                            color: AppColors.forwardColor,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _togglePlayPause,
                  child: Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.whiteColor,
                      size: 30.sp,
                    ),
                  ),
                ),
                Row(
                  children: [
                    MainText(
                      text: "1:45",
                      color: AppColors.teamColor,
                      fontSize: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    SizedBox(
                      width: 120.w,
                      child: LinearProgressIndicator(
                        value: 0.4,
                        minHeight: 6.h,
                        color: AppColors.forwardColor,
                        backgroundColor: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    MainText(
                      text: "3:20",
                      color: AppColors.teamColor,
                      fontSize: 20.sp,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}