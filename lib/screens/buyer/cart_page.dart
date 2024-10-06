import 'package:flutter/material.dart';
import 'order_summery_page.dart'; // Make sure this import points to the correct file

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {'name': 'Carrot', 'price': 25000, 'quantity': 15},
    {'name': 'Banana', 'price': 45000, 'quantity': 35},
    {'name': 'Potato', 'price': 34000, 'quantity': 30},
    {'name': 'Potato', 'price': 34000, 'quantity': 30},
    // Add more items here if needed for testing scroll
  ];

  int _getTotalItems() {
    return cartItems.length;
  }

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
        child: Column(
          children: [
            SizedBox(
              height: 550, // Set a fixed height as needed
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      72, 158, 86, 1), // Set a background color here
                  borderRadius: BorderRadius.circular(
                      12), // Optional: add rounded corners
                ),
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _buildCartItem(
                        item['name'], item['price'], item['quantity'], index);
                  },
                ),
              ),
            ),
            // Add the text widget here
            const SizedBox(
                height: 20), // Add space between the container and text
            Text(
              'Delivery Charge is depend on your location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
                height:
                    20), // Add space between the text and the checkout button
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  int totalItems = _getTotalItems();
                  int totalCost = _getTotalCost();
                  double deliveryCharge = 50;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSummaryPage(
                        totalItems: totalItems,
                        totalCost: totalCost,
                        deliveryCharge: deliveryCharge,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, int price, int quantity, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 15.0, horizontal: 1.0), // Margin to avoid overflow
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4, // Add elevation for a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        color: const Color.fromRGBO(221, 255, 214, 1),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use min size to fit content
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              12), // Desired border radius
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              blurRadius: 4, // Softens the shadow
                              offset:
                                  const Offset(0, 2), // Position of the shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12), // Ensure image respects border radius
                          child: Image.asset(
                            'assets/carrots.jpeg', // Replace with your image path
                            fit: BoxFit.cover, // Helps image fit the container
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'Available in stock',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Rs. $price',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Quantity control at the bottom
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align at the end
                    children: [
                      // Decrease Quantity Button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 30, // Width for the button
                        height: 30, // Height for the button
                        child: IconButton(
                          onPressed: () {
                            _decreaseQuantity(index);
                          },
                          icon: const Icon(Icons.remove,
                              size: 20,
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // Icon size
                          padding: EdgeInsets.zero, // Remove padding
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0), // Reduced padding
                        child: Text(
                          '$quantity kg',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Increase Quantity Button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 30, // Width for the button
                        height: 30, // Height for the button
                        child: IconButton(
                          onPressed: () {
                            _increaseQuantity(index);
                          },
                          icon: const Icon(Icons.add,
                              size: 20,
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // Icon size
                          padding: EdgeInsets.zero, // Remove padding
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Close Icon with Circular Background in the top right corner
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 40, // Adjust the width as needed
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  // Background color
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle remove item (optional)
                  },
                  icon: const Icon(Icons.close,
                      color: Colors.white), // White cross icon
                  iconSize: 29,
                  padding: EdgeInsets.zero, // Remove padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
