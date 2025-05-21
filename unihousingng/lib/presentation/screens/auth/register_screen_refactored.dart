// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Keep for logo in body
import '../../../core/constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/utils/validation_utils.dart';
import '../../widgets/auth/auth_mode_selector.dart';
import '../../widgets/auth/password_strength_indicator.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/svg_icon.dart';

enum RegisterMode { email, phone }

class RegisterScreenRefactored extends StatefulWidget {
  const RegisterScreenRefactored({super.key});

  @override
  State<RegisterScreenRefactored> createState() =>
      _RegisterScreenRefactoredState();
}

class _RegisterScreenRefactoredState extends State<RegisterScreenRefactored> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  final _authService = AuthService();
  final _navigationService = NavigationService();
  final _snackBarService = SnackBarService();

  AuthMode _registerMode = AuthMode.email;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isOtpSent = false;

  // Name validation state
  bool _isNameValid = false;
  String? _nameErrorText;

  // Email validation state
  bool _isEmailValid = false;
  String? _emailErrorText;

  // Password validation state
  bool _isPasswordValid = false;
  String? _passwordErrorText;
  bool _hasMinLength = false;
  bool _hasLetters = false;
  bool _hasDigit = false;

  // Confirm password validation state
  bool _isConfirmPasswordValid = false;
  String? _confirmPasswordErrorText;

  // Phone validation state
  bool _isPhoneValid = false;
  String? _phoneErrorText;

  @override
  void initState() {
    super.initState();

    // Add listeners for real-time validation
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    // Remove listeners
    _nameController.removeListener(_validateName);
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validateConfirmPassword);
    _phoneController.removeListener(_validatePhone);

    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Name validation function
  void _validateName() {
    final name = _nameController.text;
    setState(() {
      if (name.isEmpty) {
        _isNameValid = false;
        _nameErrorText = null;
      } else if (!ValidationUtils.isValidName(name)) {
        _isNameValid = false;
        _nameErrorText = 'Name must be at least 3 characters';
      } else {
        _isNameValid = true;
        _nameErrorText = null;
      }
    });
  }

  // Email validation function
  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _isEmailValid = false;
        _emailErrorText = null;
      } else if (!ValidationUtils.isValidEmail(email)) {
        _isEmailValid = false;
        _emailErrorText = 'Please enter a valid email';
      } else {
        _isEmailValid = true;
        _emailErrorText = null;
      }
    });
  }

  // Password validation function
  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = ValidationUtils.hasMinLength(password);
      _hasLetters = ValidationUtils.hasLetters(password);
      _hasDigit = ValidationUtils.hasDigit(password);

      _isPasswordValid = _hasMinLength && _hasLetters && _hasDigit;

      if (password.isEmpty) {
        _passwordErrorText = null;
      } else if (!_hasMinLength) {
        _passwordErrorText = 'Password must be at least 6 characters';
      } else if (!_hasLetters) {
        _passwordErrorText = 'Password must contain letters';
      } else if (!_hasDigit) {
        _passwordErrorText = 'Password must contain at least one number';
      } else {
        _passwordErrorText = null;
      }

      // Also validate confirm password when password changes
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }
    });
  }

  // Confirm password validation function
  void _validateConfirmPassword() {
    final confirmPassword = _confirmPasswordController.text;
    final password = _passwordController.text;

    setState(() {
      if (confirmPassword.isEmpty) {
        _isConfirmPasswordValid = false;
        _confirmPasswordErrorText = null;
      } else if (confirmPassword != password) {
        _isConfirmPasswordValid = false;
        _confirmPasswordErrorText = 'Passwords do not match';
      } else {
        _isConfirmPasswordValid = true;
        _confirmPasswordErrorText = null;
      }
    });
  }

  // Phone validation function
  void _validatePhone() {
    final phone = _phoneController.text;
    setState(() {
      if (phone.isEmpty) {
        _isPhoneValid = false;
        _phoneErrorText = null;
      } else if (!ValidationUtils.isValidPhone(phone)) {
        _isPhoneValid = false;
        _phoneErrorText = 'Phone number must be exactly 11 digits';
      } else {
        _isPhoneValid = true;
        _phoneErrorText = null;
      }
    });
  }

  void _switchRegisterMode(AuthMode mode) {
    setState(() {
      _registerMode = mode;
      // Reset controllers when switching modes
      if (mode == AuthMode.email) {
        _phoneController.clear();
        _otpController.clear();
        _isOtpSent = false;
      } else {
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _sendOtp() async {
    // Validate phone number
    if (!_isPhoneValid) {
      _snackBarService.showSnackBar(
        'Phone number must be exactly 11 digits',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Send OTP
    final success = await _authService.sendOtp(_phoneController.text);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isOtpSent = success;
      });

      if (success) {
        _snackBarService.showSnackBar(
          'OTP sent successfully',
          type: SnackBarType.success,
        );
      } else {
        _snackBarService.showSnackBar(
          'Failed to send OTP. Please try again.',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    AuthResult result;

    if (_registerMode == AuthMode.email) {
      result = await _authService.registerWithEmailAndPassword(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } else {
      result = await _authService.registerWithPhone(
        _nameController.text,
        _phoneController.text,
        _otpController.text,
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result == AuthResult.success) {
        _snackBarService.showSnackBar(
          'Registration successful',
          type: SnackBarType.success,
        );
        _navigationService.navigateToAndRemoveUntil(AppRoutes.main);
      } else {
        _snackBarService.showSnackBar(
          'Registration failed: ${_getErrorMessage(result)}',
          type: SnackBarType.error,
        );
      }
    }
  }

  String _getErrorMessage(AuthResult result) {
    switch (result) {
      case AuthResult.emailAlreadyInUse:
        return 'Email already in use';
      case AuthResult.weakPassword:
        return 'Password is too weak';
      case AuthResult.networkError:
        return 'Network error';
      default:
        return 'An unknown error occurred';
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.signInWithGoogle();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result == AuthResult.success) {
        _snackBarService.showSnackBar(
          'Google sign-in successful',
          type: SnackBarType.success,
        );
        _navigationService.navigateToAndRemoveUntil(AppRoutes.main);
      } else {
        _snackBarService.showSnackBar(
          'Google sign-in failed: ${_getErrorMessage(result)}',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => _navigationService.goBack(),
        ),
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        // Remove the logo from the app bar
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingLarge,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: SvgPicture.asset(
                      AppAssets.appLogoSvg,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon:
                        Icons
                            .person_outline, // Keep using Material icon for person
                    errorText: _nameErrorText,
                    isValid: _isNameValid,
                    validator: ValidationUtils.validateName,
                  ),
                  const SizedBox(height: 16),

                  // Register Mode Toggle
                  AuthModeSelector(
                    currentMode: _registerMode,
                    onModeChanged: _switchRegisterMode,
                  ),
                  const SizedBox(height: 16),

                  // Register Form
                  _registerMode == AuthMode.email
                      ? _buildEmailForm()
                      : _buildPhoneForm(),

                  const SizedBox(height: 24),

                  // Register Button
                  CustomButton(
                    text: 'Register',
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 16),

                  // Divider with "OR" text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                      ],
                    ),
                  ),

                  // Google Sign In Button
                  CustomOutlinedButton(
                    text: 'Continue with Google',
                    onPressed: _signInWithGoogle,
                    svgIcon: AppAssets.googleSvg,
                  ),

                  const SizedBox(height: 16),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigationService.goBack(),
                        child: Text(
                          'Login',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        // Email Field
        CustomTextField(
          controller: _emailController,
          labelText: 'Email',
          hintText: 'Enter your email',
          prefixWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgIcon(assetName: AppAssets.mailSvg),
          ),
          keyboardType: TextInputType.emailAddress,
          errorText: _emailErrorText,
          isValid: _isEmailValid,
          validator: ValidationUtils.validateEmail,
        ),
        const SizedBox(height: 16),

        // Password Field
        CustomTextField(
          controller: _passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgIcon(assetName: AppAssets.keySvg),
          ),
          obscureText: _obscurePassword,
          errorText: _passwordErrorText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          validator: ValidationUtils.validatePassword,
        ),

        // Password strength indicator
        if (_passwordController.text.isNotEmpty)
          PasswordStrengthIndicator(
            hasMinLength: _hasMinLength,
            hasLetters: _hasLetters,
            hasDigit: _hasDigit,
          ),
        const SizedBox(height: 16),

        // Confirm Password Field
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          prefixWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgIcon(assetName: AppAssets.keySvg),
          ),
          obscureText: _obscureConfirmPassword,
          errorText: _confirmPasswordErrorText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: _toggleConfirmPasswordVisibility,
          ),
          validator:
              (value) => ValidationUtils.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
        ),
      ],
    );
  }

  Widget _buildPhoneForm() {
    return Column(
      children: [
        // Phone Field
        CustomTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          prefixWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgIcon(assetName: AppAssets.phoneSvg),
          ),
          keyboardType: TextInputType.phone,
          errorText: _phoneErrorText,
          isValid: _isPhoneValid,
          suffixIcon:
              _isOtpSent
                  ? const Icon(Icons.check_circle, color: AppColors.accent)
                  : TextButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    child: Text(
                      'Send OTP',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          validator: ValidationUtils.validatePhone,
        ),
        const SizedBox(height: 16),

        // OTP Field
        if (_isOtpSent) ...[
          CustomTextField(
            controller: _otpController,
            labelText: 'OTP',
            hintText: 'Enter the OTP sent to your phone',
            prefixWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgIcon(assetName: AppAssets.keySvg),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            showCounter: false,
            validator: ValidationUtils.validateOtp,
          ),
          const SizedBox(height: 16),

          // Resend OTP
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _isLoading ? null : _sendOtp,
              child: Text(
                'Resend OTP',
                style: AppTextStyles.body.copyWith(color: AppColors.secondary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
