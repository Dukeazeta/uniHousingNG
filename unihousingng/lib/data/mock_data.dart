import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/constants.dart';
import 'models/property_model.dart';
import 'models/category_model.dart';
import 'models/property_image_model.dart';
import 'models/map_location_model.dart';
import 'models/landlord_model.dart';

class MockData {
  // Sample landlords
  static final List<LandlordModel> sampleLandlords = [
    LandlordModel(
      id: 'landlord_1',
      name: 'Mr. Adebayo Johnson',
      email: 'adebayo.johnson@email.com',
      phone: '08012345678',
      whatsappNumber: '08012345678',
      profileImageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      rating: 4.8,
      totalProperties: 12,
      totalReviews: 45,
      isVerified: true,
      bio:
          'Experienced property manager with over 10 years in student accommodation.',
      languages: ['English', 'Yoruba'],
      preferredContactMethod: 'whatsapp',
      businessHours: '8:00 AM - 6:00 PM',
      joinedDate: DateTime(2020, 3, 15),
    ),
    LandlordModel(
      id: 'landlord_2',
      name: 'Mrs. Chioma Okafor',
      email: 'chioma.okafor@gmail.com',
      phone: '08098765432',
      whatsappNumber: '08098765432',
      profileImageUrl:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      rating: 4.6,
      totalProperties: 8,
      totalReviews: 32,
      isVerified: true,
      bio: 'Dedicated to providing quality and affordable student housing.',
      languages: ['English', 'Igbo'],
      preferredContactMethod: 'phone',
      businessHours: '9:00 AM - 5:00 PM',
      joinedDate: DateTime(2019, 8, 22),
    ),
    LandlordModel(
      id: 'landlord_3',
      name: 'Alhaji Musa Ibrahim',
      email: 'musa.ibrahim@yahoo.com',
      phone: '08087654321',
      whatsappNumber: '08087654321',
      profileImageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      rating: 4.9,
      totalProperties: 15,
      totalReviews: 67,
      isVerified: true,
      bio:
          'Premium property developer specializing in luxury student accommodations.',
      languages: ['English', 'Hausa'],
      preferredContactMethod: 'whatsapp',
      businessHours: '7:00 AM - 7:00 PM',
      joinedDate: DateTime(2018, 1, 10),
    ),
  ];

  // Sample property images generator
  static List<PropertyImageModel> _generateSampleImages(String propertyId) {
    return [
      PropertyImageModel(
        id: '${propertyId}_img_1',
        url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=300',
        caption: 'Beautiful exterior view',
        type: 'exterior',
        isPrimary: true,
        order: 1,
      ),
      PropertyImageModel(
        id: '${propertyId}_img_2',
        url:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300',
        caption: 'Spacious living room',
        type: 'living_room',
        isPrimary: false,
        order: 2,
      ),
      PropertyImageModel(
        id: '${propertyId}_img_3',
        url: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300',
        caption: 'Comfortable bedroom',
        type: 'bedroom',
        isPrimary: false,
        order: 3,
      ),
      PropertyImageModel(
        id: '${propertyId}_img_4',
        url: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300',
        caption: 'Modern kitchen',
        type: 'kitchen',
        isPrimary: false,
        order: 4,
      ),
      PropertyImageModel(
        id: '${propertyId}_img_5',
        url: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=800',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=300',
        caption: 'Clean bathroom',
        type: 'bathroom',
        isPrimary: false,
        order: 5,
      ),
    ];
  }

  // List of Nigerian campuses
  static const List<String> nigerianCampuses = [
    'FUPRE, Delta',
    'UNILAG, Lagos',
    'UI, Ibadan',
    'UNIBEN, Benin',
    'OAU, Ile-Ife',
    'UNIZIK, Awka',
    'UNIPORT, Port Harcourt',
    'ABU, Zaria',
    'UNILORIN, Ilorin',
    'UNIJOS, Jos',
  ];

