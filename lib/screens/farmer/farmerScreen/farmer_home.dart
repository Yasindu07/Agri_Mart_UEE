import 'package:agro_mart/screens/farmer/farmerScreen/farmer_product_add.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi Yasindu!',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Distributes space between children
              children: [
                Expanded(
                  child: Text(
                    'Product List',
                    textAlign: TextAlign
                        .center, // Center text within the Expanded widget
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: screenWidth * 0.06, // Responsive font size
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FarmerProductAdd();
                        },
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),

            // Categories Row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  children: [
                    _buildCategoryCard(
                        screenWidth, screenHeight, 'Vegitable', '5'),
                    _buildCategoryCard(
                        screenWidth, screenHeight, 'Fruits', '5'),
                    _buildCategoryCard(screenWidth, screenHeight, 'Seeds', '5'),
                    _buildCategoryCard(
                        screenWidth, screenHeight, 'Dry Foods', '5'),
                  ],
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                  hintText: 'Search your product',
                  contentPadding: EdgeInsets.symmetric(
                    vertical:
                        screenHeight * 0.012, // Adjusted for screen height
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),

            // Product List
            Container(
              height: screenHeight * 0.6, // Set a fixed height for the list
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                itemCount: 3, // assuming 3 items for now
                itemBuilder: (context, index) {
                  return _buildProductCard(screenWidth, screenHeight);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      double screenWidth, double screenHeight, String title, String count) {
    double cardWidth = screenWidth * 0.3;
    double cardHeight = screenHeight * 0.1;

    return SizedBox(
      width: cardWidth,
      height: cardHeight, // Ensures square cards
      child: Card(
        color: Colors.green.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                count,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green.shade100,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              child: Image.network(
                'https://via.placeholder.com/70',
                width: screenWidth * 0.18,
                height: screenWidth * 0.18, // Responsive image size
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            // Product Details
            Expanded(
              // <-- This ensures the content won't overflow the available space.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'White Rice Local Basmati',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    'Rs. 3500',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Product Actions (PID, weight, icons)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('PID: P001',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  '15kg',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: screenWidth * 0.03),
                    Icon(Icons.delete, color: Colors.red),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
