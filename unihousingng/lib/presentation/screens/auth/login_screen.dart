import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/utils/validation_utils.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_mode_selector.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/auth/phone_login_form.dart';
import '../../widgets/auth/social_auth_section.dart';
import '../../widgets/auth/auth_footer.dart';
import '../../widgets/common/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  // Validation states
  bool _isEmailValid = false;
  String? _emailErrorText;
  String? _passwordErrorText;
  bool _hasMinLength = false;
  bool _hasLetters = false;
  bool _hasDigit = false;
  bool _isPhoneValid = false;
  String? _phoneErrorText;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  @override
  void dispose() {
    _removeValidationListeners();
    _disposeControllers();
    super.dispose();
  }

  void _setupValidationListeners() {
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _phoneController.addListener(_validatePhone);
  }

  void _removeValidationListeners() {
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _phoneController.removeListener(_validatePhone);
  }

  void _disposeControllers() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
  }

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

  void _onForgotPassword() {
    // TODO: Navigate to forgot password screen
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const AuthHeader(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to continue',
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
                    ? LoginForm(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePasswordVisibility: _togglePasswordVisibility,
                        isEmailValid: _isEmailValid,
                        emailErrorText: _emailErrorText,
                        passwordErrorText: _passwordErrorText,
                        hasMinLength: _hasMinLength,
                        hasLetters: _hasLetters,
                        hasDigit: _hasDigit,
                        onForgotPassword: _onForgotPassword,
                      )
                    : PhoneLoginForm(
                        phoneController: _phoneController,
                        otpController: _otpController,
                        isPhoneValid: _isPhoneValid,
                        phoneErrorText: _phoneErrorText,
                        isOtpSent: _isOtpSent,
                        isLoading: _isLoading,
                        onSendOtp: _sendOtp,
                      ),

                const SizedBox(height: 12),

                // Login Button
                CustomButton(
                  text: 'Login',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // Social Auth Section
                SocialAuthSection(
                  onGoogleSignIn: _signInWithGoogle,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // Register Link
                AuthFooter(
                  questionText: "Don't have an account? ",
                  actionText: 'Register',
                  onActionTap: () {
                    _navigationService.navigateTo(AppRoutes.register);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
