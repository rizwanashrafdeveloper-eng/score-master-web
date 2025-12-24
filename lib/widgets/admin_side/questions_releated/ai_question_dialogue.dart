import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/api/api_models/ai_questions_model.dart';
import 'package:scorer_web/api/api_models/questions_model.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/api/api_controllers/question_controller.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/login_button.dart';

class AIQuestionDialog extends StatelessWidget {
  final dynamic phase;
  final double scaleFactor;
  final selectedType = ''.obs;

  AIQuestionDialog({
    Key? key,
    required this.phase,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topicController = TextEditingController();
    final questionController = Get.find<QuestionController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800.w,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(32.w),
                  child: questionController.isGeneratingAI.value
                      ? _buildLoadingState()
                      : questionController.aiGeneratedQuestion.value != null
                      ? _buildGeneratedQuestionPreview(
                    questionController.aiGeneratedQuestion.value!,
                    questionController,
                    phase.id,
                    context,
                  )
                      : _buildInputForm(
                    topicController,
                    phase.challengeTypes,
                    questionController,
                    context,
                    selectedType,
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoldText(
                  text: 'AI Question Generator',
                  fontSize: 24.sp,
                  selectionColor: Colors.white,
                ),
                SizedBox(height: 6.h),
                MainText(
                  text: 'Phase: ${phase.name}',
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Get.find<QuestionController>().clearAIGeneratedQuestion();
              Get.back();
            },
            icon: Icon(Icons.close, color: Colors.white, size: 28.r),
            splashRadius: 20.r,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 40.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blueColor.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueColor),
                strokeWidth: 5,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          BoldText(
            text: 'AI is generating your question...',
            fontSize: 22.sp,
            selectionColor: AppColors.blackColor,
          ),
          SizedBox(height: 16.h),
          MainText(
            text: 'This may take a few seconds',
            fontSize: 18.sp,
            color: AppColors.languageTextColor,
          ),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.blueColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tips_and_updates,
                    color: AppColors.forwardColor,
                    size: 24.r),
                SizedBox(width: 12.w),
                Flexible(
                  child: MainText(
                    text: 'AI is crafting a contextual question based on your topic and game phase',
                    fontSize: 16.sp,
                    color: AppColors.teamColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedQuestionPreview(
      AIQuestionResponse question,
      QuestionController controller,
      int phaseId,
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.preview, color: AppColors.blueColor, size: 24.r),
            SizedBox(width: 12.w),
            BoldText(
              text: 'Generated Question Preview',
              fontSize: 22.sp,
              selectionColor: AppColors.blueColor,
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Question Preview Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.greyColor, width: 1.5),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            color: AppColors.blueColor,
                            size: 16.r),
                        SizedBox(width: 6.w),
                        MainText(
                          text: 'AI GENERATED',
                          fontSize: 14.sp,
                          color: AppColors.blueColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  MainText(
                    text: '${question.point} points',
                    fontSize: 16.sp,
                    color: AppColors.teamColor,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              if (question.scenario.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.forwardColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description,
                              color: AppColors.forwardColor,
                              size: 18.r),
                          SizedBox(width: 8.w),
                          BoldText(
                            text: 'Scenario',
                            fontSize: 16.sp,
                            selectionColor: AppColors.forwardColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      MainText(
                        text: question.scenario,
                        fontSize: 16.sp,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              BoldText(
                text: question.questionText,
                selectionColor: AppColors.redColor,
                fontSize: 22.sp,
              ),
            ],
          ),
        ),

        SizedBox(height: 32.h),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 220.w,
              child: LoginButton(
                text: 'Generate Another',
                fontSize: 18.sp,
                color: AppColors.forwardColor,
                onTap: () => controller.clearAIGeneratedQuestion(),
              ),
            ),
            SizedBox(width: 20.w),
            SizedBox(
              width: 220.w,
              child: Obx(() => LoginButton(
                text: controller.isAdding.value ? 'Adding...' : 'Add to Phase',
                fontSize: 18.sp,
                color: AppColors.blueColor,
                onTap: controller.isAdding.value
                    ? null
                    : () async {
                  final nextOrder = controller.getNextOrderForPhase(phaseId);
                  await controller.addAIGeneratedQuestion(
                    question,
                    phaseId,
                    nextOrder,
                  );
                  Get.back();
                },
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputForm(
      TextEditingController topicController,
      List<String> challengeTypes,
      QuestionController controller,
      BuildContext context,
      RxString selectedType,
      ) {

    if (selectedType.value.isEmpty && challengeTypes.isNotEmpty) {
      selectedType.value = challengeTypes.first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Information Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.blueColor.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  color: AppColors.blueColor,
                  size: 24.r),
              SizedBox(width: 16.w),
              Expanded(
                child: MainText(
                  text: 'AI will generate a contextual question based on your topic and game phase characteristics',
                  fontSize: 16.sp,
                  color: AppColors.languageTextColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),

        // Topic Field
        BoldText(
          text: 'Topic',
          fontSize: 20.sp,
          selectionColor: AppColors.blackColor,
        ),
        SizedBox(height: 12.h),
        LoginTextfield(
          text: 'e.g., Leadership in crisis situations, Team collaboration strategies',
          fontsize: 18.sp,
         // height: 120.h,
          controller: topicController,
          maxLines: 3,
        ),
        SizedBox(height: 24.h),

        // Question Type Dropdown
        BoldText(
          text: 'Question Type',
          fontSize: 20.sp,
          selectionColor: AppColors.blackColor,
        ),
        SizedBox(height: 12.h),
        Container(
          width: 400.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(() => DropdownButton<String>(
              value: selectedType.value.isEmpty ? null : selectedType.value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.blueColor, size: 28.r),
              items: challengeTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Icon(
                          _getTypeIcon(type),
                          size: 22.r,
                          color: _getTypeColor(type),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedType.value = newValue;
                }
              },
            )),
          ),
        ),
        SizedBox(height: 40.h),

        // Generate Button
        Center(
          child: SizedBox(
            width: 300.w,
            child: LoginButton(
              text: 'Generate Question',
              fontSize: 20.sp,
              icon: Icons.auto_awesome,
              color: AppColors.blueColor,
              onTap: () {
                if (topicController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter a topic',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                  return;
                }
                if (selectedType.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please select a question type',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                  return;
                }
                controller.generateAIQuestion(
                  topic: topicController.text,
                  type: selectedType.value,
                  gameName: "Leadership Game",
                  phaseName: phase.name,
                );
              },
            ),
          ),
        ),
      ],
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
}



extension QuestionTypeExtension on QuestionType {
  String get name {
    switch (this) {
      case QuestionType.MCQ:
        return 'MCQ';
      case QuestionType.OPEN_ENDED:
        return 'Open Ended';
      case QuestionType.PUZZLE:
        return 'Puzzle';
      case QuestionType.SIMULATION:
        return 'Simulation';
    }
  }
}