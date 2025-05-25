import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import 'property_info_card.dart';

class PropertyStatsRow extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyStatsRow({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PropertyInfoCard(
            icon: AppAssets.bedSvg,
            label: 'Bedrooms',
            value: '${property['beds'] ?? 0}',
            backgroundColor: Colors.blue[50],
            iconColor: Colors.blue[600],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PropertyInfoCard(
            icon: AppAssets.bathSvg,
            label: 'Bathrooms',
            value: '${property['baths'] ?? 0}',
            backgroundColor: Colors.green[50],
            iconColor: Colors.green[600],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PropertyInfoCard(
            icon: AppAssets.areaSvg,
            label: 'Area',
            value: '${property['area'] ?? 120}m²',
            backgroundColor: Colors.orange[50],
            iconColor: Colors.orange[600],
          ),
        ),
      ],
    );
  }
}
