import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_management/data/entities/user/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key, required this.users});

  final List<User> users;

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  bool _showAllUsers = true;
  bool _showRoute = true;
  List<Marker> userMarkers = [];
  List<LatLng> locations = [];

  Polyline _routePolyline = const Polyline(
    polylineId: PolylineId('userRoute'),
    color: Colors.blue,
    width: 5,
  );

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() async {
    // Initialize for current user
    await _getCurrentLocation();
    final position =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    locations.add(position);
    userMarkers.add(Marker(
      markerId: const MarkerId('currentUser'),
      position: position,
      infoWindow: const InfoWindow(title: 'Current User'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));

    // Initialize markers for each user
    for (var user in widget.users) {
      final address = user.address!.location.split(',');
      final position =
          LatLng(double.parse(address[0]), double.parse(address[1]));
      locations.add(position);
      userMarkers.add(Marker(
        markerId: MarkerId(user.id),
        position: position,
        infoWindow: InfoWindow(title: user.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    setState(() {
      _routePolyline = _routePolyline.copyWith(
          pointsParam: locations); // Update polyline with all user locations
    });
  }

  Future<void> _getCurrentLocation() async {
    bool permissionGranted = await _requestLocationPermission();
    if (permissionGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    Set<Marker> allMarkers = {};

    void _showFilterDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(localizations.filterOptions),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: Text(localizations.showRoute),
                  value: _showRoute,
                  onChanged: (value) {
                    setState(() {
                      _showRoute = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                CheckboxListTile(
                  title: Text(localizations.showMaker),
                  value: _showAllUsers,
                  onChanged: (value) {
                    setState(() {
                      _showAllUsers = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(localizations.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

    if (_showAllUsers) {
      allMarkers.addAll(userMarkers);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.mapWithUsersSilder),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map widget
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 12.0,
            ),
            markers: allMarkers,
            polylines: _showRoute ? {_routePolyline} : {},
          ),

          // Carousel slider for gallery cards
          Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                height: 150.0,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
              ),
              items: widget.users.map((user) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        final address = user.address!.location.split(',');
                        final position = LatLng(
                            double.parse(address[0]), double.parse(address[1]));
                        // Move the camera to the selected gallery location
                        _mapController.animateCamera(
                          CameraUpdate.newLatLng(position),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
