
// Updated CreateNewSessionScreen with only required fields
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/appcolors.dart';
import '../../constants/appimages.dart';
import '../../view/gradient_background.dart';
import '../../view/gradient_color.dart';
import '../../widgets/bold_text.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/login_button.dart';
import '../../widgets/main_text.dart';
import '../../api/api_controllers/toselectgameformatforsessioncontroller.dart';

class CreateNewSessionScreen extends StatefulWidget {
  const CreateNewSessionScreen({super.key});

  @override
  State<CreateNewSessionScreen> createState() => _CreateNewSessionScreenState();
}

class _CreateNewSessionScreenState extends State<CreateNewSessionScreen> {
  late final ToSelectGameFormatForSessionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ToSelectGameFormatForSessionController());
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();

    // First select date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.forwardColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // Then select time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.forwardColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    // Combine date and time
    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    controller.setStartTime(selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            CustomAppbar(ishow: true),
            SizedBox(height: 30.h),

            GradientColor(
              height: 150.h,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                width: 794.w,
                height: 150.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 50.h,
                      left: 40.w,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30.sp,
                            color: AppColors.blueColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -60,
                      right: 272.w,
                      left: 272.w,
                      child: Image.asset(
                        Appimages.game,
                        height: 200.h,
                        width: 200.w,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: BoldText(
                            text: "Create New Session",
                            fontSize: 42.sp,
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
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Session Name
                          _buildTextField(
                            label: "Session Name",
                            controller: controller.sessionNameController,
                            errorText: controller.sessionNameError,
                            hint: "Enter session name",
                          ),
                          SizedBox(height: 20.h),

                          // Description
                          _buildTextField(
                            label: "Description",
                            controller: controller.descriptionController,
                            errorText: controller.descriptionError,
                            hint: "Enter session description",
                            maxLines: 3,
                          ),
                          SizedBox(height: 20.h),

                          // Duration
                          _buildTextField(
                            label: "Duration (minutes)",
                            controller: controller.durationController,
                            errorText: controller.durationError,
                            hint: "Enter duration in minutes",
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 30.h),

                          // Game Format Selection
                          BoldText(
                            text: "Select Game Format",
                            selectionColor: AppColors.blueColor,
                            fontSize: 32.sp,
                          ),
                          SizedBox(height: 15.h),

                          // Search Bar
                          Container(
                            width: 600.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.greyColor,
                                width: 2.w,
                              ),
                            ),
                            child: TextField(
                              controller: controller.searchController,
                              decoration: InputDecoration(
                                hintText: "Search game format...",
                                hintStyle: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 28.sp,
                                  color: AppColors.greyColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 18.h,
                                  horizontal: 20.w,
                                ),
                              ),
                              onChanged: controller.filterGameFormats,
                            ),
                          ),

                          // Game Format Error
                          Obx(() => controller.gameFormatError.isNotEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              controller.gameFormatError.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                          )
                              : SizedBox(height: 15.h)),

                          // Game Format List
                          Obx(() => controller.isGameFormatsLoading.value
                              ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: CircularProgressIndicator(color: AppColors.forwardColor),
                            ),
                          )
                              : Container(
                            width: 600.w,
                            constraints: BoxConstraints(maxHeight: 300.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyColor,
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              color: Colors.white,
                            ),
                            child: controller.filteredGameFormats.isEmpty
                                ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 50.sp,
                                      color: AppColors.greyColor,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      controller.searchController.text.isEmpty
                                          ? "No game formats available"
                                          : "No game formats found",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              itemCount: controller.filteredGameFormats.length,
                              itemBuilder: (context, index) {
                                final format = controller.filteredGameFormats[index];
                                return Obx(() {
                                  final isSelected = controller.selectedGameFormat.value?.id == format.id;
                                  return GestureDetector(
                                    onTap: () => controller.selectGameFormat(format),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                        horizontal: 15.w,
                                      ),
                                      padding: EdgeInsets.all(15.w),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.forwardColor.withOpacity(0.1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(15.r),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.forwardColor
                                              : AppColors.greyColor,
                                          width: isSelected ? 2.w : 1.w,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  format.displayName,
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.blueColor,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check_circle,
                                                  color: AppColors.forwardColor,
                                                  size: 24.sp,
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            format.displayDescription,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppColors.teamColor,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 18.sp,
                                                color: AppColors.greyColor,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                '${format.timeDuration ?? 0} min',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppColors.greyColor,
                                                ),
                                              ),
                                              SizedBox(width: 15.w),
                                              Icon(
                                                Icons.people,
                                                size: 18.sp,
                                                color: AppColors.greyColor,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                format.mode?.toUpperCase() ?? 'UNKNOWN',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppColors.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          )),

                          SizedBox(height: 30.h),

                          // Selected Game Format Info
                          Obx(() => controller.selectedGameFormat.value != null
                              ? Container(
                            width: 600.w,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: AppColors.forwardColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: AppColors.forwardColor,
                                width: 2.w,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.forwardColor,
                                      size: 24.sp,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Selected Game:',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blueColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  controller.selectedGameFormat.value!.displayName,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.selectedGameFormat.value!.displayDescription,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : SizedBox.shrink()),

                          SizedBox(height: 30.h),

                          // Start Time Selection
                          BoldText(
                            text: "Session Start Time",
                            selectionColor: AppColors.blueColor,
                            fontSize: 28.sp,
                          ),
                          SizedBox(height: 15.h),

                          Obx(() => Container(
                            width: 600.w,
                            height: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: controller.startTimeError.isNotEmpty
                                    ? Colors.red
                                    : AppColors.greyColor,
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: InkWell(
                              onTap: () => _selectDateTime(context),
                              borderRadius: BorderRadius.circular(20.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.startedAt.value != null
                                          ? DateFormat('MMM d, yyyy, h:mm a').format(controller.startedAt.value!)
                                          : "Select date and time",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: controller.startedAt.value != null
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColors.forwardColor,
                                      size: 28.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),

                          Obx(() => controller.startTimeError.isNotEmpty
                              ? Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              controller.startTimeError.value,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                          )
                              : SizedBox(height: 10.h)),

                          SizedBox(height: 30.h),

                          // Action Buttons
                          Obx(() => controller.isLoading.value
                              ? Center(
                            child: CircularProgressIndicator(color: AppColors.forwardColor),
                          )
                              : Column(
                            children: [
                              LoginButton(
                                text: "Start Immediately",
                                ishow: true,
                                icon: Icons.play_arrow_rounded,
                                fontSize: 24.sp,
                                height: 65.h,
                                onTap: () async {
                                  await controller.createSession(scheduleForLater: false);
                                },
                              ),
                              SizedBox(height: 15.h),
                              LoginButton(
                                text: controller.startedAt.value != null
                                    ? "Schedule for ${DateFormat('MMM d').format(controller.startedAt.value!)}"
                                    : "Schedule for Later",
                                image: Appimages.calender,
                                ishow: true,
                                color: AppColors.forwardColor,
                                fontSize: 24.sp,
                                height: 65.h,
                                onTap: () async {
                                  if (controller.startedAt.value == null) {
                                    await _selectDateTime(context);
                                  }
                                  if (controller.startedAt.value != null) {
                                    await controller.createSession(scheduleForLater: true);
                                  }
                                },
                              ),
                            ],
                          )),

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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required RxString errorText,
    String hint = '',
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(
          text: label,
          fontSize: 24.sp,
          selectionColor: AppColors.blueColor,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: errorText.isNotEmpty ? Colors.red : AppColors.greyColor,
              width: 1.5.w,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: maxLines > 1 ? 20.h : 0,
              ),
            ),
            style: TextStyle(
              fontSize: 20.sp,
            ),
          ),
        ),
        Obx(() => errorText.isNotEmpty
            ? Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Text(
            errorText.value,
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
            ),
          ),
        )
            : SizedBox(height: 5.h)),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:scorer_web/components/responsive_fonts.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/view/gradient_background.dart';
// import 'package:scorer_web/view/gradient_color.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/custom_appbar.dart';
// import 'package:scorer_web/widgets/filter_useable_container.dart';
// import 'package:scorer_web/widgets/game_select_useable_container.dart';
// import 'package:scorer_web/widgets/login_button.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// // Import your controller - adjust path as needed
// import '../../api/api_controllers/create_game_format_controller.dart';
//
// class CreateNewSessionScreen extends StatefulWidget {
//   final bool isSelected;
//
//   const CreateNewSessionScreen({super.key, this.isSelected = true});
//
//   @override
//   State<CreateNewSessionScreen> createState() => _CreateNewSessionScreenState();
// }
//
// class _CreateNewSessionScreenState extends State<CreateNewSessionScreen> {
//   late final UnifiedCreateGameFormatController controller;
//   final TextEditingController _customPlayersController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(UnifiedCreateGameFormatController());
//     print("🔹 [CreateNewSessionScreen] Web Initialized");
//   }
//
//   Future<void> _selectDateTime(BuildContext context) async {
//     print("🔹 [CreateNewSessionScreen] Opening date-time picker");
//     final DateTime now = DateTime.now();
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: now.add(const Duration(days: 1)),
//       firstDate: now,
//       lastDate: now.add(const Duration(days: 365)),
//     );
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//       if (pickedTime != null) {
//         final selectedDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//         controller.setStartedAt(selectedDateTime);
//         print(
//           "🔹 [CreateNewSessionScreen] Date-time selected: $selectedDateTime",
//         );
//       } else {
//         print("🔹 [CreateNewSessionScreen] Time picker cancelled");
//       }
//     } else {
//       print("🔹 [CreateNewSessionScreen] Date picker cancelled");
//     }
//   }
//
//   Widget _buildPlayerCapacitySection() {
//     return Column(
//       children: [
//         BoldText(
//           text: "player_capacity".tr,
//           selectionColor: AppColors.blueColor,
//           fontSize: 30.sp,
//         ),
//         SizedBox(height: 30.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildPlayerCapacityOption(
//               image: Appimages.pas,
//               range: "5-20",
//               label: "small".tr,
//               min: 5,
//               max: 20,
//             ),
//             _buildPlayerCapacityOption(
//               image: Appimages.pas,
//               range: "21-50",
//               label: "medium".tr,
//               min: 21,
//               max: 50,
//             ),
//             _buildPlayerCapacityOption(
//               image: Appimages.pas,
//               range: "51-100",
//               label: "large".tr,
//               min: 51,
//               max: 100,
//             ),
//           ],
//         ),
//         SizedBox(height: 30.h),
//         Container(
//           height: 70.h,
//           width: 400.w,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24.r),
//             border: Border.all(
//               color: AppColors.greyColor,
//               width: 1.5.w,
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _customPlayersController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       hintText: "enter_custom_number".tr,
//                       border: InputBorder.none,
//                       hintStyle: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 24.sp,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       if (value.isNotEmpty) {
//                         final count = int.tryParse(value) ?? 0;
//                         controller.setPlayerRange(count, count);
//                       }
//                     },
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (_customPlayersController.text.isNotEmpty) {
//                       final count = int.tryParse(_customPlayersController.text) ?? 0;
//                       if (count > 0) {
//                         controller.setPlayerRange(count, count);
//                         Get.snackbar('Success', 'Player capacity set to $count');
//                       }
//                     }
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                     decoration: BoxDecoration(
//                       color: AppColors.forwardColor,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Text(
//                       "apply".tr,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPlayerCapacityOption({
//     required String image,
//     required String range,
//     required String label,
//     required int min,
//     required int max,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         controller.setPlayerRange(min, max);
//       },
//       child: Obx(() {
//         final isSelected = controller.minPlayers.value == min &&
//             controller.maxPlayers.value == max;
//         return Container(
//           padding: EdgeInsets.all(20.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.r),
//             border: Border.all(
//               color: isSelected ? AppColors.forwardColor : AppColors.greyColor,
//               width: isSelected ? 2.w : 1.w,
//             ),
//             color: isSelected ? AppColors.forwardColor.withOpacity(0.1) : Colors.transparent,
//           ),
//           child: Column(
//             children: [
//               Image.asset(
//                 image,
//                 width: 120.w,
//                 height: 100.h,
//               ),
//               SizedBox(height: 10.h),
//               BoldText(
//                 text: range,
//                 fontSize: 24.sp,
//                 selectionColor: AppColors.blueColor,
//               ),
//               MainText(
//                 text: label,
//                 fontSize: 20.sp,
//                 height: 1.7,
//                 color: isSelected ? AppColors.forwardColor : AppColors.teamColor,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildBadgeSection() {
//     return Column(
//       children: [
//         BoldText(
//           text: "badge_labeling".tr,
//           fontSize: 30.sp,
//           selectionColor: AppColors.blueColor,
//         ),
//         SizedBox(height: 20.h),
//         Image.asset(
//           Appimages.badge,
//           width: 200.w,
//           height: 160.h,
//         ),
//         SizedBox(height: 20.h),
//         Container(
//           width: 400.w,
//           padding: EdgeInsets.all(20.w),
//           decoration: BoxDecoration(
//             border: Border.all(color: AppColors.greyColor),
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Column(
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "enter_badge_name".tr,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//                 onSubmitted: (value) {
//                   if (value.isNotEmpty) {
//                     controller.addBadgeName(value);
//                     Get.snackbar('Success', 'Badge added: $value');
//                   }
//                 },
//               ),
//               SizedBox(height: 15.h),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: "required_score".tr,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//                 onSubmitted: (value) {
//                   final score = int.tryParse(value);
//                   if (score != null) {
//                     controller.setBadgeScore(score);
//                   }
//                 },
//               ),
//               SizedBox(height: 15.h),
//               Obx(() => controller.badgeNames.isEmpty
//                   ? Container()
//                   : Column(
//                 children: [
//                   BoldText(
//                     text: "current_badges".tr,
//                     fontSize: 20.sp,
//                   ),
//                   SizedBox(height: 10.h),
//                   Wrap(
//                     spacing: 10.w,
//                     children: controller.badgeNames.map((badge) {
//                       return Chip(
//                         label: Text(badge),
//                         onDeleted: () => controller.removeBadgeName(badge),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               )),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Column(
//           children: [
//             /// ✅ Fixed Appbar
//             CustomAppbar(ishow: true),
//             SizedBox(height: 30.h),
//
//             /// ✅ Fixed Top Container
//             GradientColor(
//               height: 150.h,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40.r),
//                     topRight: Radius.circular(40.r),
//                   ),
//                 ),
//                 width: 794.w,
//                 height: 150.h,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Positioned(
//                       top: 50.h,
//                       left: 40.w,
//                       child: GestureDetector(
//                         onTap: () => Get.back(),
//                         child: Container(
//                           padding: EdgeInsets.all(15.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15.r),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 10,
//                               ),
//                             ],
//                           ),
//                           child: Icon(
//                             Icons.arrow_back,
//                             size: 30.sp,
//                             color: AppColors.blueColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: -60,
//                       right: 272.w,
//                       left: 272.w,
//                       child: Image.asset(
//                         Appimages.game,
//                         height: 200.h,
//                         width: 200.w,
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
//                                   text: "create_ne".tr,
//                                   style: TextStyle(
//                                     fontSize: 42.sp,
//                                     color: AppColors.blueColor,
//                                   ),
//                                 ),
//                                 WidgetSpan(
//                                   alignment: PlaceholderAlignment.middle,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(bottom: 10.h),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Color(0xff8DC046),
//                                         borderRadius: const BorderRadius.only(
//                                           topLeft: Radius.circular(25),
//                                           bottomLeft: Radius.circular(25),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "w".tr,
//                                         style: TextStyle(
//                                           fontSize: 42.sp,
//                                           color: AppColors.blueColor,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 WidgetSpan(
//                                   alignment: PlaceholderAlignment.middle,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(bottom: 10.h),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: AppColors.forwardColor,
//                                         borderRadius: const BorderRadius.only(
//                                           topRight: Radius.circular(25),
//                                           bottomRight: Radius.circular(25),
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                           left: 4.0,
//                                           right: 10.0,
//                                         ),
//                                         child: Text(
//                                           "session".tr,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 42.sp,
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
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40.r),
//                       bottomRight: Radius.circular(40.r),
//                     ),
//                   ),
//                   child: ScrollConfiguration(
//                     behavior: ScrollConfiguration.of(context).copyWith(
//                       scrollbars: false,
//                     ),
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 40.w,
//                         vertical: 20.h,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 100.h,
//                             child: TextFormField(
//                               controller: controller.sessionNameController,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 32.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: "enter_session_name".tr,
//                                 hintStyle: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.languageTextColor,
//                                   fontSize: 32.sp,
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   vertical: 25.h,
//                                   horizontal: 20.w,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30.r),
//                                   borderSide: BorderSide(
//                                     color: AppColors.assignColor,
//                                     width: 2.w,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30.r),
//                                   borderSide: BorderSide(
//                                     color: AppColors.assignColor,
//                                     width: 2.w,
//                                   ),
//                                 ),
//                                 errorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30.r),
//                                   borderSide: BorderSide(
//                                     color: Colors.red,
//                                     width: 2.w,
//                                   ),
//                                 ),
//                                 focusedErrorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30.r),
//                                   borderSide: BorderSide(
//                                     color: Colors.red,
//                                     width: 2.w,
//                                   ),
//                                 ),
//                               ),
//                               validator: controller.validateSessionName,
//                             ),
//                           ),
//                           SizedBox(height: 40.h),
//                           BoldText(
//                             text: "select_game_format".tr,
//                             selectionColor: AppColors.blueColor,
//                             fontSize: 32.sp,
//                           ),
//                           SizedBox(height: 20.h),
//
//                           // Search Bar
//                           Container(
//                             width: 600.w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20.r),
//                               border: Border.all(
//                                 color: AppColors.greyColor,
//                                 width: 2.w,
//                               ),
//                             ),
//                             child: TextField(
//                               controller: controller.searchController,
//                               decoration: InputDecoration(
//                                 hintText: "search_game_format".tr,
//                                 hintStyle: TextStyle(
//                                   fontSize: 24.sp,
//                                   color: Colors.grey,
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.search,
//                                   size: 30.sp,
//                                   color: AppColors.greyColor,
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.symmetric(
//                                   vertical: 20.h,
//                                   horizontal: 20.w,
//                                 ),
//                               ),
//                               onChanged: (query) {
//                                 controller.filterGameFormats(query);
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 20.h),
//
//                           // Game Format Selection
//                           Obx(() => controller.isGameFormatsLoading.value
//                               ? Center(child: CircularProgressIndicator())
//                               : Container(
//                             width: 600.w,
//                             constraints: BoxConstraints(maxHeight: 300.h),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.greyColor,
//                                 width: 1.5.w,
//                               ),
//                               borderRadius: BorderRadius.circular(20.r),
//                               color: Colors.white,
//                             ),
//                             child: controller.filteredGameFormats.isEmpty
//                                 ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.search_off,
//                                     size: 50.sp,
//                                     color: AppColors.greyColor,
//                                   ),
//                                   SizedBox(height: 10.h),
//                                   Text(
//                                     controller.searchController.text.isEmpty
//                                         ? "no_game_formats_available".tr
//                                         : "no_game_formats_found".tr,
//                                     style: TextStyle(
//                                       fontSize: 22.sp,
//                                       color: AppColors.greyColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                                 : ListView.builder(
//                               padding: EdgeInsets.symmetric(vertical: 10.h),
//                               itemCount: controller.filteredGameFormats.length,
//                               itemBuilder: (context, index) {
//                                 final format = controller.filteredGameFormats[index];
//                                 if (format.name?.isEmpty ?? true) {
//                                   return SizedBox.shrink();
//                                 }
//
//                                 return Obx(() {
//                                   final isSelected = controller.selectedGameFormatIds.contains(format.id);
//                                   return Padding(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: 8.h,
//                                       horizontal: 20.w,
//                                     ),
//                                     child: GameSelectUseableContainer(
//                                       fontSize: 20.sp,
//                                       text1: format.name ?? 'Unnamed Game',
//                                       text2: format.description?.isNotEmpty == true
//                                           ? format.description!
//                                           : '${format.mode?.toUpperCase() ?? ''} • ${format.totalPhases ?? 0} Phases',
//                                       isSelected: isSelected,
//                                       onTap: () {
//                                         final formatId = format.id ?? 0;
//                                         controller.toggleGameFormatSelection(formatId);
//                                       },
//                                     ),
//                                   );
//                                 });
//                               },
//                             ),
//                           )),
//
//                           SizedBox(height: 40.h),
//                           _buildPlayerCapacitySection(),
//                           SizedBox(height: 40.h),
//                           _buildBadgeSection(),
//                           SizedBox(height: 40.h),
//
//                           // AI Scoring Section
//                           Container(
//                             width: 600.w,
//                             height: 120.h,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.greyColor,
//                                 width: 1.5.w,
//                               ),
//                               borderRadius: BorderRadius.circular(24.r),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 30.w),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Image.asset(
//                                         Appimages.ai2,
//                                         width: 80.w,
//                                         height: 80.h,
//                                       ),
//                                       SizedBox(width: 20.w),
//                                       Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           MainText(
//                                             text: "ai_scoring".tr,
//                                             fontSize: 26.sp,
//                                           ),
//                                           SizedBox(height: 5.h),
//                                           MainText(
//                                             text: "enable_ai_scoring".tr,
//                                             fontSize: 20.sp,
//                                             color: AppColors.teamColor,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Obx(() => FlutterSwitch(
//                                     value: controller.aiScoring.value,
//                                     onToggle: (val) {
//                                       controller.setAiScoring(val);
//                                     },
//                                     height: 35.sp,
//                                     width: 60.sp,
//                                     activeColor: AppColors.forwardColor,
//                                    // inactiveColor: Colors.grey[300],
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           SizedBox(height: 40.h),
//
//                           // Additional Settings
//                           Container(
//                             width: 600.w,
//                             padding: EdgeInsets.all(30.w),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.greyColor,
//                                 width: 1.5.w,
//                               ),
//                               borderRadius: BorderRadius.circular(24.r),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 BoldText(
//                                   text: "additional_settings".tr,
//                                   fontSize: 28.sp,
//                                 ),
//                                 SizedBox(height: 20.h),
//                                 _buildSettingRow(
//                                   "allow_later_join".tr,
//                                   controller.allowLaterJoin.value,
//                                       (val) => controller.setAllowLaterJoin(val),
//                                 ),
//                                 SizedBox(height: 15.h),
//                                 _buildSettingRow(
//                                   "send_invitation".tr,
//                                   controller.sendInvitation.value,
//                                       (val) => controller.setSendInvitation(val),
//                                 ),
//                                 SizedBox(height: 15.h),
//                                 _buildSettingRow(
//                                   "record_session".tr,
//                                   controller.recordSession.value,
//                                       (val) => controller.setRecordSession(val),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(height: 50.h),
//
//                           // Action Buttons
//                           Obx(() => controller.isLoadingImmediate.value
//                               ? Center(child: CircularProgressIndicator())
//                               : LoginButton(
//                             text: "start_immediately".tr,
//                             ishow: true,
//                             icon: Icons.play_arrow_rounded,
//                             fontSize: 26.sp,
//                             height: 70.h,
//                             onTap: () async {
//                               print("🔹 Starting session immediately");
//                               bool success = await controller.createSession();
//                               if (success) {
//                                 Get.snackbar('Success', 'Session created successfully!');
//                                 // Add your web navigation here
//                                 // Get.off(() => WebDashboard());
//                               }
//                             },
//                           )),
//
//                           SizedBox(height: 20.h),
//
//                           Obx(() => controller.isLoadingScheduled.value
//                               ? Center(child: CircularProgressIndicator())
//                               : LoginButton(
//                             text: controller.startedAt.value != null
//                                 ? DateFormat('MMM d, yyyy, h:mm a').format(controller.startedAt.value!)
//                                 : "schedule_for_later".tr,
//                             image: Appimages.calender,
//                             ishow: true,
//                             color: AppColors.forwardColor,
//                             fontSize: 26.sp,
//                             height: 70.h,
//                             onTap: () async {
//                               await _selectDateTime(context);
//                               if (controller.startedAt.value != null) {
//                                 bool success = await controller.createSession(
//                                   scheduleForLater: true,
//                                 );
//                                 if (success) {
//                                   Get.snackbar('Success', 'Session scheduled successfully!');
//                                   // Add your web navigation here
//                                   // Get.off(() => WebDashboard());
//                                 }
//                               }
//                             },
//                           )),
//
//                           SizedBox(height: 50.h),
//                         ],
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
//
//   Widget _buildSettingRow(String title, bool value, Function(bool) onChanged) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         MainText(
//           text: title,
//           fontSize: 22.sp,
//         ),
//         FlutterSwitch(
//           value: value,
//           onToggle: onChanged,
//           height: 30.sp,
//           width: 50.sp,
//           activeColor: AppColors.forwardColor,
//          // inactiveColor: Colors.grey[300],
//         ),
//       ],
//     );
//   }
// }