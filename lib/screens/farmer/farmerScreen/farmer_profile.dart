import 'package:flutter/material.dart';

class FarmerProfile extends StatefulWidget {
  const FarmerProfile({super.key});

  @override
  State<FarmerProfile> createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Farmer Profile Page'),
      ),
    );
  }
}
