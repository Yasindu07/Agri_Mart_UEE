import 'package:flutter/material.dart';

class FarmerCompleteOrder extends StatefulWidget {
  const FarmerCompleteOrder({super.key});

  @override
  State<FarmerCompleteOrder> createState() => _FarmerCompleteOrderState();
}

class _FarmerCompleteOrderState extends State<FarmerCompleteOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Farmer Complete Order Page'),
      ),
    );
  }
}
