import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../widgets/navigation/pill_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../map/map_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const MapScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      extendBody: true, // Important for the floating nav bar
      bottomNavigationBar: PillBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
