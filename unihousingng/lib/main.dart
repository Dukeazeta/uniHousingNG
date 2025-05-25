import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'core/constants.dart';
import 'core/theme.dart';
import 'core/services/navigation_service.dart';
import 'core/services/auth_service.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/main/main_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/map/map_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize services
  AuthService(); // Initialize auth service singleton
  NavigationService(); // Initialize navigation service singleton

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationService().navigatorKey,
      initialRoute: AppRoutes.splash,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.main: (context) => const MainScreen(),
        // Individual screens - typically accessed through the main screen
        AppRoutes.home: (context) => const HomeTab(),
        AppRoutes.map: (context) => const MapScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        // TODO: Add more routes as screens are created
        // AppRoutes.onboarding: (context) => const OnboardingScreen(),
      },
    );
  }
}
