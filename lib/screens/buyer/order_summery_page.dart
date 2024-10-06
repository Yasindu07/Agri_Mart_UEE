import 'package:flutter/material.dart';
import 'add_payment_method.dart'; // Make sure you import the AddPaymentMethodPage here

class OrderSummaryPage extends StatefulWidget {
  final int totalItems;
  final int totalCost;
  final double deliveryCharge;

  // Constructor to accept totalItems, totalCost, and deliveryCharge
  OrderSummaryPage({
    required this.totalItems,
    required this.totalCost,
    required this.deliveryCharge,
  });

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  // State variables for the delivery address, phone number, and zip code
  String deliveryAddress = '';
  String phoneNumber = '';
  String zipCode = ''; // Initialize zip code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the cart page
          },
        ),
        title: Text(
          'Order Summary',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[400],
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDeliveryAddress(),
              SizedBox(height: 20),
              _buildOrderInformation(),
              SizedBox(height: 20),
              _buildNextButton(),
            ],
          ),
        ),
      ),
      // Automatically resizes when keyboard appears
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildDeliveryAddress() {
    final TextEditingController _addressController =
        TextEditingController(text: deliveryAddress);
    final TextEditingController _phoneController =
        TextEditingController(text: phoneNumber);
    final TextEditingController _zipCodeController =
        TextEditingController(text: zipCode);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(76, 175, 80, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping,
                  color: const Color.fromARGB(255, 255, 255, 255), size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Delivery Address',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter your delivery address',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 2.0),
                borderRadius: BorderRadius.circular(
                    10.0), // Rounded corners for focused state
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            onChanged: (value) {
              // Update delivery address in state when user types
              deliveryAddress = value;
            },
          ),
          SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 2.0),
                borderRadius: BorderRadius.circular(
                    10.0), // Rounded corners for focused state
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            onChanged: (value) {
              // Update phone number in state when user types
              phoneNumber = value;
            },
          ),
          SizedBox(height: 10),
          TextField(
            controller: _zipCodeController,
            decoration: InputDecoration(
              hintText: 'Enter your zip code',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 2.0),
                borderRadius: BorderRadius.circular(
                    10.0), // Rounded corners for focused state
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            onChanged: (value) {
              // Update zip code in state when user types
              zipCode = value;
            },
          ),
          SizedBox(height: 10),
          // Save Icon Button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.save,
                  color: const Color.fromARGB(255, 255, 255, 255), size: 30),
              onPressed: () {
                setState(() {
                  // Show a message when the save button is pressed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Address saved successfully!'),
                    duration: Duration(seconds: 2),
                  ));
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInformation() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 204, 246, 196),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.blue, size: 30),
              SizedBox(width: 10),
              Text(
                'Order Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('Total Items: ${widget.totalItems}'),
          Text('Total Cost: Rs ${widget.totalCost}'),
          Text('Delivery Charge: Rs ${widget.deliveryCharge}'),
          Divider(),
          Text(
            'Final Amount: Rs ${widget.totalCost + widget.deliveryCharge}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Confirm ?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous Button
            SizedBox(
              width: 160, // Set width for both buttons
              height: 60, // Set height for both buttons
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the previous screen
                  Navigator.pop(context); // Go back to the previous page
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 143, 0,
                      0), // Button background color (grey for previous)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Next Button
            SizedBox(
              width: 160, // Set width for both buttons
              height: 60, // Set height for both buttons
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Add Payment Method Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPaymentMethodPage(),
                    ),
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4CAF50), // Green for Next button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}