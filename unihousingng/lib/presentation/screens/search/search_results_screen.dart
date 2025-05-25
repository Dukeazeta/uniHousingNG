import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/state/search_state.dart';
import '../../../core/services/search_service.dart';
import '../../../data/models/property_model.dart';
import '../../widgets/search/enhanced_search_bar.dart';
import '../../widgets/search/search_filters_bottom_sheet.dart';
import '../../widgets/search/sort_options_bottom_sheet.dart';
import '../../widgets/property/property_card.dart';
import '../../widgets/common/custom_loader.dart';
import '../property/property_details_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchResultsScreen({super.key, this.initialQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final SearchState _searchState = SearchState();

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchState.quickSearch(widget.initialQuery!);
      });
    }
  }

  void _onSearch(String query) {
    _searchState.quickSearch(query);
  }

  void _onFilterTap() {
    SearchFiltersBottomSheet.show(
      context,
      currentFilters: _searchState.currentFilters,
      onFiltersChanged: (filters) {
        _searchState.setFilters(filters);
        _searchState.search();
      },
    );
  }

  void _onSortTap() {
    SortOptionsBottomSheet.show(
      context,
      currentSortOption: _searchState.currentSortOption,
      onSortChanged: (sortOption) {
        _searchState.setSortOption(sortOption);
      },
    );
  }

  void _onPropertyTap(PropertyModel property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsScreen(property: property),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search Properties',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: EnhancedSearchBar(
              onSearch: _onSearch,
              onFilterTap: _onFilterTap,
              autofocus: widget.initialQuery == null,
            ),
          ),

          // Search results
          Expanded(
            child: ListenableBuilder(
              listenable: _searchState,
              builder: (context, _) {
                if (_searchState.isSearching) {
                  return const Center(
                    child: CustomLoader(
                      size: 60,
                      text: 'Searching properties...',
                    ),
                  );
                }

                if (!_searchState.hasSearched) {
                  return _buildEmptyState();
                }

                if (!_searchState.hasResults) {
                  return _buildNoResultsState();
                }

                return _buildSearchResults();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 80,
            color: AppColors.textSecondary.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for Properties',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your perfect student accommodation\nnear Nigerian campuses',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildQuickSearchSuggestions(),
        ],
      ),
    );
  }

  Widget _buildQuickSearchSuggestions() {
    final suggestions = [
      'FUPRE',
      'UNILAG',
      'Apartments',
      'Hostels',
      'Bedsitters',
    ];

    return Column(
      children: [
        Text(
          'Quick searches:',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              suggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () => _onSearch(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(50),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: AppColors.textSecondary.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            'No Properties Found',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters\nto find more properties',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_searchState.hasActiveFilters)
            ElevatedButton(
              onPressed: () {
                _searchState.clearFilters();
                _searchState.search();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Clear Filters',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Results header with sort and filter info
        _buildResultsHeader(),

        // Results grid
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await _searchState.search();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
              ),
              itemCount: _searchState.searchResults.length,
              itemBuilder: (context, index) {
                final property = _searchState.searchResults[index];
                return PropertyCard(
                  property: property,
                  onTap: () => _onPropertyTap(property),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.surface, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _searchState.getSearchSummary(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (_searchState.lastSearchResult != null)
                  Text(
                    'Found in ${_searchState.lastSearchResult!.searchTime.inMilliseconds}ms',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          // Sort button
          GestureDetector(
            onTap: _onSortTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sort',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
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
