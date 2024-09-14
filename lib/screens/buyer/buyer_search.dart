import 'package:flutter/material.dart';

class BuyerSearch extends StatefulWidget {
  const BuyerSearch({super.key});

  @override
  State<BuyerSearch> createState() => _BuyerSearchState();
}

class _BuyerSearchState extends State<BuyerSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Search'),
      ),
    );
  }
}
