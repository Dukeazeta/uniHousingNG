import 'package:flutter/foundation.dart';
import '../../data/models/property_model.dart';
import '../services/search_service.dart';

class SearchState extends ChangeNotifier {
  static final SearchState _instance = SearchState._internal();
  factory SearchState() => _instance;
  SearchState._internal();

  final SearchService _searchService = SearchService();

  // Current search state
  String _currentQuery = '';
  SearchFilters _currentFilters = const SearchFilters();
  SortOption _currentSortOption = SortOption.relevance;
  
  // Search results
  List<PropertyModel> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  SearchResult? _lastSearchResult;
  
  // Suggestions
  List<String> _suggestions = [];
  bool _isLoadingSuggestions = false;

  // Getters
  String get currentQuery => _currentQuery;
  SearchFilters get currentFilters => _currentFilters;
  SortOption get currentSortOption => _currentSortOption;
  List<PropertyModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get hasSearched => _hasSearched;
  SearchResult? get lastSearchResult => _lastSearchResult;
  List<String> get suggestions => _suggestions;
  bool get isLoadingSuggestions => _isLoadingSuggestions;
  List<String> get searchHistory => _searchService.searchHistory;
  List<SearchFilters> get recentFilters => _searchService.recentFilters;

  // Computed properties
  bool get hasActiveFilters => _currentFilters.hasActiveFilters;
  int get activeFilterCount => _currentFilters.activeFilterCount;
  bool get hasResults => _searchResults.isNotEmpty;
  int get resultCount => _searchResults.length;

  // Set search query
  void setQuery(String query) {
    if (_currentQuery != query) {
      _currentQuery = query;
      notifyListeners();
      
      // Load suggestions for non-empty queries
      if (query.trim().isNotEmpty) {
        _loadSuggestions(query);
      } else {
        _suggestions.clear();
        notifyListeners();
      }
    }
  }

  // Set filters
  void setFilters(SearchFilters filters) {
    _currentFilters = filters;
    notifyListeners();
  }

  // Update specific filter
  void updateFilter({
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
    _currentFilters = _currentFilters.copyWith(
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minBeds: minBeds,
      maxBeds: maxBeds,
      minBaths: minBaths,
      maxBaths: maxBaths,
      amenities: amenities,
      maxDistanceFromCampus: maxDistanceFromCampus,
      campus: campus,
      furnished: furnished,
      petsAllowed: petsAllowed,
    );
    notifyListeners();
  }

  // Set sort option
  void setSortOption(SortOption sortOption) {
    if (_currentSortOption != sortOption) {
      _currentSortOption = sortOption;
      notifyListeners();
      
      // Re-search with new sort option if we have results
      if (_hasSearched) {
        search();
      }
    }
  }

  // Perform search
  Future<void> search() async {
    _isSearching = true;
    notifyListeners();

    try {
      final result = await _searchService.search(
        query: _currentQuery,
        filters: _currentFilters,
        sortOption: _currentSortOption,
      );

      _searchResults = result.properties;
      _lastSearchResult = result;
      _hasSearched = true;
      _suggestions.clear(); // Clear suggestions after search
    } catch (e) {
      // Handle error
      _searchResults = [];
      _lastSearchResult = null;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Quick search (for search bar)
  Future<void> quickSearch(String query) async {
    setQuery(query);
    await search();
  }

  // Load suggestions
  Future<void> _loadSuggestions(String query) async {
    _isLoadingSuggestions = true;
    notifyListeners();

    try {
      final suggestions = await _searchService.getSearchSuggestions(query);
      _suggestions = suggestions;
    } catch (e) {
      _suggestions = [];
    } finally {
      _isLoadingSuggestions = false;
      notifyListeners();
    }
  }

  // Clear filters
  void clearFilters() {
    _currentFilters = const SearchFilters();
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    _hasSearched = false;
    _lastSearchResult = null;
    _suggestions = [];
    notifyListeners();
  }

  // Reset all search state
  void reset() {
    _currentQuery = '';
    _currentFilters = const SearchFilters();
    _currentSortOption = SortOption.relevance;
    _searchResults = [];
    _isSearching = false;
    _hasSearched = false;
    _lastSearchResult = null;
    _suggestions = [];
    _isLoadingSuggestions = false;
    notifyListeners();
  }

  // Apply recent filter
  void applyRecentFilter(SearchFilters filters) {
    setFilters(filters);
    search();
  }

  // Apply suggestion
  void applySuggestion(String suggestion) {
    setQuery(suggestion);
    search();
  }

  // Clear search history
  void clearSearchHistory() {
    _searchService.clearSearchHistory();
    notifyListeners();
  }

  // Clear recent filters
  void clearRecentFilters() {
    _searchService.clearRecentFilters();
    notifyListeners();
  }

  // Get formatted search summary
  String getSearchSummary() {
    if (!_hasSearched) return '';
    
    final result = _lastSearchResult;
    if (result == null) return '';

    final parts = <String>[];
    
    if (result.query.isNotEmpty) {
      parts.add('"${result.query}"');
    }
    
    if (result.filters.hasActiveFilters) {
      parts.add('with ${result.filters.activeFilterCount} filter${result.filters.activeFilterCount > 1 ? 's' : ''}');
    }
    
    final summary = parts.isNotEmpty ? parts.join(' ') : 'All properties';
    return '$summary (${result.totalCount} result${result.totalCount != 1 ? 's' : ''})';
  }

  // Get sort option display name
  String getSortOptionDisplayName(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.priceAsc:
        return 'Price: Low to High';
      case SortOption.priceDesc:
        return 'Price: High to Low';
      case SortOption.newest:
        return 'Newest First';
      case SortOption.rating:
        return 'Highest Rated';
      case SortOption.distance:
        return 'Distance';
    }
  }
}
