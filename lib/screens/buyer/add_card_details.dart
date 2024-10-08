import 'package:flutter/material.dart';
import 'success_page.dart';

class AddPaymentMethodCardPage extends StatefulWidget {
  @override
  _AddPaymentMethodCardPageState createState() =>
      _AddPaymentMethodCardPageState();
}

class _AddPaymentMethodCardPageState extends State<AddPaymentMethodCardPage> {
  bool _cashOnDelivery = false;
  bool _debitCard = true;

  // Controllers for text fields
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardholderNameController =
      TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add card details',
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
        // This will make the page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildPaymentMethodSelection(),
              SizedBox(height: 20),
              _buildCardDetailsForm(),
              SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
            221, 255, 214, 1), // Light green background color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(255, 72, 72, 72), blurRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Checkbox(
                value: _cashOnDelivery,
                onChanged: (bool? value) {
                  setState(() {
                    _cashOnDelivery = value!;
                    _debitCard = false;
                  });
                },
              ),
              Text('Visa card'),
              SizedBox(width: 165),
              Image.asset(
                'assets/visa.jpeg', // Path to your image asset
                height: 28, // Adjust height as needed
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _debitCard,
                onChanged: (bool? value) {
                  setState(() {
                    _debitCard = value!;
                    _cashOnDelivery = false;
                  });
                },
              ),
              Text('Master Card'),
              SizedBox(width: 150),
              Image.asset(
                'assets/logo mastercard.jpeg', // Path to your image asset
                height: 28, // Adjust height as needed
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Add new card',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _cardholderNameController,
          decoration: InputDecoration(
            labelText: 'Cardholder Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _expirationDateController,
          decoration: InputDecoration(
            labelText: 'MM/YY',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _cvvController,
          decoration: InputDecoration(
            labelText: 'CVV',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        // Validate card details
        if (_validateCardDetails()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(),
            ),
          );
        }
      },
      child: Text(
        'Save & Confirm',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(40, 167, 69, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 140, vertical: 10),
      ),
    );
  }

  bool _validateCardDetails() {
    String cardNumber = _cardNumberController.text.trim();
    String cardholderName = _cardholderNameController.text.trim();
    String expirationDate = _expirationDateController.text.trim();
    String cvv = _cvvController.text.trim();

    if (cardNumber.isEmpty ||
        cardholderName.isEmpty ||
        expirationDate.isEmpty ||
        cvv.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return false;
    }

    // Validate card number (example: length check)
    if (cardNumber.length < 16 || cardNumber.length > 19) {
      _showErrorDialog('Card number must be between 16 to 19 digits.');
      return false;
    }

    // Validate CVV (example: length check)
    if (cvv.length < 3 || cvv.length > 4) {
      _showErrorDialog('CVV must be 3 or 4 digits.');
      return false;
    }

    // Additional validation for expiration date can be added here

    return true; // All validations passed
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
}
