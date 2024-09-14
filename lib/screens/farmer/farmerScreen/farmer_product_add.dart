import 'package:flutter/material.dart';

class FarmerProductAdd extends StatefulWidget {
  const FarmerProductAdd({super.key});

  @override
  State<FarmerProductAdd> createState() => _FarmerProductAddState();
}

class _FarmerProductAddState extends State<FarmerProductAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: Text('Add Product'),
      ),
    );
  }
}
