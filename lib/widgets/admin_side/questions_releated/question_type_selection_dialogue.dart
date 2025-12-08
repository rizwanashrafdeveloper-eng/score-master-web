import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import '../../../api/api_controllers/question_controller.dart';
import '../../../api/api_models/questions_model.dart';
import 'add_question_dialogue.dart';
import 'ai_question_dialogue.dart';

class QuestionTypeSelectionDialog extends StatelessWidget {
  final dynamic phase;
  final double scaleFactor;

  const QuestionTypeSelectionDialog({
    Key? key,
    required this.phase,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;
    final questionTypes = List<String>.from(phase.challengeTypes);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? screenWidth * 0.25 : 40.w,
        vertical: screenHeight * 0.1,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLargeScreen ? 600.w : 500.w,
          maxHeight: screenHeight * 0.8,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, isLargeScreen),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isLargeScreen ? 24.w : 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainText(
                        text: 'Select how you want to add your question:',
                        fontSize: isLargeScreen ? 14.sp : 12.sp,
                        color: AppColors.languageTextColor,
                      ),
                      SizedBox(height: isLargeScreen ? 16.h : 12.h),

                      // AI Generation Option (Featured)
                      _buildAIOption(context, isLargeScreen),

                      SizedBox(height: isLargeScreen ? 16.h : 12.h),

                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.greyColor)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: MainText(
                              text: 'OR',
                              fontSize: isLargeScreen ? 12.sp : 10.sp,
                              color: AppColors.teamColor,
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.greyColor)),
                        ],
                      ),

                      SizedBox(height: isLargeScreen ? 16.h : 12.h),

                      BoldText(
                        text: 'Add Manually',
                        fontSize: isLargeScreen ? 14.sp : 12.sp,
                        selectionColor: AppColors.blackColor,
                      ),
                      SizedBox(height: isLargeScreen ? 12.h : 10.h),

                      // Manual Question Type Options
                      ...questionTypes.asMap().entries.map((entry) {
                        final type = entry.value;
                        return _buildQuestionTypeCard(
                          type,
                          context,
                          isLargeScreen,
                          isLast: entry.key == questionTypes.length - 1,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLargeScreen) {
    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 20.w : 16.w),
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isLargeScreen ? 10.w : 8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: isLargeScreen ? 24.r : 20.r,
            ),
          ),
          SizedBox(width: isLargeScreen ? 12.w : 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Question',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 18.sp : 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Phase: ${phase.name}',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 12.sp : 10.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: isLargeScreen ? 24.r : 20.r,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIOption(BuildContext context, bool isLargeScreen) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Get.dialog(
          AIQuestionDialog(
            phase: phase,
            scaleFactor: scaleFactor,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isLargeScreen ? 20.w : 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.blueColor,
              AppColors.blueColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blueColor.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: isLargeScreen ? 50.w : 40.w,
              height: isLargeScreen ? 50.h : 40.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: isLargeScreen ? 28.r : 24.r,
              ),
            ),
            SizedBox(width: isLargeScreen ? 16.w : 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AI Generate',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 16.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.forwardColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'RECOMMENDED',
                          style: TextStyle(
                            fontSize: isLargeScreen ? 8.sp : 7.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Let AI create contextual questions for you',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 12.sp : 10.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: isLargeScreen ? 18.r : 16.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTypeCard(
      String type,
      BuildContext context,
      bool isLargeScreen, {
        bool isLast = false,
      }) {
    final color = _getTypeColor(type);
    final icon = _getTypeIcon(type);
    final description = _getTypeDescription(type);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);

          try {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => AddQuestionDialog(
                phase: phase,
                questionType: _stringToQuestionType(type),
                scaleFactor: scaleFactor,
              ),
            );

            if (result != null) {
              final questionController = Get.find<QuestionController>();
              final nextOrder = questionController.getQuestionsForPhase(phase.id ?? 0).length + 1;

              final phaseId = result['phaseId'] ?? phase.id ?? 0;
              final questionText = result['question']?.toString() ?? '';
              final points = int.tryParse(result['points']?.toString() ?? '10') ?? 10;
              final scenario = result['scenario']?.toString() ?? '';
              final correctOption = result['correctOption'] as int? ?? 0;
              final options = (result['options'] as List<dynamic>?)?.cast<String>() ?? [];

              final question = Question(
                phaseId: phaseId,
                questionText: questionText,
                type: _stringToQuestionType(type),
                point: points,
                scenario: scenario,
                order: nextOrder,
                correctOption: correctOption,
                mcqOptions: options.isNotEmpty ? options : null,
              );

              await questionController.addQuestion(question);

              Get.snackbar(
                'Success',
                'Question added successfully!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            }
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to add question: ${e.toString()}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isLargeScreen ? 16.w : 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isLargeScreen ? 45.w : 40.w,
                height: isLargeScreen ? 45.h : 40.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isLargeScreen ? 24.r : 20.r,
                ),
              ),
              SizedBox(width: isLargeScreen ? 12.w : 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 15.sp : 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 11.sp : 10.sp,
                        color: AppColors.languageTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: isLargeScreen ? 16.r : 14.r,
                color: AppColors.greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PUZZLE':
        return Icons.extension;
      case 'MCQ':
        return Icons.radio_button_checked;
      case 'OPEN_ENDED':
        return Icons.text_fields;
      case 'SIMULATION':
        return Icons.play_circle;
      default:
        return Icons.help;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'MCQ':
        return AppColors.blueColor;
      case 'PUZZLE':
        return AppColors.orangeColor;
      case 'OPEN_ENDED':
        return AppColors.forwardColor;
      case 'SIMULATION':
        return AppColors.redColor;
      default:
        return AppColors.blueColor;
    }
  }

  String _getTypeDescription(String type) {
    switch (type.toUpperCase()) {
      case 'MCQ':
        return 'Multiple choice with single correct answer';
      case 'PUZZLE':
        return 'Sequence-based challenge questions';
      case 'OPEN_ENDED':
        return 'Free text response questions';
      case 'SIMULATION':
        return 'Scenario-based practical questions';
      default:
        return 'Custom question type';
    }
  }

  QuestionType _stringToQuestionType(String type) {
    switch (type.toUpperCase()) {
      case 'PUZZLE':
        return QuestionType.PUZZLE;
      case 'MCQ':
        return QuestionType.MCQ;
      case 'OPEN_ENDED':
        return QuestionType.OPEN_ENDED;
      case 'SIMULATION':
        return QuestionType.SIMULATION;
      default:
        return QuestionType.OPEN_ENDED;
    }
  }
}

void showQuestionTypeSelectionDialog(
    BuildContext context,
    dynamic phase, {
      required double scaleFactor,
    }) {
  showDialog(
    context: context,
    builder: (_) => QuestionTypeSelectionDialog(
      phase: phase,
      scaleFactor: scaleFactor,
    ),
  );
}