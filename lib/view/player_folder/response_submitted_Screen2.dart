import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/view/player_folder/player_analysis_web.dart';
import 'package:scorer_web/view/player_folder/scoring_breakdown_widget_web.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import controllers and widgets
import '../../api/api_controllers/player_score_controller.dart';
import '../../api/api_controllers/question_for_sessions_controller.dart';
import '../../api/api_models/player_score_model.dart';
import '../../components/player_folder/phase_strategy_column.dart';
import '../../controller/game_select_controller.dart';
import '../../shared_preference/shared_preference.dart';
import '../../widgets/create_container.dart';


class ResponseSubmittedScreen2 extends StatefulWidget {
  const ResponseSubmittedScreen2({super.key});

  @override
  State<ResponseSubmittedScreen2> createState() => _ResponseSubmittedScreen2State();
}

class _ResponseSubmittedScreen2State extends State<ResponseSubmittedScreen2> {
  final QuestionForSessionsController questionController = Get.put(QuestionForSessionsController());
  final PlayerScoreController scoreController = Get.put(PlayerScoreController());
  late GameSelectController gameController;
  final _isLoading = true.obs;
  final _errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    gameController = GameSelectController(questionController: questionController);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _isLoading.value = true;

      // Get IDs from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getInt('session_id');
      final gameFormatId = prefs.getInt('gameFormatId');
      final playerIdStr = prefs.getString('userId');

      if (sessionId == null || gameFormatId == null || playerIdStr == null) {
        _errorMessage.value = 'Missing session data. Please rejoin the session.';
        _isLoading.value = false;
        return;
      }

      final playerId = int.tryParse(playerIdStr);
      if (playerId == null) {
        _errorMessage.value = 'Invalid player ID';
        _isLoading.value = false;
        return;
      }

      print('🔄 Loading data with: sessionId=$sessionId, gameFormatId=$gameFormatId, playerId=$playerId');

      // Load questions for session
      await questionController.loadQuestions(
        sessionId: sessionId,
        gameFormatId: gameFormatId,
      );

      // Load player scores
      await scoreController.loadPlayerScores(
        playerId: playerId,
        questionId: sessionId, // Using sessionId as questionId
      );

