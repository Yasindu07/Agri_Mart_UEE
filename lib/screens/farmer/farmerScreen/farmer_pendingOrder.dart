import 'dart:async';
import 'package:agro_mart/model/cart_model.dart';
import 'package:agro_mart/model/order_model.dart';
import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerPendingOrder extends StatefulWidget {
  @override
  _FarmerPendingOrderState createState() => _FarmerPendingOrderState();
}

class _FarmerPendingOrderState extends State<FarmerPendingOrder> {
  final OrderService _orderService = OrderService();
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;
  List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Orders',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.015,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.green),
                hintText: 'Search your product',
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.018,
                  horizontal: screenWidth * 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildOrderCardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCardList() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('User not logged in'));
    }

    return StreamBuilder<List<OrderModel>>(
      stream: _orderService
          .getOrdersByFarmer(user.uid), // Pass the current farmer's userId
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error loading orders: ${snapshot.error}');
          return Center(child: Text('Error loading orders'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No pending orders found for farmer with ID: ${user.uid}');
          return Center(child: Text('No pending orders found'));
        }

        orders = snapshot.data!;

        // Debug: Print out the filtered orders
        print('Number of orders found: ${orders.length}');
        for (var order in orders) {
          print(
              'Order for userId: ${order.userId}, totalAmount: ${order.totalAmount}');
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
          ),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(
                orders[index],
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(
      OrderModel order, double screenWidth, double screenHeight) {
    bool hasCartItems = order.cartItems.isNotEmpty;

    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Row(
          children: [
            if (hasCartItems && order.cartItems.first.containsKey('imageUrl'))
              ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                child: Image.network(
                  order.cartItems.first['imageUrl'],
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.10,
                  fit: BoxFit.cover,
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                child: Image.asset(
                  'assets/images/placeholder_image.png',
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.10,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: hasCartItems
                    ? order.cartItems.map((cartItemMap) {
                        CartItem cartItem = CartItem.fromMap(cartItemMap);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  cartItem.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Text(
                                  order.shippingAddress,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Pending',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'User: ${order.username}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                Text(
                                  'Rs. ${order.totalAmount}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${cartItem.quantity} Kg',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList()
                    : [
                        Text(
                          'No items found for this order',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
