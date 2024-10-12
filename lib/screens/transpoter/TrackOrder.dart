import 'package:agro_mart/screens/buyer/buyer_home.dart';
import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:agro_mart/screens/transpoter/Rating.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Add back navigation functionality
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BuyerHomePage()));
          },
        ),
        title: Text(
          'Tracking Details',
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Driver Information Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: Offset(0, 5), // Shadow position (x, y)
                    ),
                  ]),
              child: Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                'https://via.placeholder.com/150',
                              )),
                          SizedBox(width: 12),
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
                              Text(
                                'Driver',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.zero, // Remove any padding
                            child: Icon(Icons.local_shipping),
                          ),
                          SizedBox(width: 35),
                          Text(
                            'PB-1234',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 20, // Size of the circle
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary, // Circle background color
                    child: IconButton(
                      icon: Icon(Icons.call, color: Colors.white),
                      onPressed: () => _launchURL("tel:+123456789"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Tracking History
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tracking History',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 16),

            // Timeline
            Expanded(
              child: ListView(
                children: [
                  _buildTimelineTile('Order Accepted', '11.00 AM, Feb 7', true),
                  _buildTimelineTile(
                      'Pick Up from farmer', '12.00 AM, Feb 7', true),
                  _buildTimelineTile('Out', '11.00 AM, Feb 7', true),
                  _buildTimelineTile(
                      'Arrive at destination', '11.00 AM, Feb 7', false),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your track order functionality here
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RatingScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 85, vertical: 15),
              ),
              child: Text(
                'Rating & Review',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build timeline tile
  Widget _buildTimelineTile(String status, String time, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 3,
                  ),
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
                child: isCompleted
                    ? Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
              status == "Arrive at destination"
                  ? Container()
                  : Container(
                      width: 2,
                      height: 60,
                      color: isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
            ],
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: GoogleFonts.poppins(
                  color: isCompleted ? Colors.black : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isCompleted ? "Completed" : "In-progress",
                style: GoogleFonts.poppins(
                  color: isCompleted ? Colors.black : Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              isCompleted
                  ? Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: isCompleted ? Colors.black : Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  : Text(""),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
