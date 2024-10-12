import 'package:agro_mart/model/order_model.dart';
import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:agro_mart/screens/transpoter/OrderCompleteScreen.dart';
import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryMapScreen extends StatefulWidget {
  final String? orderId;
  final String? name;
  final String? phone;
  final String? package;
  final String? quantity;
  final String? startLocation;
  final String? price;
  final String? destination;

  const DeliveryMapScreen({
    super.key,
    this.name, // Optional parameters
    this.phone,
    this.package,
    this.quantity,
    this.startLocation,
    this.price,
    this.destination,
    this.orderId,
  });

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  late GoogleMapController _mapController;
  LocationData? _currentLocation;
  Location _location = Location();
  OrderModel? _order;
  final LatLng farmerLocation =
      LatLng(7.8731, 80.7718); // Replace with actual farmer coordinates
  final LatLng buyerLocation =
      LatLng(6.9271, 79.8612); // Replace with actual buyer coordinates

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Set<Circle> _circles = {};
  List<LatLng> polylineCoordinates = [];
  bool _deliveryStarted = false;
  bool _isOrderGetFromFarmer = false;
  bool _isArrivedAtBuyer = false;
  bool _isLoading = true;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchOrderDetails();
  }

  Future<void> _getCurrentLocation() async {
    _currentLocation = await _location.getLocation();
    _addMarkersAndCircles();
    await _getPolyline(); // Fetch and draw the route
    setState(() {});
  }

  Future<void> _fetchOrderDetails() async {
    if (widget.orderId != null) {
      _order = await _orderService.getOrderById(widget.orderId!);
    }
    setState(() {
      _isLoading = false; // Set loading to false after fetching
    });
  }

  Future<void> _updateOrderStatus(String field, bool value) async {
    await _orderService
        .updateOrderStatusDeliever(widget.orderId, {field: value});
    await _fetchOrderDetails(); // Refresh the order details after update
  }

  Future<LatLng?> _stringToLatLng(String? location) async {
    if (location == null) {
      return null;
    }

    // If the location is already in "latitude,longitude" format
    if (location.contains(',')) {
      try {
        final parts = location.split(',');
        final latitude = double.parse(parts[0].trim());
        final longitude = double.parse(parts[1].trim());
        return LatLng(latitude, longitude);
      } catch (e) {
        print('Error parsing location: $e');
        return null;
      }
    } else {
      // If the location is a place name, use Geocoding API to get the coordinates
      String googleAPIKey =
          "AIzaSyClmOljs5wfE6KmOauX_vC_dBdq06A8rpk"; // Replace with your API key
      String url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$googleAPIKey';

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json["results"].isNotEmpty) {
          var location = json["results"][0]["geometry"]["location"];
          return LatLng(location["lat"], location["lng"]);
        } else {
          print('No results found for the location');
        }
      } else {
        print('Failed to fetch geocoding data');
      }
      return null;
    }
  }

  void _addMarkersAndCircles() async {
    // Parse the startLocation and destination to LatLng
    final LatLng? startLatLng = await _stringToLatLng(widget.startLocation);
    final LatLng? destinationLatLng = await _stringToLatLng(widget.destination);

    if (startLatLng != null) {
      _markers.add(
        Marker(
          markerId: MarkerId("startLocation"),
          position: startLatLng,
          infoWindow: InfoWindow(title: "Start Location"),
        ),
      );
    }

    if (destinationLatLng != null) {
      _markers.add(
        Marker(
          markerId: MarkerId("destination"),
          position: destinationLatLng,
          infoWindow: InfoWindow(title: "Destination"),
        ),
      );
    }

    if (_currentLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position:
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          infoWindow: InfoWindow(title: "Current Location"),
        ),
      );
    }

    setState(() {});
  }

  Future<void> _getPolyline() async {
    final LatLng? startLatLng = await _stringToLatLng(widget.startLocation);
    final LatLng? destinationLatLng = await _stringToLatLng(widget.destination);

    if (startLatLng == null || destinationLatLng == null) {
      print('Invalid start or destination location');
      return;
    }

    String googleAPIKey =
        "AIzaSyClmOljs5wfE6KmOauX_vC_dBdq06A8rpk"; // Replace with your actual API key

    // Get directions
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}&waypoints=via:${startLatLng.latitude},${startLatLng.longitude}&key=$googleAPIKey';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading indicator while loading
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_order == null) {
      // Handle case where order data is still null after loading
      return Scaffold(
        body: Center(
          child: Text(
            'Order not found',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransporterScreen()));
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Information",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Package: ${widget.package ?? 'N/A'}", // Fallback if package is null
                          style: GoogleFonts.poppins(fontSize: 17),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),

                        // SizedBox(width: 16),
                        // Flexible(
                        Text(
                          "Quantity: ${widget.quantity ?? 'N/A'} kg", // Fallback if quantity is null
                          style: GoogleFonts.poppins(fontSize: 17),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16), // Add some spacing
              Text(
                "Rs. ${widget.price ?? '0'}0", // Fallback if price is null
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          // Farmer and Buyer Details
          !_order!.isStarted
              ? Column(
                  children: [
                    _buildContactCard(
                      label: "Farmer",
                      name: "Sachith Nimendra",
                      phone: "tel:+123456789",
                      imageUrl: "https://via.placeholder.com/50",
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    _buildContactCard(
                      label: "Buyer",
                      name: widget.name,
                      phone: "tel:${widget.phone}",
                      imageUrl: "https://via.placeholder.com/50",
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _updateOrderStatus('isStarted', true),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: Text("Start",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                )
              : _order!.isStarted && !_order!.isArrived
                  ? Column(
                      children: [
                        _buildContactCard(
                          label: "Farmer",
                          name: "Sachith Nimendra",
                          phone: "tel:+123456789",
                          imageUrl: "https://via.placeholder.com/50",
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Picked up from farmer?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              // width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _updateOrderStatus('isArrived', true),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Text("Confirm",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18, color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : _order!.isArrived && !_order!.isCompleted
                      ? Column(
                          children: [
                            _buildContactCard(
                              label: "Buyer",
                              name: widget.name,
                              phone: "tel:${widget.phone}",
                              imageUrl: "https://via.placeholder.com/50",
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      "Arrived at buyer and picked money?", // Long text
                                      textAlign: TextAlign
                                          .left, // Align the text to the left
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  // width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _updateOrderStatus('isCompleted', true);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderCompletescreen()));
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: Text("Confirm",
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
          SizedBox(height: 16),
          // Start/Confirm Button

          // if (_deliveryStarted)
        ],
      ),
    );
  }

  Widget _buildContactCard({
    String? label,
    String? name,
    String? phone,
    String? imageUrl,
    Color? backgroundColor,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: backgroundColor ?? Colors.white, // Provide a default color if null
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : AssetImage('assets/placeholder.png')
                      as ImageProvider, // Fallback image
              radius: 24,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label ?? 'No Label', // Default label if null
                  style: GoogleFonts.poppins(color: Colors.black54),
                ),
                SizedBox(height: 4),
                Text(
                  name ?? 'No Name', // Default name if null
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.call,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: phone != null
                  ? () => _launchURL(phone)
                  : null, // Disable if phone is null
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
