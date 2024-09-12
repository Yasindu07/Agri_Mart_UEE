import 'package:agro_mart/screens/login_screen.dart';
import 'package:agro_mart/services/auth_services.dart';
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
      appBar: AppBar(
        title: Text("Farmer Page"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthServices().signOut(); // Call signOut method from AuthServices
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen())); // Navigate to LoginScreen
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome, Farmer!"),
      ),
    );
  }
}