  // Mock data for featured properties
  static final List<PropertyModel> featuredProperties = [
    PropertyModel(
      id: '1',
      title: 'Modern Studio Apartment',
      location: 'Near University of Lagos',
      price: '₦150,000',
      color: Colors.blue[100]!,
      rating: 4.8,
      beds: 1,
      baths: 1,
      category: 'Apartments',
      description:
          'A beautiful modern studio apartment with excellent amenities.',
      amenities: ['WiFi', 'Parking', 'Security', 'Power'],
      area: 45.0,
      images: _generateSampleImages('1'),
      virtualTourUrl: 'https://example.com/virtual-tour/1',
      mapLocation: MapLocationModel(
        id: 'loc_1',
        address: 'Akoka Road, Yaba, Lagos',
        streetAddress: '15 Akoka Road',
        city: 'Lagos',
        state: 'Lagos',
        coordinates: const LatLng(6.5244, 3.3792), // Near UNILAG
        landmark: 'Near University of Lagos Main Gate',
        distanceToNearestCampus: 0.8,
        nearestCampusId: 'unilag',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[0],
    ),
    PropertyModel(
      id: '2',
      title: 'Cozy 2-Bedroom Flat',
      location: 'Close to Covenant University',
      price: '₦250,000',
      color: Colors.green[100]!,
      rating: 4.5,
      beds: 2,
      baths: 2,
      category: 'Apartments',
      description: 'Spacious 2-bedroom flat perfect for students.',
      amenities: ['WiFi', 'Kitchen', 'Security', 'Water'],
      area: 75.0,
      images: _generateSampleImages('2'),
      mapLocation: MapLocationModel(
        id: 'loc_2',
        address: 'Canaan Land, Ota, Ogun State',
        streetAddress: 'KM 10 Idiroko Road',
        city: 'Ota',
        state: 'Ogun',
        coordinates: const LatLng(6.6018, 3.1582), // Near Covenant University
        landmark: 'Close to Covenant University',
        distanceToNearestCampus: 1.2,
        nearestCampusId: 'covenant',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[1],
    ),
    PropertyModel(
      id: '3',
      title: 'Luxury Student Hostel',
      location: 'University of Ibadan Area',
      price: '₦180,000',
      color: Colors.orange[100]!,
      rating: 4.7,
      beds: 1,
      baths: 1,
      category: 'Hostels',
      description: 'Premium hostel accommodation with modern facilities.',
      amenities: ['WiFi', 'Laundry', 'Security', 'Gym'],
      area: 35.0,
      images: _generateSampleImages('3'),
      mapLocation: MapLocationModel(
        id: 'loc_3',
        address: 'University Road, Ibadan, Oyo State',
        streetAddress: 'UI-Ojoo Road',
        city: 'Ibadan',
        state: 'Oyo',
        coordinates: const LatLng(7.4398, 3.9093), // Near UI
        landmark: 'University of Ibadan Area',
        distanceToNearestCampus: 0.5,
        nearestCampusId: 'ui',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[2],
    ),
  ];

  // Mock data for property categories
  static final List<CategoryModel> categories = [
    CategoryModel(name: 'Bedsitters', icon: AppAssets.houseSvg, count: 95),
    CategoryModel(name: 'Apartments', icon: AppAssets.apartmentSvg, count: 120),
    CategoryModel(name: 'Hostels', icon: AppAssets.hostelSvg, count: 85),
    CategoryModel(
      name: 'Selfcontains',
      icon: AppAssets.apartmentSvg,
      count: 68,
    ),
    CategoryModel(name: 'Shared', icon: AppAssets.sharedSvg, count: 42),
  ];

  // Mock data for property listings
  static final List<PropertyModel> propertyListings = [
    PropertyModel(
      id: '4',
      title: 'Modern Family House',
      location: 'Near FUPRE Campus',
      price: '₦28.6k/month',
      image: 'assets/images/house1.jpg',
      beds: 4,
      baths: 1,
      isFavorite: false,
      color: Colors.blue[100]!,
      category: 'Apartments',
      description: 'Spacious family house with modern amenities.',
      amenities: ['WiFi', 'Parking', 'Security', 'Kitchen'],
      area: 120.0,
      images: _generateSampleImages('4'),
      mapLocation: MapLocationModel(
        id: 'loc_4',
        address: 'Effurun, Delta State',
        streetAddress: 'Petroleum Training Institute Road',
        city: 'Effurun',
        state: 'Delta',
        coordinates: const LatLng(5.5729, 5.7561), // Near FUPRE
        landmark: 'Near FUPRE Campus',
        distanceToNearestCampus: 1.5,
        nearestCampusId: 'fupre',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[0],
    ),
    PropertyModel(
      id: '2',
      title: 'Contemporary House',
      location: 'Ugbomro, Effurun',
      price: '₦25.5k/month',
      image: 'assets/images/house2.jpg',
      beds: 3,
      baths: 1,
      isFavorite: false,
      color: Colors.green[100]!,
      category: 'Bedsitters',
      description: 'Contemporary design with excellent location.',
      amenities: ['WiFi', 'Security', 'Water', 'Power'],
      area: 85.0,
      mapLocation: MapLocationModel(
        id: 'loc_5',
        address: 'Ugbomro, Effurun, Delta State',
        streetAddress: 'Ugbomro Junction',
        city: 'Effurun',
        state: 'Delta',
        coordinates: const LatLng(5.5429, 5.7361), // Ugbomro area
        landmark: 'Ugbomro, Effurun',
        distanceToNearestCampus: 2.8,
        nearestCampusId: 'fupre',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[1],
    ),
    PropertyModel(
      id: '3',
      title: 'Luxury Apartment',
      location: 'Near FUPRE Campus',
      price: '₦32.5k/month',
      image: 'assets/images/house3.jpg',
      beds: 3,
      baths: 2,
      isFavorite: false,
      color: Colors.purple[100]!,
      category: 'Apartments',
      description: 'Luxury apartment with premium finishes.',
      amenities: ['WiFi', 'AC', 'Parking', 'Security', 'Kitchen'],
      area: 95.0,
      mapLocation: MapLocationModel(
        id: 'loc_6',
        address: 'FUPRE Campus Road, Effurun, Delta State',
        streetAddress: 'University Road',
        city: 'Effurun',
        state: 'Delta',
        coordinates: const LatLng(5.5629, 5.7661), // Very close to FUPRE
        landmark: 'Near FUPRE Campus',
        distanceToNearestCampus: 0.3,
        nearestCampusId: 'fupre',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[2],
    ),
    PropertyModel(
      id: '4',
      title: 'Student Hostel',
      location: 'University Road',
      price: '₦18.9k/month',
      image: 'assets/images/house4.jpg',
      beds: 1,
      baths: 1,
      isFavorite: false,
      color: Colors.orange[100]!,
      category: 'Hostels',
      description: 'Affordable hostel accommodation for students.',
      amenities: ['WiFi', 'Security', 'Laundry'],
      area: 25.0,
      mapLocation: MapLocationModel(
        id: 'loc_7',
        address: 'University Road, Effurun, Delta State',
        streetAddress: 'Student Village Road',
        city: 'Effurun',
        state: 'Delta',
        coordinates: const LatLng(5.5529, 5.7461), // University Road area
        landmark: 'University Road',
        distanceToNearestCampus: 1.8,
        nearestCampusId: 'fupre',
        type: LocationType.property,
      ),
      landlord: sampleLandlords[0],
    ),
  ];
}
