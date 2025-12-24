import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/custom_response_container.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/team_alpha_container.dart';

import '../../api/api_controllers/game_format_phase.dart';
import '../../api/api_controllers/view_response_controller.dart';

class ViewResponsesScreen extends StatefulWidget {
  const ViewResponsesScreen({super.key});

  @override
  State<ViewResponsesScreen> createState() => _ViewResponsesScreenState();
}

class _ViewResponsesScreenState extends State<ViewResponsesScreen> {
  final GameFormatPhaseController phaseController = Get.put(
    GameFormatPhaseController(),
  );
  final ViewResponsesController responsesController = Get.put(
    ViewResponsesController(),
  );

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxInt selectedTab = 0.obs;

  @override
  void initState() {
    super.initState();
    print("🔄 ViewResponsesScreen initialized");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (phaseController.allPhases.isEmpty) {
        phaseController.fetchGameFormatPhases();
      }
    });
  }

  List<dynamic> _getFilteredResponses() {
    if (responsesController.isLoading.value) return [];

    List<dynamic> filtered;
    switch (selectedTab.value) {
      case 1: // Pending
        filtered = responsesController.allResponses
            .where((response) => response.score == null)
            .toList();
        break;
      case 2: // Scored
        filtered = responsesController.allResponses
            .where((response) => response.score != null)
            .toList();
        break;
      default: // All
        filtered = responsesController.allResponses;
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((response) {
        final playerName = response?.player?.name?.toLowerCase() ?? '';
        return playerName.contains(query);
      }).toList();
    }

    return filtered;
  }

  Widget _buildPhaseStatusContainer({
    required String title,
    required String description,
    required String status,
    required Color color,
    required IconData icon,
    required double progress,
  }) {
    return Container(
      height: 140.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Icon(icon, size: 40.sp, color: color),
            ),
          ),
          SizedBox(width: 25.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: BoldText(
                        text: title,
                        selectionColor: AppColors.blueColor,
                        fontSize: 22.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.h,
                    backgroundColor: AppColors.greyColor.withOpacity(0.2),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoldText(text: value, selectionColor: color, fontSize: 42.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.blueColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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

                // Header Section (Matching Evaluate Screen)
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
                          top: -140.h,
                          right: 312.w,
                          left: 312.w,
                          child: CustomStackImage(),
                        ),
                        SizedBox(height: 50.h),
                        Center(
                          child: BoldText(
                            text: "View Responses",
                            fontSize: 48.sp,
                            selectionColor: AppColors.blueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content Section
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
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 30.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Current Phase Info
                              Obx(() {
                                final currentPhase =
                                    phaseController.currentPhase;
                                if (currentPhase == null)
                                  return SizedBox.shrink();

                                final phaseIndex =
                                    phaseController.currentPhaseIndex.value;
                                final isActive = phaseController.isPhaseActive(
                                  phaseIndex,
                                );
                                final isCompleted = phaseController
                                    .isPhaseCompleted(phaseIndex);

                                Color statusColor;
                                IconData icon;
                                String statusText;
                                double progress;

                                if (isCompleted) {
                                  statusColor = AppColors.forwardColor;
                                  icon = Icons.check_circle;
                                  statusText = "Completed";
                                  progress = 1.0;
                                } else if (isActive) {
                                  statusColor = AppColors.selectLangugaeColor;
                                  icon = Icons.play_circle_fill;
                                  statusText = "Active";
                                  progress = 0.7;
                                } else {
                                  statusColor = AppColors.watchColor;
                                  icon = Icons.schedule;
                                  statusText = "Pending";
                                  progress = 0.0;
                                }

                                return Column(
                                  children: [
                                    _buildPhaseStatusContainer(
                                      title:
                                          currentPhase.name ?? "Current Phase",
                                      description:
                                          "${currentPhase.description ?? ''} • ${currentPhase.timeDuration ?? 0} min",
                                      status: statusText,
                                      color: statusColor,
                                      icon: icon,
                                      progress: progress,
                                    ),
                                    SizedBox(height: 30.h),
                                  ],
                                );
                              }),

                              // Session Info and Stats Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Session Info
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Obx(() {
                                  //     if (responsesController
                                  //             .currentSessionId
                                  //             .value <=
                                  //         0)
                                  //       return SizedBox.shrink();
                                  //     return Container(
                                  //       padding: EdgeInsets.symmetric(
                                  //         horizontal: 25.w,
                                  //         vertical: 20.h,
                                  //       ),
                                  //       decoration: BoxDecoration(
                                  //         color: AppColors.blueColor
                                  //             .withOpacity(0.08),
                                  //         borderRadius: BorderRadius.circular(
                                  //           20.r,
                                  //         ),
                                  //         border: Border.all(
                                  //           color: AppColors.blueColor
                                  //               .withOpacity(0.2),
                                  //         ),
                                  //       ),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             "Session Information",
                                  //             style: TextStyle(
                                  //               fontSize: 18.sp,
                                  //               color: AppColors.blueColor,
                                  //               fontWeight: FontWeight.w600,
                                  //             ),
                                  //           ),
                                  //           SizedBox(height: 12.h),
                                  //           Row(
                                  //             children: [
                                  //               Icon(
                                  //                 Icons.fingerprint,
                                  //                 size: 22.sp,
                                  //                 color: AppColors.blueColor,
                                  //               ),
                                  //               SizedBox(width: 10.w),
                                  //               Expanded(
                                  //                 child: Text(
                                  //                   "Session ID",
                                  //                   style: TextStyle(
                                  //                     fontSize: 16.sp,
                                  //                     color:
                                  //                         AppColors.greyColor,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               Container(
                                  //                 padding: EdgeInsets.symmetric(
                                  //                   horizontal: 15.w,
                                  //                   vertical: 8.h,
                                  //                 ),
                                  //                 decoration: BoxDecoration(
                                  //                   color: Colors.white,
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(
                                  //                         10.r,
                                  //                       ),
                                  //                   border: Border.all(
                                  //                     color:
                                  //                         AppColors.blueColor,
                                  //                   ),
                                  //                   boxShadow: [
                                  //                     BoxShadow(
                                  //                       color: AppColors
                                  //                           .blueColor
                                  //                           .withOpacity(0.1),
                                  //                       blurRadius: 5.r,
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 child: BoldText(
                                  //                   text:
                                  //                       "#${responsesController.currentSessionId.value}",
                                  //                   selectionColor:
                                  //                       AppColors.blueColor,
                                  //                   fontSize: 18.sp,
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     );
                                  //   }),
                                  // ),
                                  
                                  SizedBox(width: 30.w),

                                  // Stats
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatCard(
                                            value:
                                                "${responsesController.scoredCount}",
                                            label: "Scored",
                                            color: AppColors.forwardColor,
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        Expanded(
                                          child: _buildStatCard(
                                            value:
                                                "${responsesController.pendingCount}",
                                            label: "Pending",
                                            color: AppColors.orangeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 40.h),

                              // Search and Filter Section
                              Container(
                                padding: EdgeInsets.all(25.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.greyColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Filter Responses",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: AppColors.blueColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),

                                    // Search Bar
                                    Container(
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.greyColor
                                              .withOpacity(0.4),
                                          width: 1.w,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.03,
                                            ),
                                            blurRadius: 5.r,
                                            offset: Offset(0, 2.h),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 20.w),
                                          Icon(
                                            Icons.search_rounded,
                                            color: AppColors.blueColor,
                                            size: 22.sp,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: TextField(
                                              controller: searchController,
                                              onChanged: (value) =>
                                                  searchQuery.value = value,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Search players by name...",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 16.sp,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: AppColors.blueColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          if (searchQuery.value.isNotEmpty)
                                            IconButton(
                                              icon: Icon(
                                                Icons.clear_rounded,
                                                color: AppColors.greyColor,
                                                size: 20.sp,
                                              ),
                                              onPressed: () {
                                                searchController.clear();
                                                searchQuery.value = '';
                                              },
                                            ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 20.h),

                                    // Tab Selector
                                    Container(
                                      height: 45.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.greyColor
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  selectedTab.value = 0,
                                              child: AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                  color: selectedTab.value == 0
                                                      ? AppColors.forwardColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  boxShadow:
                                                      selectedTab.value == 0
                                                      ? [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .forwardColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            blurRadius: 10.r,
                                                            offset: Offset(
                                                              0,
                                                              2.h,
                                                            ),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "All Responses",
                                                    style: TextStyle(
                                                      color:
                                                          selectedTab.value == 0
                                                          ? Colors.white
                                                          : AppColors.greyColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  selectedTab.value = 1,
                                              child: AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                  color: selectedTab.value == 1
                                                      ? AppColors.orangeColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  boxShadow:
                                                      selectedTab.value == 1
                                                      ? [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .orangeColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            blurRadius: 10.r,
                                                            offset: Offset(
                                                              0,
                                                              2.h,
                                                            ),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                      color:
                                                          selectedTab.value == 1
                                                          ? Colors.white
                                                          : AppColors.greyColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  selectedTab.value = 2,
                                              child: AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                  color: selectedTab.value == 2
                                                      ? AppColors.forwardColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  boxShadow:
                                                      selectedTab.value == 2
                                                      ? [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .forwardColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            blurRadius: 10.r,
                                                            offset: Offset(
                                                              0,
                                                              2.h,
                                                            ),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Scored",
                                                    style: TextStyle(
                                                      color:
                                                          selectedTab.value == 2
                                                          ? Colors.white
                                                          : AppColors.greyColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 30.h),

                              // Responses List Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Player Responses",
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: AppColors.blueColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Obx(() {
                                    final filteredResponses =
                                        _getFilteredResponses();
                                    if (filteredResponses.isEmpty)
                                      return SizedBox.shrink();
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.forwardColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.format_list_bulleted,
                                            size: 18.sp,
                                            color: AppColors.forwardColor,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            "${filteredResponses.length} ${filteredResponses.length == 1 ? 'Response' : 'Responses'}",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.forwardColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              // Responses List
                              Obx(() {
                                if (responsesController.isLoading.value) {
                                  return Container(
                                    height: 300.h,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: AppColors.forwardColor,
                                            strokeWidth: 3.w,
                                          ),
                                          SizedBox(height: 20.h),
                                          Text(
                                            "Loading responses...",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppColors.greyColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                if (responsesController
                                    .errorMessage
                                    .value
                                    .isNotEmpty) {
                                  return Container(
                                    height: 300.h,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            size: 60.sp,
                                            color: Colors.red,
                                          ),
                                          SizedBox(height: 20.h),
                                          Text(
                                            "Error Loading Responses",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            responsesController
                                                .errorMessage
                                                .value,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: AppColors.greyColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 30.h),
                                          ElevatedButton(
                                            onPressed: responsesController
                                                .fetchResponses,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.forwardColor,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 30.w,
                                                vertical: 15.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              elevation: 3,
                                            ),
                                            child: Text(
                                              "Try Again",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final filteredResponses =
                                    _getFilteredResponses();

                                if (filteredResponses.isEmpty) {
                                  return Container(
                                    height: 300.h,
                                    padding: EdgeInsets.all(40.w),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            searchQuery.value.isNotEmpty
                                                ? Icons.search_off_rounded
                                                : Icons.inbox_rounded,
                                            size: 80.sp,
                                            color: AppColors.greyColor
                                                .withOpacity(0.5),
                                          ),
                                          SizedBox(height: 20.h),
                                          Text(
                                            searchQuery.value.isNotEmpty
                                                ? "No players found for '${searchQuery.value}'"
                                                : selectedTab.value == 1
                                                ? "No pending responses"
                                                : selectedTab.value == 2
                                                ? "No scored responses"
                                                : "No responses available",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppColors.greyColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          if (searchQuery.value.isNotEmpty ||
                                              selectedTab.value > 0)
                                            SizedBox(height: 20.h),
                                          if (searchQuery.value.isNotEmpty ||
                                              selectedTab.value > 0)
                                            ElevatedButton(
                                              onPressed: () {
                                                searchController.clear();
                                                searchQuery.value = '';
                                                selectedTab.value = 0;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.forwardColor,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 25.w,
                                                  vertical: 12.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                "Show All Responses",
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    ...filteredResponses.map((response) {
                                      final playerName =
                                          response?.player?.name ??
                                          "Unknown Player";
                                      final questionText =
                                          response?.question?.text ??
                                          "No question text";
                                      final answerText =
                                          response?.answerData?.sequence?.join(
                                            ', ',
                                          ) ??
                                          "No answer provided";
                                      final isScored = response?.score != null;
                                      final score = response?.score ?? 0;

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 20.h),
                                        child: CustomResponseContainer(
                                          containerHeight: 280.h,
                                          color1: isScored
                                              ? AppColors.forwardColor
                                              : AppColors.orangeColor,
                                          textColor: isScored
                                              ? Colors.white
                                              : AppColors.languageTextColor,
                                          text: isScored ? "SCORED" : "PENDING",
                                          ishow: true,
                                          ishow1: true,
                                          playerName: playerName,
                                          questionText: questionText,
                                          answer: answerText,
                                          questionPoints:
                                              response?.question?.point,
                                          score: score,
                                          isScored: isScored,
                                          onEvaluateTap: () {
                                            if (!isScored) {
                                              Get.toNamed(
                                                RouteName
                                                    .evaluateResponseScreen,
                                                arguments: response,
                                              );
                                            }
                                          },
                                          onViewScoreTap: () {
                                            if (isScored) {
                                              Get.toNamed(
                                                RouteName.viewScoreScreen,
                                                arguments: response,
                                              );
                                            }
                                          },
                                          showEvaluate: !isScored,
                                          showViewScore: isScored,
                                          text1: isScored
                                              ? "View Score"
                                              : "Evaluate",
                                          image: isScored
                                              ? Appimages.eye
                                              : Appimages.star,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              }),

                              SizedBox(height: 50.h),
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
    searchController.dispose();
    super.dispose();
  }
}
