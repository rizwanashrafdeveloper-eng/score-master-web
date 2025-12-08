import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/components/admin_folder.dart/game_useable_container.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_color.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/create_container.dart';
import 'package:scorer_web/widgets/custom_stack_image.dart';
import 'package:scorer_web/widgets/main_text.dart';

// Import your controller and models
import '../../api/api_controllers/show_all_game_model_controller.dart';

class GameScreenAdminside extends StatefulWidget {
  const GameScreenAdminside({super.key});

  @override
  State<GameScreenAdminside> createState() => _GameScreenAdminsideState();
}

class _GameScreenAdminsideState extends State<GameScreenAdminside> {
  final GamesController gamesController = Get.put(GamesController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure games are loaded
    if (gamesController.games.isEmpty) {
      gamesController.fetchAllGames();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
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
                    top: -140,
                    right: 312.w,
                    left: 312.w,
                    child: CustomStackImage(
                      image: Appimages.prince2,
                      text: "Administrator",
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: BoldText(
                          text: "Game Format Management",
                          fontSize: 48.sp,
                          selectionColor: AppColors.blueColor,
                        ),
                      ),
                      MainText(
                        text: "Each of these formats has its own logic, flow,\nand evaluation methods.",
                        fontSize: 22.sp,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// ✅ Scrollable Area
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),

                          // Header with stats and refresh
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BoldText(
                                    text: "Games Management",
                                    fontSize: 32.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  SizedBox(height: 8.h),
                                  MainText(
                                    text: "Manage and monitor all game formats and configurations.",
                                    fontSize: 18.sp,
                                    height: 1.4,
                                  ),
                                ],
                              ),
                              Obx(() => Column(
                                children: [
                                  GestureDetector(
                                    onTap: gamesController.isLoading.value
                                        ? null
                                        : () => gamesController.refreshGames(),
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: gamesController.isLoading.value
                                          ? SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.blueColor,
                                        ),
                                      )
                                          : Icon(
                                        Icons.refresh,
                                        color: AppColors.blueColor,
                                        size: 24.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "${gamesController.totalGames} Games",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),

                          SizedBox(height: 30.h),

                          // 🔍 Search Bar
                          TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "Search game by name...",
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 20.h,
                                horizontal: 20.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                              ),
                            ),
                          ),

                          SizedBox(height: 30.h),

