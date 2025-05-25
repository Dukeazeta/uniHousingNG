import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Private constructor
  EnvConfig._();

  // Singleton instance
  static final EnvConfig _instance = EnvConfig._();
  static EnvConfig get instance => _instance;

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // Google Maps API Keys
  static String get googleMapsApiKeyAndroid => 
      dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID'] ?? '';
  
  static String get googleMapsApiKeyIOS => 
      dotenv.env['GOOGLE_MAPS_API_KEY_IOS'] ?? '';
  
  static String get googleMapsApiKeyWeb => 
      dotenv.env['GOOGLE_MAPS_API_KEY_WEB'] ?? '';

  // Firebase Configuration
  static String get firebaseProjectId => 
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  
  static String get firebaseApiKey => 
      dotenv.env['FIREBASE_API_KEY'] ?? '';
  
  static String get firebaseAppId => 
      dotenv.env['FIREBASE_APP_ID'] ?? '';

  // Backend API Configuration
  static String get apiBaseUrl => 
      dotenv.env['API_BASE_URL'] ?? 'https://api.unihousingng.com';
  
  static String get apiVersion => 
      dotenv.env['API_VERSION'] ?? 'v1';
  
  static int get apiTimeout => 
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // App Configuration
  static String get appName => 
      dotenv.env['APP_NAME'] ?? 'UniHousingNG';
  
  static String get appVersion => 
      dotenv.env['APP_VERSION'] ?? '1.0.0';
  
  static bool get debugMode => 
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  // Third-party Services
  static String get sentryDsn => 
      dotenv.env['SENTRY_DSN'] ?? '';
  
  static String get analyticsId => 
      dotenv.env['ANALYTICS_ID'] ?? '';

  // Payment Configuration
  static String get paystackPublicKey => 
      dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '';
  
  static String get flutterwavePublicKey => 
      dotenv.env['FLUTTERWAVE_PUBLIC_KEY'] ?? '';

  // Social Media Links
  static String get facebookUrl => 
      dotenv.env['FACEBOOK_URL'] ?? 'https://facebook.com/unihousingng';
  
  static String get twitterUrl => 
      dotenv.env['TWITTER_URL'] ?? 'https://twitter.com/unihousingng';
  
  static String get instagramUrl => 
      dotenv.env['INSTAGRAM_URL'] ?? 'https://instagram.com/unihousingng';
  
  static String get websiteUrl => 
      dotenv.env['WEBSITE_URL'] ?? 'https://unihousingng.com';

  // Support Configuration
  static String get supportEmail => 
      dotenv.env['SUPPORT_EMAIL'] ?? 'support@unihousingng.com';
  
  static String get supportPhone => 
      dotenv.env['SUPPORT_PHONE'] ?? '+234XXXXXXXXXX';

  // Helper methods
  static bool get hasGoogleMapsKey => googleMapsApiKeyAndroid.isNotEmpty;
  
  static bool get hasFirebaseConfig => 
      firebaseProjectId.isNotEmpty && firebaseApiKey.isNotEmpty;
  
  static bool get hasPaymentConfig => 
      paystackPublicKey.isNotEmpty || flutterwavePublicKey.isNotEmpty;

  // Get the appropriate Google Maps API key based on platform
  static String getGoogleMapsApiKey() {
    // You can add platform detection here if needed
    // For now, return Android key as default
    return googleMapsApiKeyAndroid;
  }

  // Validate required environment variables
  static List<String> validateConfig() {
    final List<String> missingKeys = [];
    
    if (googleMapsApiKeyAndroid.isEmpty) {
      missingKeys.add('GOOGLE_MAPS_API_KEY_ANDROID');
    }
    
    // Add more validations as needed
    return missingKeys;
  }

  // Print configuration status (for debugging)
  static void printConfigStatus() {
    if (debugMode) {
      print('=== Environment Configuration Status ===');
      print('Google Maps Android Key: ${hasGoogleMapsKey ? "✓" : "✗"}');
      print('Firebase Config: ${hasFirebaseConfig ? "✓" : "✗"}');
      print('Payment Config: ${hasPaymentConfig ? "✓" : "✗"}');
      print('API Base URL: $apiBaseUrl');
      print('Debug Mode: $debugMode');
      
      final missing = validateConfig();
      if (missing.isNotEmpty) {
        print('Missing Keys: ${missing.join(", ")}');
      }
      print('========================================');
    }
  }
}
