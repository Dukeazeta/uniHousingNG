import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../data/mock_data.dart';

class CampusSelectionDialog extends StatelessWidget {
  final String selectedCampus;
  final Function(String) onCampusSelected;

  const CampusSelectionDialog({
    super.key,
    required this.selectedCampus,
    required this.onCampusSelected,
  });

  static void show(
    BuildContext context, {
    required String selectedCampus,
    required Function(String) onCampusSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CampusSelectionDialog(
          selectedCampus: selectedCampus,
          onCampusSelected: onCampusSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Campus',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ListView.builder(
                itemCount: MockData.nigerianCampuses.length,
                itemBuilder: (context, index) {
                  final campus = MockData.nigerianCampuses[index];
                  final isSelected = campus == selectedCampus;

                  return InkWell(
                    onTap: () {
                      onCampusSelected(campus);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                campus,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
