import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../widgets/common/custom_loader.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final PageController _carouselController = PageController();

  int _currentBannerIndex = 0;
  bool _isLoading = true;

  // Current selected campus
  String _selectedCampus = 'FUPRE, Delta';

  // List of Nigerian campuses
  final List<String> _nigerianCampuses = [
    'FUPRE, Delta',
    'UNILAG, Lagos',
    'UI, Ibadan',
    'UNIBEN, Benin',
    'OAU, Ile-Ife',
    'UNIZIK, Awka',
    'UNIPORT, Port Harcourt',
    'ABU, Zaria',
    'UNILORIN, Ilorin',
    'UNIJOS, Jos',
  ];

  // Mock data for featured properties
  final List<Map<String, dynamic>> _featuredProperties = [
    {
      'id': '1',
      'title': 'Modern Studio Apartment',
      'location': 'Near University of Lagos',
      'price': '₦150,000',
      'color': Colors.blue[100]!,
      'rating': 4.8,
    },
    {
      'id': '2',
      'title': 'Cozy 2-Bedroom Flat',
      'location': 'Close to Covenant University',
      'price': '₦250,000',
      'color': Colors.green[100]!,
      'rating': 4.5,
    },
    {
      'id': '3',
      'title': 'Luxury Student Hostel',
      'location': 'University of Ibadan Area',
      'price': '₦180,000',
      'color': Colors.orange[100]!,
      'rating': 4.7,
    },
  ];

  // Mock data for property categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Bedsitters', 'icon': AppAssets.houseSvg, 'count': 95},
    {'name': 'Apartments', 'icon': AppAssets.apartmentSvg, 'count': 120},
    {'name': 'Hostels', 'icon': AppAssets.hostelSvg, 'count': 85},
    {'name': 'Selfcontains', 'icon': AppAssets.apartmentSvg, 'count': 68},
    {'name': 'Shared', 'icon': AppAssets.sharedSvg, 'count': 42},
  ];

  // Mock data for property listings
  final List<Map<String, dynamic>> _propertyListings = [
    {
      'id': '1',
      'title': 'Modern Family House',
      'location': 'Near FUPRE Campus',
      'price': '₦28.6k/month',
      'image': 'assets/images/house1.jpg',
      'beds': 4,
      'baths': 1,
      'isFavorite': false,
      'color': Colors.blue[100]!,
      'category': 'Apartments',
    },
    {
      'id': '2',
      'title': 'Contemporary House',
      'location': 'Ugbomro, Effurun',
      'price': '₦25.5k/month',
      'image': 'assets/images/house2.jpg',
      'beds': 3,
      'baths': 1,
      'isFavorite': false,
      'color': Colors.green[100]!,
      'category': 'Bedsitters',
    },
    {
      'id': '3',
      'title': 'Luxury Apartment',
      'location': 'Near FUPRE Campus',
      'price': '₦32.5k/month',
      'image': 'assets/images/house3.jpg',
      'beds': 3,
      'baths': 2,
      'isFavorite': false,
      'color': Colors.purple[100]!,
      'category': 'Apartments',
    },
    {
      'id': '4',
      'title': 'Student Hostel',
      'location': 'University Road',
      'price': '₦18.9k/month',
      'image': 'assets/images/house4.jpg',
      'beds': 1,
      'baths': 1,
      'isFavorite': false,
      'color': Colors.orange[100]!,
      'category': 'Hostels',
    },
  ];

  // Selected tab index
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    // Immediately set loading to false for testing
    // In a real app, this would happen after data is fetched
    setState(() {
      _isLoading = false;
    });

    // Set up carousel auto-scroll
    Future.delayed(const Duration(milliseconds: 500), () {
      _setupCarouselTimer();
    });
  }

  void _setupCarouselTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final nextPage = (_currentBannerIndex + 1) % _featuredProperties.length;
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

  // Show campus selection dialog
  void _showCampusSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    itemCount: _nigerianCampuses.length,
                    itemBuilder: (context, index) {
                      final campus = _nigerianCampuses[index];
                      final isSelected = campus == _selectedCampus;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCampus = campus;
                          });
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
                                    color:
                                        isSelected
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    campus,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                      color:
                                          isSelected
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
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading ? _buildLoadingView() : _buildHomeContent(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CustomLoader(size: 80, text: 'Finding your perfect home...'),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        // Simulate refreshing data
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting, profile and location
            _buildHeader(),
            const SizedBox(height: 24),

            // Featured properties carousel
            _buildFeaturedCarousel(),
            const SizedBox(height: 24),

            // Tabbed interface for Listings and Categories
            _buildTabbedInterface(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabbedInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab selector
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // Listings Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          _selectedTabIndex == 0
                              ? AppColors.primary
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Listings',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              _selectedTabIndex == 0
                                  ? Colors.white
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Categories Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          _selectedTabIndex == 1
                              ? AppColors.primary
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Categories',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              _selectedTabIndex == 1
                                  ? Colors.white
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tab content with animated crossfade for smooth transition
        AnimatedCrossFade(
          firstChild: _buildListingsGrid(),
          secondChild: _buildCategories(),
          crossFadeState:
              _selectedTabIndex == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 400),
          firstCurve: Curves.easeOutQuint,
          secondCurve: Curves.easeOutQuint,
          sizeCurve: Curves.easeInOutCubic,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User profile and greeting
            Row(
              children: [
                // Profile image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'D',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Duke',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showCampusSelectionDialog(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _selectedCampus,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Notification icon
            GestureDetector(
              onTap: () {
                // Navigate to notifications
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedCarousel() {
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
            itemCount: _featuredProperties.length,
            physics: const BouncingScrollPhysics(),
            padEnds: false,
            pageSnapping: true,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final property = _featuredProperties[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to property details
                },
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: property['color'],
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
                                property['title'],
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
                                      property['location'],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    property['price'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        property['rating'].toString(),
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
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _featuredProperties.length,
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
                  color:
                      _currentBannerIndex == index
                          ? AppColors.primary
                          : AppColors.primary.withAlpha(77),
                  boxShadow:
                      _currentBannerIndex == index
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
        ),
      ],
    );
  }

  Widget _buildCategories() {
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
              'Categories',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryItem(_categories[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        // Navigate to category listings
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.primary.withAlpha(30), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              category['icon'],
              height: 40,
              width: 40,
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
            const SizedBox(height: 12),
            Text(
              category['name'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${category['count']}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
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
                'Recent Listings',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to all listings
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
        ),

        // Listings grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68, // Adjusted to provide more vertical space
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
          ),
          itemCount: _propertyListings.length,
          itemBuilder: (context, index) {
            final property = _propertyListings[index];
            return _buildPropertyCard(property);
          },
        ),
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    // Default colors in case the property doesn't have a color defined
    final Color propertyColor = property['color'] ?? Colors.blue[100]!;

    return Container(
      decoration: BoxDecoration(
        color: propertyColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: propertyColor.withAlpha(128),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property header with category badge
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withAlpha(150),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    property['category'] ?? 'Property',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Favorite button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      property['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: property['isFavorite'] ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property icon
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.home_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Property details
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          property['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: propertyColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      property['price'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property['location'],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Beds and baths - using a more compact layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Beds
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bed_outlined,
                            size: 14,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property['beds']} Beds',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      // Baths
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bathtub_outlined,
                            size: 14,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property['baths']} Bath',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for decorative pattern
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    final double spacing = 12;

    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(i, 0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
