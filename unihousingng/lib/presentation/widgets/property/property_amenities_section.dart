import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import 'amenity_chip.dart';

class PropertyAmenitiesSection extends StatelessWidget {
  final List<Map<String, dynamic>>? amenities;

  const PropertyAmenitiesSection({
    super.key,
    this.amenities,
  });

  // Default amenities if none provided
  static final List<Map<String, dynamic>> _defaultAmenities = [
    {'icon': AppAssets.wifiSvg, 'label': 'WiFi', 'available': true},
    {'icon': AppAssets.parkingSvg, 'label': 'Parking', 'available': true},
    {'icon': AppAssets.securitySvg, 'label': 'Security', 'available': true},
    {'icon': AppAssets.powerSvg, 'label': '24/7 Power', 'available': true},
    {'icon': AppAssets.waterSvg, 'label': 'Water Supply', 'available': true},
    {'icon': AppAssets.airConditioningSvg, 'label': 'AC', 'available': false},
    {'icon': AppAssets.kitchenSvg, 'label': 'Kitchen', 'available': true},
  ];

  @override
  Widget build(BuildContext context) {
    final amenityList = amenities ?? _defaultAmenities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Amenities',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenityList.map((amenity) {
            return AmenityChip(
              icon: amenity['icon'],
              label: amenity['label'],
              isAvailable: amenity['available'],
            );
          }).toList(),
        ),
      ],
    );
  }
}
