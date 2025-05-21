import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/navigation_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final navigationService = NavigationService();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Settings sections
              _buildSettingSection(
                title: 'Account',
                items: [
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.lock_outline,
                    title: 'Security',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                ],
              ),
              
              _buildSettingSection(
                title: 'Preferences',
                items: [
                  _buildSettingItem(
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    onTap: () {},
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              _buildSettingSection(
                title: 'Support',
                items: [
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {},
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Logout button
              _buildSettingItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  await authService.signOut();
                  navigationService.navigateToAndRemoveUntil(AppRoutes.login);
                },
                textColor: AppColors.error,
                iconColor: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSettingSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...items,
        const SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
