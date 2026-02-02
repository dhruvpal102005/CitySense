import 'package:citysense_flutter/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationStep extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final Function(LatLng, String) onLocationConfirmed;

  const LocationStep({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.onLocationConfirmed,
  });

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  LatLng _userLocation = const LatLng(18.5204, 73.8567); // Default Pune
  String _locationDisplay = "Waiting for location...";
  bool _isFetchingLocation = false;
  String? _fetchedAddress;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationDisplay = "Fetching location...";
    });

    try {
      final Position position = await _locationService.getCurrentLocation();
      final Placemark? place = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final newLocation = LatLng(position.latitude, position.longitude);
      final addressText = place != null
          ? "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}"
          : "Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";

      setState(() {
        _userLocation = newLocation;
        _locationDisplay = addressText;
        _fetchedAddress = addressText;
      });

      // Update parent
      widget.onLocationConfirmed(_userLocation, _fetchedAddress ?? '');

      // Move map to new location
      _mapController.move(_userLocation, 15.0);
    } catch (e) {
      setState(() {
        _locationDisplay = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Map Section (Top Half)
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _userLocation,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.citysense.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          LucideIcons.mapPin,
                          size: 40,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Details Section (Bottom Half)
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Current Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              LucideIcons.mapPin,
                              size: 20,
                              color: Color(0xFF111111),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _locationDisplay,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.crosshair,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Lat: ${_userLocation.latitude.toStringAsFixed(6)}, Lng: ${_userLocation.longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Refresh Location Button
                        InkWell(
                          onTap: _isFetchingLocation ? null : _fetchLocation,
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF111111),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: _isFetchingLocation
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF111111),
                                      ),
                                    )
                                  : const Icon(
                                      LucideIcons.refreshCw,
                                      size: 20,
                                      color: Color(0xFF111111),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildNavButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: widget.onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF111111)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      size: 16,
                      color: Color(0xFF111111),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                // Do not allow next if address is null (fetching or error)
                onPressed: _fetchedAddress != null ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111111),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[800],
                  disabledForegroundColor: Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(LucideIcons.chevronRight, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
