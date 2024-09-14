import 'package:agro_mart/screens/buyer/buyer_bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:agro_mart/screens/login_screen.dart';
// import 'buyer_bottomNav.dart'; // Import the BottomNav widget

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BuyerBottomNav(),
      // bottomNavigationBar: BottomNav(), // Use BottomNav for navigation
    );
  }
}
