import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../common/custom_text_field.dart';
import '../common/svg_icon.dart';

class PhoneLoginForm extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController otpController;
  final bool isPhoneValid;
  final String? phoneErrorText;
  final bool isOtpSent;
  final bool isLoading;
  final VoidCallback onSendOtp;

  const PhoneLoginForm({
    super.key,
    required this.phoneController,
    required this.otpController,
    required this.isPhoneValid,
    this.phoneErrorText,
    required this.isOtpSent,
    required this.isLoading,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Phone Field
        CustomTextField(
          controller: phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          prefixWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgIcon(assetName: AppAssets.phoneSvg),
          ),
          keyboardType: TextInputType.phone,
          errorText: phoneErrorText,
          isValid: isPhoneValid,
          suffixIcon: isOtpSent
              ? const Icon(Icons.check_circle, color: AppColors.accent)
              : TextButton(
                  onPressed: isLoading ? null : onSendOtp,
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

        // OTP Field (only show if OTP is sent)
        if (isOtpSent) ...[
          CustomTextField(
            controller: otpController,
            labelText: 'OTP',
            hintText: 'Enter the OTP sent to your phone',
            prefixWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgIcon(assetName: AppAssets.keySvg),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the OTP';
              }
              if (value.length != 6) {
                return 'OTP must be 6 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Resend OTP Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onSendOtp,
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
