import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/widgets/add_one_Container.dart';
import 'package:scorer_web/widgets/setting_container.dart';
import 'package:scorer_web/controller/language_selection_controller.dart';
import '../constants/route_name.dart';

class CustomAppbar extends StatefulWidget {
  final VoidCallback? onTap;
  final bool ishow4;
  final bool ishow;
  final bool isShow;
  final double? top;
  final double? right;
  final double? height3;
  final double? width3;
  final double? borderW;
  final double? arrowH;
  final double? arrowW;
  final String? text;
  final double? right2;
  final bool ishow3;
  final double? padding1;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;
  final bool? isSmallScreen;
  final bool showLanguageSelector; // ✅ NEW

  const CustomAppbar({
    super.key,
    this.ishow = false,
    this.isShow = true,
    this.top,
    this.right,
    this.height3,
    this.width3,
    this.borderW,
    this.arrowH,
    this.arrowW,
    this.text,
    this.right2,
    this.ishow3 = false,
    this.ishow4 = false,
    this.onTap,
    this.padding1,
    this.isSmallScreen,
    this.onSettingsTap,
    this.onNotificationTap,
    this.showLanguageSelector = true, // ✅ NEW - Show by default
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar>
    with TickerProviderStateMixin {
  late AnimationController _leftController;
  late AnimationController _rightController;
  late Animation<Offset> _leftSlide;
  late Animation<Offset> _rightSlide;
  late Animation<double> _leftFade;
  late Animation<double> _rightFade;

  final LanguageSelectionController languageController =
  Get.put(LanguageSelectionController());

  @override
  void initState() {
    super.initState();

    _leftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _rightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _leftSlide = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _leftController, curve: Curves.easeOut));

    _rightSlide = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _rightController, curve: Curves.easeOut));

