import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rating & Review',
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back press
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TransporterScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Driver info and vehicle
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: Offset(0, 2), // Shadow position (x, y)
                    ),
                  ]),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with actual image
                    radius: 25,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inupa Udara',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text('Driver'),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.local_shipping,
                        color: Colors.black,
                      ),
                      Text(
                        'PB-1234',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Cost, Quantity, Arrived
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cost',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text('Rs. 5000',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text('50 kg',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Arrived',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text('1.00 PM',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),

            // Rating
            Text(
              'Please rate your delivery',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            RatingBar.builder(
              itemSize: 55,
              initialRating: 4,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.primary,
              ),
              onRatingUpdate: (rating) {
                // Handle rating update
              },
            ),
            SizedBox(height: 50),

            // Review Text Field
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                hintText: 'Write a review..',
              ),
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary, // Background color
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle submit action
              },
              child: Text('Submit',
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
