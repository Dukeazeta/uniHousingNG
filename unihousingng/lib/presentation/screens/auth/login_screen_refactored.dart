import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class LoginScreenRefactored extends StatefulWidget {
  const LoginScreenRefactored({super.key});

  @override
  State<LoginScreenRefactored> createState() => _LoginScreenRefactoredState();
}

class _LoginScreenRefactoredState extends State<LoginScreenRefactored> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  final _authService = AuthService();
  final _navigationService = NavigationService();
  final _snackBarService = SnackBarService();

  AuthMode _authMode = AuthMode.email;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isOtpSent = false;

  // Email validation state
  bool _isEmailValid = false;
  String? _emailErrorText;

  // Password validation state
  String? _passwordErrorText;
  bool _hasMinLength = false;
  bool _hasLetters = false;
  bool _hasDigit = false;

  // Phone validation state
  bool _isPhoneValid = false;
  String? _phoneErrorText;

  @override
  void initState() {
    super.initState();

    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    // Remove listeners
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _phoneController.removeListener(_validatePhone);

    // Dispose controllers
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
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

  void _switchAuthMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
      // Reset controllers when switching modes
      if (mode == AuthMode.email) {
        _phoneController.clear();
        _otpController.clear();
        _isOtpSent = false;
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    AuthResult result;

    if (_authMode == AuthMode.email) {
      result = await _authService.loginWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      result = await _authService.loginWithPhoneAndOtp(
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
          'Login successful',
          type: SnackBarType.success,
        );
        _navigationService.navigateToAndRemoveUntil(AppRoutes.main);
      } else {
        _snackBarService.showSnackBar(
          'Login failed: ${_getErrorMessage(result)}',
          type: SnackBarType.error,
        );
      }
    }
  }

  String _getErrorMessage(AuthResult result) {
    switch (result) {
      case AuthResult.invalidCredentials:
        return 'Invalid credentials';
      case AuthResult.userNotFound:
        return 'User not found';
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingMedium,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  SvgPicture.asset(
                    AppAssets.appLogoSvg,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 12),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Auth Mode Toggle
                  AuthModeSelector(
                    currentMode: _authMode,
                    onModeChanged: _switchAuthMode,
                  ),
                  const SizedBox(height: 16),

                  // Auth Form
                  _authMode == AuthMode.email
                      ? _buildEmailForm()
                      : _buildPhoneForm(),

                  const SizedBox(height: 12),

                  // Login Button
                  CustomButton(
                    text: 'Login',
                    onPressed: _login,
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

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _navigationService.navigateTo(AppRoutes.register);
                        },
                        child: Text(
                          'Register',
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
        const SizedBox(height: 12),

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
        const SizedBox(height: 8),

        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to forgot password screen
            },
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.body.copyWith(color: AppColors.secondary),
            ),
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
        const SizedBox(height: 12),

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
          const SizedBox(height: 8),

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
