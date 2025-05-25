import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/state/search_state.dart';

class EnhancedSearchBar extends StatefulWidget {
  final Function(String)? onSearch;
  final Function()? onFilterTap;
  final bool showFilterButton;
  final String? hintText;
  final bool autofocus;

  const EnhancedSearchBar({
    super.key,
    this.onSearch,
    this.onFilterTap,
    this.showFilterButton = true,
    this.hintText,
    this.autofocus = false,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SearchState _searchState = SearchState();

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller.text = _searchState.currentQuery;
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showSuggestionsOverlay();
    } else {
      _hideSuggestionsOverlay();
    }
  }

  void _onTextChanged() {
    _searchState.setQuery(_controller.text);
    if (_focusNode.hasFocus) {
      _updateSuggestionsOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSuggestionsOverlay() {
    _removeOverlay();
  }

  void _updateSuggestionsOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 8,
            width: size.width,
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 320),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.primary.withAlpha(5),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primary.withAlpha(15),
                    width: 1,
                  ),
                ),
                child: _buildSuggestionsContent(),
              ),
            ),
          ),
    );
  }

  Widget _buildSuggestionsContent() {
    return ListenableBuilder(
      listenable: _searchState,
      builder: (context, _) {
        final suggestions = _searchState.suggestions;
        final searchHistory = _searchState.searchHistory;
        final hasQuery = _controller.text.trim().isNotEmpty;

        if (_searchState.isLoadingSuggestions) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (!hasQuery && searchHistory.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Start typing to search for properties...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary.withAlpha(180),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                // Search suggestions
                if (suggestions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'Suggestions',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ...suggestions.map(
                    (suggestion) => _buildSuggestionItem(
                      suggestion,
                      Icons.search,
                      () => _onSuggestionTap(suggestion),
                    ),
                  ),
                ],

                // Search history (when no query)
                if (!hasQuery && searchHistory.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Searches',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _searchState.clearSearchHistory();
                            _updateSuggestionsOverlay();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Clear',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...searchHistory
                      .take(5)
                      .map(
                        (query) => _buildSuggestionItem(
                          query,
                          Icons.history,
                          () => _onSuggestionTap(query),
                        ),
                      ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionItem(String text, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary.withAlpha(180),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.north_west_rounded,
                size: 16,
                color: AppColors.textSecondary.withAlpha(120),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    _searchState.setQuery(suggestion);
    _focusNode.unfocus();
    widget.onSearch?.call(suggestion);
  }

  void _onSubmitted(String query) {
    _focusNode.unfocus();
    widget.onSearch?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primary.withAlpha(5),
            blurRadius: 40,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: AppColors.primary.withAlpha(10), width: 1),
      ),
      child: Row(
        children: [
          // Search input
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              onSubmitted: _onSubmitted,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search properties, locations...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary.withAlpha(180),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.primary.withAlpha(150),
                    size: 22,
                  ),
                ),
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                            ),
                            onPressed: () {
                              _controller.clear();
                              _searchState.setQuery('');
                            },
                          ),
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),

          // Filter button
          if (widget.showFilterButton) ...[
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface.withAlpha(100),
                borderRadius: BorderRadius.circular(0.5),
              ),
            ),
            ListenableBuilder(
              listenable: _searchState,
              builder: (context, _) {
                final hasActiveFilters = _searchState.hasActiveFilters;
                final filterCount = _searchState.activeFilterCount;

                return GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          hasActiveFilters
                              ? AppColors.primary.withAlpha(15)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 22,
                          color:
                              hasActiveFilters
                                  ? AppColors.primary
                                  : AppColors.textSecondary.withAlpha(180),
                        ),
                        if (hasActiveFilters)
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withAlpha(60),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                filterCount.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
