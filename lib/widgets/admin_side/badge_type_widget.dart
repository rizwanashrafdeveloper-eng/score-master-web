// widgets/admin_side_widgets/custom_badge_widget_web.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';

enum BadgeType { gold, silver, bronze }

class BadgeWidget extends StatefulWidget {
  final Function(BadgeType badge, int score) onChanged;

  const BadgeWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<BadgeWidget> createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget> {
  BadgeType selectedBadge = BadgeType.gold;
  final TextEditingController scoreController = TextEditingController();

  final Map<BadgeType, int> badgeScores = {
    BadgeType.gold: 90,
    BadgeType.silver: 80,
    BadgeType.bronze: 70,
  };

  @override
  void initState() {
    super.initState();
    scoreController.text = badgeScores[selectedBadge].toString();
    _notifyParent();
  }

  void updateScore(BadgeType badge) {
    setState(() {
      selectedBadge = badge;
      scoreController.text = badgeScores[badge].toString();
    });
    _notifyParent();
  }

  void _notifyParent() {
    final score = int.tryParse(scoreController.text) ?? badgeScores[selectedBadge]!;
    widget.onChanged(selectedBadge, score);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Badge Title
        Center(
          child: Text(
            "badge_labeling".tr,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blueColor,
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Badge Image
        Center(
          child: Image.asset(
            Appimages.badge,
            width: 200.w,
            height: 180.h,
          ),
        ),
        SizedBox(height: 20.h),

        // Badge Name Dropdown
        Container(
          width: 400.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.forwardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Badge Name".tr,
                  style: TextStyle(fontSize: 24.sp, color: Colors.white)
              ),
              DropdownButton<BadgeType>(
                value: selectedBadge,
                underline: const SizedBox(),
                dropdownColor: AppColors.forwardColor,
                style: TextStyle(fontSize: 24.sp, color: Colors.white),
                items: BadgeType.values.map((badge) {
                  return DropdownMenuItem(
                    value: badge,
                    child: Text(
                      badge.name.toUpperCase(),
                      style: TextStyle(fontSize: 24.sp, color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (badge) {
                  if (badge != null) updateScore(badge);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Required Score (Editable)
        Container(
          width: 400.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.forwardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Required Score".tr,
                  style: TextStyle(fontSize: 24.sp, color: Colors.white)
              ),
              SizedBox(
                width: 120.w,
                child: TextField(
                  controller: scoreController,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.sp, color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    _notifyParent();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}