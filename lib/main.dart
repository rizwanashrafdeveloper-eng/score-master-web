import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:scorer_web/components/admin_folder.dart/admin_schedule_folder.dart';
import 'package:scorer_web/components/admin_folder.dart/user_administrate_side.dart';
import 'package:scorer_web/components/admin_folder.dart/user_player_side_Screen.dart';
import 'package:scorer_web/components/facilitator_folder/audio_container.dart';
import 'package:scorer_web/constants/app_routes.dart';
import 'package:scorer_web/localization/app_translation.dart';
import 'package:scorer_web/localization/translation_service.dart';
import 'package:scorer_web/view/AudioWaveExample.dart';
import 'package:scorer_web/view/FacilitatorFolder/create_new_session_screen.dart';
import 'package:scorer_web/view/FacilitatorFolder/end_session_Screen.dart';
import 'package:scorer_web/view/FacilitatorFolder/evaluate_response_Screen.dart';
import 'package:scorer_web/view/FacilitatorFolder/evauate_response_Screen2.dart';
import 'package:scorer_web/view/FacilitatorFolder/facilitator_dashboard.dart';
import 'package:scorer_web/view/FacilitatorFolder/over_view_option_screen.dart';
import 'package:scorer_web/view/FacilitatorFolder/view_response_Screen.dart';
import 'package:scorer_web/view/FacilitatorFolder/view_score_Screen.dart';
import 'package:scorer_web/view/adminFolder/admin_dashboard.dart';
import 'package:scorer_web/view/adminFolder/admin_detailed_Screen.dart';
import 'package:scorer_web/view/adminFolder/admin_over_view_option_screen.dart';
import 'package:scorer_web/view/adminFolder/create_new_Session_header.dart';
import 'package:scorer_web/view/adminFolder/game_Screen2_admin_side.dart';
import 'package:scorer_web/view/adminFolder/game_Screen_Adminside.dart';
import 'package:scorer_web/view/adminFolder/user_Player_detailed_screen.dart';
import 'package:scorer_web/view/adminFolder/user_facilitate_detailed_scree.dart';
import 'package:scorer_web/view/adminFolder/user_managemnet_screen.dart';
import 'package:scorer_web/view/admin_lgin.dart';
import 'package:scorer_web/view/choose_ypur_role_screen.dart';
import 'package:scorer_web/view/facil_login_screen.dart';
import 'package:scorer_web/view/player_folder/player_dashboard_Screen.dart';
import 'package:scorer_web/view/player_folder/player_dashboard_Screen2.dart';
import 'package:scorer_web/view/player_folder/player_game_start_Screen.dart';
import 'package:scorer_web/view/player_folder/player_leaderboard_Screen.dart';
import 'package:scorer_web/view/player_folder/player_leaderboard_Screen2.dart';
import 'package:scorer_web/view/player_folder/player_login_side.dart';
import 'package:scorer_web/view/player_folder/response_submit_screen1.dart';
import 'package:scorer_web/view/player_folder/response_submitted_Screen2.dart';
import 'package:scorer_web/view/player_login_screen.dart';
import 'package:scorer_web/view/splash_Screen.dart';
import 'package:scorer_web/view/start_Screen.dart';
import 'package:scorer_web/view/start_Screen1.dart';
import 'package:scorer_web/view/start_Screen3.dart';
import 'package:scorer_web/view/start_screen2.dart';
import 'package:scorer_web/widgets/widget_nav_item.dart';

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
    Get.lazyPut(() => LoginControllerWeb(), fenix: true);
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
    final size = MediaQuery.of(context).size;
    print("📱 Screen size: width=${size.width}, height=${size.height}");
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: InitialBinding(), // ✅ ADD THIS
          translations: AppTranslations(),
          locale: locale,
          getPages: AppRoutes.getAppRoutes(),
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}