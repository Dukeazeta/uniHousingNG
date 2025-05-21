class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  static bool hasMinLength(String password) {
    return password.length >= 6;
  }

  static bool hasUppercase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool hasLowercase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool hasDigit(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool hasLetters(String password) {
    return hasUppercase(password) || hasLowercase(password);
  }

  static bool isValidPassword(String password) {
    return hasMinLength(password) && hasLetters(password) && hasDigit(password);
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (!hasMinLength(value)) {
      return 'Password must be at least 6 characters';
    }
    if (!hasLetters(value)) {
      return 'Password must contain letters';
    }
    if (!hasDigit(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Phone validation
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    if (phone.length != 11) return false;
    return RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 11) {
      return 'Phone number must be exactly 11 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    return name.length >= 3;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  // OTP validation
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length < 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }
}
