import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../common/custom_text_field.dart';
import '../common/svg_icon.dart';
import 'password_strength_indicator.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final bool isEmailValid;
  final String? emailErrorText;
  final String? passwordErrorText;
  final bool hasMinLength;
  final bool hasLetters;
  final bool hasDigit;
  final VoidCallback onForgotPassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.isEmailValid,
    this.emailErrorText,
    this.passwordErrorText,
    required this.hasMinLength,
    required this.hasLetters,
    required this.hasDigit,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Email Field
          CustomTextField(
            controller: emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgIcon(assetName: AppAssets.mailSvg),
            ),
            keyboardType: TextInputType.emailAddress,
            errorText: emailErrorText,
            isValid: isEmailValid,
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 12),

          // Password Field
          CustomTextField(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgIcon(assetName: AppAssets.keySvg),
            ),
            obscureText: obscurePassword,
            errorText: passwordErrorText,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: onTogglePasswordVisibility,
            ),
            validator: ValidationUtils.validatePassword,
          ),

          // Password strength indicator
          if (passwordController.text.isNotEmpty)
            PasswordStrengthIndicator(
              hasMinLength: hasMinLength,
              hasLetters: hasLetters,
              hasDigit: hasDigit,
            ),
          const SizedBox(height: 8),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTextStyles.body.copyWith(color: AppColors.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
