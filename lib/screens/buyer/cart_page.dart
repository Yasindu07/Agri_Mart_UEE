import 'package:flutter/material.dart';
// import 'order_summery_page.dart'; // Make sure this import points to the correct file
// import '../../model/product_model.dart'; // Import your Product model

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  CartPage({required this.cartItems}); // Update the constructor

  // CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> get cartItems => widget.cartItems;

  // int _getTotalItems() {
  //   return cartItems.length;
  // }

  int _getTotalCost() {
    return cartItems.fold(
        0,
        (int sum, item) =>
            sum + ((item['price'] as int) * (item['quantity'] as int)));
  }

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Handle profile action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cartItems.isEmpty
            ? Center(child: Text('Your cart is empty!'))
            : Column(
                children: [
                  SizedBox(
                    height: 550,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(72, 158, 86, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return _buildCartItem(
                            item['name'],
                            item['price'],
                            item['quantity'],
                            index,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total Cost: Rs. ${_getTotalCost()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        cartItems.clear();
                      });
                    },
                    child: const Text(
                      'Clear Cart',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Container(
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.symmetric(
                  //       horizontal: 16.0, vertical: 4.0),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       int totalItems = _getTotalItems();
                  //       int totalCost = _getTotalCost();
                  //       double deliveryCharge = 50;

                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => OrderSummaryPage(
                  //             totalItems: totalItems,
                  //             totalCost: totalCost,
                  //             deliveryCharge: deliveryCharge,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     child: const Text(
                  //       'Checkout',
                  //       style: TextStyle(
                  //           color: Color.fromARGB(255, 255, 255, 255),
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF4CAF50),
                  //       padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }

  Widget _buildCartItem(String name, int price, int quantity, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  child: Image.network(
                    'item_image_url_here', // Load your image dynamically
                    width: screenWidth * 0.22,
                    height: screenWidth * 0.22,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Available in stock',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: const Color.fromARGB(255, 99, 98, 98),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Rs. $price',
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _decreaseQuantity(index),
                      icon: Icon(Icons.remove,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '$quantity kg',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _increaseQuantity(index),
                      icon: Icon(Icons.add,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
