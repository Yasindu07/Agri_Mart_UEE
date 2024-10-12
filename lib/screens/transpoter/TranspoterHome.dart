import 'package:agro_mart/model/order_model.dart';
import 'package:agro_mart/model/user_model.dart';
import 'package:agro_mart/screens/transpoter/DeliveryMapScreen.dart';
import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:agro_mart/services/location_service.dart';
import 'package:agro_mart/screens/transporter_screen.dart';

class TranspoterHome extends StatefulWidget {
  const TranspoterHome({super.key});

  @override
  State<TranspoterHome> createState() => _TranspoterHomeState();
}

class _TranspoterHomeState extends State<TranspoterHome> {
  final OrderService _orderService = OrderService();
  String _currentAddress = "Fetching location...";
  Position? _currentPosition;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Get current position
      Position? position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
      });

      // Fetch address based on the position
      if (position != null) {
        String address = await _locationService.getAddressFromLatLng(position);
        setState(() {
          _currentAddress = address;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cardData = [
      {
        'name': "Inupa Udara",
        'package': "Rice",
        'quantity': "50 kg",
        'startLocation': "Galle",
        'destination': "Matara",
        'price': "Rs. 5000",
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': "Kamal Perera",
        'package': "Vegetables",
        'quantity': "30 kg",
        'startLocation': "Colombo",
        'destination': "Kandy",
        'price': "Rs. 3000",
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': "Nimal Fernando",
        'package': "Fruits",
        'quantity': "20 kg",
        'startLocation': "Kurunegala",
        'destination': "Colombo",
        'price': "Rs. 2000",
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': "Rohan Silva",
        'package': "Tea Leaves",
        'quantity': "40 kg",
        'startLocation': "Nuwara Eliya",
        'destination': "Galle",
        'price': "Rs. 4500",
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': "Sunil Rathnayake",
        'package': "Coconut",
        'quantity': "100 pcs",
        'startLocation': "Anuradhapura",
        'destination': "Colombo",
        'price': "Rs. 6000",
        'imageUrl': 'https://via.placeholder.com/150',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Text
            Text(
              "Your Location",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Row(
              children: [
                Icon(Icons.location_on,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: _currentAddress != null
                      ? Text(
                          _currentAddress,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const Text("Loading location..."),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scrollable list of cards
            // Stream of orders and user data
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _orderService.getAllOrdersWithUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('Error loading orders: ${snapshot.error}');
                    return const Center(child: Text("Error loading orders"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No orders available"));
                  }

                  // Filter out completed orders
                  final ordersWithUserData = snapshot.data!
                      .where((orderData) =>
                          !(orderData['order'] as OrderModel).isCompleted)
                      .toList();

                  if (ordersWithUserData.isEmpty) {
                    return const Center(
                        child: Text("No pending orders available"));
                  }

                  return ListView.builder(
                    itemCount: ordersWithUserData.length,
                    itemBuilder: (context, index) {
                      final orderData = ordersWithUserData[index];
                      final OrderModel order = orderData['order'] as OrderModel;
                      // final UserModel user = orderData['user'] as UserModel;

                      return ProductCard(
                        orderId: order.orderId,
                        name: order.username,
                        cartItems: order.cartItems,
                        startLocation: 'Galle',
                        destination:
                            order.shippingAddress, // Update this if needed
                        price: order.totalAmount.toString(),
                        // imageUrl: user.profilePicture,
                        phone: order.phone,
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Refactored Card Widget
class ProductCard extends StatelessWidget {
  final String orderId;
  final String name;
  final List<Map<String, dynamic>> cartItems;
  final String startLocation;
  final String destination;
  final String price;
  final String phone;
  // final String? imageUrl;

  const ProductCard({
    Key? key,
    required this.name,
    required this.cartItems,
    required this.startLocation,
    required this.destination,
    required this.price,
    required this.phone,
    required this.orderId,
    // required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String package =
        cartItems.map((item) => item['title'] as String).join(', ');
    final String quantity =
        cartItems.map((item) => item['quantity'].toString()).join(', ');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Theme.of(context).colorScheme.secondary,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 24,
                    //   backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                    //       ? NetworkImage(imageUrl!)
                    //       : AssetImage('assets/placeholder.png')
                    //           as ImageProvider,
                    // ),
                    // const SizedBox(width: 12),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Rs ${price}0",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      package,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quantity",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      quantity,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      startLocation,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Destination",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      destination,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryMapScreen(
                          // initialIndex: 2,
                          orderId: orderId,
                          name: name,
                          phone: phone,
                          package: package,
                          destination: destination,
                          price: price,
                          quantity: quantity,
                          startLocation: startLocation,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    "View",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
