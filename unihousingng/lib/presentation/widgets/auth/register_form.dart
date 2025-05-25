import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../common/custom_text_field.dart';
import '../common/svg_icon.dart';
import 'password_strength_indicator.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final bool isNameValid;
  final String? nameErrorText;
  final bool isEmailValid;
  final String? emailErrorText;
  final String? passwordErrorText;
  final String? confirmPasswordErrorText;
  final bool hasMinLength;
  final bool hasLetters;
  final bool hasDigit;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.isNameValid,
    this.nameErrorText,
    required this.isEmailValid,
    this.emailErrorText,
    this.passwordErrorText,
    this.confirmPasswordErrorText,
    required this.hasMinLength,
    required this.hasLetters,
    required this.hasDigit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Name Field
          CustomTextField(
            controller: nameController,
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            errorText: nameErrorText,
            isValid: isNameValid,
            validator: ValidationUtils.validateName,
          ),
          const SizedBox(height: 16),

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
          const SizedBox(height: 16),

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
          const SizedBox(height: 16),

          // Confirm Password Field
          CustomTextField(
            controller: confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            prefixWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgIcon(assetName: AppAssets.keySvg),
            ),
            obscureText: obscureConfirmPassword,
            errorText: confirmPasswordErrorText,
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: onToggleConfirmPasswordVisibility,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
