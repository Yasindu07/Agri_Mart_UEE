import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
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
            _buildCartItem('Carrot', 'Rs. 25000', '15kg'),
            _buildCartItem('Banana', 'Rs. 45000', '35kg'),
            _buildCartItem('Potato', 'Rs. 34000', '30kg'),
            _buildCartItem('Potato', 'Rs. 34000', '30kg'),
            Spacer(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle checkout
                },
                child: Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String price, String quantity) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.image, size: 40, color: Colors.grey),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Available in stock'),
                  Text(price, style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    // Handle remove item
                  },
                  icon: Icon(Icons.close, color: Colors.grey),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle decrement
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(quantity),
                    IconButton(
                      onPressed: () {
                        // Handle increment
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
