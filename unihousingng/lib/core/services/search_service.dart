import '../../data/models/property_model.dart';
import '../../data/models/category_model.dart';
import 'property_service.dart';

enum SortOption {
  relevance,
  priceAsc,
  priceDesc,
  newest,
  rating,
  distance,
}

class SearchFilters {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final int? minBeds;
  final int? maxBeds;
  final int? minBaths;
  final int? maxBaths;
  final List<String>? amenities;
  final double? maxDistanceFromCampus;
  final String? campus;
  final bool? furnished;
  final bool? petsAllowed;

  const SearchFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minBeds,
    this.maxBeds,
    this.minBaths,
    this.maxBaths,
    this.amenities,
    this.maxDistanceFromCampus,
    this.campus,
    this.furnished,
    this.petsAllowed,
  });

  SearchFilters copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    int? minBeds,
    int? maxBeds,
    int? minBaths,
    int? maxBaths,
    List<String>? amenities,
    double? maxDistanceFromCampus,
    String? campus,
    bool? furnished,
    bool? petsAllowed,
  }) {
    return SearchFilters(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBeds: minBeds ?? this.minBeds,
      maxBeds: maxBeds ?? this.maxBeds,
      minBaths: minBaths ?? this.minBaths,
      maxBaths: maxBaths ?? this.maxBaths,
      amenities: amenities ?? this.amenities,
      maxDistanceFromCampus: maxDistanceFromCampus ?? this.maxDistanceFromCampus,
      campus: campus ?? this.campus,
      furnished: furnished ?? this.furnished,
      petsAllowed: petsAllowed ?? this.petsAllowed,
    );
  }

  bool get hasActiveFilters {
    return category != null ||
        minPrice != null ||
        maxPrice != null ||
        minBeds != null ||
        maxBeds != null ||
        minBaths != null ||
        maxBaths != null ||
        (amenities != null && amenities!.isNotEmpty) ||
        maxDistanceFromCampus != null ||
        campus != null ||
        furnished != null ||
        petsAllowed != null;
  }

  int get activeFilterCount {
    int count = 0;
    if (category != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (minBeds != null || maxBeds != null) count++;
    if (minBaths != null || maxBaths != null) count++;
    if (amenities != null && amenities!.isNotEmpty) count++;
    if (maxDistanceFromCampus != null) count++;
    if (campus != null) count++;
    if (furnished != null) count++;
    if (petsAllowed != null) count++;
    return count;
  }
}

class SearchResult {
  final List<PropertyModel> properties;
  final int totalCount;
  final String query;
  final SearchFilters filters;
  final SortOption sortOption;
  final Duration searchTime;

