import 'package:agro_mart/model/cart_model.dart';
import 'package:agro_mart/model/order_model.dart';
import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerPendingOrder extends StatefulWidget {
  @override
  _FarmerPendingOrderState createState() => _FarmerPendingOrderState();
}

class _FarmerPendingOrderState extends State<FarmerPendingOrder> {
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Orders', style: GoogleFonts.poppins()),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getAllOrders(),
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error.toString()}',
                    style: GoogleFonts.poppins()));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                OrderModel order = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(order.cartItems.first[
                          'imageUrl']), // Display the image from the first cart item
                      radius: 30,
                    ),
                    title: Text('Order ID: ${order.userId}',
                        style: GoogleFonts.poppins()),
                    subtitle: Text(
                        'Total: Rs. ${order.totalAmount.toString()} - Order Pending',
                        style: GoogleFonts.poppins()),
                    children: order.cartItems.map((cartItemMap) {
                      CartItem cartItem = CartItem.fromMap(cartItemMap);
                      return ListTile(
                        title: Text(
                            '${cartItem.title} - ${cartItem.quantity}kg',
                            style: GoogleFonts.poppins()),
                        subtitle: Text('Rs. ${cartItem.totalPrice.toString()}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to cart item details page if needed
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text('No orders found', style: GoogleFonts.poppins()));
          }
        },
      ),
    );
  }
}
