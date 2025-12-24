// // lib/view/facilitator_folder/view_responses_screen_web.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/controller/stage_controller.dart';
// import 'package:scorer_web/shared_preference/shared_preference.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_response_container.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/custom_stratgy_container.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/main_text.dart';
//
// import '../../api/api_controllers/game_format_phase.dart';
// import '../../api/api_controllers/view_response_controller.dart';
// import '../../api/api_models/view_response_model.dart';
//
//
//
// class ViewResponsesScreen extends StatefulWidget {
//   const ViewResponsesScreen({super.key});
//
//   @override
//   State<ViewResponsesScreen> createState() => _ViewResponsesScreenState();
// }
//
// class _ViewResponsesScreenState extends State<ViewResponsesScreen> {
//   final StageController stageController = Get.put(StageController());
//   final GameFormatPhaseController phaseController = Get.put(GameFormatPhaseController());
//   final ViewResponsesController responsesController = Get.put(ViewResponsesController());
//
//   final List<String> tabs = ["All", "Pending", "Scored"];
//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;
//
//   int sessionId = 0;
//   int phaseId = 1;
//   int facilitatorId = 0;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeData();
//     });
//   }
//
//   Future<void> _initializeData() async {
//     try {
//       print('🔄 Initializing ViewResponsesScreenWeb...');
//
//       // Get data from arguments or shared preferences
//       final arguments = Get.arguments;
//       if (arguments != null) {
//         sessionId = arguments['sessionId'] ?? 0;
//         phaseId = arguments['phaseId'] ?? 1;
//         facilitatorId = arguments['facilitatorId'] ?? 0;
//       } else {
//         // Try to get from shared preferences
//         final prefsSessionId = await SharedPrefServices.getSessionId();
//         sessionId = prefsSessionId ?? 0;
//
//         final prefsFacilitatorId = await SharedPrefServices.getFacilitatorId();
//         facilitatorId = prefsFacilitatorId ?? 0;
//       }
//
//       print('📋 Initialization data:');
//       print('   - Session ID: $sessionId');
//       print('   - Phase ID: $phaseId');
//       print('   - Facilitator ID: $facilitatorId');
//
//       if (sessionId == 0) {
//         print('❌ No session ID found');
//         return;
//       }
//
//       // Set up controllers
//       phaseController.setSessionId(sessionId);
//
//       if (facilitatorId > 0) {
//         responsesController.setFacilitatorId(facilitatorId);
//         responsesController.setPhaseId(phaseId);
//       }
//
//       _isInitialized = true;
//       setState(() {});
//
//       print('✅ ViewResponsesScreenWeb initialized successfully');
//
//     } catch (e) {
//       print('❌ Error initializing ViewResponsesScreenWeb: $e');
//     }
//   }
//
//   List<Answer> get filteredResponsesWithSearch {
//     if (!_isInitialized || responsesController.isLoading.value) {
//       return [];
//     }
//
//     final allResponses = responsesController.filteredResponses;
//
//     if (searchQuery.value.isEmpty) {
//       return allResponses;
//     }
//
//     final query = searchQuery.value.toLowerCase();
//     return allResponses.where((response) {
//       final playerName = response.player?.name?.toLowerCase() ?? '';
//       return playerName.contains(query);
//     }).toList();
//   }
//
//   Widget _buildCountContainer(String count, String label) {
//     return Container(
//       height: 100.h,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: AppColors.greyColor,
//           width: 1.5.w,
//         ),
//         borderRadius: BorderRadius.circular(26.r),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BoldText(
//             text: count,
//             selectionColor: AppColors.redColor,
//             fontSize: 45.sp,
//           ),
//           SizedBox(width: 11.w),
//           BoldText(
//             text: label,
//             selectionColor: AppColors.blueColor,
//             fontSize: 30.sp,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 CustomAppbar(ishow: true),
//                 SizedBox(height: 56.h),
//
//                 GradientColor(
//                   height: 200.h,
//                   child: Container(
//                     width: 794.w,
//                     height: 235.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40.r),
//                         topRight: Radius.circular(40.r),
//                       ),
//                     ),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Positioned(
//                           top: 50.h,
//                           left: -40.w,
//                           child: ForwardButtonContainer(
//                             onTap: () => Get.back(),
//                             imageH: 20.h,
//                             imageW: 23.5.w,
//                             height1: 90.h,
//                             height2: 65.h,
//                             width1: 90.w,
//                             width2: 65.w,
//                             image: Appimages.arrowback,
//                           ),
//                         ),
//                         Positioned(
//                           top: -140,
//                           right: 312.w,
//                           left: 312.w,
//                           child: CustomStackImage(),
//                         ),
//                         Obx(() {
//                           final currentPhase = phaseController.currentPhase;
//                           final phaseName = currentPhase?.name ?? "Stage 2 Responses";
//                           return Center(
//                             child: BoldText(
//                               text: "$phaseName Responses",
//                               fontSize: 48.sp,
//                               selectionColor: AppColors.blueColor,
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 Expanded(
//                   child: GradientColor(
//                     ishow: false,
//                     child: Container(
//                       width: 794.w,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(40.r),
//                           topRight: Radius.circular(40.r),
//                         ),
//                       ),
//                       child: SingleChildScrollView(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                           child: Column(
//                             children: [
//                               SizedBox(height: 48.h),
//
//                               // Current Phase Container
//                               Obx(() {
//                                 if (phaseController.isLoading.value) {
//                                   return Container(
//                                     height: 280.h,
//                                     child: Center(child: CircularProgressIndicator()),
//                                   );
//                                 }
//
//                                 final currentPhase = phaseController.currentPhase;
//                                 if (currentPhase == null) {
//                                   return Container(
//                                     height: 280.h,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: AppColors.greyColor),
//                                       borderRadius: BorderRadius.circular(12.r),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         "No phase data available",
//                                         style: TextStyle(
//                                           color: AppColors.greyColor,
//                                           fontSize: 16.sp,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//
//                                 final isActive = phaseController.isPhaseActive(phaseController.currentPhaseIndex.value);
//                                 final isCompleted = phaseController.isPhaseCompleted(phaseController.currentPhaseIndex.value);
//
//                                 Color iconColor;
//                                 IconData icon;
//                                 Color statusColor;
//                                 String statusText;
//                                 String timeText;
//
//                                 if (isCompleted) {
//                                   iconColor = AppColors.forwardColor;
//                                   icon = Icons.check;
//                                   statusColor = AppColors.forwardColor;
//                                   statusText = "Completed";
//                                   timeText = "Completed • ${currentPhase.timeDuration ?? 0} min";
//                                 } else if (isActive) {
//                                   iconColor = AppColors.selectLangugaeColor;
//                                   icon = Icons.play_arrow_rounded;
//                                   statusColor = AppColors.selectLangugaeColor;
//                                   statusText = "Active";
//                                   timeText = "Active • ${currentPhase.timeDuration ?? 0} min";
//                                 } else {
//                                   iconColor = AppColors.watchColor;
//                                   icon = Icons.watch_later;
//                                   statusColor = AppColors.watchColor;
//                                   statusText = "Pending";
//                                   timeText = "Upcoming • ${currentPhase.timeDuration ?? 0} min";
//                                 }
//
//                                 return CustomStratgyContainer(
//                                   circleH: 40.h,
//                                   circleW: 40.w,
//                                   circleS: 20.sp,
//                                   isshow: true,
//                                   mainHeight: 1.3,
//                                   fontSize: 24.sp,
//                                   containerHeight: 280.h,
//                                   width3: 54.w,
//                                   spaceHeight2: 40.h,
//                                   spaceHeight: 20.h,
//                                   extra: currentPhase.description ?? "Phase description",
//                                   iconContainer: iconColor,
//                                   icon: icon,
//                                   text1: currentPhase.name ?? "Current Phase",
//                                   text2: timeText,
//                                   text3: statusText,
//                                   smallContainer: statusColor,
//                                   largeConatiner: statusColor,
//                                 );
//                               }),
//
//                               SizedBox(height: 60.h),
//
//                               // Center(
//                               //   child: CreateContainer(
//                               //     text: "Stage 2 Scoring",
//                               //     width: 290.w,
//                               //     height: 67.h,
//                               //     arrowW: 37.h,
//                               //     arrowh: 45.h,
//                               //     borderW: 1.97.w,
//                               //     top: -40.h,
//                               //     right: 20.w,
//                               //   ),
//                               // ),
//                               //
//                               // SizedBox(height: 67.h),
//
//                               // Scored/Pending Counts
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Obx(() => _buildCountContainer(
//                                       "${responsesController.scoredCount}",
//                                       "Scored",
//                                     )),
//                                   ),
//                                   SizedBox(width: 15.w),
//                                   Expanded(
//                                     child: Obx(() => _buildCountContainer(
//                                       "${responsesController.pendingCount}",
//                                       "Pending",
//                                     )),
//                                   ),
//                                 ],
//                               ),
//
//                               SizedBox(height: 40.h),
//
//                               // Search Bar
//                               Container(
//                                 height: 50.h,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12.r),
//                                   border: Border.all(
//                                     color: AppColors.greyColor,
//                                     width: 1.5.w,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     SizedBox(width: 15.w),
//                                     Icon(
//                                       Icons.search,
//                                       color: AppColors.greyColor,
//                                       size: 20.w,
//                                     ),
//                                     SizedBox(width: 10.w),
//                                     Expanded(
//                                       child: TextField(
//                                         controller: searchController,
//                                         onChanged: (value) {
//                                           searchQuery.value = value;
//                                         },
//                                         decoration: InputDecoration(
//                                           hintText: "Search players...",
//                                           hintStyle: TextStyle(
//                                             color: AppColors.greyColor,
//                                             fontSize: 14.sp,
//                                           ),
//                                           border: InputBorder.none,
//                                           contentPadding: EdgeInsets.zero,
//                                         ),
//                                         style: TextStyle(
//                                           fontSize: 14.sp,
//                                           color: AppColors.blueColor,
//                                         ),
//                                       ),
//                                     ),
//                                     if (searchQuery.value.isNotEmpty)
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.clear,
//                                           color: AppColors.greyColor,
//                                           size: 20.w,
//                                         ),
//                                         onPressed: () {
//                                           searchController.clear();
//                                           searchQuery.value = '';
//                                         },
//                                       ),
//                                   ],
//                                 ),
//                               ),
//
//                               SizedBox(height: 20.h),
//
//                               // Tab Selector
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50.h,
//                                 child: Obx(() {
//                                   final selectedIndex = stageController.selectedIndex.value;
//                                   return Row(
//                                     children: [
//                                       for (int i = 0; i < tabs.length; i++)
//                                         Expanded(
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               stageController.changeTab(i);
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 border: Border(
//                                                   bottom: BorderSide(
//                                                     color: selectedIndex == i
//                                                         ? AppColors.forwardColor
//                                                         : Colors.transparent,
//                                                     width: 2.w,
//                                                   ),
//                                                 ),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   tabs[i],
//                                                   style: TextStyle(
//                                                     fontSize: 16.sp,
//                                                     color: selectedIndex == i
//                                                         ? AppColors.forwardColor
//                                                         : AppColors.greyColor,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   );
//                                 }),
//                               ),
//
//                               SizedBox(height: 13.h),
//
//                               // Responses List
//                               Obx(() {
//                                 if (!_isInitialized || responsesController.isLoading.value) {
//                                   return SizedBox(
//                                     height: 200.h,
//                                     child: Center(child: CircularProgressIndicator()),
//                                   );
//                                 }
//
//                                 if (responsesController.errorMessage.value.isNotEmpty) {
//                                   return SizedBox(
//                                     height: 100.h,
//                                     child: Center(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             responsesController.errorMessage.value,
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 14.sp,
//                                             ),
//                                           ),
//                                           SizedBox(height: 10.h),
//                                           ElevatedButton(
//                                             onPressed: () => responsesController.fetchResponses(),
//                                             child: Text('Retry'),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }
//
//                                 final filteredResponses = filteredResponsesWithSearch;
//
//                                 if (filteredResponses.isEmpty) {
//                                   return SizedBox(
//                                     height: 200.h,
//                                     child: Center(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           if (searchQuery.value.isNotEmpty)
//                                             Text(
//                                               "No players found",
//                                               style: TextStyle(
//                                                 fontSize: 16.sp,
//                                                 color: AppColors.greyColor,
//                                               ),
//                                             )
//                                           else
//                                             Text(
//                                               stageController.selectedIndex.value == 0
//                                                   ? "No responses yet"
//                                                   : stageController.selectedIndex.value == 1
//                                                   ? "No pending responses"
//                                                   : "No scored responses",
//                                               style: TextStyle(
//                                                 fontSize: 16.sp,
//                                                 color: AppColors.greyColor,
//                                               ),
//                                             ),
//                                           if (searchQuery.value.isNotEmpty)
//                                             TextButton(
//                                               onPressed: () {
//                                                 searchController.clear();
//                                                 searchQuery.value = '';
//                                               },
//                                               child: Text("Clear search"),
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }
//
//                                 return Column(
//                                   children: [
//                                     if (searchQuery.value.isNotEmpty)
//                                       Padding(
//                                         padding: EdgeInsets.only(bottom: 10.h),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${filteredResponses.length} results found",
//                                               style: TextStyle(
//                                                 fontSize: 12.sp,
//                                                 color: AppColors.greyColor,
//                                               ),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 searchController.clear();
//                                                 searchQuery.value = '';
//                                               },
//                                               child: Text(
//                                                 "Clear",
//                                                 style: TextStyle(
//                                                   fontSize: 12.sp,
//                                                   color: AppColors.forwardColor,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//
//                                     Column(
//                                       children: filteredResponses.map((response) {
//                                         final playerName = response.player?.name ?? "Unknown Player";
//                                         final questionText = response.question?.text ?? "No question text";
//                                         final answerSequence = response.answerData?.sequence?.join(', ') ?? "No answer";
//                                         final isScored = response.score != null;
//
//                                         return Padding(
//                                           padding: EdgeInsets.only(bottom: 20.h),
//                                           child: CustomResponseContainer(
//                                             color1: isScored ? AppColors.forwardColor : AppColors.greyColor,
//                                             textColor: isScored ? Colors.white : null,
//                                             text: isScored ? "Scored" : "Pending",
//                                             ishow: true,
//                                             ishow1: true,
//                                             playerName: playerName,
//                                             questionText: questionText,
//                                             answer: answerSequence,
//                                             score: response.score,
//                                             isScored: isScored,
//                                             onEvaluateTap: () {
//                                               if (!isScored) {
//                                                 Get.toNamed(RouteName.evaluateResponseScreen, arguments: response);
//                                               }
//                                             },
//                                             onViewScoreTap: () {
//                                               if (isScored) {
//                                                 Get.toNamed(RouteName.viewScoreScreen, arguments: response);
//                                               }
//                                             },
//                                             showEvaluate: !isScored,
//                                             showViewScore: isScored,
//                                             text1: isScored ? "View Score" : "Evaluate",
//                                             image: isScored ? Appimages.eye : Appimages.star,
//                                           ),
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ],
//                                 );
//                               }),
//
//                               SizedBox(height: 40.h),
//
//                               // All Phases Section
//                               Obx(() {
//                                 if (phaseController.isLoading.value) {
//                                   return Center(child: CircularProgressIndicator());
//                                 }
//
//                                 final allPhases = phaseController.allPhases;
//                                 if (allPhases.isEmpty) {
//                                   return Container(
//                                     padding: EdgeInsets.all(16.w),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: AppColors.greyColor),
//                                       borderRadius: BorderRadius.circular(12.r),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         "No phases available",
//                                         style: TextStyle(
//                                           color: AppColors.greyColor,
//                                           fontSize: 14.sp,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//
//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     BoldText(
//                                       text: "All Phases",
//                                       fontSize: 24.sp,
//                                       selectionColor: AppColors.blueColor,
//                                     ),
//                                     SizedBox(height: 30.h),
//                                     ...allPhases.asMap().entries.map((entry) {
//                                       final index = entry.key;
//                                       final phase = entry.value;
//                                       final isActive = phaseController.isPhaseActive(index);
//                                       final isCompleted = phaseController.isPhaseCompleted(index);
//
//                                       Color iconColor;
//                                       IconData icon;
//                                       Color statusColor;
//                                       String statusText;
//                                       String timeText;
//                                       double value;
//
//                                       if (isCompleted) {
//                                         iconColor = AppColors.forwardColor;
//                                         icon = Icons.check;
//                                         statusColor = AppColors.forwardColor;
//                                         statusText = "Completed";
//                                         timeText = "Completed • ${phase.timeDuration ?? 0} min";
//                                         value = 1.0;
//                                       } else if (isActive) {
//                                         iconColor = AppColors.selectLangugaeColor;
//                                         icon = Icons.play_arrow_sharp;
//                                         statusColor = AppColors.selectLangugaeColor;
//                                         statusText = "Active";
//                                         timeText = "Active • ${phase.timeDuration ?? 0} min";
//                                         value = 0.5;
//                                       } else {
//                                         iconColor = AppColors.watchColor;
//                                         icon = Icons.watch_later;
//                                         statusColor = AppColors.watchColor;
//                                         statusText = "Pending";
//                                         timeText = "Upcoming • ${phase.timeDuration ?? 0} min";
//                                         value = 0.0;
//                                       }
//
//                                       return Column(
//                                         children: [
//                                           CustomStratgyContainer(
//                                             value: value,
//                                             iconContainer: iconColor,
//                                             icon: icon,
//                                             text1: "Phase ${index + 1}: ${phase.name}",
//                                             text2: timeText,
//                                             text3: statusText,
//                                             smallContainer: statusColor,
//                                             largeConatiner: isCompleted || isActive ? statusColor : AppColors.greyColor,
//                                           ),
//                                           if (index < allPhases.length - 1) SizedBox(height: 10.h),
//                                         ],
//                                       );
//                                     }).toList(),
//                                   ],
//                                 );
//                               }),
//
//                               SizedBox(height: 49.h),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }