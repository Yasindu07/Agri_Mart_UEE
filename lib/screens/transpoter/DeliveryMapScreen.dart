import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({super.key});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  late GoogleMapController _mapController;
  LocationData? _currentLocation;
  Location _location = Location();
  final LatLng farmerLocation =
      LatLng(7.8731, 80.7718); // Replace with actual farmer coordinates
  final LatLng buyerLocation =
      LatLng(6.9271, 79.8612); // Replace with actual buyer coordinates

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Set<Circle> _circles = {};
  List<LatLng> polylineCoordinates = [];
  bool _deliveryStarted = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    _currentLocation = await _location.getLocation();
    _addMarkersAndCircles();
    await _getPolyline(); // Fetch and draw the route
    setState(() {});
  }

  void _addMarkersAndCircles() {
    // Adding markers for farmer and buyer locations
    _markers.add(
      Marker(
        markerId: MarkerId("farmerLocation"),
        position: farmerLocation,
        infoWindow: InfoWindow(title: "Farmer"),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId("buyerLocation"),
        position: buyerLocation,
        infoWindow: InfoWindow(title: "Buyer"),
      ),
    );

    // Adding a circle for the current location
    if (_currentLocation != null) {
      _circles.add(
        Circle(
          circleId: CircleId("currentLocationCircle"),
          center:
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          radius: 50, // Radius in meters
          fillColor:
              Colors.blue.withOpacity(0.5), // Fill color with transparency
          strokeColor: Colors.blueAccent, // Border color
          strokeWidth: 2,
        ),
      );
    }
  }

  Future<void> _getPolyline() async {
    String googleAPIKey =
        "AIzaSyClmOljs5wfE6KmOauX_vC_dBdq06A8rpk"; // Replace with your API key

    // Get directions
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${buyerLocation.latitude},${buyerLocation.longitude}&waypoints=via:${farmerLocation.latitude},${farmerLocation.longitude}&key=$googleAPIKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json["routes"].isNotEmpty) {
        var route = json["routes"][0];
        var polyline = route["overview_polyline"]["points"];
        polylineCoordinates = PolylinePoints()
            .decodePolyline(polyline)
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        _addPolyline();
      }
    }
  }

  void _addPolyline() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("route"),
      color: Colors.black,
      points: polylineCoordinates,
      width: 4,
    );
    _polylines.add(polyline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    zoom: 12,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  circles: _circles,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Package Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Package: Rice"),
                      SizedBox(width: 16),
                      Text("Quantity: 50 kg"),
                    ],
                  ),
                ],
              ),
              Text("Rs. 5000",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black)),
            ],
          ),
          SizedBox(height: 16),
          // Farmer and Buyer Details
          _buildContactCard(
            label: "Farmer",
            name: "Sachith Nimendra",
            phone: "tel:+123456789",
            imageUrl: "https://via.placeholder.com/50",
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          _buildContactCard(
            label: "Buyer",
            name: "Inupa Udara",
            phone: "tel:+987654321",
            imageUrl: "https://via.placeholder.com/50",
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(height: 16),
          // Start/Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _deliveryStarted = !_deliveryStarted;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: _deliveryStarted
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
              ),
              child: Text(_deliveryStarted ? "Confirm" : "Start",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
          if (_deliveryStarted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child:
                  Text("Picked up from farmer?", textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      {required String label,
      required String name,
      required String phone,
      required String imageUrl,
      required Color backgroundColor}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 24,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.black54)),
                SizedBox(height: 4),
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () => _launchURL(phone),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
