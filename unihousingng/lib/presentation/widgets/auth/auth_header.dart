import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double logoHeight;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        SvgPicture.asset(
          AppAssets.appLogoSvg,
          height: logoHeight,
          width: logoHeight,
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
