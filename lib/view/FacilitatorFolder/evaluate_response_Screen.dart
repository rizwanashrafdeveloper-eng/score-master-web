// Replace entire EvaluateResponseScreen with this web-optimized version

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/api/api_controllers/evaluate_response.dart';
import 'package:scorer_web/api/api_controllers/facilitator_evaluate_score_controller.dart';
import 'package:scorer_web/api/api_controllers/view_response_controller.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_response_container.dart';
import 'package:scorer_web/widgets/custom_sloder_row.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/team_alpha_container.dart';

import '../../api/api_models/view_response_model.dart';
import '../../shared_preference/shared_preference.dart';

class EvaluateResponseScreen extends StatefulWidget {
  const EvaluateResponseScreen({super.key});

  @override
  State<EvaluateResponseScreen> createState() => _EvaluateResponseScreenState();
}

class _EvaluateResponseScreenState extends State<EvaluateResponseScreen> {
  final ScoreController scoreController = Get.put(ScoreController());
  final FacilitatorEvaluateScoreController evaluateController = Get.put(FacilitatorEvaluateScoreController());

  Answer? responseData;
  bool isLoading = true;
  bool isManualMode = false;

  // Manual editing controllers
  final TextEditingController finalScoreController = TextEditingController();
  final TextEditingController relevanceScoreController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController charityScoreController = TextEditingController();
  final TextEditingController strategicThinkingController = TextEditingController();
  final TextEditingController feasibilityScoreController = TextEditingController();
  final TextEditingController innovationScoreController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('═══════════════════════════════════════════════');
    print('🎯 [EVALUATE SCREEN] Initializing...');
    print('═══════════════════════════════════════════════');
    _initializeData();
  }

  void _initializeData() {
    try {
      final arguments = Get.arguments;
      print('📥 [EVALUATE SCREEN] Received arguments type: ${arguments.runtimeType}');

      if (arguments is Answer) {
        responseData = arguments;
        print('✅ [EVALUATE SCREEN] Successfully parsed Answer object');
        print('   - Player: ${responseData?.player?.name} (ID: ${responseData?.player?.id})');
        print('   - Question: ${responseData?.question?.text} (ID: ${responseData?.question?.id})');
        print('   - Answer: ${responseData?.answerData?.sequence?.join(', ')}');
        print('   - Current Score: ${responseData?.score ?? "Not scored"}');
      } else {
        print('❌ [EVALUATE SCREEN] Invalid arguments type');
        Get.back();
        return;
      }

      // Fetch AI evaluation
      if (responseData != null) {
        print('🤖 [EVALUATE SCREEN] Requesting AI evaluation...');
        scoreController.fetchScore(
          answerData: responseData?.answerData?.sequence?.join(', '),
          questionText: responseData?.question?.text,
          playerName: responseData?.player?.name,
        ).then((_) {
          setState(() {
            isLoading = false;
          });
          _prefillManualFields();
          print('✅ [EVALUATE SCREEN] AI evaluation completed');
        });
      }
    } catch (e) {
      print('❌ [EVALUATE SCREEN] Error: $e');
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'Failed to load response data',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _prefillManualFields() {
    final score = scoreController.scoreResponse.value;
    if (score != null) {
      finalScoreController.text = score.finalScore.toString();
      relevanceScoreController.text = score.relevanceScore.toString();
      suggestionController.text = score.suggestion;
      qualityController.text = score.qualityAssessment;
      descriptionController.text = score.description;
      charityScoreController.text = score.scoreBreakdown.getNumericValue(score.scoreBreakdown.charity).toString();
      strategicThinkingController.text = score.scoreBreakdown.getNumericValue(score.scoreBreakdown.strategicThinking).toString();
      feasibilityScoreController.text = score.scoreBreakdown.getNumericValue(score.scoreBreakdown.feasibility).toString();
      innovationScoreController.text = score.scoreBreakdown.getNumericValue(score.scoreBreakdown.innovation).toString();
      pointsController.text = (responseData?.question?.point ?? 10).toString();
      print('✅ [EVALUATE SCREEN] Manual fields pre-filled');
    }
  }

  Future<void> _acceptAIScore() async {
    final score = scoreController.scoreResponse.value;
    if (score == null || responseData == null) {
      Get.snackbar('Error', 'No AI score available', backgroundColor: Colors.red);
      return;
    }

    print('═══════════════════════════════════════════════');
    print('✅ [SUBMIT SCORE] Accepting AI Score...');
    print('═══════════════════════════════════════════════');

    final sessionId = await SharedPrefServices.getSessionId() ?? 0;
    final phaseId = await SharedPrefServices.getCurrentPhaseId() ?? 0;

    print('📊 [SUBMIT SCORE] Context:');
    print('   - Session ID: $sessionId');
    print('   - Phase ID: $phaseId');
    print('   - Question ID: ${responseData!.question.id}');
    print('   - Player ID: ${responseData!.player.id}');
    print('   - Final Score: ${score.finalScore}');

    if (sessionId == 0 || phaseId == 0) {
      Get.snackbar('Error', 'Session/Phase information missing',
          backgroundColor: Colors.red);
      return;
    }

    final success = await evaluateController.submitScore(
      questionId: responseData!.question.id,
      playerId: responseData!.player.id,
      sessionId: sessionId,
      phaseId: phaseId,
      finalScore: score.finalScore,
      relevanceScore: score.relevanceScore,
      suggestion: score.suggestion,
      qualityAssessment: score.qualityAssessment,
      description: score.description,
      charityScore: score.scoreBreakdown.getNumericValue(score.scoreBreakdown.charity),
      strategicThinking: score.scoreBreakdown.getNumericValue(score.scoreBreakdown.strategicThinking),
      feasibilityScore: score.scoreBreakdown.getNumericValue(score.scoreBreakdown.feasibility),
      innovationScore: score.scoreBreakdown.getNumericValue(score.scoreBreakdown.innovation),
      points: responseData?.question?.point ?? 10,
    );

    if (success) {
      print('✅ [SUBMIT SCORE] Success! Navigating back...');
      Get.snackbar('Success', 'Score submitted successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
      await Future.delayed(Duration(milliseconds: 500));
      Get.back(result: true); // Return true to indicate success
    } else {
      print('❌ [SUBMIT SCORE] Failed: ${evaluateController.errorMessage.value}');
      Get.snackbar('Error', 'Failed to submit score: ${evaluateController.errorMessage.value}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            Positioned(top: 700.h, right: 0, child: TeamAlphaContainer()),
            Column(
              children: [
                CustomAppbar(ishow: true),
                SizedBox(height: 56.h),

                // Header
                GradientColor(
                  height: 200.h,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    width: 794.w,
                    height: 235.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 50.h,
                          left: -40.w,
                          child: ForwardButtonContainer(
                            onTap: () => Get.back(),
                            imageH: 20.h,
                            imageW: 23.5.w,
                            height1: 90.h,
                            height2: 65.h,
                            width1: 90.w,
                            width2: 65.w,
                            image: Appimages.arrowback,
                          ),
                        ),
                        Positioned(
                          top: -140,
                          right: 312.w,
                          left: 312.w,
                          child: CustomStackImage(),
                        ),
                        Center(
                          child: BoldText(
                            text: "Evaluate Response",
                            fontSize: 48.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: GradientColor(
                    ishow: false,
                    child: Container(
                      width: 794.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.r),
                          bottomRight: Radius.circular(40.r),
                        ),
                      ),
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                          child: Column(
                            children: [
                              // Response Container
                              if (responseData != null)
                                CustomResponseContainer(
                                  ishow1: false,
                                  containerHeight: 270.h,
                                  color1: responseData?.score != null
                                      ? AppColors.forwardColor
                                      : AppColors.yellowColor,
                                  text1: responseData?.score != null ? "View Score" : "Evaluate",
                                  image: responseData?.score != null ? Appimages.eye : Appimages.star,
                                  text: responseData?.score != null ? "Scored" : "Pending",
                                  ishow: true,
                                  textColor: responseData?.score != null
                                      ? Colors.white
                                      : AppColors.languageTextColor,
                                  playerName: responseData?.player?.name,
                                  questionText: responseData?.question?.text,
                                  answer: responseData?.answerData?.sequence?.join(', '),
                                  questionPoints: responseData?.question?.point,
                                  score: responseData?.score,
                                  isScored: responseData?.score != null,
                                ),

                              SizedBox(height: 40.h),

                              Center(
                                child: BoldText(
                                  text: "AI Evaluation",
                                  fontSize: 34.sp,
                                  selectionColor: AppColors.forwardColor,
                                ),
                              ),

                              SizedBox(height: 30.h),

                              // AI Analysis or Loading
                              if (isLoading)
                                Container(
                                  height: 300.h,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(color: AppColors.forwardColor),
                                        SizedBox(height: 20.h),
                                        Text("Analyzing response...",
                                            style: TextStyle(fontSize: 22.sp, color: AppColors.greyColor)),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Obx(() {
                                  final score = scoreController.scoreResponse.value;
                                  if (score == null) {
                                    return Container(
                                      padding: EdgeInsets.all(30.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.greyColor),
                                        borderRadius: BorderRadius.circular(26.r),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(Icons.assessment_outlined,
                                              size: 60.sp, color: AppColors.greyColor),
                                          SizedBox(height: 20.h),
                                          Text('No AI evaluation available',
                                              style: TextStyle(fontSize: 22.sp, color: AppColors.greyColor)),
                                        ],
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      // AI Analysis Container
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(30.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.greyColor, width: 1.7.w),
                                          borderRadius: BorderRadius.circular(26.r),
                                        ),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: BoldText(
                                                text: "AI Analysis & Suggestions",
                                                fontSize: 31.sp,
                                                selectionColor: AppColors.blueColor,
                                              ),
                                            ),
                                            SizedBox(height: 30.h),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                BoldText(text: "Final Score", selectionColor: AppColors.blueColor, fontSize: 26.sp),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.forwardColor.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(12.r),
                                                  ),
                                                  child: BoldText(
                                                    text: "${score.finalScore}/100",
                                                    selectionColor: AppColors.forwardColor,
                                                    fontSize: 28.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20.h),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                BoldText(text: "Relevance Score", selectionColor: AppColors.blueColor, fontSize: 26.sp),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.orangeColor.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(12.r),
                                                  ),
                                                  child: BoldText(
                                                    text: "${score.relevanceScore}%",
                                                    selectionColor: AppColors.orangeColor,
                                                    fontSize: 28.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15.h),
                                            LinearProgressIndicator(
                                              value: score.relevanceScore / 100,
                                              minHeight: 10.h,
                                              color: AppColors.forwardColor,
                                              backgroundColor: AppColors.greyColor,
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            SizedBox(height: 30.h),
                                            MainText(
                                              text: score.suggestion.isNotEmpty
                                                  ? score.suggestion
                                                  : "No specific suggestions.",
                                              fontSize: 22.sp,
                                              height: 1.4,
                                            ),
                                            SizedBox(height: 30.h),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                BoldText(text: "Quality", selectionColor: AppColors.blueColor, fontSize: 26.sp),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.forwardColor.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(12.r),
                                                  ),
                                                  child: BoldText(
                                                    text: score.qualityAssessment,
                                                    selectionColor: AppColors.forwardColor,
                                                    fontSize: 24.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15.h),
                                            MainText(
                                              text: score.description.isNotEmpty
                                                  ? score.description
                                                  : "No detailed description.",
                                              fontSize: 22.sp,
                                              height: 1.4,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 30.h),

                                      // Scoring Breakdown
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(30.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.greyColor, width: 1.7.w),
                                          borderRadius: BorderRadius.circular(26.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BoldText(
                                              text: "Scoring Breakdown",
                                              fontSize: 28.sp,
                                              selectionColor: AppColors.blueColor,
                                            ),
                                            SizedBox(height: 30.h),
                                            CustomSloderRow(
                                              text: "Clarity & Specificity",
                                              text2: score.scoreBreakdown.charity,
                                              progress: score.scoreBreakdown.getNumericValue(
                                                  score.scoreBreakdown.charity) /
                                                  score.scoreBreakdown.getMaxValue(
                                                      score.scoreBreakdown.charity),
                                            ),
                                            SizedBox(height: 20.h),
                                            CustomSloderRow(
                                              text: "Strategic Thinking",
                                              text2: score.scoreBreakdown.strategicThinking,
                                              progress: score.scoreBreakdown.getNumericValue(
                                                  score.scoreBreakdown.strategicThinking) /
                                                  score.scoreBreakdown.getMaxValue(
                                                      score.scoreBreakdown.strategicThinking),
                                            ),
                                            SizedBox(height: 20.h),
                                            CustomSloderRow(
                                              text: "Feasibility",
                                              text2: score.scoreBreakdown.feasibility,
                                              progress: score.scoreBreakdown.getNumericValue(
                                                  score.scoreBreakdown.feasibility) /
                                                  score.scoreBreakdown.getMaxValue(
                                                      score.scoreBreakdown.feasibility),
                                            ),
                                            SizedBox(height: 20.h),
                                            CustomSloderRow(
                                              text: "Innovation",
                                              text2: score.scoreBreakdown.innovation,
                                              progress: score.scoreBreakdown.getNumericValue(
                                                  score.scoreBreakdown.innovation) /
                                                  score.scoreBreakdown.getMaxValue(
                                                      score.scoreBreakdown.innovation),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 40.h),

                                      // Action Buttons
                                      Obx(() {
                                        return evaluateController.isLoading.value
                                            ? Center(child: CircularProgressIndicator(color: AppColors.forwardColor))
                                            : Column(
                                          children: [
                                            LoginButton(
                                              onTap: _acceptAIScore,
                                              text: "Accept AI Score",
                                              color: AppColors.forwardColor,
                                              image: Appimages.ai2,
                                              ishow: true,
                                              imageHeight: 48.h,
                                              imageWidth: 42.w,
                                            ),
                                            SizedBox(height: 20.h),
                                            LoginButton(
                                              onTap: () {
                                                Get.snackbar('Manual Override',
                                                    'Manual scoring interface - coming soon',
                                                    backgroundColor: AppColors.blueColor,
                                                    colorText: Colors.white);
                                              },
                                              text: "Manual Overwrite",
                                              ishow: true,
                                              icon: Icons.edit,
                                              imageHeight: 48.h,
                                              imageWidth: 42.w,
                                            ),
                                          ],
                                        );
                                      }),

                                      SizedBox(height: 40.h),
                                    ],
                                  );
                                }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    finalScoreController.dispose();
    relevanceScoreController.dispose();
    suggestionController.dispose();
    qualityController.dispose();
    descriptionController.dispose();
    charityScoreController.dispose();
    strategicThinkingController.dispose();
    feasibilityScoreController.dispose();
    innovationScoreController.dispose();
    pointsController.dispose();
    super.dispose();
  }
}



