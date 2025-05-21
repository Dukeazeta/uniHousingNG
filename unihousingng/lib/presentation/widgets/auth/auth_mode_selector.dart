import 'package:flutter/material.dart';
import '../../../core/constants.dart';

enum AuthMode { email, phone }

class AuthModeSelector extends StatelessWidget {
  final AuthMode currentMode;
  final Function(AuthMode) onModeChanged;

  const AuthModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildAuthModeButton(
            title: 'Email',
            isSelected: currentMode == AuthMode.email,
            onTap: () => onModeChanged(AuthMode.email),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAuthModeButton(
            title: 'Phone',
            isSelected: currentMode == AuthMode.phone,
            onTap: () => onModeChanged(AuthMode.phone),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthModeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
