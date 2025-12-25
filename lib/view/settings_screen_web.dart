import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/constants/route_name.dart';
import 'package:scorer_web/shared_preference/shared_preference.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';
import 'package:scorer_web/widgets/login_button.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_controllers/user_profile_controller.dart';
import 'edit_profile_screen_web.dart';
import 'setting_item_web.dart';

class SettingsScreenWeb extends StatefulWidget {
  const SettingsScreenWeb({super.key});

  @override
  State<SettingsScreenWeb> createState() => _SettingsScreenWebState();
}

class _SettingsScreenWebState extends State<SettingsScreenWeb> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  late final UserProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(UserProfileController());
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final langCode = await SharedPrefServices.getLanguageCode();
    setState(() {
      if (langCode == 'fr') {
        _selectedLanguage = 'Français';
      } else if (langCode == 'es') {
        _selectedLanguage = 'Español';
      } else {
        _selectedLanguage = 'English';
      }
    });
  }

  Future<void> _saveSettings() async {
    if (_selectedLanguage == 'Français') {
      await SharedPrefServices.saveLanguage('fr', 'FR');
      Get.updateLocale(Locale('fr', 'FR'));
    } else if (_selectedLanguage == 'Español') {
      await SharedPrefServices.saveLanguage('es', 'ES');
      Get.updateLocale(Locale('es', 'ES'));
    } else {
      await SharedPrefServices.saveLanguage('en', 'US');
      Get.updateLocale(Locale('en', 'US'));
    }

    Get.snackbar(
      'settings_saved'.tr,
      'preferences_saved'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.forwardColor,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  Future<void> _logout() async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('logout'.tr, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold)),
        content: Text('confirm_logout'.tr, style: TextStyle(fontSize: 18.sp)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(fontSize: 18.sp, color: AppColors.teamColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await SharedPrefServices.clearUserData();
              Get.offAllNamed(RouteName.startScreen);
              Get.snackbar(
                'logged_out'.tr,
                'logout_success'.tr,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('logout'.tr, style: TextStyle(fontSize: 18.sp, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Español', 'Français'];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('select_language'.tr, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 350.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return ListTile(
                title: Text(language, style: TextStyle(fontSize: 20.sp)),
                trailing: _selectedLanguage == language
                    ? Icon(Icons.check_circle, color: AppColors.forwardColor, size: 26.sp)
                    : Icon(Icons.radio_button_unchecked, color: AppColors.greyColor, size: 26.sp),
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Get.back();
                  _saveSettings();
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr, style: TextStyle(fontSize: 18.sp)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Icon(Icons.info, color: AppColors.blueColor, size: 32.sp),
            SizedBox(width: 10.w),
            Text('about_scorer'.tr, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('scorer_version'.trArgs(['1.0.0']), style: TextStyle(fontSize: 18.sp)),
              SizedBox(height: 10.h),
              Text('scorer_description'.tr, style: TextStyle(fontSize: 16.sp, height: 1.5)),
              SizedBox(height: 18.h),
              Text('developed_by'.tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              Text('your_company_name'.tr, style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 10.h),
              Text('contact'.tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              Text('support@scorerapp.com', style: TextStyle(fontSize: 16.sp, color: AppColors.blueColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr, style: TextStyle(fontSize: 18.sp)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url, String errorKey) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'error'.tr,
        errorKey.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(ishow: true),
              SizedBox(height: 56.h),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 794.w,
                      maxHeight: MediaQuery.of(context).size.height - 180.h,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: Column(
                        children: [
                          /// Top Section
                          SizedBox(
                            height: 200.h,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 35.h,
                                  left: -35.w,
                                  child: ForwardButtonContainer(
                                    onTap: () => Get.back(),
                                    imageH: 18.h,
                                    imageW: 21.w,
                                    height1: 80.h,
                                    height2: 60.h,
                                    width1: 80.w,
                                    width2: 60.w,
                                    image: Appimages.arrowback,
                                  ),
                                ),
                                Positioned(
                                  top: -100.h,
                                  right: 312.w,
                                  left: 312.w,
                                  child: Image.asset(
                                    Appimages.prince2,
                                    height: 200.h,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12.h,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      BoldText(
                                        text: 'settings'.tr,
                                        fontSize: 42.sp,
                                        selectionColor: AppColors.blueColor,
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        'manage_your_account_settings'.tr,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: AppColors.teamColor,
                                          height: 1.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Settings Content
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(
                                scrollbars: false,
                              ),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 30.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// User Profile Card
                                    Obx(() {
                                      return Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(25.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(22.r),
                                          border: Border.all(color: AppColors.greyColor, width: 1.5.w),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 10,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 45.r,
                                              backgroundColor: AppColors.forwardColor.withOpacity(0.2),
                                              child: Icon(
                                                Icons.person,
                                                size: 45.sp,
                                                color: AppColors.forwardColor,
                                              ),
                                            ),
                                            SizedBox(width: 25.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BoldText(
                                                    text: _profileController.userName.value.isEmpty
                                                        ? 'loading'.tr
                                                        : _profileController.userName.value,
                                                    fontSize: 28.sp,
                                                    selectionColor: AppColors.blueColor,
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  MainText(
                                                    text: _profileController.userEmail.value.isEmpty
                                                        ? 'loading'.tr
                                                        : _profileController.userEmail.value,
                                                    fontSize: 20.sp,
                                                    color: AppColors.teamColor,
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 6.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.forwardColor.withOpacity(0.15),
                                                      borderRadius: BorderRadius.circular(25.r),
                                                    ),
                                                    child: Text(
                                                      _profileController.userRole.value.toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: AppColors.forwardColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Get.to(() => EditProfileScreenWeb());
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: AppColors.blueColor,
                                                size: 35.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),

                                    SizedBox(height: 40.h),

                                    /// Preferences Section
                                    BoldText(
                                      text: 'preferences'.tr,
                                      fontSize: 32.sp,
                                      selectionColor: AppColors.blueColor,
                                    ),
                                    SizedBox(height: 20.h),

                                    SettingItemWeb(
                                      icon: Icons.notifications,
                                      title: 'notifications'.tr,
                                      subtitle: 'control_notification_preferences'.tr,
                                      trailing: Switch(
                                        value: _notificationsEnabled,
                                        activeColor: AppColors.forwardColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _notificationsEnabled = value;
                                          });
                                        },
                                      ),
                                    ),

                                    SizedBox(height: 15.h),

                                    SettingItemWeb(
                                      icon: Icons.language,
                                      title: 'language'.tr,
                                      subtitle: _selectedLanguage,
                                      onTap: _showLanguageDialog,
                                    ),

                                    SizedBox(height: 40.h),

                                    /// Support Section
                                    BoldText(
                                      text: 'support'.tr,
                                      fontSize: 32.sp,
                                      selectionColor: AppColors.blueColor,
                                    ),
                                    SizedBox(height: 20.h),

                                    SettingItemWeb(
                                      icon: Icons.privacy_tip,
                                      title: 'privacy_policy'.tr,
                                      subtitle: 'read_privacy_policy'.tr,
                                      onTap: () => _launchURL(
                                        'https://yourwebsite.com/privacy-policy',
                                        'could_not_open_privacy',
                                      ),
                                    ),

                                    SizedBox(height: 15.h),

                                    SettingItemWeb(
                                      icon: Icons.description,
                                      title: 'terms_service'.tr,
                                      subtitle: 'read_terms_service'.tr,
                                      onTap: () => _launchURL(
                                        'https://yourwebsite.com/terms-of-service',
                                        'could_not_open_terms',
                                      ),
                                    ),

                                    SizedBox(height: 15.h),

                                    SettingItemWeb(
                                      icon: Icons.info,
                                      title: 'about'.tr,
                                      subtitle: 'about_scorer_app'.tr,
                                      onTap: _showAboutDialog,
                                    ),

                                    SizedBox(height: 40.h),

                                    /// Logout Button
                                    LoginButton(
                                      text: 'logout'.tr,
                                      color: Colors.red,
                                      ishow: true,
                                      icon: Icons.logout,
                                      onTap: _logout,
                                    ),

                                    SizedBox(height: 40.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}