import 'package:agro_mart/screens/transpoter/DeliveryMapScreen.dart';
import 'package:agro_mart/screens/transpoter/TranspoterHome.dart';
import 'package:agro_mart/screens/transpoter/TranspoterOrders.dart';
import 'package:agro_mart/screens/transpoter/TranspoterProfile.dart';
import 'package:flutter/material.dart';

class TransporterScreen extends StatefulWidget {
  final int initialIndex;
  final String? orderId;
  final String? name;
  final String? phone;
  final String? package;
  final String? quantity;
  final String? startLocation;
  final String? price;
  final String? destination;
  const TransporterScreen({
    super.key,
    this.initialIndex = 0,
    this.orderId,
    this.name, // Optional parameters
    this.phone,
    this.package,
    this.quantity,
    this.startLocation,
    this.price,
    this.destination,
  });

  @override
  State<TransporterScreen> createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  int _selectedIndex = 0;

  // final List<Widget> _pages = [
  //   TranspoterHome(),
  //   TranspoterOrder(),
  //   DeliveryMapScreen(),
  //   TranspoterProfile(),
  // ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Initialize with the passed index
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Select the current page based on the selected index and pass data when necessary
    Widget currentPage;

    switch (_selectedIndex) {
      case 0:
        currentPage = TranspoterHome(); // Home Page
        break;
      case 1:
        currentPage = TranspoterOrder(); // Orders Page
        break;
      // case 2:
      //   // Pass data to DeliveryMapScreen when "Map" is selected
      //   currentPage = DeliveryMapScreen(
      //     orderId: widget.orderId,
      //     name: widget.name,
      //     phone: widget.phone,
      //     package: widget.package,
      //     quantity: widget.quantity,
      //     startLocation: widget.startLocation,
      //     price: widget.price,
      //     destination: widget.destination,
      //   );
      // break;
      case 2:
        currentPage = TranspoterProfile(); // Profile Page
        break;
      default:
        currentPage = TranspoterHome(); // Default to Home Page
        break;
    }
    return Scaffold(
      body: currentPage,
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.map),
          //   label: 'Map',
          // ),
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
