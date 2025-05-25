// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants.dart';
import '../../../data/models/property_model.dart';
import '../../../data/models/campus_model.dart';
import '../../../data/models/map_location_model.dart';

class PropertyMapWidget extends StatefulWidget {
  final List<PropertyModel> properties;
  final CampusModel? selectedCampus;
  final Function(PropertyModel)? onPropertyTap;
  final Function(LatLng)? onMapTap;
  final double height;
  final bool showControls;
  final bool showCampusMarkers;
  final LatLng? initialCenter;
  final double initialZoom;

  const PropertyMapWidget({
    super.key,
    required this.properties,
    this.selectedCampus,
    this.onPropertyTap,
    this.onMapTap,
    this.height = 400,
    this.showControls = true,
    this.showCampusMarkers = true,
    this.initialCenter,
    this.initialZoom = 12.0,
  });

  @override
  State<PropertyMapWidget> createState() => _PropertyMapWidgetState();
}

class _PropertyMapWidgetState extends State<PropertyMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didUpdateWidget(PropertyMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.properties != widget.properties ||
        oldWidget.selectedCampus != widget.selectedCampus) {
      _updateMarkers();
    }
  }

  void _initializeMap() {
    _updateMarkers();
    setState(() {
      _isLoading = false;
    });
  }

  void _updateMarkers() {
    final Set<Marker> markers = {};
    final Set<Circle> circles = {};

    // Add campus marker if selected
    if (widget.selectedCampus != null && widget.showCampusMarkers) {
      markers.add(_createCampusMarker(widget.selectedCampus!));
      circles.add(_createCampusCircle(widget.selectedCampus!));
    }

    // Add property markers
    for (final property in widget.properties) {
      if (property.mapLocation != null) {
        markers.add(_createPropertyMarker(property));
      }
    }

    setState(() {
      _markers = markers;
      _circles = circles;
    });
  }

  Marker _createCampusMarker(CampusModel campus) {
    return Marker(
      markerId: MarkerId('campus_${campus.id}'),
      position: campus.location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: campus.shortName, snippet: campus.name),
      onTap: () {
        _showCampusInfo(campus);
      },
    );
  }

  Circle _createCampusCircle(CampusModel campus) {
    return Circle(
      circleId: CircleId('campus_circle_${campus.id}'),
      center: campus.location,
      radius: 2000, // 2km radius
      fillColor: AppColors.primary.withOpacity(0.1),
      strokeColor: AppColors.primary,
      strokeWidth: 2,
    );
  }

  Marker _createPropertyMarker(PropertyModel property) {
    return Marker(
      markerId: MarkerId('property_${property.id}'),
      position: property.mapLocation!.coordinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        _getMarkerHue(property.category),
      ),
      infoWindow: InfoWindow(
        title: property.title,
        snippet: '₦${property.price}/year • ${property.beds} beds',
      ),
      onTap: () {
        if (widget.onPropertyTap != null) {
          widget.onPropertyTap!(property);
        }
      },
    );
  }

  double _getMarkerHue(String category) {
    switch (category.toLowerCase()) {
      case 'bedsitter':
        return BitmapDescriptor.hueGreen;
      case 'apartment':
        return BitmapDescriptor.hueOrange;
      case 'hostel':
        return BitmapDescriptor.hueViolet;
      case 'selfcontain':
        return BitmapDescriptor.hueYellow;
      case 'shared':
        return BitmapDescriptor.hueCyan;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _showCampusInfo(CampusModel campus) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campus.shortName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            campus.fullLocation,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(campus.description, style: const TextStyle(fontSize: 14)),
                if (campus.studentPopulation != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${campus.studentPopulation!.toStringAsFixed(0)} students',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _animateToLocation(campus.location, campus.defaultZoom);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View on Map'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _animateToLocation(LatLng location, double zoom) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: zoom),
      ),
    );
  }

  LatLng get _initialCenter {
    if (widget.initialCenter != null) {
      return widget.initialCenter!;
    }
    if (widget.selectedCampus != null) {
      return widget.selectedCampus!.location;
    }
    if (widget.properties.isNotEmpty) {
      final property = widget.properties.first;
      if (property.mapLocation != null) {
        return property.mapLocation!.coordinates;
      }
    }
    // Default to FUPRE location
    return const LatLng(5.5629, 5.7661);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _initialCenter,
            zoom: widget.initialZoom,
          ),
          markers: _markers,
          circles: _circles,
          onTap: widget.onMapTap,
          zoomControlsEnabled: widget.showControls,
          mapToolbarEnabled: widget.showControls,
          myLocationButtonEnabled: widget.showControls,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
