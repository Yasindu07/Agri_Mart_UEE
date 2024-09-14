import 'package:agro_mart/screens/farmer/farmer_bottomNav.dart';
import 'package:flutter/material.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNav(),
    );
  }
}
