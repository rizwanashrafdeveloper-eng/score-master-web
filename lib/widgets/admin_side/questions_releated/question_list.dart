// components/question_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/api/api_models/questions_model.dart';

class QuestionList extends StatelessWidget {
  final List<Question> questions;
  final double scaleFactor;
  final List<String> questionType;

  const QuestionList({
    Key? key,
    required this.questions,
    required this.scaleFactor,
    required this.questionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return Container();

    final Map<QuestionType, List<Question>> groupedQuestions = {};
    for (var q in questions) {
      groupedQuestions.putIfAbsent(q.type, () => []).add(q);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedQuestions.entries.map((entry) {
        return _buildQuestionGroup(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildQuestionGroup(QuestionType type, List<Question> questions) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.blueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.blueColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getTypeIcon(type.toString().split('.').last).icon,
                  color: AppColors.blueColor,
                  size: 24.r,
                ),
                SizedBox(width: 12.w),
                Text(
                  "${_getTypeDisplayName(type)} Questions (${questions.length})",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blueColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) => _buildQuestionCard(questions[index], index),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Icon
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: AppColors.blueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                _getTypeIcon(question.type.toString().split('.').last).icon,
                color: AppColors.blueColor,
                size: 28.r,
              ),
            ),
          ),
          SizedBox(width: 20.w),

          // Question Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Text
                Text(
                  "Q${question.order}: ${question.questionText}",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),

                // Tags and Metadata
                Wrap(
                  spacing: 12.w,
                  runSpacing: 8.h,
                  children: [
                    // Points Tag
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.forwardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16.r, color: AppColors.blueColor),
                          SizedBox(width: 6.w),
                          Text(
                            "${question.point} points",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scenario Tag
                    if (question.scenario.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.forwardColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.description, size: 16.r, color: AppColors.languageTextColor),
                            SizedBox(width: 6.w),
                            Text(
                              "Scenario",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.languageTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Question Type Tag
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: _getTypeColor(question.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _getTypeDisplayName(question.type),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _getTypeColor(question.type),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                // Scenario Preview (if available)
                if (question.scenario.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.borderColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 18.r, color: AppColors.forwardColor),
                            SizedBox(width: 8.w),
                            Text(
                              "Scenario Preview",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.forwardColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          question.scenario.length > 150
                              ? "${question.scenario.substring(0, 150)}..."
                              : question.scenario,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.languageTextColor,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 20.w),

          // Edit Button
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.forwardColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.forwardColor.withOpacity(0.3)),
            ),
            child: IconButton(
              onPressed: () {
                Get.snackbar(
                  'Edit Question',
                  'Editing question: ${question.questionText}',
                  backgroundColor: AppColors.blueColor,
                  colorText: Colors.white,
                  duration: Duration(seconds: 3),
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: Icon(
                Icons.edit_outlined,
                color: AppColors.blueColor,
                size: 24.r,
              ),
              splashRadius: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  Icon _getTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PUZZLE':
        return Icon(Icons.extension, color: AppColors.blueColor);
      case 'MCQ':
        return Icon(Icons.radio_button_checked, color: AppColors.blueColor);
      case 'OPEN_ENDED':
        return Icon(Icons.text_fields, color: AppColors.blueColor);
      case 'SIMULATION':
        return Icon(Icons.play_circle, color: AppColors.blueColor);
      default:
        return Icon(Icons.help, color: AppColors.blueColor);
    }
  }

  Color _getTypeColor(QuestionType type) {
    switch (type) {
      case QuestionType.PUZZLE:
        return AppColors.orangeColor;
      case QuestionType.MCQ:
        return AppColors.blueColor;
      case QuestionType.OPEN_ENDED:
        return AppColors.forwardColor;
      case QuestionType.SIMULATION:
        return AppColors.redColor;
      default:
        return AppColors.blueColor;
    }
  }

  String _getTypeDisplayName(QuestionType type) {
    switch (type) {
      case QuestionType.PUZZLE:
        return 'Puzzle';
      case QuestionType.MCQ:
        return 'MCQ';
      case QuestionType.OPEN_ENDED:
        return 'Open Ended';
      case QuestionType.SIMULATION:
        return 'Simulation';
      default:
        return 'Question';
    }
  }
}