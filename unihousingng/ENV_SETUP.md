# Environment Configuration Setup

This document explains how to set up environment variables and API keys for the UniHousingNG Flutter app.

## Quick Setup

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the `.env` file with your actual values:**
   ```bash
   # Open .env file and replace placeholder values
   nano .env  # or use your preferred editor
   ```

3. **Get your Google Maps API key:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable Google Maps SDK for Android/iOS
   - Create credentials (API Key)
   - Copy the API key to your `.env` file

## Environment Variables

### Required for Maps Functionality
- `GOOGLE_MAPS_API_KEY_ANDROID` - Google Maps API key for Android
- `GOOGLE_MAPS_API_KEY_IOS` - Google Maps API key for iOS  
- `GOOGLE_MAPS_API_KEY_WEB` - Google Maps API key for Web

### App Configuration
- `APP_NAME` - Application name
- `APP_VERSION` - Current app version
- `DEBUG_MODE` - Enable/disable debug features

### API Configuration
- `API_BASE_URL` - Backend API base URL
- `API_VERSION` - API version
- `API_TIMEOUT` - Request timeout in milliseconds

### Future Integrations
- `FIREBASE_PROJECT_ID` - Firebase project ID
- `FIREBASE_API_KEY` - Firebase API key
- `PAYSTACK_PUBLIC_KEY` - Paystack payment key
- `FLUTTERWAVE_PUBLIC_KEY` - Flutterwave payment key

## Google Maps Setup

### 1. Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable billing (required for Maps API)

### 2. Enable APIs
Enable these APIs in your project:
- Maps SDK for Android
- Maps SDK for iOS
- Maps JavaScript API (for web)
- Places API (for location search)

### 3. Create API Key
1. Go to "Credentials" in Google Cloud Console
2. Click "Create Credentials" → "API Key"
3. Copy the generated key
4. (Recommended) Restrict the key to your app

### 4. Configure API Key Restrictions
For security, restrict your API key:
- **Android**: Add your app's package name and SHA-1 fingerprint
- **iOS**: Add your app's bundle identifier
- **Web**: Add your domain

## Android Configuration

The app automatically loads the Google Maps API key from environment variables during build.

### Build with Environment Variables
```bash
# Set environment variable and build
export GOOGLE_MAPS_API_KEY=your_actual_api_key_here
flutter build apk
```

### Alternative: Update gradle.properties
Edit `android/gradle.properties`:
```properties
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

## iOS Configuration (Future)

For iOS, you'll need to add the API key to `ios/Runner/Info.plist`:
```xml
<key>GMSApiKey</key>
<string>YOUR_API_KEY_HERE</string>
```

## Security Best Practices

1. **Never commit `.env` files** - They're already in `.gitignore`
2. **Use different keys for different environments** (dev, staging, prod)
3. **Restrict API keys** to specific apps/domains
4. **Rotate keys regularly**
5. **Monitor API usage** in Google Cloud Console

## Troubleshooting

### Maps not loading?
1. Check if API key is set in `.env` file
2. Verify the key has correct permissions
3. Ensure billing is enabled in Google Cloud
4. Check if APIs are enabled

### Build errors?
1. Run `flutter clean && flutter pub get`
2. Check if `.env` file exists and has correct format
3. Verify Android configuration in `build.gradle.kts`

### Debug Mode
The app prints configuration status in debug mode. Check console output for:
```
=== Environment Configuration Status ===
Google Maps Android Key: ✓
Firebase Config: ✗
...
```

## Environment Files

- `.env` - Main environment file (not committed)
- `.env.example` - Template file (committed)
- `.env.local` - Local overrides (not committed)
- `.env.production` - Production values (not committed)

## Usage in Code

```dart
import 'package:unihousingng/core/config/env_config.dart';

// Get API key
String apiKey = EnvConfig.googleMapsApiKeyAndroid;

// Check if key exists
bool hasKey = EnvConfig.hasGoogleMapsKey;

// Get app configuration
String appName = EnvConfig.appName;
bool isDebug = EnvConfig.debugMode;
```

## Team Setup

When a new team member joins:
1. They copy `.env.example` to `.env`
2. They get API keys from team lead
3. They update `.env` with actual values
4. They can start development immediately

## Production Deployment

For production builds:
1. Use production environment variables
2. Ensure all keys are properly restricted
3. Test thoroughly before release
4. Monitor API usage and costs
