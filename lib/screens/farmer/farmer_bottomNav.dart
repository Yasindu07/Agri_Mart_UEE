import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

//import Screens
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_completeOrder.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_faq.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_home.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_pendingOrder.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_profile.dart';

class BottomNav extends StatefulWidget {
  final int initialIndex;
  BottomNav({super.key, this.initialIndex = 0});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Initialize with the passed index
  }

  final _items = [
    SalomonBottomBarItem(
      icon: Icon(Icons.home, color: Color(0xFF28A745)),
      title: Text("Home"),
      selectedColor: Color(0xFF055A30),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.pending_actions_outlined, color: Color(0xFF28A745)),
      title: Text("Pending"),
      selectedColor: Color(0xFF055A30),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.done, color: Color(0xFF28A745)),
      title: Text("Done"),
      selectedColor: Color(0xFF055A30),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.lightbulb, color: Color(0xFF28A745)),
      title: Text("FAQ"),
      selectedColor: Color(0xFF055A30),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.person, color: Color(0xFF28A745)),
      title: Text("Profile"),
      selectedColor: Color(0xFF055A30),
    ),
  ];

  final _screens = [
    const FarmerHomePage(),
    const FarmerPendingOrder(),
    const FarmerCompleteOrder(),
    FarmerFaq(),
    const FarmerProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        duration: Duration(seconds: 1),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _items,
      ),
    );
  }
}