  const SearchResult({
    required this.properties,
    required this.totalCount,
    required this.query,
    required this.filters,
    required this.sortOption,
    required this.searchTime,
  });
}

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final PropertyService _propertyService = PropertyService();
  
  // Search history storage
  final List<String> _searchHistory = [];
  final List<SearchFilters> _recentFilters = [];

  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  List<SearchFilters> get recentFilters => List.unmodifiable(_recentFilters);

  // Perform search with filters and sorting
  Future<SearchResult> search({
    required String query,
    SearchFilters filters = const SearchFilters(),
    SortOption sortOption = SortOption.relevance,
  }) async {
    final stopwatch = Stopwatch()..start();

    // Add to search history if not empty
    if (query.trim().isNotEmpty) {
      _addToSearchHistory(query.trim());
    }

    // Add to recent filters if has active filters
    if (filters.hasActiveFilters) {
      _addToRecentFilters(filters);
    }

    // Get all properties
    List<PropertyModel> allProperties = [
      ...await _propertyService.getFeaturedProperties(),
      ...await _propertyService.getPropertyListings(),
    ];

    // Apply search query
    List<PropertyModel> filteredProperties = _applySearchQuery(allProperties, query);

    // Apply filters
    filteredProperties = _applyFilters(filteredProperties, filters);

    // Apply sorting
    filteredProperties = _applySorting(filteredProperties, sortOption, query);

    stopwatch.stop();

    return SearchResult(
      properties: filteredProperties,
      totalCount: filteredProperties.length,
      query: query,
      filters: filters,
      sortOption: sortOption,
      searchTime: stopwatch.elapsed,
    );
  }

  // Apply search query to properties
  List<PropertyModel> _applySearchQuery(List<PropertyModel> properties, String query) {
    if (query.trim().isEmpty) {
      return properties;
    }

    final searchTerms = query.toLowerCase().split(' ').where((term) => term.isNotEmpty).toList();

    return properties.where((property) {
      final searchableText = [
        property.title,
        property.location,
        property.category,
        property.description ?? '',
        ...(property.amenities ?? []),
      ].join(' ').toLowerCase();

      // Check if all search terms are found
      return searchTerms.every((term) => searchableText.contains(term));
    }).toList();
  }

  // Apply filters to properties
  List<PropertyModel> _applyFilters(List<PropertyModel> properties, SearchFilters filters) {
    return properties.where((property) {
      // Category filter
      if (filters.category != null && property.category != filters.category) {
        return false;
      }

      // Price range filter (simplified - would need proper price parsing in real app)
      if (filters.minPrice != null || filters.maxPrice != null) {
        final priceString = property.price.replaceAll(RegExp(r'[^\d.]'), '');
        final price = double.tryParse(priceString) ?? 0;
        
        if (filters.minPrice != null && price < filters.minPrice!) return false;
        if (filters.maxPrice != null && price > filters.maxPrice!) return false;
      }

      // Beds filter
      if (filters.minBeds != null && property.beds < filters.minBeds!) return false;
      if (filters.maxBeds != null && property.beds > filters.maxBeds!) return false;

      // Baths filter
      if (filters.minBaths != null && property.baths < filters.minBaths!) return false;
      if (filters.maxBaths != null && property.baths > filters.maxBaths!) return false;

      // Amenities filter
      if (filters.amenities != null && filters.amenities!.isNotEmpty) {
        final propertyAmenities = property.amenities ?? [];
        final hasRequiredAmenities = filters.amenities!.every(
          (amenity) => propertyAmenities.contains(amenity),
        );
        if (!hasRequiredAmenities) return false;
      }

      // Campus/location filter
      if (filters.campus != null) {
        final campusMatch = property.location.toLowerCase().contains(filters.campus!.toLowerCase());
        if (!campusMatch) return false;
      }

      return true;
    }).toList();
  }

  // Apply sorting to properties
  List<PropertyModel> _applySorting(List<PropertyModel> properties, SortOption sortOption, String query) {
    switch (sortOption) {
      case SortOption.relevance:
        return _sortByRelevance(properties, query);
      case SortOption.priceAsc:
        return _sortByPrice(properties, ascending: true);
      case SortOption.priceDesc:
        return _sortByPrice(properties, ascending: false);
      case SortOption.newest:
        return properties; // Would sort by creation date in real app
      case SortOption.rating:
        return _sortByRating(properties);
      case SortOption.distance:
        return properties; // Would sort by distance from campus in real app
    }
  }

  List<PropertyModel> _sortByRelevance(List<PropertyModel> properties, String query) {
    if (query.trim().isEmpty) return properties;

    // Simple relevance scoring based on title and location matches
    properties.sort((a, b) {
      int scoreA = _calculateRelevanceScore(a, query);
      int scoreB = _calculateRelevanceScore(b, query);
      return scoreB.compareTo(scoreA); // Higher score first
    });

    return properties;
  }

  int _calculateRelevanceScore(PropertyModel property, String query) {
    int score = 0;
    final queryLower = query.toLowerCase();

    // Title exact match gets highest score
    if (property.title.toLowerCase().contains(queryLower)) score += 10;
    
    // Location match gets medium score
    if (property.location.toLowerCase().contains(queryLower)) score += 5;
    
    // Category match gets lower score
    if (property.category.toLowerCase().contains(queryLower)) score += 3;

    // Featured properties get bonus
    // (In real app, you'd have a featured flag)
    
    return score;
  }

  List<PropertyModel> _sortByPrice(List<PropertyModel> properties, {required bool ascending}) {
    properties.sort((a, b) {
      final priceA = _extractPrice(a.price);
      final priceB = _extractPrice(b.price);
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });
    return properties;
  }

  List<PropertyModel> _sortByRating(List<PropertyModel> properties) {
    properties.sort((a, b) {
      final ratingA = a.rating ?? 0;
      final ratingB = b.rating ?? 0;
      return ratingB.compareTo(ratingA); // Higher rating first
    });
    return properties;
  }

  double _extractPrice(String priceString) {
    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 0;
  }

  void _addToSearchHistory(String query) {
    _searchHistory.remove(query); // Remove if already exists
    _searchHistory.insert(0, query); // Add to beginning
    
    // Keep only last 10 searches
    if (_searchHistory.length > 10) {
      _searchHistory.removeRange(10, _searchHistory.length);
    }
  }

  void _addToRecentFilters(SearchFilters filters) {
    _recentFilters.insert(0, filters);
    
    // Keep only last 5 filter sets
    if (_recentFilters.length > 5) {
      _recentFilters.removeRange(5, _recentFilters.length);
    }
  }

  void clearSearchHistory() {
    _searchHistory.clear();
  }

  void clearRecentFilters() {
    _recentFilters.clear();
  }

  // Get search suggestions based on history and properties
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.trim().isEmpty) {
      return _searchHistory.take(5).toList();
    }

    final suggestions = <String>[];
    
    // Add matching search history
    suggestions.addAll(
      _searchHistory.where((item) => 
        item.toLowerCase().contains(query.toLowerCase())
      ).take(3)
    );

    // Add property titles and locations that match
    final allProperties = [
      ...await _propertyService.getFeaturedProperties(),
      ...await _propertyService.getPropertyListings(),
    ];

    final propertyMatches = allProperties
        .where((p) => 
          p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.location.toLowerCase().contains(query.toLowerCase())
        )
        .map((p) => p.title)
        .take(3)
        .toList();

    suggestions.addAll(propertyMatches);

    // Remove duplicates and return
    return suggestions.toSet().toList();
  }
}
