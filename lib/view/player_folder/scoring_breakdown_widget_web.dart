import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_sloder_row.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../../api/api_models/player_score_model.dart';

class ScoringBreakdownWidgetWeb extends StatelessWidget {
  final PlayerScoreModel? scoreData;

  const ScoringBreakdownWidgetWeb({super.key, this.scoreData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor,
          width: 1.7.w,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 17.w,
          right: 15.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            BoldText(
              text: "Scoring Breakdown",
              selectionColor: AppColors.blueColor,
              fontSize: 30.sp,
            ),
            SizedBox(height: 5.h),

            if (scoreData != null) ...[
              CustomSloderRow(
                text: "Clarity & Specificity",
                text2: "${_calculateClarityScore(scoreData!)}/25",
                progress: _calculateClarityScore(scoreData!) / 25.0,
              ),
              SizedBox(height: 5.h),
              CustomSloderRow(
                text: "Strategic Thinking",
                text2: "${scoreData!.strategicThinking}/25",
                progress: scoreData!.strategicThinking / 25.0,
              ),
              SizedBox(height: 5.h),
              CustomSloderRow(
                text: "Feasibility",
                text2: "${scoreData!.feasibilityScore}/25",
                progress: scoreData!.feasibilityScore / 25.0,
              ),
              SizedBox(height: 5.h),
              CustomSloderRow(
                text: "Innovation",
                text2: "${scoreData!.innovationScore}/25",
                progress: scoreData!.innovationScore / 25.0,
              ),
              SizedBox(height: 5.h),
              CustomSloderRow(
                text: "Relevance",
                text2: "${scoreData!.relevanceScore}/25",
                progress: scoreData!.relevanceScore / 25.0,
              ),
            ] else ...[
              SizedBox(height: 50.h),
              Center(
                child: MainText(
                  text: "No scoring data available",
                  fontSize: 18.sp,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _calculateClarityScore(PlayerScoreModel scoreData) {
    // Calculate clarity score based on available data
    // This is an example - adjust based on your actual scoring logic
    return ((scoreData.finalScore * 0.25) +
        (scoreData.relevanceScore * 0.25) +
        (scoreData.strategicThinking * 0.25) +
        (scoreData.feasibilityScore * 0.25))
        .toDouble();
  }
}