import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_mart/model/order_model.dart';
import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranspoterOrder extends StatelessWidget {
  const TranspoterOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderService _orderService = OrderService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TransporterScreen()));
          },
        ),
        title: Text(
          "Your Deliveries",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<OrderModel>>(
          stream: _orderService.getAllOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text("Error loading orders: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No orders available"));
            }

            // Filter orders based on isCompleted status
            final completedOrders =
                snapshot.data!.where((order) => order.isCompleted).toList();
            final pendingOrders =
                snapshot.data!.where((order) => !order.isCompleted).toList();

            return ListView(
              children: [
                // Display completed orders
                if (completedOrders.isNotEmpty) ...[
                  Text(
                    "Completed Orders",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...completedOrders.map((order) => OrderCard(
                        orderId: order.orderId ?? "Unknown",
                        status: "Completed",
                        startLocation: order.cartItems.isNotEmpty
                            ? order.cartItems[0]['startLocation'] ?? "Unknown"
                            : "Unknown",
                        endLocation: order.shippingAddress,
                        rating: 5,
                      )),
                  const SizedBox(height: 16),
                ],

                // Display pending orders
                if (pendingOrders.isNotEmpty) ...[
                  Text(
                    "Pending Orders",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...pendingOrders.map((order) => OrderCard(
                        orderId: order.orderId ?? "Unknown",
                        status: "Pending",
                        startLocation: order.cartItems.isNotEmpty
                            ? order.cartItems[0]['startLocation'] ?? "Galle"
                            : "Unknown",
                        endLocation: order.shippingAddress,
                        rating: 5,
                      )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String startLocation;
  final String endLocation;
  final int rating;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.status,
    required this.startLocation,
    required this.endLocation,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TransporterScreen(
                      initialIndex: 2,
                    )));
      },
      child: Card(
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
                children: [
                  // Order ID
                  Expanded(
                    child: Text(
                      "Order ID\n$orderId",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis, // Handle overflow
                      maxLines: 2, // Limit to two lines
                    ),
                  ),
                  const SizedBox(width: 8), // Add some spacing
                  // Order Status
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis, // Handle overflow
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Location Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 10, color: Color(0xFF28A745)),
                          const SizedBox(width: 4),
                          Text(
                            startLocation,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 10, color: Color(0xFF28A745)),
                          const SizedBox(width: 4),
                          Text(
                            endLocation,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Rating Information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Rating",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        "$rating/5",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
