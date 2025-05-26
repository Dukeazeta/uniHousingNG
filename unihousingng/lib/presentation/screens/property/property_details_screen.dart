import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/services/contact_service.dart';
import '../../../core/services/favorites_service.dart';
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
  final FavoritesService _favoritesService = FavoritesService();

  Color _getPropertyColor() {
    return widget.property.color;
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFav = await _favoritesService.isFavorite(widget.property.id);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    final success = await _favoritesService.toggleFavorite(widget.property.id);
    if (success && mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Added to favorites!' : 'Removed from favorites!',
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
    if (widget.property.hasLandlord) {
      ContactService.showContactOptions(
        context,
        phone: widget.property.landlordPhone,
        whatsapp: widget.property.landlordWhatsApp,
        email: widget.property.landlordEmail,
        propertyTitle: widget.property.title,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact information not available'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _callLandlord() {
    if (widget.property.landlordPhone.isNotEmpty) {
      ContactService.makePhoneCall(widget.property.landlordPhone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number not available'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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

            // Landlord Information
            if (widget.property.hasLandlord) ...[
              const SizedBox(height: 24),
              _buildLandlordSection(),
            ],

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

  Widget _buildLandlordSection() {
    final landlord = widget.property.landlord!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Landlord Information',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (landlord.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                    landlord.profileImageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            landlord.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 30,
                                ),
                          ),
                        )
                        : Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 30,
                        ),
              ),
              const SizedBox(width: 16),

              // Landlord Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landlord.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (landlord.rating != null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            landlord.ratingText,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${landlord.reviewsText})',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    Text(
                      landlord.propertiesText,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (landlord.bio != null) ...[
            const SizedBox(height: 16),
            Text(
              landlord.bio!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Contact Buttons
          Row(
            children: [
              if (landlord.hasPhone)
                Expanded(
                  child: _buildContactButton(
                    icon: Icons.phone,
                    label: 'Call',
                    color: Colors.green,
                    onTap:
                        () =>
                            ContactService.makePhoneCall(landlord.displayPhone),
                  ),
                ),
              if (landlord.hasPhone && landlord.hasWhatsApp)
                const SizedBox(width: 12),
              if (landlord.hasWhatsApp)
                Expanded(
                  child: _buildContactButton(
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    color: Colors.green[600]!,
                    onTap:
                        () => ContactService.sendWhatsAppMessage(
                          landlord.displayWhatsApp,
                          message:
                              'Hello! I\'m interested in your property "${widget.property.title}" on UniHousingNG.',
                        ),
                  ),
                ),
              if ((landlord.hasPhone || landlord.hasWhatsApp) &&
                  landlord.hasEmail)
                const SizedBox(width: 12),
              if (landlord.hasEmail)
                Expanded(
                  child: _buildContactButton(
                    icon: Icons.email,
                    label: 'Email',
                    color: Colors.blue,
                    onTap:
                        () => ContactService.sendEmail(
                          landlord.displayEmail,
                          subject: 'Inquiry about ${widget.property.title}',
                        ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
