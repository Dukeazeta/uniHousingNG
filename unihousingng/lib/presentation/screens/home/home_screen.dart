import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/property_model.dart';
import '../../../data/models/category_model.dart';
import '../../widgets/common/custom_loader.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/campus_selection_dialog.dart';
import '../../widgets/home/featured_properties_carousel.dart';
import '../../widgets/home/home_tab_selector.dart';
import '../../widgets/home/property_listings_grid.dart';
import '../../widgets/home/categories_grid.dart';
import '../../widgets/search/enhanced_search_bar.dart';
import '../property/property_details_screen.dart';
import '../search/search_results_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  String _selectedCampus = 'FUPRE, Delta';
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _onCampusSelected(String campus) {
    setState(() {
      _selectedCampus = campus;
    });
  }

  void _onPropertyTap(PropertyModel property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsScreen(property: property),
      ),
    );
  }

  void _onCategoryTap(CategoryModel category) {
    // Navigate to search results with category filter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(initialQuery: category.name),
      ),
    );
  }

  void _onSearchTap(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(initialQuery: query),
      ),
    );
  }

  void _onFilterTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchResultsScreen()),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
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
            HomeHeader(
              selectedCampus: _selectedCampus,
              onLocationTap: () {
                CampusSelectionDialog.show(
                  context,
                  selectedCampus: _selectedCampus,
                  onCampusSelected: _onCampusSelected,
                );
              },
            ),
            const SizedBox(height: 24),

            // Enhanced search bar
            EnhancedSearchBar(
              onSearch: _onSearchTap,
              onFilterTap: _onFilterTap,
              hintText:
                  'Search properties near ${_selectedCampus.split(',')[0]}...',
            ),
            const SizedBox(height: 24),

            // Featured properties carousel
            FeaturedPropertiesCarousel(
              properties: MockData.featuredProperties,
              onPropertyTap: _onPropertyTap,
            ),
            const SizedBox(height: 24),

            // Tabbed interface for Listings and Categories
            HomeTabSelector(
              selectedTabIndex: _selectedTabIndex,
              onTabSelected: _onTabSelected,
            ),
            const SizedBox(height: 24),

            // Tab content with animated crossfade for smooth transition
            AnimatedCrossFade(
              firstChild: PropertyListingsGrid(
                properties: MockData.propertyListings,
                onPropertyTap: _onPropertyTap,
              ),
              secondChild: CategoriesGrid(
                categories: MockData.categories,
                onCategoryTap: _onCategoryTap,
              ),
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
        ),
      ),
    );
  }
}
