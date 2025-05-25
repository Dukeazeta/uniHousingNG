import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../common/custom_button.dart';

class PropertyContactButtons extends StatelessWidget {
  final VoidCallback onContactLandlord;
  final VoidCallback onCall;

  const PropertyContactButtons({
    super.key,
    required this.onContactLandlord,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              text: 'Contact Landlord',
              onPressed: onContactLandlord,
              backgroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: 'Call',
              onPressed: onCall,
              backgroundColor: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
