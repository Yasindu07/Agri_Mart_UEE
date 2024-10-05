import 'package:agro_mart/screens/transpoter/TrackOrder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary, // Light green background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 8, // Blur radius
                  offset: Offset(0, 2), // Shadow position (x, y)
                ),
              ]),
          width: 350,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Success!',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.check_circle,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'Thank you for the order',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your order has been placed and is on it’s way',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Add your track order functionality here
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackOrderScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 85, vertical: 15),
                ),
                child: Text(
                  'Track the Order',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
