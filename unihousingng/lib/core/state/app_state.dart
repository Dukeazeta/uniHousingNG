import 'package:flutter/foundation.dart';
import '../../data/models/property_model.dart';
import '../../data/models/category_model.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Current selected campus
  String _selectedCampus = 'FUPRE, Delta';
  String get selectedCampus => _selectedCampus;

  void setSelectedCampus(String campus) {
    _selectedCampus = campus;
    notifyListeners();
  }

  // Loading states
  bool _isLoadingProperties = false;
  bool _isLoadingCategories = false;
  bool _isLoadingFeatured = false;

  bool get isLoadingProperties => _isLoadingProperties;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingFeatured => _isLoadingFeatured;

  void setLoadingProperties(bool loading) {
    _isLoadingProperties = loading;
    notifyListeners();
  }

  void setLoadingCategories(bool loading) {
    _isLoadingCategories = loading;
    notifyListeners();
  }

  void setLoadingFeatured(bool loading) {
    _isLoadingFeatured = loading;
    notifyListeners();
  }

  // Properties data
  List<PropertyModel> _featuredProperties = [];
  List<PropertyModel> _propertyListings = [];
  List<CategoryModel> _categories = [];
  List<PropertyModel> _favoriteProperties = [];

  List<PropertyModel> get featuredProperties => _featuredProperties;
  List<PropertyModel> get propertyListings => _propertyListings;
  List<CategoryModel> get categories => _categories;
  List<PropertyModel> get favoriteProperties => _favoriteProperties;

  void setFeaturedProperties(List<PropertyModel> properties) {
    _featuredProperties = properties;
    notifyListeners();
  }

  void setPropertyListings(List<PropertyModel> properties) {
    _propertyListings = properties;
    notifyListeners();
  }

  void setCategories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setFavoriteProperties(List<PropertyModel> properties) {
    _favoriteProperties = properties;
    notifyListeners();
  }

  // Search and filter state
  String _searchQuery = '';
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;

  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    notifyListeners();
  }

  // Toggle favorite property
  void toggleFavorite(PropertyModel property) {
    final updatedProperty = property.copyWith(isFavorite: !property.isFavorite);
    
    // Update in featured properties
    final featuredIndex = _featuredProperties.indexWhere((p) => p.id == property.id);
    if (featuredIndex != -1) {
      _featuredProperties[featuredIndex] = updatedProperty;
    }

    // Update in property listings
    final listingIndex = _propertyListings.indexWhere((p) => p.id == property.id);
    if (listingIndex != -1) {
      _propertyListings[listingIndex] = updatedProperty;
    }

    // Update favorites list
    if (updatedProperty.isFavorite) {
      if (!_favoriteProperties.any((p) => p.id == property.id)) {
        _favoriteProperties.add(updatedProperty);
      }
    } else {
      _favoriteProperties.removeWhere((p) => p.id == property.id);
    }

    notifyListeners();
  }

  // Get filtered properties
  List<PropertyModel> getFilteredProperties() {
    List<PropertyModel> filtered = List.from(_propertyListings);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((property) {
        final titleMatch = property.title.toLowerCase().contains(_searchQuery.toLowerCase());
        final locationMatch = property.location.toLowerCase().contains(_searchQuery.toLowerCase());
        final categoryMatch = property.category.toLowerCase().contains(_searchQuery.toLowerCase());
        return titleMatch || locationMatch || categoryMatch;
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered = filtered.where((property) => property.category == _selectedCategory).toList();
    }

    // Price filtering would require converting price strings to numbers
    // This is a simplified implementation

    return filtered;
  }

  // Reset all state
  void reset() {
    _selectedCampus = 'FUPRE, Delta';
    _featuredProperties = [];
    _propertyListings = [];
    _categories = [];
    _favoriteProperties = [];
    _searchQuery = '';
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _isLoadingProperties = false;
    _isLoadingCategories = false;
    _isLoadingFeatured = false;
    notifyListeners();
  }
}
