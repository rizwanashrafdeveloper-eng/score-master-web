class Validators {
  static String? isRequired(String? value, {String fieldName = "This field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final regex = RegExp(r'^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$');
    return regex.hasMatch(value) ? null : "Enter a valid email address";
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";

    final cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
    final phoneRegex = RegExp(r'^(\+\d{1,3})?[\d\s\-\(\)]{8,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return "Invalid phone number";
    }

    final digitsOnly = cleanedValue.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 8) return "Phone number is too short";
    if (digitsOnly.length > 15) return "Phone number is too long";

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    //
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return "Password must contain at least one uppercase letter";
    // }
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return "Password must contain at least one number";
    // }
    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }
}
