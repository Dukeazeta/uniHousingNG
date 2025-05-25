import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants.dart';
import '../../widgets/property/property_header.dart';
import '../../widgets/property/property_stats_row.dart';
import '../../widgets/property/property_description_section.dart';
import '../../widgets/property/property_amenities_section.dart';
import '../../widgets/property/property_location_section.dart';
import '../../widgets/property/property_contact_buttons.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.property['isFavorite'] ?? false;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _shareProperty() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Property shared!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _contactLandlord() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Contacting landlord...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _callLandlord() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Calling landlord...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildPropertyContent(),
        ],
      ),
      floatingActionButton: PropertyContactButtons(
        onContactLandlord: _contactLandlord,
        onCall: _callLandlord,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.backArrowSvg,
              height: 20,
              width: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      actions: [
        _buildActionButton(
          icon: AppAssets.shareSvg,
          onTap: _shareProperty,
        ),
        _buildActionButton(
          icon: AppAssets.favoriteSvg,
          onTap: _toggleFavorite,
          color: _isFavorite ? Colors.red : Colors.white,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.property['color'] ?? AppColors.primary,
                (widget.property['color'] ?? AppColors.primary).withAlpha(200),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.home_rounded,
              size: 100,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          icon,
          height: 20,
          width: 20,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget _buildPropertyContent() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyHeader(property: widget.property),
            const SizedBox(height: 24),
            PropertyStatsRow(property: widget.property),
            const SizedBox(height: 24),
            PropertyDescriptionSection(
              description: widget.property['description'],
            ),
            const SizedBox(height: 24),
            const PropertyAmenitiesSection(),
            const SizedBox(height: 24),
            PropertyLocationSection(
              location: widget.property['location'],
            ),
            const SizedBox(height: 100), // Space for floating button
          ],
        ),
      ),
    );
  }
}
