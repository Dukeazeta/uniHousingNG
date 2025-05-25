import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/services/search_service.dart';

class SortOptionsBottomSheet extends StatelessWidget {
  final SortOption currentSortOption;
  final Function(SortOption) onSortChanged;

  const SortOptionsBottomSheet({
    super.key,
    required this.currentSortOption,
    required this.onSortChanged,
  });

  static void show(
    BuildContext context, {
    required SortOption currentSortOption,
    required Function(SortOption) onSortChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsBottomSheet(
        currentSortOption: currentSortOption,
        onSortChanged: onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Sort By',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Sort options
          ...SortOption.values.map((option) => _buildSortOption(
            context,
            option,
            _getSortOptionInfo(option),
          )),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    SortOption option,
    Map<String, dynamic> info,
  ) {
    final isSelected = currentSortOption == option;

    return InkWell(
      onTap: () {
        onSortChanged(option);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              info['icon'],
              size: 24,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info['title'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  if (info['subtitle'] != null)
                    Text(
                      info['subtitle'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getSortOptionInfo(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return {
          'icon': Icons.auto_awesome,
          'title': 'Relevance',
          'subtitle': 'Best match for your search',
        };
      case SortOption.priceAsc:
        return {
          'icon': Icons.trending_up,
          'title': 'Price: Low to High',
          'subtitle': 'Cheapest properties first',
        };
      case SortOption.priceDesc:
        return {
          'icon': Icons.trending_down,
          'title': 'Price: High to Low',
          'subtitle': 'Most expensive properties first',
        };
      case SortOption.newest:
        return {
          'icon': Icons.new_releases,
          'title': 'Newest First',
          'subtitle': 'Recently added properties',
        };
      case SortOption.rating:
        return {
          'icon': Icons.star,
          'title': 'Highest Rated',
          'subtitle': 'Best reviewed properties',
        };
      case SortOption.distance:
        return {
          'icon': Icons.location_on,
          'title': 'Distance',
          'subtitle': 'Closest to campus',
        };
    }
  }
}
