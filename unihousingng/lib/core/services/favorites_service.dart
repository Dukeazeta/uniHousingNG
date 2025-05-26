import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/property_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'user_favorites';
  
  // Singleton pattern
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  // Cache for favorites
  List<String> _favoriteIds = [];
  bool _isInitialized = false;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteIds = favoritesJson;
    _isInitialized = true;
  }

  // Get all favorite property IDs
  Future<List<String>> getFavoriteIds() async {
    await initialize();
    return List.from(_favoriteIds);
  }

  // Check if a property is favorite
  Future<bool> isFavorite(String propertyId) async {
    await initialize();
    return _favoriteIds.contains(propertyId);
  }

  // Add property to favorites
  Future<bool> addToFavorites(String propertyId) async {
    await initialize();
    
    if (!_favoriteIds.contains(propertyId)) {
      _favoriteIds.add(propertyId);
      return await _saveFavorites();
    }
    return true; // Already in favorites
  }

  // Remove property from favorites
  Future<bool> removeFromFavorites(String propertyId) async {
    await initialize();
    
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
      return await _saveFavorites();
    }
    return true; // Already not in favorites
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String propertyId) async {
    await initialize();
    
    if (_favoriteIds.contains(propertyId)) {
      return await removeFromFavorites(propertyId);
    } else {
      return await addToFavorites(propertyId);
    }
  }

  // Get favorite properties from a list
  Future<List<PropertyModel>> getFavoriteProperties(List<PropertyModel> allProperties) async {
    await initialize();
    
    return allProperties.where((property) => _favoriteIds.contains(property.id)).toList();
  }

  // Get favorite count
  Future<int> getFavoriteCount() async {
    await initialize();
    return _favoriteIds.length;
  }

  // Clear all favorites
  Future<bool> clearAllFavorites() async {
    await initialize();
    
    _favoriteIds.clear();
    return await _saveFavorites();
  }

  // Save favorites to SharedPreferences
  Future<bool> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoriteIds);
      return true;
    } catch (e) {
      print('Error saving favorites: $e');
      return false;
    }
  }

  // Export favorites as JSON (for backup/sync)
  Future<String> exportFavorites() async {
    await initialize();
    
    return jsonEncode({
      'favorites': _favoriteIds,
      'timestamp': DateTime.now().toIso8601String(),
      'count': _favoriteIds.length,
    });
  }

  // Import favorites from JSON (for backup/sync)
  Future<bool> importFavorites(String jsonData) async {
    try {
      final data = jsonDecode(jsonData);
      final List<String> importedFavorites = List<String>.from(data['favorites'] ?? []);
      
      _favoriteIds = importedFavorites;
      _isInitialized = true;
      
      return await _saveFavorites();
    } catch (e) {
      print('Error importing favorites: $e');
      return false;
    }
  }

  // Get recently added favorites (last 10)
  Future<List<String>> getRecentFavorites({int limit = 10}) async {
    await initialize();
    
    // Since we don't track timestamps, just return the last added ones
    final recentCount = _favoriteIds.length > limit ? limit : _favoriteIds.length;
    return _favoriteIds.reversed.take(recentCount).toList();
  }

  // Batch operations
  Future<bool> addMultipleToFavorites(List<String> propertyIds) async {
    await initialize();
    
    bool hasChanges = false;
    for (String id in propertyIds) {
      if (!_favoriteIds.contains(id)) {
        _favoriteIds.add(id);
        hasChanges = true;
      }
    }
    
    if (hasChanges) {
      return await _saveFavorites();
    }
    return true;
  }

  Future<bool> removeMultipleFromFavorites(List<String> propertyIds) async {
    await initialize();
    
    bool hasChanges = false;
    for (String id in propertyIds) {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
        hasChanges = true;
      }
    }
    
    if (hasChanges) {
      return await _saveFavorites();
    }
    return true;
  }

  // Statistics
  Future<Map<String, dynamic>> getFavoritesStats() async {
    await initialize();
    
    return {
      'total_favorites': _favoriteIds.length,
      'has_favorites': _favoriteIds.isNotEmpty,
      'favorite_ids': List.from(_favoriteIds),
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  // Search within favorites
  Future<List<PropertyModel>> searchFavorites(
    List<PropertyModel> allProperties, 
    String query
  ) async {
    final favorites = await getFavoriteProperties(allProperties);
    
    if (query.isEmpty) return favorites;
    
    final lowercaseQuery = query.toLowerCase();
    return favorites.where((property) {
      return property.title.toLowerCase().contains(lowercaseQuery) ||
             property.location.toLowerCase().contains(lowercaseQuery) ||
             property.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
