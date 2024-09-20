import 'package:agro_mart/screens/login_screen.dart';
import 'package:agro_mart/screens/transpoter/DeliveryMapScreen.dart';
import 'package:agro_mart/screens/transpoter/TranspoterHome.dart';
import 'package:agro_mart/screens/transpoter/TranspoterMap.dart';
import 'package:agro_mart/screens/transpoter/TranspoterOrders.dart';
import 'package:agro_mart/screens/transpoter/TranspoterProfile.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:flutter/material.dart';

class TransporterScreen extends StatefulWidget {
  const TransporterScreen({super.key});

  @override
  State<TransporterScreen> createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TranspoterHome(),
    TranspoterOrder(),
    DeliveryMapScreen(),
    TranspoterProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFF055A30),
        unselectedItemColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
