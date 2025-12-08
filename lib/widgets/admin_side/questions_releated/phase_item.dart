import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/api/api_controllers/question_controller.dart';
import 'package:scorer_web/api/api_models/phase_model.dart';
import 'package:scorer_web/api/api_models/questions_model.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/admin_side/questions_releated/question_list.dart';
import 'package:scorer_web/widgets/admin_side/questions_releated/question_type_selection_dialogue.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';


class PhaseItem extends StatelessWidget {
  final PhaseModel phase;
  final int index;
  final double scaleFactor;
  final VoidCallback onAddQuestion;

  const PhaseItem({
    Key? key,
    required this.phase,
    required this.index,
    required this.scaleFactor,
    required this.onAddQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionController = Get.find<QuestionController>();

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phase Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blueColor, AppColors.blueColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldText(
                      text: phase.name,
                      fontSize: 24.sp,
                      selectionColor: AppColors.blackColor,
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 20.w,
                      runSpacing: 8.h,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer, size: 20.r, color: AppColors.teamColor),
                            SizedBox(width: 6.w),
                            MainText(
                              text: '${phase.timeDuration} min',
                              fontSize: 16.sp,
                              color: AppColors.teamColor,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.layers, size: 20.r, color: AppColors.teamColor),
                            SizedBox(width: 6.w),
                            MainText(
                              text: '${phase.stagesCount} stages',
                              fontSize: 16.sp,
                              color: AppColors.teamColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Challenge Types
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: phase.challengeTypes.map((type) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: _getChallengeColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: _getChallengeColor(type).withOpacity(0.3), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getChallengeIcon(type),
                      size: 20.r,
                      color: _getChallengeColor(type),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: _getChallengeColor(type),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24.h),

          // Questions Section
          Obx(() {
            final phaseQuestions = questionController.getQuestionsForPhase(phase.id ?? 0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppColors.blueColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                              Icons.quiz,
                              size: 24.r,
                              color: AppColors.blueColor
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoldText(
                              text: 'Questions',
                              fontSize: 20.sp,
                              selectionColor: AppColors.blueColor,
                            ),
                            SizedBox(height: 4.h),
                            MainText(
                              text: '${phaseQuestions.length} questions added',
                              fontSize: 14.sp,
                              color: AppColors.teamColor,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Add Question Button
                    Container(
                      width: 200.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.forwardColor, AppColors.forwardColor.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.forwardColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            print("🟢 PhaseItem onTap called - Showing question dialog");

                            // Show the selection dialog
                            await showDialog(
                              context: context,
                              builder: (context) => QuestionTypeSelectionDialog(
                                phase: phase,
                                scaleFactor: scaleFactor,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 24.r, color: Colors.white),
                              SizedBox(width: 8.w),
                              Text(
                                'Add Question',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (phaseQuestions.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  QuestionList(
                    questions: phaseQuestions,
                    scaleFactor: scaleFactor,
                    questionType: phase.challengeTypes,
                  ),
                ] else ...[
                  SizedBox(height: 24.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.borderColor.withOpacity(0.3), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: AppColors.forwardColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.quiz_outlined,
                            size: 40.r,
                            color: AppColors.greyColor,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        BoldText(
                          text: 'No questions added yet',
                          fontSize: 22.sp,
                          selectionColor: AppColors.languageTextColor,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: MainText(
                            text: 'Click "Add Question" to start building your assessment',
                            fontSize: 16.sp,
                            color: AppColors.teamColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Color _getChallengeColor(String type) {
    switch (type.toUpperCase()) {
      case 'MCQ':
        return AppColors.blueColor;
      case 'PUZZLE':
        return AppColors.orangeColor;
      case 'OPEN_ENDED':
      case 'OPEN ENDED':
        return AppColors.forwardColor;
      case 'SIMULATION':
        return AppColors.redColor;
      default:
        return AppColors.blueColor;
    }
  }

  IconData _getChallengeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'MCQ':
        return Icons.radio_button_checked;
      case 'PUZZLE':
        return Icons.extension;
      case 'OPEN_ENDED':
      case 'OPEN ENDED':
        return Icons.text_fields;
      case 'SIMULATION':
        return Icons.play_circle;
      default:
        return Icons.help;
    }
  }
}