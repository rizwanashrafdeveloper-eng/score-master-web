import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/login_button.dart';
import '../../../api/api_models/questions_model.dart';

class AddQuestionDialog extends StatefulWidget {
  final dynamic phase;
  final QuestionType questionType;
  final double scaleFactor;

  const AddQuestionDialog({
    Key? key,
    required this.phase,
    required this.questionType,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _scenarioController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController(text: '10');
  final List<TextEditingController> _optionsControllers = [];
  int _selectedCorrectOption = 0;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    if (widget.questionType == QuestionType.MCQ || widget.questionType == QuestionType.PUZZLE) {
      for (int i = 0; i < 4; i++) {
        _optionsControllers.add(TextEditingController());
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scenarioController.dispose();
    _pointsController.dispose();
    for (final c in _optionsControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 1200;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? screenWidth * 0.2 : 30.w,
        vertical: screenHeight * 0.08,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLargeScreen ? 800.w : 650.w,
          maxHeight: screenHeight * 0.84,
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
                color: Colors.black.withOpacity(0.15),
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(isLargeScreen),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 32.w : 20.w,
                    vertical: isLargeScreen ? 20.h : 16.h,
                  ),
                  child: _showPreview ? _buildPreview(isLargeScreen) : _buildForm(isLargeScreen),
                ),
              ),
              _buildFooter(isLargeScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 28.w : 20.w,
        vertical: isLargeScreen ? 24.h : 18.h,
      ),
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
              _getTypeIcon(),
              color: Colors.white,
              size: isLargeScreen ? 24.r : 20.r,
            ),
          ),
          SizedBox(width: isLargeScreen ? 14.w : 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoldText(
                  text: 'Add ${widget.questionType.name} Question',
                  fontSize: isLargeScreen ? 20.sp : 16.sp,
                  selectionColor: Colors.white,
                ),
                SizedBox(height: 4.h),
                MainText(
                  text: 'Phase: ${widget.phase.name}',
                  fontSize: isLargeScreen ? 12.sp : 10.sp,
                  color: Colors.white.withOpacity(0.9),
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

  Widget _buildForm(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Points Field
        BoldText(
          text: 'Points',
          fontSize: isLargeScreen ? 16.sp : 14.sp,
          selectionColor: AppColors.blackColor,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: isLargeScreen ? 200.w : 160.w,
          child: LoginTextfield(
            text: 'Enter points (e.g., 10)',
            fontsize: isLargeScreen ? 14.sp : 12.sp,
            height: isLargeScreen ? 55.h : 50.h,
            controller: _pointsController,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: isLargeScreen ? 16.h : 12.h),

        // Scenario Field (for Puzzle and Simulation)
        if (widget.questionType == QuestionType.PUZZLE ||
            widget.questionType == QuestionType.SIMULATION) ...[
          BoldText(
            text: 'Scenario (Optional)',
            fontSize: isLargeScreen ? 16.sp : 14.sp,
            selectionColor: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          LoginTextfield(
            text: 'Enter scenario context...',
            fontsize: isLargeScreen ? 14.sp : 12.sp,
            height: isLargeScreen ? 90.h : 80.h,
            controller: _scenarioController,
            maxLines: 3,
          ),
          SizedBox(height: isLargeScreen ? 16.h : 12.h),
        ],

        // Question Field
        BoldText(
          text: 'Question',
          fontSize: isLargeScreen ? 16.sp : 14.sp,
          selectionColor: AppColors.blackColor,
        ),
        SizedBox(height: 8.h),
        LoginTextfield(
          text: 'Enter your question...',
          fontsize: isLargeScreen ? 14.sp : 12.sp,
          height: isLargeScreen ? 90.h : 80.h,
          controller: _questionController,
          maxLines: 3,
        ),
        SizedBox(height: isLargeScreen ? 16.h : 12.h),

        // Type-specific fields
        if (widget.questionType == QuestionType.MCQ)
          _buildMcqFields(isLargeScreen),
        if (widget.questionType == QuestionType.PUZZLE)
          _buildPuzzleFields(isLargeScreen),

        SizedBox(height: isLargeScreen ? 20.h : 16.h),

        // Preview Button
        Center(
          child: SizedBox(
            width: isLargeScreen ? 220.w : 180.w,
            child: LoginButton(
              text: 'Preview Question',
              fontSize: isLargeScreen ? 16.sp : 14.sp,
              color: AppColors.forwardColor,
              onTap: () {
                if (_questionController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter a question',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                  return;
                }
                setState(() => _showPreview = true);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMcqFields(bool isLargeScreen) {
    final optionWidth = isLargeScreen ? 280.w : 240.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(
          text: 'Options',
          fontSize: isLargeScreen ? 16.sp : 14.sp,
          selectionColor: AppColors.blackColor,
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: isLargeScreen ? 16.w : 12.w,
          runSpacing: isLargeScreen ? 12.h : 10.h,
          children: _optionsControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return SizedBox(
              width: optionWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: _selectedCorrectOption,
                    onChanged: (val) => setState(() => _selectedCorrectOption = val!),
                    activeColor: AppColors.blueColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: LoginTextfield(
                      text: 'Option ${index + 1}',
                      fontsize: isLargeScreen ? 14.sp : 12.sp,
                      height: isLargeScreen ? 55.h : 50.h,
                      controller: controller,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8.h),
        MainText(
          text: 'Select the correct option using radio buttons',
          fontSize: isLargeScreen ? 12.sp : 10.sp,
          color: AppColors.teamColor,
        ),
      ],
    );
  }

  Widget _buildPuzzleFields(bool isLargeScreen) {
    final optionWidth = isLargeScreen ? 300.w : 260.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(
          text: 'Sequence Options',
          fontSize: isLargeScreen ? 16.sp : 14.sp,
          selectionColor: AppColors.blackColor,
        ),
        SizedBox(height: 8.h),
        MainText(
          text: 'Enter options in the correct order',
          fontSize: isLargeScreen ? 12.sp : 10.sp,
          color: AppColors.teamColor,
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: isLargeScreen ? 16.w : 12.w,
          runSpacing: isLargeScreen ? 12.h : 10.h,
          children: _optionsControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return SizedBox(
              width: optionWidth,
              child: Row(
                children: [
                  Container(
                    width: isLargeScreen ? 32.w : 28.w,
                    height: isLargeScreen ? 32.h : 28.h,
                    decoration: BoxDecoration(
                      color: AppColors.forwardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: BoldText(
                        text: '${index + 1}',
                        fontSize: isLargeScreen ? 14.sp : 12.sp,
                        selectionColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: isLargeScreen ? 12.w : 10.w),
                  Expanded(
                    child: LoginTextfield(
                      text: 'Step ${index + 1}',
                      fontsize: isLargeScreen ? 14.sp : 12.sp,
                      height: isLargeScreen ? 55.h : 50.h,
                      controller: controller,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPreview(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.preview, color: AppColors.blueColor,
                size: isLargeScreen ? 22.r : 18.r),
            SizedBox(width: isLargeScreen ? 10.w : 8.w),
            BoldText(
              text: 'Preview',
              fontSize: isLargeScreen ? 18.sp : 16.sp,
              selectionColor: AppColors.blueColor,
            ),
          ],
        ),
        SizedBox(height: isLargeScreen ? 20.h : 16.h),
        _buildQuestionPreview(isLargeScreen),
        SizedBox(height: isLargeScreen ? 20.h : 16.h),
        Center(
          child: SizedBox(
            width: isLargeScreen ? 200.w : 170.w,
            child: LoginButton(
              text: 'Edit Question',
              fontSize: isLargeScreen ? 16.sp : 14.sp,
              color: AppColors.forwardColor,
              onTap: () => setState(() => _showPreview = false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionPreview(bool isLargeScreen) {
    final options = _optionsControllers.map((c) => c.text).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLargeScreen ? 20.w : 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.greyColor, width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
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
                  horizontal: isLargeScreen ? 10.w : 8.w,
                  vertical: isLargeScreen ? 5.h : 4.h,
                ),
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: MainText(
                  text: widget.questionType.name.toUpperCase(),
                  fontSize: isLargeScreen ? 11.sp : 10.sp,
                  color: _getTypeColor(),
                ),
              ),
              SizedBox(width: isLargeScreen ? 10.w : 8.w),
              MainText(
                text: '${_pointsController.text} points',
                fontSize: isLargeScreen ? 11.sp : 10.sp,
                color: AppColors.teamColor,
              ),
            ],
          ),
          SizedBox(height: isLargeScreen ? 16.h : 12.h),

          if (_scenarioController.text.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isLargeScreen ? 14.w : 12.w),
              decoration: BoxDecoration(
                color: AppColors.forwardColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: MainText(
                text: _scenarioController.text,
                fontSize: isLargeScreen ? 13.sp : 12.sp,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: isLargeScreen ? 16.h : 12.h),
          ],

          BoldText(
            text: _questionController.text,
            selectionColor: AppColors.redColor,
            fontSize: isLargeScreen ? 18.sp : 16.sp,
          ),

          if (widget.questionType == QuestionType.MCQ ||
              widget.questionType == QuestionType.PUZZLE) ...[
            SizedBox(height: isLargeScreen ? 16.h : 12.h),
            Wrap(
              spacing: isLargeScreen ? 12.w : 10.w,
              runSpacing: isLargeScreen ? 12.h : 10.h,
              children: options.asMap().entries.map((entry) {
                if (entry.value.isEmpty) return SizedBox.shrink();
                return SizedBox(
                  width: isLargeScreen ? 280.w : 240.w,
                  child: Row(
                    children: [
                      if (widget.questionType == QuestionType.PUZZLE)
                        Container(
                          width: isLargeScreen ? 28.w : 24.w,
                          height: isLargeScreen ? 28.h : 24.h,
                          margin: EdgeInsets.only(right: isLargeScreen ? 10.w : 8.w),
                          decoration: BoxDecoration(
                            color: AppColors.forwardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isLargeScreen ? 12.sp : 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(isLargeScreen ? 14.w : 12.w),
                          decoration: BoxDecoration(
                            color: entry.key == _selectedCorrectOption &&
                                widget.questionType == QuestionType.MCQ
                                ? AppColors.blueColor.withOpacity(0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: entry.key == _selectedCorrectOption &&
                                  widget.questionType == QuestionType.MCQ
                                  ? AppColors.blueColor
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: MainText(
                            text: entry.value,
                            fontSize: isLargeScreen ? 13.sp : 12.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(bool isLargeScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 28.w : 20.w,
        vertical: isLargeScreen ? 20.h : 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: isLargeScreen ? 120.w : 100.w,
            child: LoginButton(
              text: 'Cancel',
              fontSize: isLargeScreen ? 14.sp : 12.sp,
              color: AppColors.greyColor,
              onTap: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: isLargeScreen ? 12.w : 10.w),
          SizedBox(
            width: isLargeScreen ? 140.w : 120.w,
            child: LoginButton(
              text: 'Save Question',
              fontSize: isLargeScreen ? 14.sp : 12.sp,
              color: AppColors.blueColor,
              onTap: _onSave,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (widget.questionType) {
      case QuestionType.PUZZLE:
        return Icons.extension;
      case QuestionType.MCQ:
        return Icons.radio_button_checked;
      case QuestionType.OPEN_ENDED:
        return Icons.text_fields;
      case QuestionType.SIMULATION:
        return Icons.play_circle;
      default:
        return Icons.help;
    }
  }

  Color _getTypeColor() {
    switch (widget.questionType) {
      case QuestionType.MCQ:
        return AppColors.blueColor;
      case QuestionType.PUZZLE:
        return AppColors.orangeColor;
      case QuestionType.OPEN_ENDED:
        return AppColors.forwardColor;
      case QuestionType.SIMULATION:
        return AppColors.redColor;
      default:
        return AppColors.blueColor;
    }
  }

  void _onSave() {
    if (_questionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Question cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    final points = int.tryParse(_pointsController.text) ?? 10;

    Navigator.pop(context, {
      'type': widget.questionType,
      'question': _questionController.text,
      'scenario': _scenarioController.text,
      'points': points,
      'options': _optionsControllers.map((c) => c.text).toList(),
      'correctOption': _selectedCorrectOption,
      'phaseId': widget.phase.id,
    });
  }
}