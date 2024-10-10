import 'package:agro_mart/screens/farmer/farmer_bottomNav.dart';
import 'package:flutter/material.dart';

class FarmerScreen extends StatefulWidget {
  final int initialIndex;
  const FarmerScreen({super.key, this.initialIndex = 0});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Initialize with the passed index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNav(
        initialIndex: _selectedIndex,
      ),
    );
  }
}
