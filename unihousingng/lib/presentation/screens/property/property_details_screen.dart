import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../data/models/property_model.dart';
import '../../widgets/property/property_header.dart';
import '../../widgets/property/property_stats_row.dart';
import '../../widgets/property/property_description_section.dart';
import '../../widgets/property/property_amenities_section.dart';
import '../../widgets/property/property_location_section.dart';
import '../../widgets/property/property_contact_buttons.dart';
import '../../widgets/property/property_image_gallery.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _isFavorite = false;

  Color _getPropertyColor() {
    return widget.property.color;
  }

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.property.isFavorite;
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
        slivers: [_buildSliverAppBar(), _buildPropertyContent()],
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
        _buildActionButton(icon: AppAssets.shareSvg, onTap: _shareProperty),
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
              colors: [_getPropertyColor(), _getPropertyColor().withAlpha(200)],
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
            // Image Gallery
            if (widget.property.hasImages) ...[
              PropertyImageGallery(
                images: widget.property.images,
                height: 250,
                showIndicators: true,
                showImageCount: true,
                enableFullScreen: true,
              ),
              const SizedBox(height: 24),
            ],

            PropertyHeader(property: widget.property.toMap()),
            const SizedBox(height: 24),
            PropertyStatsRow(property: widget.property.toMap()),
            const SizedBox(height: 24),
            PropertyDescriptionSection(
              description: widget.property.description,
            ),
            const SizedBox(height: 24),
            const PropertyAmenitiesSection(),
            const SizedBox(height: 24),
            PropertyLocationSection(location: widget.property.location),

            // Virtual Tour Button
            if (widget.property.hasVirtualTour) ...[
              const SizedBox(height: 24),
              _buildVirtualTourButton(widget.property.virtualTourUrl!),
            ],

            const SizedBox(height: 100), // Space for floating button
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualTourButton(String virtualTourUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            'Take Virtual Tour',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
