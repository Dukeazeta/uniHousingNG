import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

enum AuthResult {
  success,
  invalidCredentials,
  userNotFound,
  emailAlreadyInUse,
  weakPassword,
  networkError,
  unknown,
}

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    // Load user data from shared preferences on initialization
    _loadUserFromPrefs();
  }

  // Current user
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Shared preferences key
  static const String _userPrefKey = 'user_data';

  // Load user from shared preferences
  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userPrefKey);

      if (userJson != null) {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(userData);
        _authStateController.add(_currentUser);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Save user to shared preferences
  Future<void> _saveUserToPrefs(UserModel? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (user != null) {
        final userJson = json.encode(user.toJson());
        await prefs.setString(_userPrefKey, userJson);
      } else {
        await prefs.remove(_userPrefKey);
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Stream controller for auth state changes
  final _authStateController = StreamController<UserModel?>.broadcast();
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  // Default test accounts
  final Map<String, Map<String, String>> _testAccounts = {
    'student@unihousing.ng': {
      'password': 'Student123',
      'name': 'John Student',
      'id': '1001',
    },
    'landlord@unihousing.ng': {
      'password': 'Landlord123',
      'name': 'Mary Landlord',
      'id': '2001',
    },
    'admin@unihousing.ng': {
      'password': 'Admin123',
      'name': 'Admin User',
      'id': '3001',
    },
    'test@example.com': {
      'password': 'Password123',
      'name': 'Test User',
      'id': '1',
    },
  };

  // Mock login with email and password
  Future<AuthResult> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email exists in test accounts
      if (_testAccounts.containsKey(email)) {
        // Check if password matches
        if (_testAccounts[email]!['password'] == password) {
          _currentUser = UserModel(
            id: _testAccounts[email]!['id']!,
            name: _testAccounts[email]!['name']!,
            email: email,
          );
          _authStateController.add(_currentUser);
          _saveUserToPrefs(_currentUser);
          return AuthResult.success;
        }
      }

      return AuthResult.invalidCredentials;
    } catch (e) {
      return AuthResult.unknown;
    }
  }

  // Default phone test accounts
  final Map<String, Map<String, String>> _phoneTestAccounts = {
    '08012345678': {'otp': '123456', 'name': 'Phone User', 'id': '2'},
    '08011111111': {'otp': '111111', 'name': 'Student Mobile', 'id': '1002'},
    '08022222222': {'otp': '222222', 'name': 'Landlord Mobile', 'id': '2002'},
  };

  // Mock login with phone and OTP
  Future<AuthResult> loginWithPhoneAndOtp(String phone, String otp) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if phone exists in test accounts
      if (_phoneTestAccounts.containsKey(phone)) {
        // Check if OTP matches
        if (_phoneTestAccounts[phone]!['otp'] == otp) {
          _currentUser = UserModel(
            id: _phoneTestAccounts[phone]!['id']!,
            name: _phoneTestAccounts[phone]!['name']!,
            phone: phone,
          );
          _authStateController.add(_currentUser);
          _saveUserToPrefs(_currentUser);
          return AuthResult.success;
        }
      }

      return AuthResult.invalidCredentials;
    } catch (e) {
      return AuthResult.unknown;
    }
  }

  // Mock register with email and password
  Future<AuthResult> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration logic
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );
      _authStateController.add(_currentUser);
      _saveUserToPrefs(_currentUser);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.unknown;
    }
  }

  // Mock register with phone
  Future<AuthResult> registerWithPhone(
    String name,
    String phone,
    String otp,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration logic
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
      );
      _authStateController.add(_currentUser);
      _saveUserToPrefs(_currentUser);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.unknown;
    }
  }

  // Mock send OTP
  Future<bool> sendOtp(String phone) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if phone exists in test accounts
      if (_phoneTestAccounts.containsKey(phone)) {
        return true;
      }

      // For testing purposes, allow any phone number
      return true;
    } catch (e) {
      return false;
    }
  }

  // Mock sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock Google sign in
      _currentUser = UserModel(
        id: '3',
        name: 'Google User',
        email: 'google@example.com',
        photoUrl: 'https://via.placeholder.com/150',
      );
      _authStateController.add(_currentUser);
      _saveUserToPrefs(_currentUser);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.unknown;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
    await _saveUserToPrefs(null);
  }

  // Dispose
  void dispose() {
    _authStateController.close();
  }
}
