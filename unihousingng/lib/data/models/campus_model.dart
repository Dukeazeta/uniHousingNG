import 'package:google_maps_flutter/google_maps_flutter.dart';

class CampusModel {
  final String id;
  final String name;
  final String shortName;
  final String state;
  final String city;
  final LatLng location;
  final String description;
  final String? logoUrl;
  final List<String> faculties;
  final int? studentPopulation;
  final String? website;
  final CampusBounds bounds;

  const CampusModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.state,
    required this.city,
    required this.location,
    required this.description,
    this.logoUrl,
    this.faculties = const [],
    this.studentPopulation,
    this.website,
    required this.bounds,
  });

  factory CampusModel.fromMap(Map<String, dynamic> map) {
    return CampusModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      shortName: map['shortName'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      location: LatLng(
        map['location']['latitude'] ?? 0.0,
        map['location']['longitude'] ?? 0.0,
      ),
      description: map['description'] ?? '',
      logoUrl: map['logoUrl'],
      faculties:
          map['faculties'] != null ? List<String>.from(map['faculties']) : [],
      studentPopulation: map['studentPopulation'],
      website: map['website'],
      bounds: CampusBounds.fromMap(map['bounds'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'state': state,
      'city': city,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'description': description,
      'logoUrl': logoUrl,
      'faculties': faculties,
      'studentPopulation': studentPopulation,
      'website': website,
      'bounds': bounds.toMap(),
    };
  }

  CampusModel copyWith({
    String? id,
    String? name,
    String? shortName,
    String? state,
    String? city,
    LatLng? location,
    String? description,
    String? logoUrl,
    List<String>? faculties,
    int? studentPopulation,
    String? website,
    CampusBounds? bounds,
  }) {
    return CampusModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      state: state ?? this.state,
      city: city ?? this.city,
      location: location ?? this.location,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      faculties: faculties ?? this.faculties,
      studentPopulation: studentPopulation ?? this.studentPopulation,
      website: website ?? this.website,
      bounds: bounds ?? this.bounds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CampusModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CampusModel(id: $id, name: $name, shortName: $shortName)';
  }

  // Helper methods
  String get fullLocation => '$city, $state';
  String get displayName => '$shortName - $name';

  // Calculate distance from a point to campus
  double distanceFromPoint(LatLng point) {
    return _calculateDistance(point, location);
  }

  // Check if a point is within campus bounds
  bool containsPoint(LatLng point) {
    return bounds.contains(point);
  }

  // Get campus center for map display
  LatLng get center => location;

  // Get appropriate zoom level for campus
  double get defaultZoom => 15.0;
}

class CampusBounds {
  final LatLng northeast;
  final LatLng southwest;

  const CampusBounds({required this.northeast, required this.southwest});

  factory CampusBounds.fromMap(Map<String, dynamic> map) {
    return CampusBounds(
      northeast: LatLng(
        map['northeast']?['latitude'] ?? 0.0,
        map['northeast']?['longitude'] ?? 0.0,
      ),
      southwest: LatLng(
        map['southwest']?['latitude'] ?? 0.0,
        map['southwest']?['longitude'] ?? 0.0,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'northeast': {
        'latitude': northeast.latitude,
        'longitude': northeast.longitude,
      },
      'southwest': {
        'latitude': southwest.latitude,
        'longitude': southwest.longitude,
      },
    };
  }

  // Check if a point is within bounds
  bool contains(LatLng point) {
    return point.latitude >= southwest.latitude &&
        point.latitude <= northeast.latitude &&
        point.longitude >= southwest.longitude &&
        point.longitude <= northeast.longitude;
  }

  // Get center of bounds
  LatLng get center {
    return LatLng(
      (northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2,
    );
  }
}

// Helper function to calculate distance between two points
double _calculateDistance(LatLng point1, LatLng point2) {
  // Simple distance calculation (for more accuracy, use Haversine formula)
  final double deltaLat = point1.latitude - point2.latitude;
  final double deltaLng = point1.longitude - point2.longitude;
  return (deltaLat * deltaLat + deltaLng * deltaLng) *
      111000; // Approximate meters
}
