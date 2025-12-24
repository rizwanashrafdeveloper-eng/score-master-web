import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:scorer_web/constants/app_routes.dart';
import 'package:scorer_web/localization/app_translation.dart';
import 'package:scorer_web/localization/translation_service.dart';

import 'package:scorer_web/view/splash_Screen.dart';


// Import your controllers
import 'package:scorer_web/api/api_controllers/session_controller.dart';
import 'package:scorer_web/api/api_controllers/join_session_controller.dart';
import 'package:scorer_web/api/api_controllers/session_list_controller.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get.dart';

import 'api/api_controllers/login_controller_web.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize all your controllers here
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => SessionController(), fenix: true);
    Get.lazyPut(() => JoinSessionController(), fenix: true);
    Get.lazyPut(() => SessionsListController(), fenix: true);
    // Add other controllers as needed
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedLocale = await TranslationService().getSavedLocale();
  runApp(MyApp(locale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // ==================== RESPONSIVE CONFIGURATION ====================
      // Design size based on your primary design (usually desktop)
      designSize: const Size(1920, 1080),

      // Enable text scaling based on screen size
      minTextAdapt: true,

      // Enable split screen support
      splitScreenMode: true,

      // Use the builder to ensure ScreenUtil is initialized before building app
      builder: (context, child) {
        // Log screen information for debugging
        _logScreenInfo(context);

        return GetMaterialApp(
          // ==================== APP CONFIGURATION ====================
          title: 'Scorer Web',

          // Initialize controllers globally
          initialBinding: InitialBinding(),

          // Localization setup
          translations: AppTranslations(),
          locale: locale,
          fallbackLocale: const Locale('en', 'US'),

          // Routes
          getPages: AppRoutes.getAppRoutes(),

          // Theme configuration with responsive values
          theme: _buildResponsiveTheme(context),

          // Disable debug banner
          debugShowCheckedModeBanner: false,

          // Home screen
          home: SplashScreen(),
        );
      },
    );
  }

  /// Build responsive theme data
  ThemeData _buildResponsiveTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,

      // ==================== COLOR SCHEME ====================
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),

      // ==================== TEXT THEME (RESPONSIVE) ====================
      textTheme: TextTheme(
        // Display styles (largest text)
        displayLarge: TextStyle(fontSize: 57.sp, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),

        // Headline styles
        headlineLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),

        // Title styles
        titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),

        // Body styles (most common)
        bodyLarge: TextStyle(fontSize: 16.sp),
        bodyMedium: TextStyle(fontSize: 14.sp),
        bodySmall: TextStyle(fontSize: 12.sp),

        // Label styles (buttons, etc)
        labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
      ),

      // ==================== BUTTON THEMES (RESPONSIVE) ====================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          minimumSize: Size(100.w, 45.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          minimumSize: Size(100.w, 45.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          minimumSize: Size(80.w, 40.h),
        ),
      ),

      // ==================== INPUT DECORATION (RESPONSIVE) ====================
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),

      // ==================== CARD THEME (RESPONSIVE) - FIXED ====================
      cardTheme: CardThemeData(  // ✅ Changed from CardTheme to CardThemeData
        elevation: 2,
        margin: EdgeInsets.all(8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),

      // ==================== APP BAR THEME (RESPONSIVE) ====================
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ==================== ICON THEME (RESPONSIVE) ====================
      iconTheme: IconThemeData(
        size: 24.sp,
      ),

      // ==================== DIVIDER THEME (RESPONSIVE) ====================
      dividerTheme: DividerThemeData(
        thickness: 1.w,
        space: 16.h,
      ),
    );
  }

  /// Log screen information for debugging
  void _logScreenInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    print('╔════════════════════════════════════════╗');
    print('║     RESPONSIVE SCREEN INFORMATION     ║');
    print('╠════════════════════════════════════════╣');
    print('║ Width:        ${size.width.toStringAsFixed(2)} px');
    print('║ Height:       ${size.height.toStringAsFixed(2)} px');
    print('║ Pixel Ratio:  ${pixelRatio.toStringAsFixed(2)}');
    print('║ Device Type:  ${_getDeviceType(size.width)}');
    print('╚════════════════════════════════════════╝');
  }

  String _getDeviceType(double width) {
    if (width < 600) return 'Mobile 📱';
    if (width < 1200) return 'Tablet 📱';
    return 'Desktop 💻';
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:scorer_web/components/admin_folder.dart/admin_schedule_folder.dart';
// import 'package:scorer_web/components/admin_folder.dart/user_administrate_side.dart';
// import 'package:scorer_web/components/admin_folder.dart/user_player_side_Screen.dart';
// import 'package:scorer_web/components/facilitator_folder/audio_container.dart';
// import 'package:scorer_web/constants/app_routes.dart';
// import 'package:scorer_web/localization/app_translation.dart';
// import 'package:scorer_web/localization/translation_service.dart';
// import 'package:scorer_web/view/AudioWaveExample.dart';
// import 'package:scorer_web/view/FacilitatorFolder/create_new_session_screen.dart';
// import 'package:scorer_web/view/FacilitatorFolder/end_session_Screen.dart';
// import 'package:scorer_web/view/FacilitatorFolder/evaluate_response_Screen.dart';
// import 'package:scorer_web/view/FacilitatorFolder/evauate_response_Screen2.dart';
// import 'package:scorer_web/view/FacilitatorFolder/facilitator_dashboard.dart';
// import 'package:scorer_web/view/FacilitatorFolder/over_view_option_screen.dart';
// import 'package:scorer_web/view/FacilitatorFolder/view_response_Screen.dart';
// import 'package:scorer_web/view/FacilitatorFolder/view_score_Screen.dart';
// import 'package:scorer_web/view/adminFolder/admin_dashboard.dart';
// import 'package:scorer_web/view/adminFolder/admin_detailed_Screen.dart';
// import 'package:scorer_web/view/adminFolder/admin_over_view_option_screen.dart';
// import 'package:scorer_web/view/adminFolder/create_new_Session_header.dart';
// import 'package:scorer_web/view/adminFolder/game_Screen2_admin_side.dart';
// import 'package:scorer_web/view/adminFolder/game_Screen_Adminside.dart';
// import 'package:scorer_web/view/adminFolder/user_Player_detailed_screen.dart';
// import 'package:scorer_web/view/adminFolder/user_facilitate_detailed_scree.dart';
// import 'package:scorer_web/view/adminFolder/user_managemnet_screen.dart';
// import 'package:scorer_web/view/admin_lgin.dart';
// import 'package:scorer_web/view/choose_ypur_role_screen.dart';
// import 'package:scorer_web/view/facil_login_screen.dart';
// import 'package:scorer_web/view/player_folder/player_dashboard_Screen.dart';
// import 'package:scorer_web/view/player_folder/player_dashboard_Screen2.dart';
// import 'package:scorer_web/view/player_folder/player_game_start_Screen.dart';
// import 'package:scorer_web/view/player_folder/player_leaderboard_Screen.dart';
// import 'package:scorer_web/view/player_folder/player_leaderboard_Screen2.dart';
// import 'package:scorer_web/view/player_folder/player_login_side.dart';
// import 'package:scorer_web/view/player_folder/response_submit_screen1.dart';
// import 'package:scorer_web/view/player_folder/response_submitted_Screen2.dart';
// import 'package:scorer_web/view/player_login_screen.dart';
// import 'package:scorer_web/view/splash_Screen.dart';
// import 'package:scorer_web/view/start_Screen.dart';
// import 'package:scorer_web/view/start_Screen1.dart';
// import 'package:scorer_web/view/start_Screen3.dart';
// import 'package:scorer_web/view/start_screen2.dart';
// import 'package:scorer_web/widgets/widget_nav_item.dart';
//
// // Import your controllers
// import 'package:scorer_web/api/api_controllers/session_controller.dart';
// import 'package:scorer_web/api/api_controllers/join_session_controller.dart';
// import 'package:scorer_web/api/api_controllers/session_list_controller.dart';
// import 'package:get/get_instance/src/bindings_interface.dart';
// import 'package:get/get.dart';
//
// import 'api/api_controllers/login_controller_web.dart';
//
// class InitialBinding implements Bindings {
//   @override
//   void dependencies() {
//     // Initialize all your controllers here
//     Get.lazyPut(() => AuthController(), fenix: true);
//     Get.lazyPut(() => SessionController(), fenix: true);
//     Get.lazyPut(() => JoinSessionController(), fenix: true);
//     Get.lazyPut(() => SessionsListController(), fenix: true);
//     // Add other controllers as needed
//   }
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final savedLocale = await TranslationService().getSavedLocale();
//   runApp(MyApp(locale: savedLocale));
// }
//
// class MyApp extends StatelessWidget {
//   final Locale locale;
//
//   const MyApp({super.key, required this.locale});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     print("📱 Screen size: width=${size.width}, height=${size.height}");
//     return ScreenUtilInit(
//       designSize: const Size(1920, 1080),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           initialBinding: InitialBinding(), // ✅ ADD THIS
//           translations: AppTranslations(),
//           locale: locale,
//           getPages: AppRoutes.getAppRoutes(),
//           fallbackLocale: const Locale('en', 'US'),
//           debugShowCheckedModeBanner: false,
//           home: SplashScreen(),
//         );
//       },
//     );
//   }
// }