import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerDialog extends StatefulWidget {
  const LocationPickerDialog({super.key});

  @override
  LocationPickerDialogState createState() => LocationPickerDialogState();
}

class LocationPickerDialogState extends State<LocationPickerDialog> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  LatLng _pickedLocation = const LatLng(0, 0);
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool permissionGranted = await _requestLocationPermission();
    if (permissionGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _pickedLocation =
              _currentPosition; // Set picked location to current position
          _isLoading = false; // Stop loading
        });
      } catch (e) {
        if (mounted) {
          // Handle the error here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not get current location: $e")),
          );
          Navigator.of(context).pop(); // Close the dialog on error
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context)
            .pop(); // Close the dialog if permission not granted
      }
    }
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  void _onMapTapped(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng; // Update picked location as the camera moves
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Loading indicator
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
                onTap: _onMapTapped,
                markers: {
                  Marker(
                    markerId: const MarkerId('pickedLocation'),
                    position: _pickedLocation,
                  ),
                },
                // onCameraMove: _onCameraMove,
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null), // Cancel button
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_pickedLocation == const LatLng(0, 0)) return;
            Navigator.of(context).pop(_pickedLocation);
          }, // Confirm button
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
