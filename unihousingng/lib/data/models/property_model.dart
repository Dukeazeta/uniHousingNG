import 'package:flutter/material.dart';
import 'property_image_model.dart';
import 'map_location_model.dart';

class PropertyModel {
  final String id;
  final String title;
  final String location;
  final String price;
  final String? image;
  final int beds;
  final int baths;
  final bool isFavorite;
  final Color color;
  final String category;
  final double? rating;
  final String? description;
  final List<String>? amenities;
  final double? area;
  final List<PropertyImageModel> images;
  final String? virtualTourUrl;
  final MapLocationModel? mapLocation;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.image,
    required this.beds,
    required this.baths,
    this.isFavorite = false,
    required this.color,
    required this.category,
    this.rating,
    this.description,
    this.amenities,
    this.area,
    this.images = const [],
    this.virtualTourUrl,
    this.mapLocation,
  });

  PropertyModel copyWith({
    String? id,
    String? title,
    String? location,
    String? price,
    String? image,
    int? beds,
    int? baths,
    bool? isFavorite,
    Color? color,
    String? category,
    double? rating,
    String? description,
    List<String>? amenities,
    double? area,
    List<PropertyImageModel>? images,
    String? virtualTourUrl,
    MapLocationModel? mapLocation,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      price: price ?? this.price,
      image: image ?? this.image,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      isFavorite: isFavorite ?? this.isFavorite,
      color: color ?? this.color,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      area: area ?? this.area,
      images: images ?? this.images,
      virtualTourUrl: virtualTourUrl ?? this.virtualTourUrl,
      mapLocation: mapLocation ?? this.mapLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'price': price,
      'image': image,
      'beds': beds,
      'baths': baths,
      'isFavorite': isFavorite,
      'color': color, // Keep as Color object for UI compatibility
      'category': category,
      'rating': rating,
      'description': description,
      'amenities': amenities,
      'area': area,
      'images': images.map((img) => img.toMap()).toList(),
      'virtualTourUrl': virtualTourUrl,
      'mapLocation': mapLocation?.toMap(),
    };
  }

  // For serialization to storage/network
  Map<String, dynamic> toSerializableMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'price': price,
      'image': image,
      'beds': beds,
      'baths': baths,
      'isFavorite': isFavorite,
      'color': color.toARGB32(), // Convert to int for serialization
      'category': category,
      'rating': rating,
      'description': description,
      'amenities': amenities,
      'area': area,
      'images': images.map((img) => img.toMap()).toList(),
      'virtualTourUrl': virtualTourUrl,
      'mapLocation': mapLocation?.toMap(),
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    // Handle color conversion properly
    Color propertyColor;
    final colorValue = map['color'];
    if (colorValue is Color) {
      propertyColor = colorValue;
    } else if (colorValue is int) {
      propertyColor = Color(colorValue);
    } else {
      propertyColor = const Color(0xFF2196F3);
    }

    return PropertyModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      price: map['price'] ?? '',
      image: map['image'],
      beds: map['beds']?.toInt() ?? 0,
      baths: map['baths']?.toInt() ?? 0,
      isFavorite: map['isFavorite'] ?? false,
      color: propertyColor,
      category: map['category'] ?? '',
      rating: map['rating']?.toDouble(),
      description: map['description'],
      amenities:
          map['amenities'] != null ? List<String>.from(map['amenities']) : null,
      area: map['area']?.toDouble(),
      images:
          map['images'] != null
              ? (map['images'] as List)
                  .map((img) => PropertyImageModel.fromMap(img))
                  .toList()
              : [],
      virtualTourUrl: map['virtualTourUrl'],
      mapLocation:
          map['mapLocation'] != null
              ? MapLocationModel.fromMap(map['mapLocation'])
              : null,
    );
  }

  // Helper methods for images
  PropertyImageModel? get primaryImage {
    try {
      return images.firstWhere((img) => img.isPrimary);
    } catch (e) {
      return images.isNotEmpty ? images.first : null;
    }
  }

  List<PropertyImageModel> get exteriorImages {
    return images.where((img) => img.isExterior).toList();
  }

  List<PropertyImageModel> get interiorImages {
    return images.where((img) => img.isInterior).toList();
  }

  List<PropertyImageModel> get bedroomImages {
    return images.where((img) => img.isBedroom).toList();
  }

  List<PropertyImageModel> get bathroomImages {
    return images.where((img) => img.isBathroom).toList();
  }

  List<PropertyImageModel> get kitchenImages {
    return images.where((img) => img.isKitchen).toList();
  }

  List<PropertyImageModel> getImagesByType(String type) {
    return images.where((img) => img.type == type).toList();
  }

  bool get hasImages => images.isNotEmpty;
  bool get hasVirtualTour =>
      virtualTourUrl != null && virtualTourUrl!.isNotEmpty;
}
