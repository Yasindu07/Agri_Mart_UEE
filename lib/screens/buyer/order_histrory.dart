import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/model/order_model.dart' as custom_order;

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final OrderService _orderService = OrderService();
  List<custom_order.OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _orderService.getAllOrders().listen((orderList) {
        setState(() {
          _orders = orderList
              .where((order) => order.userId == user.uid) // Filter by user ID
              .toList();
          _isLoading = false; // Loading complete
        });
      });
    } else {
      setState(() {
        _isLoading = false; // Loading complete even if user is not logged in
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History', style: GoogleFonts.poppins()),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(child: Text('No orders found.'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Order ID: ${order.orderDate}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: ${order.totalAmount.toStringAsFixed(2)} Rs'),
                            Text('Payment Method: ${order.paymentMethod}'),
                            Text('Shipping Address: ${order.shippingAddress}'),
                          ],
                        ),
                        trailing: Text(
                          order.orderDate.toString(), // Change this to a formatted date string if desired
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
