import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scorer_web/components/player_folder/complete_session_row.dart';
import 'package:scorer_web/components/player_folder/phase_strategy_column.dart';
import 'package:scorer_web/components/admin_folder.dart/admin_team_progress_contaner.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/controller/game_select_controller.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/view/player_folder/phase_question_container.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/custom_stratgy_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';
import 'package:scorer_web/api/api_controllers/question_for_sessions_controller.dart';
import 'package:scorer_web/api/api_controllers/team_view_controller.dart';
import 'package:scorer_web/api/api_controllers/player_q_submit_controller.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';
import '../../widgets/team_alpha_container.dart';

class PlayerGameStartScreen extends StatefulWidget {
  const PlayerGameStartScreen({super.key});

  @override
  State<PlayerGameStartScreen> createState() => _PlayerGameStartScreenState();
}

class _PlayerGameStartScreenState extends State<PlayerGameStartScreen> {
  late final GameSelectController controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() async {
    try {
      // Initialize controllers in correct order
      final questionController = Get.put(QuestionForSessionsController(), permanent: true);
      final teamController = Get.put(TeamViewController(), permanent: true);
      Get.put(PlayerQSubmitController(), permanent: true);

      // Create GameSelectController with unique tag
      controller = Get.put(
        GameSelectController(questionController: questionController),
        tag: 'game_select_main',
        permanent: true,
      );

      // Load data with real IDs from SharedPreferences
      await _loadInitialData();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print("❌ Error initializing controllers: $e");
      Get.snackbar(
        'Initialization Error',
        'Failed to initialize: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadInitialData() async {
    final teamController = Get.find<TeamViewController>();
    final questionController = Get.find<QuestionForSessionsController>();

    try {
      // Load teams first
      if (teamController.teamView.value == null) {
        await teamController.loadTeams();
      }

      // Get real IDs from SharedPreferences or TeamView
      int sessionId = await SharedPrefServices.getSessionId() ?? 25;
      int gameFormatId = await SharedPrefServices.getGameId() ?? 72;

      // If not in SharedPreferences, try to get from TeamView
      if (teamController.teamView.value != null) {
        sessionId = teamController.teamView.value!.sessionId;
        gameFormatId = teamController.teamView.value!.gameFormat.id;

        // Save them for future use
        await SharedPrefServices.saveSessionId(sessionId);
        await SharedPrefServices.saveGameId(gameFormatId);
      }

      print("🔍 Loading questions with sessionId: $sessionId, gameFormatId: $gameFormatId");

      // Load questions with real IDs
      if (questionController.questionData.value == null) {
        await questionController.loadQuestions(
          sessionId: sessionId,
          gameFormatId: gameFormatId,
        );
      }
    } catch (e) {
      print("❌ Error loading initial data: $e");
      Get.snackbar(
        'Load Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.blueColor),
              SizedBox(height: 20.h),
              Text(
                "Loading game session...",
                style: TextStyle(fontSize: 16.sp, color: AppColors.teamColor),
              ),
            ],
          ),
        ),
      );
    }

