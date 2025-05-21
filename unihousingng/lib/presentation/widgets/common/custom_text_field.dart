// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool showCounter;
  final bool isValid;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.validator,
    this.maxLength,
    this.showCounter = true,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon:
            prefixWidget ??
            (prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null),
        suffixIcon:
            suffixIcon ??
            (isValid
                ? const Icon(Icons.check_circle, color: AppColors.accent)
                : errorText != null
                ? const Icon(Icons.error, color: AppColors.error)
                : null),
        counterText: showCounter ? null : '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: BorderSide(
            color: errorText != null ? AppColors.error : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: BorderSide(
            color: errorText != null ? AppColors.error : AppColors.primary,
            width: 2,
          ),
        ),
        errorText: errorText,
        errorStyle: const TextStyle(color: AppColors.error),
        fillColor: AppColors.surface,
        filled: true,
      ),
      validator: validator,
    );
  }
}
