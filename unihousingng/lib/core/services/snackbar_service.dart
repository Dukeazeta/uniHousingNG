import 'package:flutter/material.dart';
import '../constants.dart';
import 'navigation_service.dart';

enum SnackBarType {
  success,
  error,
  info,
}

class SnackBarService {
  // Singleton pattern
  static final SnackBarService _instance = SnackBarService._internal();
  factory SnackBarService() => _instance;
  SnackBarService._internal();

  // Show snackbar
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Get scaffold messenger
    final scaffoldMessenger = ScaffoldMessenger.of(
      NavigationService().navigatorKey.currentContext!,
    );

    // Get color based on type
    final Color backgroundColor = _getBackgroundColor(type);

    // Show snackbar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
      ),
    );
  }

  // Get background color based on type
  Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return AppColors.accent;
      case SnackBarType.error:
        return AppColors.error;
      case SnackBarType.info:
        return AppColors.primary;
    }
  }
}
