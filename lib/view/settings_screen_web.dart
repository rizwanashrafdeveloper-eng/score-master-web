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

import 'edit_profile_screen_web.dart';
import 'setting_item_web.dart';

class SettingsScreenWeb extends StatefulWidget {
  const SettingsScreenWeb({super.key});

  @override
  State<SettingsScreenWeb> createState() => _SettingsScreenWebState();
}

class _SettingsScreenWebState extends State<SettingsScreenWeb> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final langCode = await SharedPrefServices.getLanguageCode();
    if (langCode == 'fr') {
      _selectedLanguage = 'French';
    } else if (langCode == 'es') {
      _selectedLanguage = 'Spanish';
    } else {
      _selectedLanguage = 'English';
    }
    setState(() {});
  }

  Future<void> _saveSettings() async {
    if (_selectedLanguage == 'French') {
      await SharedPrefServices.saveLanguage('fr');
      Get.updateLocale(Locale('fr', 'FR'));
    } else if (_selectedLanguage == 'Spanish') {
      await SharedPrefServices.saveLanguage('es');
      Get.updateLocale(Locale('es', 'ES'));
    } else {
      await SharedPrefServices.saveLanguage('en');
      Get.updateLocale(Locale('en', 'US'));
    }

    Get.snackbar(
      'settings_saved'.tr,
      'preferences_saved'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.forwardColor,
      colorText: Colors.white,
    );
  }

  Future<void> _logout() async {
    Get.dialog(
      AlertDialog(
        title: Text('logout'.tr, style: TextStyle(fontSize: 28.sp)),
        content: Text('confirm_logout'.tr, style: TextStyle(fontSize: 20.sp)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(fontSize: 20.sp)),
          ),
          TextButton(
            onPressed: () async {
              await SharedPrefServices.clearUserData();
              Get.offAllNamed(RouteName.startScreen);
              Get.snackbar(
                'logged_out'.tr,
                'logout_success'.tr,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text(
              'logout'.tr,
              style: TextStyle(color: Colors.red, fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French'];

    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr, style: TextStyle(fontSize: 28.sp)),
        content: SizedBox(
          width: 400.w,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return ListTile(
                title: Text(language, style: TextStyle(fontSize: 22.sp)),
                trailing: _selectedLanguage == language
                    ? Icon(Icons.check, color: AppColors.forwardColor, size: 28.sp)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Get.back();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr, style: TextStyle(fontSize: 20.sp)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('about_scorer'.tr, style: TextStyle(fontSize: 28.sp)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('scorer_version'.trArgs(['1.0.0']), style: TextStyle(fontSize: 20.sp)),
              SizedBox(height: 12.h),
              Text('scorer_description'.tr, style: TextStyle(fontSize: 18.sp)),
              SizedBox(height: 20.h),
              Text('developed_by'.tr, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Text('your_company_name'.tr, style: TextStyle(fontSize: 18.sp)),
              SizedBox(height: 12.h),
              Text('contact'.tr, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Text('support@scorerapp.com', style: TextStyle(fontSize: 18.sp)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr, style: TextStyle(fontSize: 20.sp)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPrivacyPolicy() async {
    const url = 'https://yourwebsite.com/privacy-policy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(
        'error'.tr,
        'could_not_open_privacy'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _launchTermsOfService() async {
    const url = 'https://yourwebsite.com/terms-of-service';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(
        'error'.tr,
        'could_not_open_terms'.tr,
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
                  child: Container(
                    width: 794.w,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Column(
                      children: [
                        /// Top Section
                        SizedBox(
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
                                top: -140,
                                right: 312.w,
                                left: 312.w,
                                child: Image.asset(
                                  Appimages.prince2,
                                  height: 225.h,
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BoldText(
                                      text: 'settings'.tr,
                                      fontSize: 48.sp,
                                      selectionColor: AppColors.blueColor,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'manage_your_account_settings'.tr,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        color: AppColors.teamColor,
                                        height: 1.4,
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
                              padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 40.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// User Profile Card
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(30.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25.r),
                                      border: Border.all(color: AppColors.greyColor, width: 2.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: FutureBuilder<String?>(
                                      future: SharedPrefServices.getUserName(),
                                      builder: (context, snapshot) {
                                        final userName = snapshot.data ?? 'User';

                                        return Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 50.r,
                                              backgroundColor: AppColors.forwardColor.withOpacity(0.2),
                                              child: Icon(
                                                Icons.person,
                                                size: 50.sp,
                                                color: AppColors.forwardColor,
                                              ),
                                            ),
                                            SizedBox(width: 30.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BoldText(
                                                    text: userName,
                                                    fontSize: 32.sp,
                                                    selectionColor: AppColors.blueColor,
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  FutureBuilder<String?>(
                                                    future: SharedPrefServices.getUserEmail(),
                                                    builder: (context, emailSnapshot) {
                                                      final userEmail = emailSnapshot.data ?? 'user@example.com';
                                                      return MainText(
                                                        text: userEmail,
                                                        fontSize: 24.sp,
                                                        color: AppColors.teamColor,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(height: 12.h),
                                                  FutureBuilder<String?>(
                                                    future: SharedPrefServices.getUserRole(),
                                                    builder: (context, snapshot) {
                                                      final role = snapshot.data ?? 'User';
                                                      return Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 20.w,
                                                          vertical: 8.h,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.forwardColor.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(30.r),
                                                        ),
                                                        child: Text(
                                                          role.toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 20.sp,
                                                            color: AppColors.forwardColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    },
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
                                                size: 40.sp,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),

                                  SizedBox(height: 50.h),

                                  /// Preferences Section
                                  BoldText(
                                    text: 'preferences'.tr,
                                    fontSize: 36.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  SizedBox(height: 25.h),

                                  // Notifications
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

                                  SizedBox(height: 20.h),

                                  // Language
                                  SettingItemWeb(
                                    icon: Icons.language,
                                    title: 'language'.tr,
                                    subtitle: _selectedLanguage,
                                    onTap: _showLanguageDialog,
                                  ),

                                  SizedBox(height: 50.h),

                                  /// Support Section
                                  BoldText(
                                    text: 'support'.tr,
                                    fontSize: 36.sp,
                                    selectionColor: AppColors.blueColor,
                                  ),
                                  SizedBox(height: 25.h),

                                  // Privacy Policy
                                  SettingItemWeb(
                                    icon: Icons.privacy_tip,
                                    title: 'privacy_policy'.tr,
                                    subtitle: 'read_privacy_policy'.tr,
                                    onTap: _launchPrivacyPolicy,
                                  ),

                                  SizedBox(height: 20.h),

                                  // Terms of Service
                                  SettingItemWeb(
                                    icon: Icons.description,
                                    title: 'terms_service'.tr,
                                    subtitle: 'read_terms_service'.tr,
                                    onTap: _launchTermsOfService,
                                  ),

                                  SizedBox(height: 20.h),

                                  // About
                                  SettingItemWeb(
                                    icon: Icons.info,
                                    title: 'about'.tr,
                                    subtitle: 'about_scorer_app'.tr,
                                    onTap: _showAboutDialog,
                                  ),

                                  SizedBox(height: 50.h),

                                  /// Save Settings Button
                                  LoginButton(
                                    text: 'save_settings'.tr,
                                    ishow: true,
                                    icon: Icons.save,
                                    onTap: _saveSettings,
                                  ),

                                  SizedBox(height: 20.h),

                                  /// Logout Button
                                  LoginButton(
                                    text: 'logout'.tr,
                                    color: Colors.red,
                                    ishow: true,
                                    icon: Icons.logout,
                                    onTap: _logout,
                                  ),

                                  SizedBox(height: 50.h),
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
            ],
          ),
        ),
      ),
    );
  }
}