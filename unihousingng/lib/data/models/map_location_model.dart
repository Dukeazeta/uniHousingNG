import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationModel {
  final String id;
  final String address;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? postalCode;
  final LatLng coordinates;
  final String? landmark;
  final double? distanceToNearestCampus;
  final String? nearestCampusId;
  final LocationType type;
  final Map<String, dynamic>? additionalInfo;

  const MapLocationModel({
    required this.id,
    required this.address,
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    required this.coordinates,
    this.landmark,
    this.distanceToNearestCampus,
    this.nearestCampusId,
    this.type = LocationType.property,
    this.additionalInfo,
  });

  factory MapLocationModel.fromMap(Map<String, dynamic> map) {
    return MapLocationModel(
      id: map['id'] ?? '',
      address: map['address'] ?? '',
      streetAddress: map['streetAddress'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      coordinates: LatLng(
        map['coordinates']['latitude'] ?? 0.0,
        map['coordinates']['longitude'] ?? 0.0,
      ),
      landmark: map['landmark'],
      distanceToNearestCampus: map['distanceToNearestCampus']?.toDouble(),
      nearestCampusId: map['nearestCampusId'],
      type: LocationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => LocationType.property,
      ),
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'landmark': landmark,
      'distanceToNearestCampus': distanceToNearestCampus,
      'nearestCampusId': nearestCampusId,
      'type': type.name,
      'additionalInfo': additionalInfo,
    };
  }

  MapLocationModel copyWith({
    String? id,
    String? address,
    String? streetAddress,
    String? city,
    String? state,
    String? postalCode,
    LatLng? coordinates,
    String? landmark,
    double? distanceToNearestCampus,
    String? nearestCampusId,
    LocationType? type,
    Map<String, dynamic>? additionalInfo,
  }) {
    return MapLocationModel(
      id: id ?? this.id,
      address: address ?? this.address,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      coordinates: coordinates ?? this.coordinates,
      landmark: landmark ?? this.landmark,
      distanceToNearestCampus:
          distanceToNearestCampus ?? this.distanceToNearestCampus,
      nearestCampusId: nearestCampusId ?? this.nearestCampusId,
      type: type ?? this.type,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapLocationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MapLocationModel(id: $id, address: $address, coordinates: $coordinates)';
  }

  // Helper methods
  String get fullAddress {
    final parts = <String>[];
    if (streetAddress != null) parts.add(streetAddress!);
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (postalCode != null) parts.add(postalCode!);
    return parts.isNotEmpty ? parts.join(', ') : address;
  }

  String get shortAddress {
    if (streetAddress != null && city != null) {
      return '$streetAddress, $city';
    }
    return address;
  }

  String get displayAddress {
    if (landmark != null) {
      return '$landmark, ${shortAddress}';
    }
    return shortAddress;
  }

  // Calculate distance from this location to another point
  double distanceTo(LatLng point) {
    return _calculateDistance(coordinates, point);
  }

  // Get formatted distance string
  String getDistanceString(LatLng point) {
    final distance = distanceTo(point);
    if (distance < 1000) {
      return '${distance.round()}m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
  }

  // Check if location is within walking distance (default 1km)
  bool isWalkingDistance(LatLng point, {double maxDistance = 1000}) {
    return distanceTo(point) <= maxDistance;
  }

  // Get location type icon
  String get typeIcon {
    switch (type) {
      case LocationType.property:
        return '🏠';
      case LocationType.campus:
        return '🎓';
      case LocationType.transport:
        return '🚌';
      case LocationType.amenity:
        return '🏪';
      case LocationType.landmark:
        return '📍';
    }
  }

  // Get location type color
  String get typeColor {
    switch (type) {
      case LocationType.property:
        return '#4CAF50';
      case LocationType.campus:
        return '#2196F3';
      case LocationType.transport:
        return '#FF9800';
      case LocationType.amenity:
        return '#9C27B0';
      case LocationType.landmark:
        return '#F44336';
    }
  }
}

enum LocationType { property, campus, transport, amenity, landmark }

extension LocationTypeExtension on LocationType {
  String get displayName {
    switch (this) {
      case LocationType.property:
        return 'Property';
      case LocationType.campus:
        return 'Campus';
      case LocationType.transport:
        return 'Transport';
      case LocationType.amenity:
        return 'Amenity';
      case LocationType.landmark:
        return 'Landmark';
    }
  }

  String get description {
    switch (this) {
      case LocationType.property:
        return 'Student accommodation';
      case LocationType.campus:
        return 'University campus';
      case LocationType.transport:
        return 'Bus stop, train station';
      case LocationType.amenity:
        return 'Shop, restaurant, bank';
      case LocationType.landmark:
        return 'Notable location';
    }
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