    _leftFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _leftController, curve: Curves.easeInOut));
    _rightFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _rightController, curve: Curves.easeInOut));

    _leftController.forward();
    Future.delayed(const Duration(milliseconds: 150),
            () => _rightController.forward());
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive values
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    final appBarHeight = isMobile ? 120.h : (isTablet ? 150.h : 187.h);
    final logoWidth = isMobile ? 80.w : (isTablet ? 100.w : 136.w);
    final logoHeight = isMobile ? 70.h : (isTablet ? 90.h : 118.h);
    final horizontalPadding = isMobile ? 20.w : (isTablet ? 80.w : 175.w);

    return Container(
      width: double.infinity,
      height: appBarHeight,
      color: AppColors.whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ==================== LEFT LOGO ====================
            SlideTransition(
              position: _leftSlide,
              child: FadeTransition(
                opacity: _leftFade,
                child: SvgPicture.asset(
                  Appimages.splash,
                  width: logoWidth,
                  height: logoHeight,
                ),
              ),
            ),

            // ==================== RIGHT ACTIONS ====================
            SlideTransition(
              position: _rightSlide,
              child: FadeTransition(
                opacity: _rightFade,
                child: widget.ishow3
                    ? const SizedBox()
                    : widget.ishow
                    ? Image.asset(
                  Appimages.house1,
                  width: isMobile ? 150.w : (isTablet ? 180.w : 205.w),
                  height: isMobile ? 100.h : (isTablet ? 120.h : 156.h),
                )
                    : Row(
                  children: [
                    // ✅ LANGUAGE SELECTOR
                    if (widget.showLanguageSelector)
                      _buildLanguageSelector(isMobile, isTablet),

                    if (widget.showLanguageSelector)
                      SizedBox(width: isMobile ? 4.w : 6.w),

                    // Settings Button
                    GestureDetector(
                      onTap: widget.onSettingsTap ??
                              () {
                            Get.toNamed(RouteName.settingsScreen);
                          },
                      child: SettingContainer(
                        icons: Icons.settings,
                        size: isMobile ? 40.w : null,
                      ),
                    ),
                    SizedBox(width: isMobile ? 4.w : 6.w),

                    // Notifications Button
                    GestureDetector(
                      onTap: widget.onNotificationTap ??
                              () {
                            Get.toNamed(RouteName.notificationScreen);
                          },
                      child: SettingContainer(
                        icons: Icons.notifications,
                        ishow: true,
                        size: isMobile ? 40.w : null,
                      ),
                    ),
                    SizedBox(width: isMobile ? 4.w : 6.w),

                    // Create/Add Button
                    if (!widget.ishow4)
                      Padding(
                        padding: EdgeInsets.all(isMobile ? 4.w : 8.w),
                        child: AddOneContainer(
                          padding1: widget.padding1,
                          right2: widget.right2,
                          top: widget.top,
                          text: widget.text,
                          right: widget.right,
                          height3: widget.height3,
                          width3: widget.width3,
                          borderW: widget.borderW,
                          arrowH: widget.arrowH,
                          arrowW: widget.arrowW,
                          isShow: widget.isShow,
                          icon: Icons.add,
                          onTap: widget.onTap,
                          minSize: isMobile ? 50 : 60,
                          maxSize: isMobile ? 80 : 120,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== LANGUAGE SELECTOR ====================
  Widget _buildLanguageSelector(bool isMobile, bool isTablet) {
    final languages = [
      {'code': 'en', 'flag': '🇬🇧', 'name': 'English', 'index': 0},
      {'code': 'es', 'flag': '🇪🇸', 'name': 'Español', 'index': 1},
      {'code': 'fr', 'flag': '🇫🇷', 'name': 'Français', 'index': 2},
    ];

    return Obx(() {
      final currentIndex = languageController.selectLangauge.value;
      final currentLang = currentIndex < languages.length
          ? languages[currentIndex]
          : languages[0];

      return Container(
        height: isMobile ? 40.h : (isTablet ? 50.h : 60.h),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8.w : 12.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: AppColors.forwardColor.withOpacity(0.3),
            width: 1.5.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: currentIndex < 3 ? currentIndex : 0,
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: isMobile ? 18.sp : 20.sp,
              color: AppColors.forwardColor,
            ),
            elevation: 8,
            borderRadius: BorderRadius.circular(12.r),
            dropdownColor: AppColors.whiteColor,
            items: languages.map((lang) {
              return DropdownMenuItem<int>(
                value: lang['index'] as int,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang['flag'] as String,
                      style: TextStyle(fontSize: isMobile ? 18.sp : 20.sp),
                    ),
                    if (!isMobile) ...[
                      SizedBox(width: 6.w),
                      Text(
                        lang['code'] as String,
                        style: TextStyle(
                          fontSize: isMobile ? 12.sp : (isTablet ? 14.sp : 16.sp),
                          fontWeight: FontWeight.w500,
                          color: AppColors.languageColor,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                languageController.select(newValue);
              }
            },
            selectedItemBuilder: (BuildContext context) {
              return languages.map((lang) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang['flag'] as String,
                      style: TextStyle(fontSize: isMobile ? 18.sp : 20.sp),
                    ),
                    if (!isMobile) ...[
                      SizedBox(width: 6.w),
                      Text(
                        lang['code'] as String,
                        style: TextStyle(
                          fontSize: isMobile ? 12.sp : (isTablet ? 14.sp : 16.sp),
                          fontWeight: FontWeight.w600,
                          color: AppColors.forwardColor,
                        ),
                      ),
                    ],
                  ],
                );
              }).toList();
            },
          ),
        ),
      );
    });
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/constants/appimages.dart';
// import 'package:scorer_web/widgets/add_one_Container.dart';
// import 'package:scorer_web/widgets/setting_container.dart';
// import '../constants/route_name.dart';
//
// class CustomAppbar extends StatefulWidget {
//   final VoidCallback? onTap;
//   final bool ishow4;
//   final bool ishow;
//   final bool isShow;
//   final double? top;
//   final double? right;
//   final double? height3;
//   final double? width3;
//   final double? borderW;
//   final double? arrowH;
//   final double? arrowW;
//   final String? text;
//   final double? right2;
//   final bool ishow3;
//   final double? padding1;
//   final VoidCallback? onSettingsTap;
//   final VoidCallback? onNotificationTap;
//   final bool? isSmallScreen;
//
//   const CustomAppbar({
//     super.key,
//     this.ishow = false,
//     this.isShow = true,
//     this.top,
//     this.right,
//     this.height3,
//     this.width3,
//     this.borderW,
//     this.arrowH,
//     this.arrowW,
//     this.text,
//     this.right2,
//     this.ishow3 = false,
//     this.ishow4 = false,
//     this.onTap,
//     this.padding1,
//     this.isSmallScreen,
//     this.onSettingsTap,
//     this.onNotificationTap,
//   });
//
//   @override
//   State<CustomAppbar> createState() => _CustomAppbarState();
// }
//
// class _CustomAppbarState extends State<CustomAppbar>
//     with TickerProviderStateMixin {
//   late AnimationController _leftController;
//   late AnimationController _rightController;
//   late Animation<Offset> _leftSlide;
//   late Animation<Offset> _rightSlide;
//   late Animation<double> _leftFade;
//   late Animation<double> _rightFade;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _leftController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//
//     _rightController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _leftSlide = Tween<Offset>(
//       begin: const Offset(-0.3, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _leftController, curve: Curves.easeOut));
//
//     _rightSlide = Tween<Offset>(
//       begin: const Offset(0.3, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _rightController, curve: Curves.easeOut));
//
//     _leftFade = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _leftController, curve: Curves.easeInOut));
//     _rightFade = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _rightController, curve: Curves.easeInOut));
//
//     _leftController.forward();
//     Future.delayed(const Duration(milliseconds: 150),
//             () => _rightController.forward());
//   }
//
//   @override
//   void dispose() {
//     _leftController.dispose();
//     _rightController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 187.h,
//       color: AppColors.whiteColor,
//       child: Padding(
//         padding: EdgeInsets.only(left: 175.w, right: 127.w),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             /// Left side (Logo animation)
//             SlideTransition(
//               position: _leftSlide,
//               child: FadeTransition(
//                 opacity: _leftFade,
//                 child: SvgPicture.asset(
//                   Appimages.splash,
//                   width: 136.w,
//                   height: 118.h,
//                 ),
//               ),
//             ),
//
//             /// Right side (Icons animation)
//             SlideTransition(
//               position: _rightSlide,
//               child: FadeTransition(
//                 opacity: _rightFade,
//                 child: widget.ishow3
//                     ? const SizedBox()
//                     : widget.ishow
//                     ? Image.asset(
//                   Appimages.house1,
//                   width: 205.w,
//                   height: 156.h,
//                 )
//                     : Row(
//                   children: [
//                     // Settings Button
//                     GestureDetector(
//                       onTap: widget.onSettingsTap ??
//                               () {
//                             Get.toNamed(RouteName.settingsScreen);
//                           },
//                       child: SettingContainer(icons: Icons.settings),
//                     ),
//                     SizedBox(width: 6.w),
//
//                     // Notifications Button
//                     GestureDetector(
//                       onTap: widget.onNotificationTap ??
//                               () {
//                             Get.toNamed(RouteName.notificationScreen);
//                           },
//                       child: SettingContainer(
//                         icons: Icons.notifications,
//                         ishow: true,
//                       ),
//                     ),
//                     SizedBox(width: 6.w),
//                     SizedBox(height: 40,),
//                     // Create Button
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: widget.ishow4
//                           ? const SizedBox()
//                           : AddOneContainer(
//                         padding1: widget.padding1,
//                         right2: widget.right2,
//                         top: widget.top,
//                         text: widget.text,
//                         right: widget.right,
//                         height3: widget.height3,
//                         width3: widget.width3,
//                         borderW: widget.borderW,
//                         arrowH: widget.arrowH,
//                         arrowW: widget.arrowW,
//                         isShow: widget.isShow,
//                         icon: Icons.add,
//                         onTap: widget.onTap,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
