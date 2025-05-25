import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants.dart';
import '../../../data/models/property_model.dart';
import '../../../data/models/campus_model.dart';
import '../../../data/sample_data/campus_data.dart';
import '../../../data/mock_data.dart';
import '../../widgets/map/property_map_widget.dart';
import '../property/property_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CampusModel? _selectedCampus;
  List<PropertyModel> _properties = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Apartments',
    'Bedsitters',
    'Hostels',
    'Selfcontains',
    'Shared',
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Set default campus to FUPRE
    _selectedCampus = CampusData.fupre;

    // Load all properties
    _properties = [
      ...MockData.featuredProperties,
      ...MockData.propertyListings,
    ];

    setState(() {
      _isLoading = false;
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

  void _onCampusChanged(CampusModel? campus) {
    setState(() {
      _selectedCampus = campus;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  List<PropertyModel> get _filteredProperties {
    if (_selectedFilter == 'All') {
      return _properties;
    }
    return _properties
        .where((property) => property.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with campus selector and filters
            _buildHeader(),

            // Map
            Expanded(
              child: PropertyMapWidget(
                properties: _filteredProperties,
                selectedCampus: _selectedCampus,
                onPropertyTap: _onPropertyTap,
                height: double.infinity,
                showControls: true,
                showCampusMarkers: true,
                initialCenter: _selectedCampus?.location,
                initialZoom: 13.0,
              ),
            ),

            // Bottom info panel
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and campus selector
          Row(
            children: [
              const Text(
                'Property Map',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              _buildCampusSelector(),
            ],
          ),

          const SizedBox(height: 12),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _filterOptions.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _onFilterChanged(filter);
                          }
                        },
                        backgroundColor: Colors.grey[100],
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.grey[700],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : Colors.grey[300]!,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampusSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CampusModel>(
          value: _selectedCampus,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primary,
            size: 20,
          ),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items:
              CampusData.allCampuses.map((campus) {
                return DropdownMenuItem<CampusModel>(
                  value: campus,
                  child: Text(campus.shortName),
                );
              }).toList(),
          onChanged: _onCampusChanged,
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    final filteredCount = _filteredProperties.length;
    final campusName = _selectedCampus?.shortName ?? 'All Campuses';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  campusName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              '$filteredCount properties found',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),

          // Legend button
          IconButton(
            onPressed: _showLegend,
            icon: const Icon(Icons.info_outline, color: AppColors.primary),
            tooltip: 'Map Legend',
          ),
        ],
      ),
    );
  }

  void _showLegend() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Map Legend',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildLegendItem(
                  color: Colors.blue,
                  label: 'Campus',
                  description: 'University campus location',
                ),
                _buildLegendItem(
                  color: Colors.green,
                  label: 'Bedsitters',
                  description: 'Single room accommodations',
                ),
                _buildLegendItem(
                  color: Colors.orange,
                  label: 'Apartments',
                  description: 'Multi-room apartments',
                ),
                _buildLegendItem(
                  color: Colors.purple,
                  label: 'Hostels',
                  description: 'Student hostel accommodations',
                ),
                _buildLegendItem(
                  color: Colors.yellow[700]!,
                  label: 'Selfcontains',
                  description: 'Self-contained units',
                ),
                _buildLegendItem(
                  color: Colors.cyan,
                  label: 'Shared',
                  description: 'Shared accommodations',
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
