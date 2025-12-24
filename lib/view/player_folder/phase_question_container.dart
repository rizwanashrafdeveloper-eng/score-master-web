import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/controller/game_select_controller.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/components/player_folder/scenerio_container.dart';
import 'package:scorer_web/widgets/filter_useable_container.dart';

import '../../api/api_models/question_for_session_model.dart';


class PhaseQuestionsContainer extends StatelessWidget {
  final Question question;
  final GameSelectController controller;

  const PhaseQuestionsContainer({
    super.key,
    required this.question,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _buildQuestionByType(question);
  }

  Widget _buildQuestionByType(Question question) {
    switch (question.type.toUpperCase()) {
      case 'MCQ':
        return _buildMcqType(question);
      case 'PUZZLE':
        return _buildPuzzleType(question);
      case 'OPENENDED':
      case 'OPEN_ENDED':
        return _buildOpenEndedType(question);
      case 'SIMULATION':
        return _buildSimulationType(question);
      default:
        return _buildDefaultType(question);
    }
  }

  Widget _buildDefaultType(Question question) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question, questionType: question.type.toUpperCase()),
          SizedBox(height: 12.h),
          BoldText(
            text: question.questionText.isNotEmpty
                ? question.questionText
                : "No question text available",
            selectionColor: AppColors.redColor,
            fontSize: 18.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildMcqType(Question question) {
    final options = question.mcqOptions ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question, questionType: 'MCQ'),
          SizedBox(height: 12.h),
          BoldText(
            text: question.questionText.isNotEmpty
                ? question.questionText
                : "Multiple Choice Question",
            selectionColor: AppColors.redColor,
            fontSize: 18.sp,
          ),
          SizedBox(height: 15.h),
          if (options.isEmpty)
            MainText(
              text: "No options available",
              fontSize: 16.sp,
              color: AppColors.teamColor,
            )
          else
            ...List.generate(options.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Obx(() {
                  final selectedOption = controller.getSelectedMcqOption(question.id);
                  return FilterUseableContainer(
                    isSelected: selectedOption == index,
                    fontSze: 20.sp,
                    text: options[index],
                    onTap: () {
                      controller.selectMcqOption(question.id, index);
                    },
                  );
                }),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildPuzzleType(Question question) {
    final options = question.sequenceOptions ?? question.mcqOptions ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question, questionType: 'PUZZLE'),
          SizedBox(height: 12.h),
          if (question.scenario.isNotEmpty)
            ScenerioContainer(
              text: question.scenario,
            ),
          SizedBox(height: 12.h),
          BoldText(
            text: question.questionText.isNotEmpty
                ? question.questionText
                : "Puzzle Question",
            selectionColor: AppColors.redColor,
            fontSize: 18.sp,
          ),
          SizedBox(height: 5.h),
          MainText(
            text: "Select options in the correct order",
            fontSize: 16.sp,
            color: AppColors.teamColor,
          ),
          SizedBox(height: 15.h),
          if (options.isEmpty)
            MainText(
              text: "No options available",
              fontSize: 16.sp,
              color: AppColors.teamColor,
            )
          else
            ...List.generate(options.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Obx(() {
                  final selectedSequence = controller.getPuzzleSequence(question.id);
                  final sequenceIndex = selectedSequence.indexOf(index);
                  final isSelected = sequenceIndex != -1;

                  return Row(
                    children: [
                      if (isSelected)
                        Container(
                          width: 30.w,
                          height: 30.h,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: AppColors.forwardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: BoldText(
                              text: "${sequenceIndex + 1}",
                              fontSize: 16.sp,
                              selectionColor: Colors.white,
                            ),
                          ),
                        ),
                      Expanded(
                        child: FilterUseableContainer(
                          isSelected: isSelected,
                          fontSze: 20.sp,
                          text: options[index],
                          onTap: () {
                            controller.toggleSequenceSelection(question.id, index);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              );
            }),
          Obx(() {
            final selectedSequence = controller.getPuzzleSequence(question.id);
            if (selectedSequence.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldText(
                      text: "Your Sequence",
                      fontSize: 18.sp,
                      selectionColor: AppColors.blueColor,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.forwardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: MainText(
                        text: selectedSequence
                            .map((i) => "${selectedSequence.indexOf(i) + 1}. ${options[i]}")
                            .join(" → "),
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () => controller.clearPuzzleSequence(question.id),
                      child: MainText(
                        text: "Clear Sequence",
                        fontSize: 16.sp,
                        color: AppColors.redColor,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildOpenEndedType(Question question) {
    final textController = TextEditingController(
      text: controller.getTextResponse(question.id) ?? '',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question, questionType: 'OPEN-ENDED'),
          SizedBox(height: 12.h),
          BoldText(
            text: question.questionText.isNotEmpty
                ? question.questionText
                : "Open Ended Question",
            selectionColor: AppColors.redColor,
            fontSize: 18.sp,
          ),
          SizedBox(height: 15.h),
          _buildInputBox(question, textController),
        ],
      ),
    );
  }

  Widget _buildSimulationType(Question question) {
    final textController = TextEditingController(
      text: controller.getTextResponse(question.id) ?? '',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question, questionType: 'SIMULATION'),
          SizedBox(height: 12.h),
          if (question.scenario.isNotEmpty)
            ScenerioContainer(
              text: question.scenario,
            ),
          SizedBox(height: 12.h),
          BoldText(
            text: question.questionText.isNotEmpty
                ? question.questionText
                : "Simulation Question",
            selectionColor: AppColors.redColor,
            fontSize: 18.sp,
          ),
          SizedBox(height: 15.h),
          _buildInputBox(question, textController),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(Question question, {required String questionType}) {
    Color color;
    String typeText = questionType;

    switch (questionType) {
      case 'MCQ':
        color = AppColors.blueColor;
        break;
      case 'PUZZLE':
        color = AppColors.orangeColor;
        break;
      case 'OPEN-ENDED':
        color = AppColors.forwardColor;
        break;
      case 'SIMULATION':
        color = AppColors.redColor;
        break;
      default:
        color = AppColors.greyColor;
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: MainText(
            text: typeText,
            fontSize: 14.sp,
            color: color,
          ),
        ),
        SizedBox(width: 8.w),
        MainText(
          text: "${question.point} points",
          fontSize: 14.sp,
          color: AppColors.teamColor,
        ),
      ],
    );
  }

  Widget _buildInputBox(Question question, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextFormField(
            controller: textController,
            cursorColor: AppColors.blackColor,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: "Share your thoughts...",
              hintStyle: TextStyle(color: AppColors.teamColor, fontSize: 16.sp),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            onChanged: (value) {
              controller.saveTextResponse(question.id, value);
            },
          ),
        ),
      ],
    );
  }
}