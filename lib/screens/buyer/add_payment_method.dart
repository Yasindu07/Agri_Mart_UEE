import 'package:flutter/material.dart';
import 'add_card_details.dart';

class AddPaymentMethodPage extends StatefulWidget {
  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  bool _cashOnDelivery = true;
  bool _debitCard = false;
  bool _creditCard = false;

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
          'Add Payment Method',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPaymentMethodSection(),
            SizedBox(height: 20),
            _buildShippingInfo(),
            SizedBox(height: 260),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(221, 255, 214, 1), // Light green background
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 160, 160, 160), blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.local_shipping,
                  color: const Color(0xFF4CAF50)), // Cash on delivery icon
              SizedBox(width: 10),
              Expanded(
                child: CheckboxListTile(
                  activeColor: Colors.green,
                  value: _cashOnDelivery,
                  onChanged: (bool? value) {
                    setState(() {
                      _cashOnDelivery = value!;
                      _debitCard = false;
                      _creditCard = false;
                    });
                  },
                  title: Text('Cash on Delivery'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.credit_card, color: Colors.orange), // Debit card icon
              SizedBox(width: 10),
              Expanded(
                child: CheckboxListTile(
                  activeColor: Colors.orange,
                  value: _debitCard,
                  onChanged: (bool? value) {
                    setState(() {
                      _debitCard = value!;
                      _cashOnDelivery = false;
                      _creditCard = false;
                    });
                  },
                  title: Text('Debit Card'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.credit_card_outlined,
                  color: Colors.blue), // Credit card icon
              SizedBox(width: 10),
              Expanded(
                child: CheckboxListTile(
                  activeColor: Colors.blue,
                  value: _creditCard,
                  onChanged: (bool? value) {
                    setState(() {
                      _creditCard = value!;
                      _cashOnDelivery = false;
                      _debitCard = false;
                    });
                  },
                  title: Text('Credit Card'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Container(
      height: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(221, 255, 214, 1),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 160, 160, 160), blurRadius: 5)
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.green, size: 30),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping To',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '123 Main Street, Springfield, IL 62704',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              Text(
                'Phone: (555) 123-4567',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPaymentMethodCardPage(),
          ),
        );
      },
      child: Text(
        'Checkout',
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
