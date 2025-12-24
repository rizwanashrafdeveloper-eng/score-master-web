import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../../api/api_models/player_score_model.dart';

class PlayerAnalysisWeb extends StatelessWidget {
  final PlayerScoreModel? scoreData;

  const PlayerAnalysisWeb({super.key, this.scoreData});

  @override
  Widget build(BuildContext context) {
    if (scoreData == null) {
      return Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: MainText(
          text: "No analysis data available",
          fontSize: 16.sp,
          color: AppColors.greyColor,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            text: "Performance Analysis",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blueColor,
          ),
          SizedBox(height: 16.h),
          _buildAnalysisRow("Final Score", "${scoreData!.finalScore}/100"),
          SizedBox(height: 12.h),
          _buildAnalysisRow("Strategic Thinking", "${scoreData!.strategicThinking}/25"),
          SizedBox(height: 12.h),
          _buildAnalysisRow("Feasibility", "${scoreData!.feasibilityScore}/25"),
          SizedBox(height: 12.h),
          _buildAnalysisRow("Innovation", "${scoreData!.innovationScore}/25"),
          SizedBox(height: 12.h),
          _buildAnalysisRow("Relevance", "${scoreData!.relevanceScore}/25"),
          SizedBox(height: 20.h),
          if (scoreData!.suggestion.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: "Suggestion:",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueColor,
                ),
                SizedBox(height: 8.h),
                MainText(
                  text: scoreData!.suggestion,
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ],
            ),
          SizedBox(height: 20.h),
          if (scoreData!.qualityAssessment.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: "Quality Assessment:",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueColor,
                ),
                SizedBox(height: 8.h),
                MainText(
                  text: scoreData!.qualityAssessment,
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MainText(
            text: label,
            fontSize: 16.sp,
            color: Colors.grey[700],
          ),
        ),
        MainText(
          text: value,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.forwardColor,
        ),
      ],
    );
  }
}