import 'package:flutter/material.dart';

class FarmerPendingOrder extends StatefulWidget {
  const FarmerPendingOrder({super.key});

  @override
  State<FarmerPendingOrder> createState() => _FarmerPendingOrderState();
}

class _FarmerPendingOrderState extends State<FarmerPendingOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Farmer Pending Order Page'),
      ),
    );
  }
}