                          // Games List
                          Obx(() {
                            if (gamesController.isLoading.value) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(80.h),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(color: AppColors.blueColor),
                                      SizedBox(height: 30.h),
                                      Text(
                                        "Loading games...",
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (gamesController.hasError.value) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(50.h),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 80.sp,
                                      ),
                                      SizedBox(height: 30.h),
                                      Text(
                                        "Error loading games",
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      Text(
                                        gamesController.errorMessage.value,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 30.h),
                                      ElevatedButton(
                                        onPressed: () => gamesController.refreshGames(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                                          child: Text("Try Again", style: TextStyle(fontSize: 20.sp)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Filter by search
                            final filteredGames = gamesController.games.where((game) {
                              final query = searchController.text.trim().toLowerCase();
                              return game.displayName.toLowerCase().contains(query);
                            }).toList();

                            if (filteredGames.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(80.h),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.games_outlined,
                                        color: Colors.grey,
                                        size: 80.sp,
                                      ),
                                      SizedBox(height: 30.h),
                                      Text(
                                        searchController.text.isEmpty ? "No games available" : "No games found",
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      Text(
                                        searchController.text.isEmpty
                                            ? "Create your first game to get started"
                                            : "Try a different search term",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Display filtered games
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredGames.length,
                              itemBuilder: (context, index) {
                                final game = filteredGames[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 25.h),
                                  child: GameUseAbleContainer(
                                    game: game,
                                    onTap: null,
                                  ),
                                );
                              },
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}











//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/components/admin_folder.dart/account_info_column.dart';
// import 'package:scorer_web/components/admin_folder.dart/game_useable_container.dart';
// import 'package:scorer_web/components/facilitator_folder/active_Session_screen.dart';
// import 'package:scorer_web/components/facilitator_folder/analysis_container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_session_Container.dart';
// import 'package:scorer_web/components/facilitator_folder/custom_time_row.dart';
// import 'package:scorer_web/components/facilitator_folder/facil_dashBoard_stack_container.dart';
// import 'package:scorer_web/components/facilitator_folder/feedback_container.dart';
// import 'package:scorer_web/components/facilitator_folder/phase_breakdown_container.dart';
// import 'package:scorer_web/components/facilitator_folder/players_Row.dart';
// import 'package:scorer_web/components/facilitator_folder/schedule_Screen.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/constants/route_name.dart';
// import 'package:scorer_web/controller/facil_dashboard_controller.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/create_container.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/custom_dashboard_container.dart';
// import 'package:scorer_web/widgets/custom_response_container.dart';
// import 'package:scorer_web/widgets/custom_sloder_row.dart';
// import 'package:scorer_web/widgets/custom_stack_image.dart';
// import 'package:scorer_web/widgets/forward_button_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/players_containers.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
// import 'package:scorer_web/widgets/useable_text_row.dart';
// // import 'package:syncfusion_flutter_sliders/sliders.dart';
//
//
//
// class GameScreenAdminside extends StatelessWidget {
//   const GameScreenAdminside({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Expanded(
//              child: Column(
//               children: [
//                  GradientColor(
//                 height: 200.h,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40.r),
//                       topRight: Radius.circular(40.r)
//                     ),
//                   // color: AppColors.whiteColor,
//
//                   ),
//                   // color: AppColors.whiteColor,
//                   width: 794.w,
//                   height: 235.h,
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       // // Positioned(
//                       // //   top: 50.h,
//                       // //   left: -40.w,
//                       // //   child: ForwardButtonContainer(
//                       // //     onTap: () => Get.back(),
//                       // //     imageH: 20.h,
//                       // //     imageW: 23.5.w,
//                       // //     height1: 90.h,
//                       // //     height2: 65.h,
//                       // //     width1: 90.w,
//                       // //     width2: 65.w,
//                       // //     image: Appimages.arrowback,
//                       // //   ),
//                       // ),
//                       Positioned(
//                         top: -140,
//                         right: 312.w,
//                         left: 312.w,
//                         child: CustomStackImage(
//                           image: Appimages.prince2,
//                           text: "Administrator",
//                         ),
//                       ),
//                    Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                          Center(
//                         child: BoldText(
//                           text: "Game Format Management",
//                           fontSize: 48.sp,
//                           selectionColor: AppColors.blueColor,
//                         ),
//                       ),
//                        MainText(text: "Each of these formats has its own logic, flow,\nand evaluation methods.",fontSize: 22.sp,
//                        textAlign: TextAlign.center,
//                        )
//
//                     ],
//                    )
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// ✅ Scrollable Area
//               Expanded(
//                 child: GradientColor(
//                   ishow: false,
//                   child: Container(
//                     width: 794.w,
//                     decoration: BoxDecoration(
//                       // color: AppColors.whiteColor,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(40.r),
//                         bottomRight: Radius.circular(40.r)
//                       ),
//                     ),
//                     child: ScrollConfiguration(
//                         behavior: ScrollConfiguration.of(context).copyWith(
//                       scrollbars: false, // ✅ ye side wali scrollbar hatayega
//                     ),
//                       child: SingleChildScrollView(
//                         child: Padding(
//                           padding:  EdgeInsets.symmetric(horizontal: 70.w),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               GameUseAbleContainer(),
//                               SizedBox(height: 25.h,),
//                                GameUseAbleContainer(),
//                               SizedBox(height: 25.h,), GameUseAbleContainer(),
//                               SizedBox(height: 25.h,), GameUseAbleContainer(),
//                               SizedBox(height: 25.h,),
//
//
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ],
//              ),
//            );
//   }
// }