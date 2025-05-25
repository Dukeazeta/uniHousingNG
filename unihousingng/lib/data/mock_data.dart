import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'models/property_model.dart';
import 'models/category_model.dart';
import 'models/property_image_model.dart';

class MockData {
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
    ),
  ];
}
