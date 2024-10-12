

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agro_mart/model/cart_model.dart';
import 'package:agro_mart/services/cart_service.dart';
import 'package:agro_mart/screens/buyer/order_process.dart'; // Import the order process page

class CartDisplayPage extends StatefulWidget {
  const CartDisplayPage({Key? key}) : super(key: key);

  @override
  _CartDisplayPageState createState() => _CartDisplayPageState();
}

class _CartDisplayPageState extends State<CartDisplayPage> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  // Fetch cart items from the CartService
  Future<void> _fetchCartItems() async {
    try {
      final items = await _cartService.getCartItems();
      setState(() {
        _cartItems = items;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart items: $e')),
      );
    }
  }

  // Method to delete a cart item
  Future<void> _deleteCartItem(String productId) async {
    try {
      await _cartService.deleteCartItem(productId);
      setState(() {
        _cartItems.removeWhere((item) => item.productId == productId);
      });
      Fluttertoast.showToast(
        msg: "Item removed from cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to remove item: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Calculate total price of all items in the cart
  double _calculateTotalCartPrice() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart Items',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart Items:',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Display cart items using ListView.builder
            Expanded(
              child: ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return Card(
                    color: const Color(0xFFDDFFD6), // Set the card color here
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0), // Card margin
                    elevation: 5, // Adds shadow to the card for better visual
                    child: ListTile(
                      leading: Image.network(
                        item.imageUrl.isNotEmpty
                            ? item.imageUrl
                            : 'https://via.placeholder.com/150',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.title, style: GoogleFonts.poppins()),
                      subtitle: Text(
                          '${item.quantity} x ${item.pricePerKg.toStringAsFixed(2)} Rs / Kg'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rs ${item.totalPrice.toStringAsFixed(2)} ',
                            style: GoogleFonts.poppins(
                              fontSize: 16, // Set your desired font size here
                              fontWeight: FontWeight
                                  .bold, // Optional: set the font weight
                              color:
                                  Colors.black, // Optional: set the text color
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteCartItem(item.productId),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Checkout Button
            SizedBox(height: screenHeight * 0.12),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to OrderProcessPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderProcessPage(
                          cartItems: _cartItems, // Pass cart items
                          totalAmount:
                              _calculateTotalCartPrice(), // Pass total amount
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Checkout: Rs ${_calculateTotalCartPrice().toStringAsFixed(2)} ',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2,
                      vertical: screenHeight * 0.013,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
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
