import 'package:get/get.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_services/user_profile_update_service.dart';

class UserProfileController extends GetxController {
  var isLoading = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userRole = ''.obs;
  var userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load user profile from SharedPreferences
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      // Load from SharedPreferences
      final name = await SharedPrefServices.getUserName() ?? '';
      final email = await SharedPrefServices.getUserEmail() ?? '';
      final phone = await SharedPrefServices.getUserPhone() ?? '';
      final role = await SharedPrefServices.getUserRole() ?? '';
      final id = await SharedPrefServices.getUserId();

      userName.value = name;
      userEmail.value = email;
      userPhone.value = phone;
      userRole.value = role;
      userId.value = int.tryParse(id ?? '0') ?? 0;

      print("👤 Loaded profile: name=$name, email=$email, phone=$phone, role=$role, id=$id");
    } catch (e) {
      print("❌ Error loading profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile via API
  Future<bool> updateUserProfile({
    String? name,
    String? phone,
  }) async {
    if (userId.value == 0) {
      Get.snackbar(
        'error'.tr,
        'user_id_not_found'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    try {
      isLoading.value = true;

      final result = await UserUpdateService.updateUserProfile(
        userId: userId.value,
        name: name,
        phone: phone,
      );

      if (result != null) {
        // Update local data
        if (name != null && name.isNotEmpty) {
          userName.value = result['name'] ?? name;
          await SharedPrefServices.saveUserName(userName.value);
        }

        if (phone != null && phone.isNotEmpty) {
          userPhone.value = result['phone'] ?? phone;
          await SharedPrefServices.saveUserPhone(userPhone.value);
        }

        print("✅ Profile updated successfully");

        Get.snackbar(
          'profile_updated'.tr,
          'profile_updated_success'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: Duration(seconds: 3),
        );

        return true;
      } else {
        Get.snackbar(
          'update_failed'.tr,
          'failed_to_update_profile'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }
    } catch (e) {
      print("🔥 Error updating profile: $e");
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}