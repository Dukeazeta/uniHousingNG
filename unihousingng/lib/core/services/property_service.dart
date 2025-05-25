import '../../data/models/property_model.dart';
import '../../data/models/category_model.dart';
import '../../data/mock_data.dart';

class PropertyService {
  static final PropertyService _instance = PropertyService._internal();
  factory PropertyService() => _instance;
  PropertyService._internal();

  // Get featured properties
  Future<List<PropertyModel>> getFeaturedProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.featuredProperties;
  }

  // Get property listings
  Future<List<PropertyModel>> getPropertyListings({
    String? category,
    String? location,
    double? minPrice,
    double? maxPrice,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    List<PropertyModel> properties = MockData.propertyListings;

    // Apply filters
    if (category != null && category.isNotEmpty) {
      properties = properties.where((p) => p.category == category).toList();
    }

    if (location != null && location.isNotEmpty) {
      properties = properties.where((p) => 
        p.location.toLowerCase().contains(location.toLowerCase())
      ).toList();
    }

    // Price filtering would require converting price strings to numbers
    // This is a simplified implementation
    
    return properties;
  }

  // Get property categories
  Future<List<CategoryModel>> getCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.categories;
  }

  // Get property by ID
  Future<PropertyModel?> getPropertyById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Search in all property lists
    final allProperties = [
      ...MockData.featuredProperties,
      ...MockData.propertyListings,
    ];

    try {
      return allProperties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search properties
  Future<List<PropertyModel>> searchProperties(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (query.isEmpty) {
      return MockData.propertyListings;
    }

    final allProperties = [
      ...MockData.featuredProperties,
      ...MockData.propertyListings,
    ];

    return allProperties.where((property) {
      final titleMatch = property.title.toLowerCase().contains(query.toLowerCase());
      final locationMatch = property.location.toLowerCase().contains(query.toLowerCase());
      final categoryMatch = property.category.toLowerCase().contains(query.toLowerCase());
      
      return titleMatch || locationMatch || categoryMatch;
    }).toList();
  }

  // Toggle favorite status
  Future<PropertyModel> toggleFavorite(PropertyModel property) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    return property.copyWith(isFavorite: !property.isFavorite);
  }

  // Get favorite properties
  Future<List<PropertyModel>> getFavoriteProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    final allProperties = [
      ...MockData.featuredProperties,
      ...MockData.propertyListings,
    ];

    return allProperties.where((property) => property.isFavorite).toList();
  }

  // Get properties by category
  Future<List<PropertyModel>> getPropertiesByCategory(String category) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allProperties = [
      ...MockData.featuredProperties,
      ...MockData.propertyListings,
    ];

    return allProperties.where((property) => property.category == category).toList();
  }

  // Get properties near campus
  Future<List<PropertyModel>> getPropertiesNearCampus(String campus) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    final allProperties = [
      ...MockData.featuredProperties,
      ...MockData.propertyListings,
    ];

    // Simple location matching - in a real app, this would use geolocation
    return allProperties.where((property) {
      return property.location.toLowerCase().contains(campus.toLowerCase()) ||
             campus.toLowerCase().contains(property.location.toLowerCase());
    }).toList();
  }
}
