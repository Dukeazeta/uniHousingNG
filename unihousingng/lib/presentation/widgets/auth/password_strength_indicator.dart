import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final bool hasMinLength;
  final bool hasLetters;
  final bool hasDigit;

  const PasswordStrengthIndicator({
    super.key,
    required this.hasMinLength,
    required this.hasLetters,
    required this.hasDigit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: hasMinLength ? AppColors.accent : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: hasLetters ? AppColors.accent : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: hasDigit ? AppColors.accent : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '6+ characters',
              style: TextStyle(
                fontSize: 12,
                color:
                    hasMinLength ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
            Text(
              'Letters',
              style: TextStyle(
                fontSize: 12,
                color: hasLetters ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
            Text(
              'Numbers',
              style: TextStyle(
                fontSize: 12,
                color: hasDigit ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
