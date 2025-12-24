// view/game2_screen_web.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/api/api_controllers/add_phase_controller.dart';
import 'package:scorer_web/api/api_controllers/create_game_controller.dart';
import 'package:scorer_web/api/api_controllers/facilitator_controller.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/filter_useable_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/login_textfield.dart';
import 'package:scorer_web/widgets/main_text.dart';

import '../../api/api_controllers/question_controller.dart';
import '../../components/admin_folder.dart/default_time_container.dart';
import '../../components/admin_folder.dart/game_Setup_logic_container.dart';
import '../../components/facilitator_folder/count_container_row.dart';
import '../../widgets/admin_side/badge_type_widget.dart';
import '../../widgets/admin_side/challenge_type_selector_widget.dart';

class Game2ScreenWeb extends StatefulWidget {
  const Game2ScreenWeb({super.key});

  @override
  State<Game2ScreenWeb> createState() => _Game2ScreenWebState();
}

class _Game2ScreenWebState extends State<Game2ScreenWeb> {
  final AddPhaseController addPhaseController = Get.put(AddPhaseController());
  final FacilitatorsController facilitatorController = Get.put(
      FacilitatorsController());
  final CreateGameController createGameController = Get.put(
      CreateGameController());
  final RxBool showPhaseSection = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Initialize QuestionController if not already done
    if (!Get.isRegistered<QuestionController>()) {
      Get.put(QuestionController());
      print("✅ QuestionController initialized");
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      await facilitatorController.fetchFacilitatorsFromApi();
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to load facilitators: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? mapFilterToScoringType(String filterValue) {
    final normalized = filterValue.toUpperCase();
    if (addPhaseController.scoringTypeOptions.contains(normalized)) {
      return normalized;
    }
    const filterToScoringMap = {
      'MIXED': 'HYBRID',
      'POINT': 'POINTS',
      'TIMED': 'TIME',
      'COMPLETE': 'COMPLETION',
      'ACCURATE': 'ACCURACY',
    };
    return filterToScoringMap[normalized];
  }

  List<String> validateFormFields() {
    List<String> errors = [];
    if (addPhaseController.validateName(
        addPhaseController.nameController.text) != null) {
      errors.add(addPhaseController.validateName(
          addPhaseController.nameController.text)!);
    }
    if (addPhaseController.validateDescription(
        addPhaseController.descriptionController.text) != null) {
      errors.add(addPhaseController.validateDescription(
          addPhaseController.descriptionController.text)!);
    }
    if (addPhaseController.validateOrder(
        addPhaseController.orderController.text) != null) {
      errors.add(addPhaseController.validateOrder(
          addPhaseController.orderController.text)!);
    }
    if (addPhaseController.validateTimeDuration(
        addPhaseController.timeDurationController.text) != null) {
      errors.add(addPhaseController.validateTimeDuration(
          addPhaseController.timeDurationController.text)!);
    }
    if (addPhaseController.validateRequiredScore(
        addPhaseController.requiredScoreController.text) != null) {
      errors.add(addPhaseController.validateRequiredScore(
          addPhaseController.requiredScoreController.text)!);
    }

    return errors;
  }

  void togglePhaseSection() {
    showPhaseSection.value = !showPhaseSection.value;
  }

  Future<void> _saveGame() async {
    try {
      await createGameController.createGameFormat();
      // Success is handled in the controller via snackbar
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to create game: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            const CustomAppbar(ishow: true, ishow3: true),
            SizedBox(height: 40.h),

            // Top Gradient Section
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
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 90.w,
                          height: 90.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.forwardColor,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Appimages.arrowback,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              width: 23.5.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: "Create Ne".tr,
                                  style: TextStyle(
                                    fontSize: 48.sp,
                                    color: AppColors.blueColor,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 14.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff8DC046),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.r),
                                          bottomLeft: Radius.circular(30.r),
                                        ),
                                      ),
                                      child: Text(
                                        "w".tr,
                                        style: TextStyle(
                                          fontSize: 48.sp,
                                          color: AppColors.blueColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 14.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.forwardColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30.r),
                                          bottomRight: Radius.circular(30.r),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 4.0, right: 10.0),
                                        child: Text(
                                          "Game".tr,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 48.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Area
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
                  child: Obx(() {
                    if (isLoading.value &&
                        facilitatorController.facilitators.isEmpty) {
                      return _buildLoadingState();
                    }

                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 30.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Game Image
                            SizedBox(
                              height: 250.h,
                              width: 250.w,
                              child: Image.asset(
                                Appimages.game,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // Game Name Field
                            SizedBox(
                              width: 600.w,
                              child: LoginTextfield(
                                text: "enter_game_name".tr,
                                fontsize: 24.sp,
                                //   height: 80.h,
                                onChanged: (value) {
                                  createGameController.name.value = value;
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Description Field
                            SizedBox(
                              width: 600.w,
                              child: LoginTextfield(
                                text: "description".tr,
                                // height: 120.h,
                                fontsize: 24.sp,
                                maxLines: 4,
                                onChanged: (value) {
                                  createGameController.description.value =
                                      value;
                                },
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // Default Time Container
                            DefaultTimeContainer(
                                controller: createGameController),
                            SizedBox(height: 30.h),

                            // Facilitators Section
                            _buildFacilitatorsSection(),
                            SizedBox(height: 30.h),

                            // Number of Phases Section
                            _buildPhasesSection(),
                            SizedBox(height: 30.h),

                            // Save Game Button
                            Obx(() =>
                            createGameController.isCreatingGame.value
                                ? _buildLoadingButton()
                                : LoginButton(
                              text: "save".tr,
                              ishow: true,
                              image: Appimages.save,
                              onTap: _saveGame,
                            )),
                            SizedBox(height: 30.h),
                            GameLogicSetupContainer(scaleFactor: 50,),
                            SizedBox(height: 30.h),
                            // Add Phase Button
                            Center(
                              child: LoginButton(
                                text: "add_phase".tr,
                                ishow: true,
                                icon: Icons.add,
                                onTap: togglePhaseSection,
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // Phase Section (Conditional)
                            Obx(() =>
                            showPhaseSection.value
                                ? _buildPhaseSection()
                                : const SizedBox()),

                            SizedBox(height: 30.h),

                            // Cancel Button
                            Center(
                              child: LoginButton(
                                text: "cancel".tr,
                                color: AppColors.forwardColor,
                                onTap: () => Get.back(),
                              ),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.forwardColor),
          ),
          SizedBox(height: 20.h),
          BoldText(
            text: "Loading Game Creator...".tr,
            fontSize: 24.sp,
            selectionColor: AppColors.blueColor,
          ),
          SizedBox(height: 10.h),
          MainText(
            text: "Preparing your game creation environment".tr,
            fontSize: 18.sp,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      width: 200.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.forwardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 12.w),
          MainText(
            text: "Saving...".tr,
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitatorsSection() {
    return SizedBox(
      width: 600.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldText(
            text: "add_facilitators".tr,
            fontSize: 28.sp,
            selectionColor: AppColors.blueColor,
          ),
          SizedBox(height: 20.h),

          // Search Field
          TextField(
            onChanged: (value) {
              facilitatorController.searchQuery.value = value;
            },
            decoration: InputDecoration(
              hintText: "search_facilitator".tr,
              prefixIcon: Icon(Icons.search, size: 28.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 16.w,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Facilitators List
          Obx(() {
            if (facilitatorController.isLoading.value) {
              return _buildFacilitatorsLoading();
            }

            // Show all facilitators when no search query, show filtered when searching
            final facilitatorsToShow = facilitatorController.searchQuery.value
                .isEmpty
                ? facilitatorController.facilitators
                : facilitatorController.filteredFacilitators;

            if (facilitatorsToShow.isEmpty) {
              return _buildNoFacilitators();
            }

            return _buildFacilitatorsList(facilitatorsToShow);
          }),

          SizedBox(height: 20.h),

          // Selected Facilitators
          _buildSelectedFacilitators(),
        ],
      ),
    );
  }

  Widget _buildFacilitatorsLoading() {
    return Container(
      height: 120.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.forwardColor),
          ),
          SizedBox(height: 10.h),
          MainText(
            text: "Loading facilitators...".tr,
            fontSize: 16.sp,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNoFacilitators() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 40.r,
            color: AppColors.greyColor,
          ),
          SizedBox(height: 10.h),
          BoldText(
            text: "No Facilitators Found".tr,
            fontSize: 18.sp,
            selectionColor: AppColors.greyColor,
          ),
          SizedBox(height: 5.h),
          MainText(
            text: facilitatorController.searchQuery.value.isEmpty
                ? "No facilitators available in the system".tr
                : "No matches for '${facilitatorController.searchQuery.value}'"
                .tr,
            fontSize: 14.sp,
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitatorsList(List<dynamic> facilitators) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(8.w),
        itemCount: facilitators.length,
        itemBuilder: (context, index) {
          final facilitator = facilitators[index];
          return Obx(() {
            final isSelected = facilitatorController.selectedIds.contains(
                facilitator.id);
            return ListTile(
              leading: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.forwardColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.forwardColor,
                  size: 20.r,
                ),
              ),
              title: Text(
                facilitator.name ?? "Unknown Facilitator",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                facilitator.email ?? "No email",
                style: TextStyle(fontSize: 14.sp),
              ),
              trailing: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.forwardColor : AppColors
                    .greyColor,
                size: 24.r,
              ),
              onTap: () {
                facilitatorController.toggleSelection(facilitator.id!);
              },
            );
          });
        },
      ),
    );
  }

  Widget _buildSelectedFacilitators() {
    return Obx(() {
      final selected = facilitatorController.getSelectedFacilitators();
      if (selected.isEmpty) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.greyColor, size: 24.r),
              SizedBox(width: 10.w),
              Expanded(
                child: MainText(
                  text: "no_facilitators_selected".tr,
                  fontSize: 16.sp,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BoldText(
                text: "Selected Facilitators".tr,
                fontSize: 20.sp,
                selectionColor: AppColors.blueColor,
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.forwardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "${selected.length}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: selected.map((facilitator) {
              return Chip(
                label: Text(
                  facilitator.name ?? "",
                  style: TextStyle(fontSize: 14.sp),
                ),
                avatar: CircleAvatar(
                  backgroundColor: AppColors.forwardColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: AppColors.forwardColor,
                    size: 16.r,
                  ),
                ),
                deleteIcon: Icon(Icons.close, size: 16.r),
                onDeleted: () {
                  facilitatorController.toggleSelection(facilitator.id!);
                },
                backgroundColor: AppColors.forwardColor.withOpacity(0.05),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildPhasesSection() {
    return Center(
      child: SizedBox(
        width: 600.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoldText(
              text: "number_of_phases".tr,
              fontSize: 28.sp,
              selectionColor: AppColors.blueColor,
            ),
            SizedBox(height: 16.h),
            MainText(
              text: "phase_structure_adapts".tr,
              color: AppColors.teamColor,
              textAlign: TextAlign.center,
              height: 1.4,
              fontSize: 20.sp,
            ),
            SizedBox(height: 30.h),
            Center(
              child: CountContainerRow(
                onCountChanged: (count) {
                  createGameController.totalPhases.value = count;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseSection() {
    return SizedBox(
      width: 600.w,
      child: Form(
        key: addPhaseController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with decorative line
            Stack(
              alignment: Alignment.center,
              children: [
                Divider(
                  color: AppColors.forwardColor,
                  thickness: 2,
                  height: 50.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.forwardColor),
                  ),
                  child: BoldText(
                    text: "Phase Details".tr,
                    fontSize: 24.sp,
                    selectionColor: AppColors.forwardColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Error Message
            Obx(() {
              if (addPhaseController.errorMessage.value.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: MainText(
                          text: addPhaseController.errorMessage.value,
                          color: Colors.red,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            }),
            SizedBox(height: 20.h),

            // Phase Form Fields
            _buildPhaseFormFields(),
            SizedBox(height: 30.h),

            // Action Buttons
            _buildPhaseActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseFormFields() {
    return Column(
      children: [
        // Phase Name
        LoginTextfield(
          ishow: false,
          text: "Phase Name".tr,
          fontsize: 20.sp,
          //height: 70.h,
          controller: addPhaseController.nameController,
          validator: addPhaseController.validateName,
        ),
        SizedBox(height: 16.h),

        // Phase Description
        LoginTextfield(
          ishow: false,
          text: "Phase Description".tr,
          fontsize: 20.sp,
          // height: 100.h,
          maxLines: 3,
          controller: addPhaseController.descriptionController,
          validator: addPhaseController.validateDescription,
        ),
        SizedBox(height: 16.h),

        // Order and Time Duration in Row
        Row(
          children: [
            Expanded(
              child: LoginTextfield(
                ishow: false,
                text: "Order".tr,
                fontsize: 20.sp,
                // height: 70.h,
                controller: addPhaseController.orderController,
                validator: addPhaseController.validateOrder,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: LoginTextfield(
                ishow: false,
                text: "Time Duration (minutes)".tr,
                fontsize: 20.sp,
                //  height: 70.h,
                controller: addPhaseController.timeDurationController,
                validator: addPhaseController.validateTimeDuration,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Required Score
        LoginTextfield(
          ishow: false,
          text: "Required Score".tr,
          fontsize: 20.sp,
          // height: 70.h,
          controller: addPhaseController.requiredScoreController,
          validator: addPhaseController.validateRequiredScore,
          keyboardType: TextInputType.number,
        ),
        // Scoring Type Dropdown
        BoldText(
          text: "Scoring Type".tr,
          fontSize: 20.sp,
          selectionColor: AppColors.blueColor,
        ),
        SizedBox(height: 8.h),
        Obx(() =>
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Select Scoring Type".tr),
                  value: addPhaseController.scoringType.value,
                  items: addPhaseController.scoringTypeOptions.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type, style: TextStyle(fontSize: 18.sp)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    addPhaseController.setScoringType(value);
                  },
                ),
              ),
            )),
        SizedBox(height: 20.h),


// Difficulty Dropdown
        BoldText(
          text: "Difficulty".tr,
          fontSize: 20.sp,
          selectionColor: AppColors.blueColor,
        ),
        SizedBox(height: 8.h),
        Obx(() =>
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Select Difficulty".tr),
                  value: addPhaseController.difficulty.value,
                  items: addPhaseController.difficultyOptions.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level, style: TextStyle(fontSize: 18.sp)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    addPhaseController.setDifficulty(value);
                  },
                ),
              ),
            )),
        SizedBox(height: 16),
        // Challenge Type Selector
        ChallengeTypeSelector(
          availableTypes: addPhaseController.challengeTypeOptions,
          initialSelected: addPhaseController.challengeTypes,
          onSelectionChanged: (selectedList) {
            addPhaseController.challengeTypes.value = selectedList;
          },
        ),
        SizedBox(height: 20.h),

        // Badge Widget
        BadgeWidget(
          onChanged: (badge, score) {
            addPhaseController.setBadge(badge.name, score: score.toString());
          },
        ),
      ],
    );
  }

  Widget _buildPhaseActionButtons() {
    return Column(
      children: [
        Obx(() =>
        addPhaseController.isLoading.value
            ? _buildLoadingButton()
            : LoginButton(
          text: "Save Phase".tr,
          ishow: true,
          image: Appimages.save,
          onTap: () async {
            // Add the same validation as mobile
            final formErrors = validateFormFields();
            if (formErrors.isNotEmpty) {
              Get.snackbar(
                'Error'.tr,
                formErrors.join('\n'),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
              );
              return;
            }

            // Add dropdown validation
            if (!addPhaseController.validateDropdowns()) {
              Get.snackbar(
                'Error'.tr,
                'Please select all required dropdowns',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (createGameController.currentGameId.value == null) {
              Get.snackbar(
                'Error'.tr,
                'Please create a game first before adding phases'.tr,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            addPhaseController.setGameFormatId(
                createGameController.currentGameId.value);

            if (addPhaseController.validateDropdowns()) {
              await addPhaseController.submitPhase();
              if (!addPhaseController.isLoading.value &&
                  addPhaseController.errorMessage.value.isEmpty) {
                togglePhaseSection();
                Get.snackbar(
                  'Success'.tr,
                  'Phase added successfully!'.tr,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            }
          },
        )),
        SizedBox(height: 16.h),
        LoginButton(
          text: "Cancel Phase".tr,
          color: Colors.grey,
          onTap: () {
            addPhaseController.clearForm();
            togglePhaseSection();
          },
        ),
      ],
    );
  }
}


//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/admin_folder.dart/custom_container.dart';
// import 'package:scorer_web/components/admin_folder.dart/default_time_container.dart';
// import 'package:scorer_web/components/admin_folder.dart/game_Setup_logic_container.dart';
// import 'package:scorer_web/components/facilitator_folder/additional_setting_column.dart';
// import 'package:scorer_web/components/facilitator_folder/analysis_container.dart';
// import 'package:scorer_web/components/facilitator_folder/count_container_row.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_phase_container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_session_Container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_time_row.dart';
// import 'package:scorer_web/components/facilitator_folder/feedback_container.dart';
// import 'package:scorer_web/components/facilitator_folder/phase_breakdown_container.dart';
// import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_response_container.dart';
// import 'package:scorer_web/widgets/custom_sloder_row.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/filter_useable_container.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/game_select_useable_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/login_textfield.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/players_containers.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// // import 'package:syncfusion_flutter_sliders/sliders.dart';
//
// class GameScreen2AdminSide extends StatelessWidget {
//   final bool isSelected;
//
//   const GameScreen2AdminSide({super.key, this.isSelected = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Column(
//           children: [
//             /// ✅ Fixed Appbar
//             CustomAppbar(ishow: true, ishow3: true),
//             SizedBox(height: 56.h),
//
//             /// ✅ Fixed Top Container
//             GradientColor(
//               height: 180.h,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40.r),
//                     topRight: Radius.circular(40.r),
//                   ),
//
//                   // color: AppColors.whiteColor,
//                 ),
//                 // color: AppColors.whiteColor,
//                 width: 794.w,
//                 height: 235.h,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Positioned(
//                       top: 50.h,
//                       left: -40.w,
//                       child: ForwardButtonContainer(
//                         onTap: () => Get.back(),
//                         imageH: 20.h,
//                         imageW: 23.5.w,
//                         height1: 90.h,
//                         height2: 65.h,
//                         width1: 90.w,
//                         width2: 65.w,
//                         image: Appimages.arrowback,
//                       ),
//                     ),
//                     Positioned(
//                       top: -140,
//                       right: 312.w,
//                       left: 312.w,
//                       child: CustomStackImage(
//                         image: Appimages.prince2,
//                         text: "Administrator",
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: RichText(
//                             text: TextSpan(
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                               children: [
//                                 TextSpan(
//                                   text: "Add Ne".tr,
//
//                                   style: TextStyle(
//                                     fontSize: 48.sp,
//                                     color: AppColors.blueColor,
//                                   ),
//                                 ),
//                                 WidgetSpan(
//                                   alignment: PlaceholderAlignment.middle,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(bottom: 14.h),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Color(0xff8DC046),
//                                         borderRadius: const BorderRadius.only(
//                                           topLeft: Radius.circular(30),
//                                           bottomLeft: Radius.circular(30),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "w".tr,
//                                         style: TextStyle(
//                                           fontSize: 48.sp,
//                                           color: AppColors.blueColor,
//
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 WidgetSpan(
//                                   alignment: PlaceholderAlignment.middle,
//                                   child: Padding(
//                                     // padding: EdgeInsets.all(8.0),\
//                                     padding: EdgeInsets.only(bottom: 14.h),
//
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: AppColors.forwardColor,
//                                         borderRadius: const BorderRadius.only(
//                                           topRight: Radius.circular(30),
//                                           bottomRight: Radius.circular(30),
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                           left: 4.0,
//                                           right: 10.0,
//                                         ),
//                                         child: Text(
//                                           "Game".tr,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 48.sp,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// ✅ Scrollable Area
//             Expanded(
//               child: GradientColor(
//                 ishow: false,
//                 child: Container(
//                   width: 794.w,
//                   decoration: BoxDecoration(
//                     // color: AppColors.whiteColor,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40.r),
//                       bottomRight: Radius.circular(40.r),
//                     ),
//                   ),
//                   child: ScrollConfiguration(
//                     behavior: ScrollConfiguration.of(context).copyWith(
//                       scrollbars: false, // ✅ ye side wali scrollbar hatayega
//                     ),
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20.w,
//                         vertical: 10.h,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 36.w),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               height: 390.h,
//                               width: 390.w,
//                               child: Image.asset(
//                                 Appimages.game,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//
//                             SizedBox(height: 30.h),
//                             LoginTextfield(
//                               text: "enter_game_name".tr,
//                               fontsize: 42.sp,
//                               height: 130.h,
//                             ),
//                             SizedBox(height: 10.h),
//                             LoginTextfield(
//                               //ishow: true,
//                               text: "description".tr,
//                               height: 200.h,
//                               fontsize: 42.sp,
//                             ),
//                             SizedBox(height: 40.h),
//                             BoldText(
//                               text: "number_of_phases".tr,
//                               fontSize: 30.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                             SizedBox(height: 25.h),
//                             MainText(
//                               text: "phase_structure_adapts".tr,
//                               color: AppColors.teamColor,
//                               textAlign: TextAlign.center,
//                               height: 1.4,
//                               fontSize: 24.sp,
//                             ),
//                             SizedBox(height: 30.h),
//                             CountContainerRow(),
//                             SizedBox(height: 40.h),
//                             GameLogicSetupContainer(),
//                             SizedBox(height: 20.h),
//                             LoginButton(
//                               text: "add_phase".tr,
//                               ishow: true,
//                               icon: Icons.add,
//                               // imageHeight: 26 * scaleFactor,
//                               // imageWidth: 26 * scaleFactor,
//                             ),
//                             SizedBox(height: 34.h),
//                             BoldText(
//                               text: "challenge_types".tr,
//                               selectionColor: AppColors.blueColor,
//                             ),
//
//                             SizedBox(height: 25.h),
//                             FilterUseableContainer(
//                               isSelected: true,
//                               text: "mcq".tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//                             FilterUseableContainer(
//                               isSelected: false,
//                               text: "open_ended".tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//                             FilterUseableContainer(
//                               isSelected: true,
//                               text: "puzzle".tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//                             FilterUseableContainer(
//                               isSelected: false,
//                               text: "simulation".tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//                             CustomContainer(),
//                             SizedBox(height: 20.h),
//                             DefaultTimeContainer(),
//                             SizedBox(height: 40.h),
//                             Center(
//                               child: BoldText(
//                                 text: "badge_labeling".tr,
//                                 fontSize: 30.sp,
//                                 selectionColor: AppColors.blueColor,
//                               ),
//                             ),
//                             SizedBox(height: 16.h),
//                             Center(
//                               child: Image.asset(
//                                 Appimages.badge,
//                                 width: 200.w,
//                                 height: 200.h,
//                               ),
//                             ),
//                             SizedBox(height: 11.h),
//                             CustomPhaseContainer(
//                               text1: "badge_name".tr,
//
//                               text2: "gold_achiever".tr,
//                               // fontSize: .sp,
//                               color: AppColors.forwardColor,
//                             ),
//                             SizedBox(height: 10.h),
//                             CustomPhaseContainer(
//                               text1: "required_score".tr,
//                               text2: "90+",
//                               // fontSize: 16 .sp,
//                               color: AppColors.forwardColor,
//                             ),
//                             SizedBox(height: 16.h),
//                             LoginButton(
//                               text: "add_more_badges".tr,
//
//                               color: AppColors.forwardColor,
//
//                               fontFamily: "refsan",
//                             ),
//                             SizedBox(height: 18.h),
//                             BoldText(
//                               text: "additional_settings".tr,
//                               selectionColor: AppColors.blueColor,
//                               fontSize: 30.sp,
//                             ),
//
//                             SizedBox(height: 20.h),
//                             FilterUseableContainer(
//                               isSelected: true,
//                               text: 'manual'.tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//                             FilterUseableContainer(
//                               isSelected: false,
//                               text: 'ai'.tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//
//                             FilterUseableContainer(
//                               isSelected: false,
//                               text: 'mixed'.tr,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 10.h),
//
//                             CustomContainer(
//                               text1: "points_per_correct_answer".tr,
//                               text2: "10pts",
//                               color: AppColors.forwardColor,
//                             ),
//                             SizedBox(height: 10.h),
//
//                             CustomContainer(
//                               text1: "penalty_for_wrong_answers".tr,
//                               text2: "-5pts",
//                               color: AppColors.redColor,
//                             ),
//
//                             SizedBox(height: 40.h),
//
//                             GameRow(fontsize: 20.sp),
//                             SizedBox(height: 10.h),
//                             GameRow(
//                               fontsize: 20.sp,
//                               text: "allow_team_mode".tr,
//                             ),
//                             SizedBox(height: 10.h),
//                             GameRow(
//                               fontsize: 20.sp,
//
//                               text: "auto_start_sessions".tr,
//                             ),
//                             SizedBox(height: 43.h),
//                             LoginButton(
//                               // fontSize: 20.sp,
//                               text: "save".tr,
//                               ishow: true,
//                               image: Appimages.save,
//                             ),
//                             SizedBox(height: 10.h),
//                             LoginButton(
//                               // fontSize: 20.sp
//                               // ,
//                               text: "cancel".tr,
//                               color: AppColors.forwardColor,
//                             ),
//                             SizedBox(height: 43.h),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