    final teamController = Get.find<TeamViewController>();
    final questionController = Get.find<QuestionForSessionsController>();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 700.h,
                right: 0,
                child: TeamAlphaContainer(),
              ),
              Column(
                children: [
                  CustomAppbar(ishow4: true, ishow: true),
                  SizedBox(height: 56.h),

                  // Header Section
                  GradientColor(
                    height: 180.h,
                    child: Container(
                      width: 794.w,
                      height: 235.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -140,
                            right: 312.w,
                            left: 312.w,
                            child: CustomStackImage(
                              image: Appimages.player2,
                              text: "Player",
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Center(
                                child: BoldText(
                                  text: teamController.teamView.value?.teams.isNotEmpty == true
                                      ? teamController.teamView.value!.teams.first.nickname
                                      : "Team Alpha",
                                  fontSize: 48.sp,
                                  selectionColor: AppColors.blueColor,
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: GradientColor(
                      ishow: false,
                      child: Container(
                        width: 794.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.r),
                            bottomRight: Radius.circular(40.r),
                          ),
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 36.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Game Image
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        height: 370.h,
                                        width: 428.w,
                                        child: Image.asset(
                                          Appimages.group,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10.h,
                                        right: 15.w,
                                        child: Obx(() => CreateContainer(
                                          fontsize2: 12.sp,
                                          text: "${questionController.questionData.value?.phases.length ?? 0} Phases",
                                          top: -25.h,
                                          right: 2.w,
                                          width: 172.w,
                                          borderW: 2.w,
                                          arrowW: 30.w,
                                          arrowh: 35.h,
                                          height: 63.h,
                                        )),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20.h),

                                  // Game Title
                                  Obx(() => BoldText(
                                    text: teamController.teamView.value?.gameFormat.name ?? "team_building_workshop".tr,
                                    fontSize: 30.sp,
                                    selectionColor: AppColors.blueColor,
                                  )),

                                  // Facilitator Info
                                  Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Appimages.person,
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      MainText(
                                        text: "Facilitator: ${teamController.teamView.value?.gameFormat.facilitators.isNotEmpty == true ? teamController.teamView.value!.gameFormat.facilitators[0].name : 'Unknown'}",
                                        fontSize: 20.sp,
                                      ),
                                    ],
                                  )),

                                  SizedBox(height: 30.h),

                                  // Error Message if questions failed to load
                                  Obx(() {
                                    if (questionController.errorMessage.isNotEmpty) {
                                      return Container(
                                        padding: EdgeInsets.all(16.w),
                                        margin: EdgeInsets.only(bottom: 20.h),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(color: Colors.red),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.error_outline, color: Colors.red, size: 40.w),
                                            SizedBox(height: 10.h),
                                            Text(
                                              "Failed to load questions",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              questionController.errorMessage.value,
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 14.sp,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 10.h),
                                            ElevatedButton(
                                              onPressed: () => _loadInitialData(),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: Text("Retry"),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  }),

                                  // Current Phase Container
                                  _buildCurrentPhaseContainer(questionController),

                                  SizedBox(height: 30.h),

                                  // Team Progress
                                  AdminTeamProgress(),

                                  SizedBox(height: 30.h),

                                  // All Phases
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      children: [
                                        PhaseStrategyColumn(controller: controller),
                                        SizedBox(height: 20.h),

                                        // Next Phase Button
                                        Obx(() {
                                          final isPhaseComplete = controller.isCurrentPhaseComplete();
                                          final isLastPhase = controller.isLastPhase();

                                          if (isPhaseComplete && !isLastPhase) {
                                            return LoginButton(
                                              onTap: () {
                                                controller.moveToNextPhase();
                                              },
                                              ishow: true,
                                              fontSize: 18.sp,
                                              image: Appimages.forward,
                                              text: "next_phase".tr,
                                              color: AppColors.forwardColor,
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),

                                        SizedBox(height: 20.h),

                                        // Review AI Score
                                        LoginButton(
                                          onTap: () => Get.toNamed(RouteName.submitResponseScreen),
                                          fontSize: 20.sp,
                                          text: "review_ai_score".tr,
                                          color: AppColors.forwardColor,
                                          ishow: true,
                                          image: Appimages.ai2,
                                          imageHeight: 32.h,
                                          imageWidth: 32.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 70.h),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildCurrentPhaseContainer(QuestionForSessionsController questionController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Obx(() {
        if (questionController.isLoading.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(40.h),
              child: CircularProgressIndicator(color: AppColors.blueColor),
            ),
          );
        }

        final phase = controller.getCurrentPhase();
        final currentQuestion = controller.getCurrentQuestion();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.greyColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phase Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoldText(
                          text: "current_phase".tr,
                          fontSize: 30.sp,
                          selectionColor: AppColors.blueColor,
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            UseableContainer(
                              text: phase != null ? "Phase ${controller.currentPhase.value + 1}" : "Phase 1",
                              color: AppColors.orangeColor,
                            ),
                            SizedBox(width: 10.w),
                            MainText(
                              text: phase?.name ?? "strategy_building".tr,
                              fontSize: 20.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 50.0.r,
                      lineWidth: 4.0.w,
                      percent: controller.timeProgress.value,
                      animation: true,
                      animationDuration: 500,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.transparent,
                      progressColor: AppColors.forwardColor,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BoldText(
                            text: controller.remainingTime.value,
                            fontSize: 20.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                          MainText(
                            text: "remaining".tr,
                            fontSize: 12.sp,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15.h),

                // Phase Description
                if (phase?.description != null && phase!.description.isNotEmpty)
                  Column(
                    children: [
                      MainText(
                        text: phase.description,
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),

                // Question Progress
                if (currentQuestion != null)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainText(
                            text: "Question ${controller.currentQuestionIndex.value + 1} of ${controller.getCurrentPhaseQuestions().length}",
                            fontSize: 16.sp,
                            color: AppColors.blueColor,
                          ),
                          MainText(
                            text: "${currentQuestion.point} points",
                            fontSize: 16.sp,
                            color: AppColors.teamColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),

                SizedBox(height: 20.h),

                // Session Progress Row
                CompleteSessionRow(controller: controller),
                SizedBox(height: 16.h),

                // Current Phase Status
                Obx(() {
                  final isPhaseComplete = controller.isCurrentPhaseComplete();
                  final progress = isPhaseComplete
                      ? 1.0
                      : (controller.submittedQuestions.length / (phase?.questions.length ?? 1)).clamp(0.0, 1.0);

                  return CustomStratgyContainer(
                    value: progress,
                    borderColor: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
                    iconContainer: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
                    icon: isPhaseComplete ? Icons.check : Icons.play_arrow_sharp,
                    text1: phase?.name ?? "Stage 2",
                    text2: isPhaseComplete
                        ? "Completed • ${phase?.timeDuration != null ? (phase!.timeDuration / 60).ceil() : 0} min"
                        : "Time Left ${controller.remainingTime.value}",
                    text3: isPhaseComplete ? "completed".tr : "active".tr,
                    smallContainer: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
                    largeConatiner: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
                  );
                }),

                SizedBox(height: 20.h),

                // Current Question Display
                Obx(() {
                  if (questionController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.blueColor),
                    );
                  }

                  final currentQuestion = controller.getCurrentQuestion();
                  if (currentQuestion == null) {
                    return Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyColor),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: MainText(
                          text: controller.isCurrentPhaseComplete()
                              ? "Phase Completed! 🎉"
                              : "No questions available",
                          fontSize: 20.sp,
                          color: AppColors.teamColor,
                        ),
                      ),
                    );
                  }

                  return PhaseQuestionsContainer(
                    question: currentQuestion,
                    controller: controller,
                  );
                }),

                SizedBox(height: 20.h),

                // Submit Button
                Obx(() {
                  final currentQuestion = controller.getCurrentQuestion();
                  if (currentQuestion == null) return const SizedBox.shrink();

                  final canSubmit = controller.canSubmitQuestion();
                  return LoginButton(
                    onTap: canSubmit ? () async {
                      await controller.submitCurrentQuestion();
                    } : null,
                    ishow: true,
                    fontSize: 18.sp,
                    image: Appimages.submit,
                    text: "submit_question".tr,
                    color: canSubmit ? AppColors.forwardColor : AppColors.greyColor,
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:scorer_web/components/player_folder/complete_session_row.dart';
// import 'package:scorer_web/components/player_folder/phase_strategy_column.dart';
// import 'package:scorer_web/components/admin_folder.dart/admin_team_progress_contaner.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/controller/game_select_controller.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/view/player_folder/phase_question_container.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/custom_stratgy_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// import 'package:scorer_web/api/api_controllers/question_for_sessions_controller.dart';
// import 'package:scorer_web/api/api_controllers/team_view_controller.dart';
// import 'package:scorer_web/api/api_controllers/player_q_submit_controller.dart';
// import '../../widgets/team_alpha_container.dart';
//
// class PlayerGameStartScreen extends StatefulWidget {
//   const PlayerGameStartScreen({super.key});
//
//   @override
//   State<PlayerGameStartScreen> createState() => _PlayerGameStartScreenState();
// }
//
// class _PlayerGameStartScreenState extends State<PlayerGameStartScreen> {
//   late final GameSelectController controller;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }
//
//   void _initializeControllers() async {
//     try {
//       // Initialize controllers in correct order
//       final questionController = Get.put(QuestionForSessionsController(), permanent: true);
//       final teamController = Get.put(TeamViewController(), permanent: true);
//       Get.put(PlayerQSubmitController(), permanent: true);
//
//       // Create GameSelectController with unique tag
//       controller = Get.put(
//         GameSelectController(questionController: questionController),
//         tag: 'game_select_main',
//         permanent: true,
//       );
//
//       // Load data
//       await _loadInitialData();
//
//       setState(() {
//         _isInitialized = true;
//       });
//     } catch (e) {
//       print("❌ Error initializing controllers: $e");
//       Get.snackbar(
//         'Initialization Error',
//         'Failed to initialize: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> _loadInitialData() async {
//     final teamController = Get.find<TeamViewController>();
//     final questionController = Get.find<QuestionForSessionsController>();
//
//     try {
//       // Load teams first
//       if (teamController.teamView.value == null) {
//         await teamController.loadTeams();
//       }
//
//       // Load questions
//       if (questionController.questionData.value == null) {
//         await questionController.loadQuestions(
//           sessionId: 1,
//           gameFormatId: 1,
//         );
//       }
//     } catch (e) {
//       print("❌ Error loading initial data: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(color: AppColors.blueColor),
//         ),
//       );
//     }
//
//     final teamController = Get.find<TeamViewController>();
//     final questionController = Get.find<QuestionForSessionsController>();
//
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 700.h,
//                 right: 0,
//                 child: TeamAlphaContainer(),
//               ),
//               Column(
//                 children: [
//                   CustomAppbar(ishow4: true, ishow: true),
//                   SizedBox(height: 56.h),
//
//                   // Header Section
//                   GradientColor(
//                     height: 180.h,
//                     child: Container(
//                       width: 794.w,
//                       height: 235.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(40.r),
//                           topRight: Radius.circular(40.r),
//                         ),
//                       ),
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Positioned(
//                             top: -140,
//                             right: 312.w,
//                             left: 312.w,
//                             child: CustomStackImage(
//                               image: Appimages.player2,
//                               text: "Player",
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Obx(() => Center(
//                                 child: BoldText(
//                                   text: teamController.teamView.value?.teams.isNotEmpty == true
//                                       ? teamController.teamView.value!.teams.first.nickname
//                                       : "Team Alpha",
//                                   fontSize: 48.sp,
//                                   selectionColor: AppColors.blueColor,
//                                 ),
//                               )),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Main Content
//                   Expanded(
//                     child: GradientColor(
//                       ishow: false,
//                       child: Container(
//                         width: 794.w,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(40.r),
//                             bottomRight: Radius.circular(40.r),
//                           ),
//                         ),
//                         child: ScrollConfiguration(
//                           behavior: ScrollConfiguration.of(context).copyWith(
//                             scrollbars: false,
//                           ),
//                           child: SingleChildScrollView(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20.w,
//                               vertical: 10.h,
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 36.w),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   // Game Image
//                                   Stack(
//                                     clipBehavior: Clip.none,
//                                     children: [
//                                       SizedBox(
//                                         height: 370.h,
//                                         width: 428.w,
//                                         child: Image.asset(
//                                           Appimages.group,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       ),
//                                       Positioned(
//                                         bottom: 10.h,
//                                         right: 15.w,
//                                         child: Obx(() => CreateContainer(
//                                           fontsize2: 12.sp,
//                                           text: "${questionController.questionData.value?.phases.length ?? 0} Phases",
//                                           top: -25.h,
//                                           right: 2.w,
//                                           width: 172.w,
//                                           borderW: 2.w,
//                                           arrowW: 30.w,
//                                           arrowh: 35.h,
//                                           height: 63.h,
//                                         )),
//                                       ),
//                                     ],
//                                   ),
//
//                                   SizedBox(height: 20.h),
//
//                                   // Game Title
//                                   Obx(() => BoldText(
//                                     text: teamController.teamView.value?.gameFormat.name ?? "team_building_workshop".tr,
//                                     fontSize: 30.sp,
//                                     selectionColor: AppColors.blueColor,
//                                   )),
//
//                                   // Facilitator Info
//                                   Obx(() => Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SvgPicture.asset(
//                                         Appimages.person,
//                                         height: 25.h,
//                                         width: 25.w,
//                                       ),
//                                       SizedBox(width: 8.w),
//                                       MainText(
//                                         text: "Facilitator: ${teamController.teamView.value?.gameFormat.facilitators.isNotEmpty == true ? teamController.teamView.value!.gameFormat.facilitators[0].name : 'Unknown'}",
//                                         fontSize: 20.sp,
//                                       ),
//                                     ],
//                                   )),
//
//                                   SizedBox(height: 30.h),
//
//                                   // Current Phase Container
//                                   _buildCurrentPhaseContainer(questionController),
//
//                                   SizedBox(height: 30.h),
//
//                                   // Team Progress
//                                   AdminTeamProgress(),
//
//                                   SizedBox(height: 30.h),
//
//                                   // All Phases
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 10.w),
//                                     child: Column(
//                                       children: [
//                                         PhaseStrategyColumn(controller: controller),
//                                         SizedBox(height: 20.h),
//
//                                         // Next Phase Button
//                                         Obx(() {
//                                           final isPhaseComplete = controller.isCurrentPhaseComplete();
//                                           final isLastPhase = controller.isLastPhase();
//
//                                           if (isPhaseComplete && !isLastPhase) {
//                                             return LoginButton(
//                                               onTap: () {
//                                                 controller.moveToNextPhase();
//                                               },
//                                               ishow: true,
//                                               fontSize: 18.sp,
//                                               image: Appimages.forward,
//                                               text: "next_phase".tr,
//                                               color: AppColors.forwardColor,
//                                             );
//                                           }
//                                           return const SizedBox.shrink();
//                                         }),
//
//                                         SizedBox(height: 20.h),
//
//                                         // Review AI Score
//                                         LoginButton(
//                                           onTap: () => Get.toNamed(RouteName.submitResponseScreen),
//                                           fontSize: 20.sp,
//                                           text: "review_ai_score".tr,
//                                           color: AppColors.forwardColor,
//                                           ishow: true,
//                                           image: Appimages.ai2,
//                                           imageHeight: 32.h,
//                                           imageWidth: 32.w,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 70.h),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCurrentPhaseContainer(QuestionForSessionsController questionController) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 13.w),
//       child: Obx(() {
//         if (questionController.isLoading.value) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(40.h),
//               child: CircularProgressIndicator(color: AppColors.blueColor),
//             ),
//           );
//         }
//
//         final phase = controller.getCurrentPhase();
//         final currentQuestion = controller.getCurrentQuestion();
//
//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: AppColors.greyColor,
//               width: 1.5,
//             ),
//             borderRadius: BorderRadius.circular(24.r),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Phase Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         BoldText(
//                           text: "current_phase".tr,
//                           fontSize: 30.sp,
//                           selectionColor: AppColors.blueColor,
//                         ),
//                         SizedBox(height: 5.h),
//                         Row(
//                           children: [
//                             UseableContainer(
//                               text: phase != null ? "Phase ${controller.currentPhase.value + 1}" : "Phase 1",
//                               color: AppColors.orangeColor,
//                             ),
//                             SizedBox(width: 10.w),
//                             MainText(
//                               text: phase?.name ?? "strategy_building".tr,
//                               fontSize: 20.sp,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     CircularPercentIndicator(
//                       radius: 50.0.r,
//                       lineWidth: 4.0.w,
//                       percent: controller.timeProgress.value,
//                       animation: true,
//                       animationDuration: 500,
//                       circularStrokeCap: CircularStrokeCap.round,
//                       backgroundColor: Colors.transparent,
//                       progressColor: AppColors.forwardColor,
//                       center: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           BoldText(
//                             text: controller.remainingTime.value,
//                             fontSize: 20.sp,
//                             selectionColor: AppColors.blueColor,
//                           ),
//                           MainText(
//                             text: "remaining".tr,
//                             fontSize: 12.sp,
//                             height: 1,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 15.h),
//
//                 // Phase Description
//                 if (phase?.description != null && phase!.description.isNotEmpty)
//                   Column(
//                     children: [
//                       MainText(
//                         text: phase.description,
//                         fontSize: 18.sp,
//                       ),
//                       SizedBox(height: 15.h),
//                     ],
//                   ),
//
//                 // Question Progress
//                 if (currentQuestion != null)
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           MainText(
//                             text: "Question ${controller.currentQuestionIndex.value + 1} of ${controller.getCurrentPhaseQuestions().length}",
//                             fontSize: 16.sp,
//                             color: AppColors.blueColor,
//                           ),
//                           MainText(
//                             text: "${currentQuestion.point} points",
//                             fontSize: 16.sp,
//                             color: AppColors.teamColor,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                     ],
//                   ),
//
//                 SizedBox(height: 20.h),
//
//                 // Session Progress Row
//                 CompleteSessionRow(controller: controller),
//                 SizedBox(height: 16.h),
//
//                 // Current Phase Status
//                 Obx(() {
//                   final isPhaseComplete = controller.isCurrentPhaseComplete();
//                   final progress = isPhaseComplete
//                       ? 1.0
//                       : (controller.submittedQuestions.length / (phase?.questions.length ?? 1)).clamp(0.0, 1.0);
//
//                   return CustomStratgyContainer(
//                     value: progress,
//                     borderColor: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
//                     iconContainer: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
//                     icon: isPhaseComplete ? Icons.check : Icons.play_arrow_sharp,
//                     text1: phase?.name ?? "Stage 2",
//                     text2: isPhaseComplete
//                         ? "Completed • ${phase?.timeDuration != null ? (phase!.timeDuration / 60).ceil() : 0} min"
//                         : "Time Left ${controller.remainingTime.value}",
//                     text3: isPhaseComplete ? "completed".tr : "active".tr,
//                     smallContainer: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
//                     largeConatiner: isPhaseComplete ? AppColors.forwardColor : AppColors.selectLangugaeColor,
//                   );
//                 }),
//
//                 SizedBox(height: 20.h),
//
//                 // Current Question Display
//                 Obx(() {
//                   if (questionController.isLoading.value) {
//                     return Center(
//                       child: CircularProgressIndicator(color: AppColors.blueColor),
//                     );
//                   }
//
//                   final currentQuestion = controller.getCurrentQuestion();
//                   if (currentQuestion == null) {
//                     return Container(
//                       padding: EdgeInsets.all(20.w),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.greyColor),
//                         borderRadius: BorderRadius.circular(16.r),
//                       ),
//                       child: Center(
//                         child: MainText(
//                           text: controller.isCurrentPhaseComplete()
//                               ? "Phase Completed! 🎉"
//                               : "No questions available",
//                           fontSize: 20.sp,
//                           color: AppColors.teamColor,
//                         ),
//                       ),
//                     );
//                   }
//
//                   return PhaseQuestionsContainer(
//                     question: currentQuestion,
//                     controller: controller,
//                   );
//                 }),
//
//                 SizedBox(height: 20.h),
//
//                 // Submit Button
//                 Obx(() {
//                   final currentQuestion = controller.getCurrentQuestion();
//                   if (currentQuestion == null) return const SizedBox.shrink();
//
//                   final canSubmit = controller.canSubmitQuestion();
//                   return LoginButton(
//                     onTap: canSubmit ? () async {
//                       await controller.submitCurrentQuestion();
//                     } : null,
//                     ishow: true,
//                     fontSize: 18.sp,
//                     image: Appimages.submit,
//                     text: "submit_question".tr,
//                     color: canSubmit ? AppColors.forwardColor : AppColors.greyColor,
//                   );
//                 }),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.onClose();
//     super.dispose();
//   }
// }