import 'package:flutter/material.dart';
import 'add_payment_method.dart'; // Import the AddPaymentMethodPage

class OrderSummaryPage extends StatefulWidget {
  final int totalItems;
  final double pricePerKg; // Added pricePerKg parameter
  final double availableQuantity; // Added availableQuantity parameter
  final double deliveryCharge;

  // Constructor to accept totalItems, totalCost, and deliveryCharge
  OrderSummaryPage({
    required this.totalItems,
    required this.pricePerKg,
    required this.availableQuantity,
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
  bool isAddressSaved = false; // New flag to check if address is saved

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
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

    // Form Key
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(76, 175, 80, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Form(
        key: _formKey, // Assign the form key here
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
            TextFormField(
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your delivery address';
                }
                return null; // Return null if valid
              },
              onChanged: (value) {
                deliveryAddress =
                    value; // Update delivery address in state when user types
              },
            ),
            SizedBox(height: 10),
            TextFormField(
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                  return 'Enter a valid phone number';
                }
                return null; // Return null if valid
              },
              onChanged: (value) {
                phoneNumber =
                    value; // Update phone number in state when user types
              },
            ),
            SizedBox(height: 10),
            TextFormField(
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your zip code';
                } else if (!RegExp(r'^\d{5}(?:[-\s]\d{4})?$').hasMatch(value)) {
                  return 'Enter a valid zip code';
                }
                return null; // Return null if valid
              },
              onChanged: (value) {
                zipCode = value; // Update zip code in state when user types
              },
            ),
            SizedBox(height: 10),
            // Save Icon Button
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // To size the row to the minimum width needed
                children: [
                  Text(
                    'Save', // The text label
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 255, 255), // Text color
                      fontWeight: FontWeight.bold, // Text style
                      fontSize: 16, // Font size
                    ),
                  ),
                  SizedBox(
                      width: 8), // Add some space between the text and the icon
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 30,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isAddressSaved =
                              true; // Only set to true if all fields are valid

                          // Show a dialog box when the save button is pressed
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success'),
                                content: Text('Address saved successfully!'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      } else {
                        setState(() {
                          isAddressSaved =
                              false; // If not valid, reset the flag
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInformation() {
    // Calculate the total cost based on price per kg and available quantity
    double totalCost = widget.pricePerKg * widget.availableQuantity;

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
          Text('Total Items: ${widget.totalItems}'), // Display total items
          Text(
              'Total Cost: Rs ${totalCost.toStringAsFixed(2)}'), // Display calculated total cost
          Text(
              'Delivery Charge: Rs ${widget.deliveryCharge.toStringAsFixed(2)}'),
          Divider(),
          Text(
            'Final Amount: Rs ${(totalCost + widget.deliveryCharge).toStringAsFixed(2)}', // Display final amount
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
              width: 160,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
                  backgroundColor: const Color.fromARGB(255, 143, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            // Next Button
            SizedBox(
              width: 160,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (isAddressSaved) {
                    // Navigate to the Add Payment Method Page only if the address is saved
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPaymentMethodPage(
                          deliveryAddress: deliveryAddress,
                          phoneNumber: phoneNumber,
                          zipCode: zipCode,
                        ),
                      ),
                    );
                  } else {
                    // Show an alert or error message if the address is not saved
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Not completed!'),
                          content: Text(
                              'Please fill and save your delivery address, phone number, and zip code before proceeding.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 143, 72),
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
