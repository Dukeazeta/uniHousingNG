import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App Colors
class AppColors {
  static const Color primary = Color(0xFF2E7D32); // Green
  static const Color secondary = Color(0xFFFF9800); // Orange
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color accent = Color(0xFF66BB6A); // Light Green
  static const Color error = Color(0xFFE53935); // Red
  static const Color surface = Color(0xFFF5F5F5); // Light Gray
}

// App Text Styles
class AppTextStyles {
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

// App Dimensions
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 16.0;
  static const double buttonBorderRadius = 30.0; // More rounded for buttons
  static const double inputBorderRadius = 20.0; // More rounded for input fields
}

// App Strings
class AppStrings {
  static const String appName = "UniHousingNG";
  static const String splashTagline = "Find your perfect campus accommodation";
}

// App Assets
class AppAssets {
  // SVG Icons
  static const String appLogoSvg = "assets/images/svgs/uniHousingNG.svg";
  static const String keySvg = "assets/images/svgs/key.svg";
  static const String mailSvg = "assets/images/svgs/mail.svg";
  static const String phoneSvg = "assets/images/svgs/phone.svg";
  static const String googleSvg = "assets/images/svgs/google.svg";

  // Navigation icons
  static const String homeSvg = "assets/images/svgs/home.svg";
  static const String mapSvg = "assets/images/svgs/map.svg";
  static const String settingsSvg = "assets/images/svgs/settings.svg";
  static const String profileSvg = "assets/images/svgs/profile.svg";

  // Category icons
  static const String apartmentSvg = "assets/images/svgs/apartment.svg";
  static const String hostelSvg = "assets/images/svgs/hostel.svg";
  static const String houseSvg = "assets/images/svgs/house.svg";
  static const String sharedSvg = "assets/images/svgs/shared.svg";

  // Property detail icons
  static const String bedSvg = "assets/images/svgs/bed.svg";
  static const String bathSvg = "assets/images/svgs/bath.svg";
  static const String areaSvg = "assets/images/svgs/area.svg";
  static const String wifiSvg = "assets/images/svgs/wifi.svg";
  static const String parkingSvg = "assets/images/svgs/parking.svg";
  static const String securitySvg = "assets/images/svgs/security.svg";
  static const String powerSvg = "assets/images/svgs/power.svg";
  static const String waterSvg = "assets/images/svgs/water.svg";
  static const String airConditioningSvg =
      "assets/images/svgs/air_conditioning.svg";
  static const String kitchenSvg = "assets/images/svgs/kitchen.svg";
  static const String laundrySvg = "assets/images/svgs/laundry.svg";
  static const String balconySvg = "assets/images/svgs/balcony.svg";
  static const String furnishedSvg = "assets/images/svgs/furnished.svg";
  static const String petFriendlySvg = "assets/images/svgs/pet_friendly.svg";
  static const String gymSvg = "assets/images/svgs/gym.svg";
  static const String poolSvg = "assets/images/svgs/pool.svg";
  static const String locationSvg = "assets/images/svgs/location.svg";
  static const String messageSvg = "assets/images/svgs/message.svg";
  static const String shareSvg = "assets/images/svgs/share.svg";
  static const String favoriteSvg = "assets/images/svgs/favorite.svg";
  static const String backArrowSvg = "assets/images/svgs/back_arrow.svg";
  static const String starSvg = "assets/images/svgs/star.svg";
  static const String searchSvg = "assets/images/svgs/search.svg";
  static const String filterSvg = "assets/images/svgs/filter.svg";

  // Images
  static const String loginBackground = "assets/images/loginBackground.png";
}

// App Routes
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  static const String map = '/map';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String propertyDetails = '/property-details';
  static const String search = '/search';
}
