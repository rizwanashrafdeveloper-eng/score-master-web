// widgets/admin_side_widgets/challenge_type_selector_web.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';

class ChallengeTypeSelector extends StatefulWidget {
  final List<String> availableTypes;
  final List<String> initialSelected;
  final Function(List<String>) onSelectionChanged;

  const ChallengeTypeSelector({
    super.key,
    required this.availableTypes,
    this.initialSelected = const [],
    required this.onSelectionChanged,
  });

  @override
  State<ChallengeTypeSelector> createState() => _ChallengeTypeSelectorState();
}

class _ChallengeTypeSelectorState extends State<ChallengeTypeSelector> {
  late List<String> selectedTypes;

  @override
  void initState() {
    super.initState();
    selectedTypes = List.from(widget.initialSelected);
  }

  void toggleSelection(String type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
    });
    widget.onSelectionChanged(selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(
          text: "challenge_types".tr,
          selectionColor: AppColors.blueColor,
          fontSize: 30.sp,
        ),
        SizedBox(height: 20.h),

        ...widget.availableTypes.map((type) {
          final isSelected = selectedTypes.contains(type);

          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: GestureDetector(
              onTap: () => toggleSelection(type),
              child: Container(
                width: 400.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blueColor.withOpacity(0.2) : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.blueColor : AppColors.greyColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type.tr,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.blueColor : AppColors.greyColor,
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: AppColors.blueColor, size: 28.r)
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}