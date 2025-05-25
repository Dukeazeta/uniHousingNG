import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/services/search_service.dart';
import '../../../data/mock_data.dart';
import '../common/custom_button.dart';

class SearchFiltersBottomSheet extends StatefulWidget {
  final SearchFilters currentFilters;
  final Function(SearchFilters) onFiltersChanged;

  const SearchFiltersBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  static void show(
    BuildContext context, {
    required SearchFilters currentFilters,
    required Function(SearchFilters) onFiltersChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchFiltersBottomSheet(
        currentFilters: currentFilters,
        onFiltersChanged: onFiltersChanged,
      ),
    );
  }

  @override
  State<SearchFiltersBottomSheet> createState() => _SearchFiltersBottomSheetState();
}

class _SearchFiltersBottomSheetState extends State<SearchFiltersBottomSheet> {
  late SearchFilters _filters;
  late RangeValues _priceRange;
  late RangeValues _bedsRange;
  late RangeValues _bathsRange;
  late Set<String> _selectedAmenities;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    
    // Initialize ranges
    _priceRange = RangeValues(
      _filters.minPrice ?? 10000,
      _filters.maxPrice ?? 100000,
    );
    
    _bedsRange = RangeValues(
      (_filters.minBeds ?? 1).toDouble(),
      (_filters.maxBeds ?? 5).toDouble(),
    );
    
    _bathsRange = RangeValues(
      (_filters.minBaths ?? 1).toDouble(),
      (_filters.maxBaths ?? 3).toDouble(),
    );
    
    _selectedAmenities = Set.from(_filters.amenities ?? []);
  }

  void _updateFilters() {
    _filters = _filters.copyWith(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minBeds: _bedsRange.start.round(),
      maxBeds: _bedsRange.end.round(),
      minBaths: _bathsRange.start.round(),
      maxBaths: _bathsRange.end.round(),
      amenities: _selectedAmenities.toList(),
    );
  }

  void _applyFilters() {
    _updateFilters();
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters = const SearchFilters();
      _priceRange = const RangeValues(10000, 100000);
      _bedsRange = const RangeValues(1, 5);
      _bathsRange = const RangeValues(1, 3);
      _selectedAmenities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Property Category
                  _buildCategoryFilter(),
                  const SizedBox(height: 24),

                  // Price Range
                  _buildPriceRangeFilter(),
                  const SizedBox(height: 24),

                  // Bedrooms
                  _buildBedsFilter(),
                  const SizedBox(height: 24),

                  // Bathrooms
                  _buildBathsFilter(),
                  const SizedBox(height: 24),

                  // Amenities
                  _buildAmenitiesFilter(),
                  const SizedBox(height: 24),

                  // Campus
                  _buildCampusFilter(),
                  const SizedBox(height: 100), // Space for buttons
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: 'Apply Filters',
                    onPressed: _applyFilters,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Property Type'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MockData.categories.map((category) {
            final isSelected = _filters.category == category.name;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _filters = _filters.copyWith(
                    category: isSelected ? null : category.name,
                  );
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                  ),
                ),
                child: Text(
                  category.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Price Range'),
        const SizedBox(height: 12),
        RangeSlider(
          values: _priceRange,
          min: 5000,
          max: 200000,
          divisions: 39,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface,
          labels: RangeLabels(
            '₦${_priceRange.start.round()}',
            '₦${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₦${_priceRange.start.round().toString()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '₦${_priceRange.end.round().toString()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBedsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Bedrooms'),
        const SizedBox(height: 12),
        RangeSlider(
          values: _bedsRange,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface,
          labels: RangeLabels(
            '${_bedsRange.start.round()}',
            '${_bedsRange.end.round()}+',
          ),
          onChanged: (values) {
            setState(() {
              _bedsRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBathsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Bathrooms'),
        const SizedBox(height: 12),
        RangeSlider(
          values: _bathsRange,
          min: 1,
          max: 3,
          divisions: 2,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface,
          labels: RangeLabels(
            '${_bathsRange.start.round()}',
            '${_bathsRange.end.round()}+',
          ),
          onChanged: (values) {
            setState(() {
              _bathsRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAmenitiesFilter() {
    final amenities = ['WiFi', 'Parking', 'Security', 'Power', 'Water', 'AC', 'Kitchen'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Amenities'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedAmenities.remove(amenity);
                  } else {
                    _selectedAmenities.add(amenity);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                  ),
                ),
                child: Text(
                  amenity,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCampusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Near Campus'),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _filters.campus,
          decoration: InputDecoration(
            hintText: 'Select campus',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.surface),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.surface),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          items: MockData.nigerianCampuses.map((campus) {
            return DropdownMenuItem(
              value: campus,
              child: Text(campus),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(campus: value);
            });
          },
        ),
      ],
    );
  }
}
