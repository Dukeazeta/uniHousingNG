import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../common/custom_button.dart';

class SocialAuthSection extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final bool isLoading;

  const SocialAuthSection({
    super.key,
    required this.onGoogleSignIn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          onPressed: isLoading ? null : onGoogleSignIn,
          svgIcon: AppAssets.googleSvg,
        ),
      ],
    );
  }
}
