import 'package:flutter/material.dart';

class FarmerFaq extends StatefulWidget {
  const FarmerFaq({super.key});

  @override
  State<FarmerFaq> createState() => _FarmerFaqState();
}

class _FarmerFaqState extends State<FarmerFaq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Farmer FAQ Page'),
      ),
    );
  }
}
