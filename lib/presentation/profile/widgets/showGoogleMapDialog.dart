import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/config/config.dart';
import 'package:product_management/provider/user/user_view_model.dart';
import 'package:product_management/widgets/common_dialog.dart';

class GoogleMapPickerDialog extends ConsumerStatefulWidget {
  const GoogleMapPickerDialog({super.key, required this.userNotifier});

  final UserViewModel userNotifier;

  @override
  GoogleMapPickerDialogState createState() => GoogleMapPickerDialogState();
}

class GoogleMapPickerDialogState extends ConsumerState<GoogleMapPickerDialog> {
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
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _pickedLocation =
              _currentPosition; // Set picked location to current position
          _isLoading = false; // Stop loading
        });
      } catch (e) {
        // Handle the error here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not get current location: $e")),
        );
        Navigator.of(context).pop(); // Close the dialog on error
      }
    } else {
      Navigator.of(context).pop(); // Close the dialog if permission not granted
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

  // void _onCameraMove(CameraPosition position) {
  //   setState(() {
  //     _pickedLocation =
  //         position.target; // Update picked location as the camera moves
  //   });
  // }

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
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
                onTap: _onMapTapped,
                markers: {
                  Marker(
                    markerId: const MarkerId('pickedLocation'),
                    position: _pickedLocation,
                    infoWindow: InfoWindow(
                      title: 'Selected Location',
                      snippet: 'Lat: ${_pickedLocation.latitude}, Lng: ${_pickedLocation.longitude}',
                    ),
                    // draggable: true,
                    // onDragEnd: (newPosition) {
                    //   setState(() {
                    //     _pickedLocation =
                    //         newPosition; // Update picked location on drag end
                    //   });
                    // },
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
          onPressed: () async {
            if (_pickedLocation == const LatLng(0, 0)) return;
            try {
              final address = await widget.userNotifier
                  .getAddressFromLatLng(_pickedLocation);
              logger.f('Retrieved address $address');

              widget.userNotifier.setAddressName(address!);
              widget.userNotifier.setAddressLocation(
                  '${_pickedLocation.latitude}, ${_pickedLocation.longitude}');
              await widget.userNotifier.updateAddress();

              if (context.mounted) {
                Navigator.of(context).pop();
                showSnackBar(
                    context, 'Address updated successfully!', Colors.green);
              }
            } on Exception catch (e) {
              if (!context.mounted) return;
              showSnackBar(context, 'Error updating address: ${e.toString()}',
                  Colors.red);
            }
          },
          // Confirm button
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
