import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/user_model.dart';
import '../../widgets/profile/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  late UserModel? _currentUser;
  String _userName = 'User';
  String _userInitials = 'U';
  String? _userEmail;
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    _currentUser = _authService.currentUser;
    if (_currentUser != null) {
      setState(() {
        _userName = _currentUser!.name;
        _userInitials = _getInitials(_userName);
        _userEmail = _currentUser!.email;
        _userPhone = _currentUser!.phone;
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else {
      return nameParts[0][0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Profile picture
              ProfileAvatar(
                initials: _userInitials,
                imageUrl: _currentUser?.photoUrl,
                borderColor: AppColors.primary,
                size: 100,
              ),
              const SizedBox(height: 16),
              
              // User name
              Text(
                _userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              
              // User contact info
              if (_userEmail != null)
                Text(
                  _userEmail!,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (_userPhone != null)
                Text(
                  _userPhone!,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 32),
              
              // Edit profile button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 32),
              
              // Profile sections
              _buildProfileSection(
                title: 'My Properties',
                icon: Icons.home,
                onTap: () {},
              ),
              
              _buildProfileSection(
                title: 'Saved Properties',
                icon: Icons.favorite,
                onTap: () {},
              ),
              
              _buildProfileSection(
                title: 'Booking History',
                icon: Icons.history,
                onTap: () {},
              ),
              
              _buildProfileSection(
                title: 'Payment Methods',
                icon: Icons.payment,
                onTap: () {},
              ),
              
              _buildProfileSection(
                title: 'Reviews',
                icon: Icons.star,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
