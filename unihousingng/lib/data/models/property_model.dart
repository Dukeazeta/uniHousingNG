import 'package:flutter/material.dart';

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
      'color': color.toARGB32(),
      'category': category,
      'rating': rating,
      'description': description,
      'amenities': amenities,
      'area': area,
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      price: map['price'] ?? '',
      image: map['image'],
      beds: map['beds']?.toInt() ?? 0,
      baths: map['baths']?.toInt() ?? 0,
      isFavorite: map['isFavorite'] ?? false,
      color: Color(map['color'] ?? 0xFF2196F3),
      category: map['category'] ?? '',
      rating: map['rating']?.toDouble(),
      description: map['description'],
      amenities:
          map['amenities'] != null ? List<String>.from(map['amenities']) : null,
      area: map['area']?.toDouble(),
    );
  }
}
