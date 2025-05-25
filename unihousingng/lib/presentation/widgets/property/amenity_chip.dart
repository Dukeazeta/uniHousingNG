import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';

class AmenityChip extends StatelessWidget {
  final String icon;
  final String label;
  final bool isAvailable;
  final Color? backgroundColor;

  const AmenityChip({
    super.key,
    required this.icon,
    required this.label,
    this.isAvailable = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            (isAvailable 
                ? AppColors.primary.withAlpha(20) 
                : AppColors.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAvailable 
              ? AppColors.primary.withAlpha(50)
              : AppColors.textSecondary.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 16,
            width: 16,
            colorFilter: ColorFilter.mode(
              isAvailable ? AppColors.primary : AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isAvailable ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
