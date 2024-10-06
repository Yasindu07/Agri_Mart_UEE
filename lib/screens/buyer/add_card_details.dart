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
              Text('Credit card'),
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
              Text('Debit Card'),
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
            Text(
              'Add new card',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 112),
            Image.asset(
              'assets/visa.jpeg', // Path to your image asset (you can use any image here)
              height: 28, // Adjust height as needed
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/logo mastercard.jpeg', // Path to your image asset (you can use any image here)
              height: 28, // Adjust height as needed
            ),
            SizedBox(width: 8), // Space between the image and text
          ],
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Cardholder Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'MM/YY',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(),
          ),
        );
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
}
