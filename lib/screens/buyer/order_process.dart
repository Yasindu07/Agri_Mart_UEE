import 'package:agro_mart/services/location_service.dart';
import 'package:agro_mart/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_mart/model/cart_model.dart';
import 'package:agro_mart/model/order_model.dart'
    as custom_order; // Use alias for custom Order model
import 'package:flutter_svg/flutter_svg.dart';

class OrderProcessPage extends StatefulWidget {
  final List<CartItem> cartItems; // Pass the cart items
  final double totalAmount; // Pass the total amount

  const OrderProcessPage({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _OrderProcessPageState createState() => _OrderProcessPageState();
}

class _OrderProcessPageState extends State<OrderProcessPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  String _paymentMethod = 'Visa'; // Default payment method set to Visa

  final LocationService _locationService = LocationService();
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    try {
      Position? position = await _locationService.getCurrentLocation();
      if (position != null) {
        String address = await _locationService.getAddressFromLatLng(position);
        setState(() {
          _locationController.text =
              address; // Set the fetched address to the text field
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  // Method to submit the order
  // Method to submit the order
  // Method to submit the order
Future<void> _submitOrder() async {
  if (_formKey.currentState!.validate()) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You need to be logged in to place an order.')),
      );
      return;
    }

    try {
      // Create an instance of the custom Order class using the alias
      final order = custom_order.Order(
        userId: user.uid,
        cartItems: widget.cartItems.map((item) => item.toMap()).toList(),
        totalAmount: widget.totalAmount,
        shippingAddress: _locationController.text, // Use the text value
        paymentMethod: _paymentMethod,
        orderDate: DateTime.now(), // Set order date to now
      );

      // Submit the order using the OrderService
      await _orderService.submitOrder(order);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      // Navigate back or to the home page after placing the order
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Process',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Display cart items
              Text(
                'Cart Items',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildCartItemsList(),

              SizedBox(height: 20),
              Text(
                'Shipping Address',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Items Location',
                  prefixIcon: Icon(Icons.location_on,
                      size: 20, color: Theme.of(context).colorScheme.primary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Method',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPaymentMethodOptions(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Submit Order', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a list of cart items to display
  Widget _buildCartItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: Image.network(
              item.imageUrl.isNotEmpty
                  ? item.imageUrl
                  : 'https://via.placeholder.com/150',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              item.title,
              style: GoogleFonts.poppins(),
            ),
            subtitle: Text(
              '${item.quantity} x ${item.pricePerKg.toStringAsFixed(2)} Rs / Kg',
              style: GoogleFonts.poppins(),
            ),
            trailing: Text(
              '${item.totalPrice.toStringAsFixed(2)} Rs',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  // Build payment method options using radio buttons
  Widget _buildPaymentMethodOptions() {
    return Column(
      children: [
        RadioListTile<String>(
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/visa.svg',
                width: 24,
                height: 24,
                color: Color(0xFF1A1F71),
              ),
              SizedBox(width: 10),
              Text('Visa', style: GoogleFonts.poppins()),
            ],
          ),
          value: 'Visa',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/mastercard.svg',
                width: 24,
                height: 24,
                color: Color(0xFFEB001B),
              ),
              SizedBox(width: 10),
              Text('MasterCard', style: GoogleFonts.poppins()),
            ],
          ),
          value: 'MasterCard',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
      ],
    );
  }
}