      // Initialize game controller with current phase
      if (questionController.questionData.value != null) {
        gameController = GameSelectController(questionController: questionController);
        Get.put(gameController, permanent: true);
      }

    } catch (e) {
      _errorMessage.value = 'Error loading data: $e';
      print('❌ Error loading data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> exportToPdf() async {
    try {
      final pdf = pw.Document();
      final analysis = scoreController.analysisData;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context context) => [
            // Header
            pw.Center(
              child: pw.Text(
                '🏆 Team Alpha - Session Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ),
            pw.SizedBox(height: 16),

            // Response Summary
            pw.Text(
              'Response Summary',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.indigo,
              ),
            ),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 8),

            // Analysis Data
            if (analysis == null)
              pw.Text(
                'No data available.',
                style: pw.TextStyle(color: PdfColors.red, fontSize: 14),
              )
            else
              _buildAnalysisTable(analysis),

            pw.SizedBox(height: 24),

            // Tips Section
            pw.Text(
              'Tips & Strategies',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 8),
            pw.Bullet(text: 'Focus on teamwork and communication.'),
            pw.Bullet(text: 'Adapt strategies dynamically.'),
            pw.Bullet(text: 'Review performance analytics regularly.'),
            pw.SizedBox(height: 24),

            // Footer
            pw.Center(
              child: pw.Text(
                'Generated by Score Master+',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );

      // TODO: Add PDF sharing/export functionality for web
      Get.snackbar(
        'PDF Generated',
        'PDF export would be implemented here for web download.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      Get.snackbar(
        'Export Failed',
        'Error generating PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  pw.Widget _buildAnalysisTable(dynamic analysis) {
    try {
      if (analysis is! PlayerScoreModel) {
        return pw.Text('Invalid analysis data format.',
            style: pw.TextStyle(color: PdfColors.red));
      }

      final score = analysis;
      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1),
        },
        children: [
          // Header Row
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.blue50),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Metric',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Value',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
            ],
          ),
          // Data Rows
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Final Score'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('${score.finalScore}/100'),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Strategic Thinking'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('${score.strategicThinking}/25'),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Feasibility'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('${score.feasibilityScore}/25'),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Innovation'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('${score.innovationScore}/25'),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Relevance'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('${score.relevanceScore}/25'),
              ),
            ],
          ),
          if (score.suggestion.isNotEmpty)
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Suggestion'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(score.suggestion),
                ),
              ],
            ),
        ],
      );
    } catch (e) {
      return pw.Text('Error formatting analysis data: $e',
          style: pw.TextStyle(color: PdfColors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Obx(() {
            if (_isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.forwardColor),
                    SizedBox(height: 20.h),
                    MainText(
                      text: 'Loading your results...',
                      fontSize: 18.sp,
                      color: AppColors.blueColor,
                    ),
                  ],
                ),
              );
            }

            if (_errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 20.h),
                    MainText(
                      text: _errorMessage.value,
                      fontSize: 18.sp,
                      color: Colors.red,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    LoginButton(
                      text: 'Retry',
                      onTap: _loadData,
                      color: AppColors.forwardColor,
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                Column(
                  children: [
                    CustomAppbar(ishow4: true, ishow: true),
                    SizedBox(height: 56.h),

                    /// Top fixed container
                    GradientColor(
                      height: 180.h,
                      child: Container(
                        width: 794.w,
                        height: 150.h,
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
                                Center(
                                  child: BoldText(
                                    text: "Team Alpha",
                                    fontSize: 48.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

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
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 36.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        height: 298.h,
                                        width: 298.w,
                                        child: SvgPicture.asset(
                                          Appimages.Crown,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10.h,
                                        right: -20.w,
                                        child: Obx(() {
                                          final phases = questionController.questionData.value?.phases ?? [];
                                          return CreateContainer(
                                            fontsize2: 12,
                                            text: "${phases.length} Phases",
                                            top: -25.h,
                                            right: 2.w,
                                            width: 172.w,
                                            borderW: 2.w,
                                            arrowW: 30.w,
                                            arrowh: 35.h,
                                            height: 63.h,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 70.h),
                                  BoldText(
                                    text: "Response Accepted!",
                                    fontSize: 30.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  SizedBox(height: 30.h),

                                  // Player Analysis
                                  Obx(() {
                                    final scoreData = scoreController.analysisData;
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
                                    return PlayerAnalysisWeb(scoreData: scoreData);
                                  }),

                                  SizedBox(height: 50.h),

                                  // Scoring Breakdown
                                  Obx(() {
                                    final scoreData = scoreController.analysisData;
                                    return ScoringBreakdownWidgetWeb(scoreData: scoreData);
                                  }),

                                  SizedBox(height: 50.h),

                                  // Phase Strategy Column
                                  Obx(() {
                                    if (questionController.questionData.value == null) {
                                      return Center(
                                        child: MainText(
                                          text: "No phase data available",
                                          fontSize: 16.sp,
                                          color: AppColors.greyColor,
                                        ),
                                      );
                                    }
                                    return PhaseStrategyColumn(
                                      controller: gameController, // ✅ CORRECT - This is GameSelectController
                                    );
                                  }),

                                  SizedBox(height: 50.h),

                                  // Buttons
                                  Obx(() {
                                    final currentPhase = gameController.currentPhase.value;
                                    final phases = questionController.questionData.value?.phases ?? [];
                                    final isLastPhase = currentPhase >= phases.length - 1;

                                    return Column(
                                      children: [
                                        if (!isLastPhase)
                                          LoginButton(
                                            text: "Move to Phase ${currentPhase + 2}",
                                            color: AppColors.forwardColor,
                                            ishow: true,
                                            image: Appimages.submit,
                                            imageHeight: 40.h,
                                            imageWidth: 40.w,
                                            onTap: () {
                                              // TODO: Implement move to next phase
                                              Get.snackbar(
                                                'Coming Soon',
                                                'Phase navigation will be implemented',
                                                backgroundColor: Colors.blue,
                                                colorText: Colors.white,
                                              );
                                            },
                                          ),
                                        SizedBox(height: 10.h),
                                        LoginButton(
                                          text: "Live Leaderboard",
                                          ishow: true,
                                          image: Appimages.tropy1,
                                          imageHeight: 40.h,
                                          imageWidth: 40.w,
                                          onTap: () => Get.toNamed(RouteName.playerLeaderboardScreen),
                                        ),
                                        SizedBox(height: 10.h),
                                        LoginButton(
                                          text: "Export PDF",
                                          ishow: true,
                                          color: AppColors.redColor,
                                          image: Appimages.export,
                                          imageHeight: 40.h,
                                          imageWidth: 40.w,
                                          onTap: exportToPdf,
                                        ),
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
            );
          }),
        ),
      ),
    );
  }
}