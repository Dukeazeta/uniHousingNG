import '../../data/mock_data.dart';

class CampusService {
  static final CampusService _instance = CampusService._internal();
  factory CampusService() => _instance;
  CampusService._internal();

  // Get all available campuses
  Future<List<String>> getAllCampuses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.nigerianCampuses;
  }

  // Search campuses
  Future<List<String>> searchCampuses(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (query.isEmpty) {
      return MockData.nigerianCampuses;
    }

    return MockData.nigerianCampuses
        .where((campus) => campus.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get campus details (in a real app, this would return more detailed info)
  Future<Map<String, dynamic>?> getCampusDetails(String campusName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (!MockData.nigerianCampuses.contains(campusName)) {
      return null;
    }

    // Mock campus details
    return {
      'name': campusName,
      'state': campusName.split(', ').last,
      'propertyCount': _getPropertyCountForCampus(campusName),
      'averageRent': _getAverageRentForCampus(campusName),
      'popularAreas': _getPopularAreasForCampus(campusName),
    };
  }

  // Get nearby areas for a campus
  Future<List<String>> getNearbyAreas(String campusName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _getPopularAreasForCampus(campusName);
  }

  // Helper methods for mock data
  int _getPropertyCountForCampus(String campus) {
    // Mock property counts
    switch (campus) {
      case 'FUPRE, Delta':
        return 45;
      case 'UNILAG, Lagos':
        return 120;
      case 'UI, Ibadan':
        return 85;
      case 'UNIBEN, Benin':
        return 67;
      default:
        return 30;
    }
  }

  String _getAverageRentForCampus(String campus) {
    // Mock average rent
    switch (campus) {
      case 'FUPRE, Delta':
        return '₦25,000/month';
      case 'UNILAG, Lagos':
        return '₦45,000/month';
      case 'UI, Ibadan':
        return '₦35,000/month';
      case 'UNIBEN, Benin':
        return '₦28,000/month';
      default:
        return '₦30,000/month';
    }
  }

  List<String> _getPopularAreasForCampus(String campus) {
    // Mock popular areas
    switch (campus) {
      case 'FUPRE, Delta':
        return ['Ugbomro', 'Effurun', 'Warri', 'Ekpan'];
      case 'UNILAG, Lagos':
        return ['Akoka', 'Yaba', 'Bariga', 'Palmgrove'];
      case 'UI, Ibadan':
        return ['Bodija', 'Agbowo', 'Sango', 'Ojoo'];
      case 'UNIBEN, Benin':
        return ['Ugbowo', 'Ekosodin', 'Osasogie', 'Uselu'];
      default:
        return ['Campus Area', 'Town', 'Suburb'];
    }
  }
}
