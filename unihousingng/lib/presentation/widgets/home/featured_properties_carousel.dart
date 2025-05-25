import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../data/models/property_model.dart';

class FeaturedPropertiesCarousel extends StatefulWidget {
  final List<PropertyModel> properties;
  final Function(PropertyModel) onPropertyTap;

  const FeaturedPropertiesCarousel({
    super.key,
    required this.properties,
    required this.onPropertyTap,
  });

  @override
  State<FeaturedPropertiesCarousel> createState() =>
      _FeaturedPropertiesCarouselState();
}

class _FeaturedPropertiesCarouselState
    extends State<FeaturedPropertiesCarousel> {
  final PageController _carouselController = PageController();
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set up carousel auto-scroll
    Future.delayed(const Duration(milliseconds: 500), () {
      _setupCarouselTimer();
    });
  }

  void _setupCarouselTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && widget.properties.isNotEmpty) {
        final nextPage = (_currentBannerIndex + 1) % widget.properties.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutQuint,
        );
        _setupCarouselTimer();
      }
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.properties.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Properties',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all featured properties
              },
              child: Text(
                'See All',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: widget.properties.length,
            physics: const BouncingScrollPhysics(),
            padEnds: false,
            pageSnapping: true,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final property = widget.properties[index];
              return GestureDetector(
                onTap: () => widget.onPropertyTap(property),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0.92,
                    end: _currentBannerIndex == index ? 1.0 : 0.92,
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuint,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: _buildPropertyCard(property),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildPageIndicators(),
      ],
    );
  }

  Widget _buildPropertyCard(PropertyModel property) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: property.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Property icon
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.home_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
          // Gradient overlay and content
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.4, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(200),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white.withAlpha(204),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.location,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withAlpha(204),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property.price,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (property.rating != null)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            property.rating.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.properties.length,
        (index) => GestureDetector(
          onTap: () {
            _carouselController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            width: _currentBannerIndex == index ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _currentBannerIndex == index
                  ? AppColors.primary
                  : AppColors.primary.withAlpha(77),
              boxShadow: _currentBannerIndex == index
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(100),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
