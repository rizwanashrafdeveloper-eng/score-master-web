import 'package:flutter/material.dart';
//import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/api/api_controllers/create_game_controller.dart';
import 'package:scorer_web/api/api_controllers/question_controller.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/use_able_game_row.dart';

import '../../widgets/admin_side/questions_releated/phase_item.dart';
import '../../widgets/admin_side/questions_releated/question_type_selection_dialogue.dart';


class GameLogicSetupContainer extends StatefulWidget {
  final double scaleFactor;

  const GameLogicSetupContainer({Key? key, required this.scaleFactor}) : super(key: key);

  @override
  State<GameLogicSetupContainer> createState() => _GameLogicSetupContainerState();
}

class _GameLogicSetupContainerState extends State<GameLogicSetupContainer> {
  @override
  void initState() {
    super.initState();
    // Initialize QuestionController if not registered
    if (!Get.isRegistered<QuestionController>()) {
      Get.put(QuestionController());
    }

    // Load phases if game ID exists
    final createGameController = Get.find<CreateGameController>();
    if (createGameController.currentGameId.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        createGameController.loadExistingGame(createGameController.currentGameId.value!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final createGameController = Get.find<CreateGameController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColors.forwardColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.greyColor, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(createGameController),
          SizedBox(height: 32.h),
          Obx(() => _buildPhasesList(createGameController, context)),
        ],
      ),
    );
  }

  Widget _buildHeader(CreateGameController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoldText(
                text: "game_logic_setup".tr,
                fontSize: 32.sp,
                selectionColor: AppColors.blueColor,
              ),
              SizedBox(height: 8.h),
              Obx(() {
                if (controller.currentGameId.value != null) {
                  return MainText(
                    text: "Game ID: ${controller.currentGameId.value}",
                    fontSize: 16.sp,
                    color: AppColors.teamColor,
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        ),
        Obx(() => Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: controller.currentGameId.value == null
                ? AppColors.greyColor.withOpacity(0.1)
                : AppColors.forwardColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: controller.currentGameId.value == null
                  ? AppColors.greyColor
                  : AppColors.forwardColor,
            ),
          ),
          child: IconButton(
            onPressed: controller.isFetchingPhases.value || controller.currentGameId.value == null
                ? null
                : () => controller.loadExistingGame(controller.currentGameId.value!),
            icon: controller.isFetchingPhases.value
                ? SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.blueColor,
              ),
            )
                : Icon(
              Icons.refresh,
              color: controller.currentGameId.value == null
                  ? AppColors.greyColor
                  : AppColors.blueColor,
              size: 28.r,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPhasesList(CreateGameController controller, BuildContext context) {
    // Show loading only on initial load
    if (controller.isFetchingPhases.value && controller.phases.isEmpty) {
      return Container(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.blueColor,
                strokeWidth: 4,
              ),
              SizedBox(height: 20.h),
              MainText(
                text: "Loading phases...",
                fontSize: 18.sp,
                color: AppColors.languageTextColor,
              ),
            ],
          ),
        ),
      );
    }

    // Show empty state
    if (controller.phases.isEmpty) {
      return _buildEmptyPhasesWidget(controller);
    }

    // Show phases list
    return Column(
      children: controller.phases.asMap().entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: PhaseItem(
            phase: entry.value,
            index: entry.key,
            scaleFactor: widget.scaleFactor,
            onAddQuestion: () => showQuestionTypeSelectionDialog(
              context,
              entry.value,
              scaleFactor: widget.scaleFactor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyPhasesWidget(CreateGameController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.forwardColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.layers_outlined,
              size: 48.r,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 24.h),
          BoldText(
            text: controller.currentGameId.value == null
                ? "No game created yet"
                : "No phases added yet",
            fontSize: 24.sp,
            selectionColor: AppColors.languageTextColor,
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: MainText(
              text: controller.currentGameId.value != null
                  ? "Add phases using the 'Add Phase' button above to start building your game logic"
                  : "Create a game first, then add phases to build your game structure",
              fontSize: 16.sp,
              color: AppColors.teamColor,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class GameRow extends StatefulWidget {
  final String? text;
  final double scaleFactor;
  final bool? initialValue;
  final Function(bool)? onToggle;

  const GameRow({
    super.key,
    this.text,
    required this.scaleFactor,
    this.initialValue = false,
    this.onToggle,
  });

  @override
  State<GameRow> createState() => _GameRowState();
}

class _GameRowState extends State<GameRow> {
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    switchValue = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MainText(
              text: widget.text ?? "enable_leaderboard".tr,
              fontSize: 18.sp,
            ),
          ),
          // FlutterSwitch(
          //   value: switchValue,
          //   onToggle: (val) {
          //     setState(() {
          //       switchValue = val;
          //     });
          //     if (widget.onToggle != null) {
          //       widget.onToggle!(val);
          //     }
          //   },
          //   height: 40.h,
          //   width: 80.w,
          //   activeColor: AppColors.forwardColor,
          //   inactiveColor: AppColors.greyColor,
          //   toggleSize: 32.r,
          // )
        ],
      ),
    );
  }
}