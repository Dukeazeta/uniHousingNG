import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/utils/validation_utils.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_mode_selector.dart';
import '../../widgets/auth/register_form.dart';
import '../../widgets/auth/phone_register_form.dart';
import '../../widgets/auth/social_auth_section.dart';
import '../../widgets/auth/auth_footer.dart';
import '../../widgets/common/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  // Validation states
  bool _isNameValid = false;
  String? _nameErrorText;
  bool _isEmailValid = false;
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
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
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
    _phoneController.addListener(_validatePhone);
  }

  void _removeValidationListeners() {
    _nameController.removeListener(_validateName);
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validateConfirmPassword);
    _phoneController.removeListener(_validatePhone);
  }

  void _disposeControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
  }

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

      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }
    });
  }

  void _validateConfirmPassword() {
    final confirmPassword = _confirmPasswordController.text;
    final password = _passwordController.text;

    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordErrorText = null;
      } else if (confirmPassword != password) {
        _confirmPasswordErrorText = 'Passwords do not match';
      } else {
        _confirmPasswordErrorText = null;
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

  void _switchRegisterMode(AuthMode mode) {
    setState(() {
      _registerMode = mode;
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const AuthHeader(
                  title: 'Create Account',
                  subtitle: 'Join us to find your perfect home',
                ),
                const SizedBox(height: 24),

                // Auth Mode Toggle
                AuthModeSelector(
                  currentMode: _registerMode,
                  onModeChanged: _switchRegisterMode,
                ),
                const SizedBox(height: 16),

                // Register Form
                _registerMode == AuthMode.email
                    ? RegisterForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        obscurePassword: _obscurePassword,
                        obscureConfirmPassword: _obscureConfirmPassword,
                        onTogglePasswordVisibility: _togglePasswordVisibility,
                        onToggleConfirmPasswordVisibility:
                            _toggleConfirmPasswordVisibility,
                        isNameValid: _isNameValid,
                        nameErrorText: _nameErrorText,
                        isEmailValid: _isEmailValid,
                        emailErrorText: _emailErrorText,
                        passwordErrorText: _passwordErrorText,
                        confirmPasswordErrorText: _confirmPasswordErrorText,
                        hasMinLength: _hasMinLength,
                        hasLetters: _hasLetters,
                        hasDigit: _hasDigit,
                      )
                    : PhoneRegisterForm(
                        nameController: _nameController,
                        phoneController: _phoneController,
                        otpController: _otpController,
                        isNameValid: _isNameValid,
                        nameErrorText: _nameErrorText,
                        isPhoneValid: _isPhoneValid,
                        phoneErrorText: _phoneErrorText,
                        isOtpSent: _isOtpSent,
                        isLoading: _isLoading,
                        onSendOtp: _sendOtp,
                      ),

                const SizedBox(height: 24),

                // Register Button
                CustomButton(
                  text: 'Register',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // Social Auth Section
                SocialAuthSection(
                  onGoogleSignIn: _signInWithGoogle,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // Login Link
                AuthFooter(
                  questionText: "Already have an account? ",
                  actionText: 'Login',
                  onActionTap: () => _navigationService.goBack(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
