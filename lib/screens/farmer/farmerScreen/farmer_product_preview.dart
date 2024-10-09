import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPreviewPage extends StatefulWidget {
  final String title;
  final String category;
  final double quantity;
  final String description;
  final String location;
  final double pricePerKg;
  final List<File?> images;

  const ProductPreviewPage({
    Key? key,
    required this.title,
    required this.category,
    required this.quantity,
    required this.description,
    required this.location,
    required this.pricePerKg,
    required this.images,
  }) : super(key: key);

  @override
  State<ProductPreviewPage> createState() => _ProductPreviewPageState();
}

class _ProductPreviewPageState extends State<ProductPreviewPage> {
  String _selectedShipping = 'Pick-Up';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height; // Correctly reference the product

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Preview',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'step 2/2',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.all(screenWidth * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Container(
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image:
                          widget.images.isNotEmpty && widget.images[0] != null
                              ? FileImage(widget
                                  .images[0]!) // Use FileImage for local files
                              : const NetworkImage(
                                      'https://via.placeholder.com/150')
                                  as ImageProvider, // Fallback if no images
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Wrap the title in Flexible to allow it to wrap or scale
                    Flexible(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        softWrap: true,
                        maxLines: 2, // Adjust as needed
                        overflow: TextOverflow
                            .ellipsis, // Add ellipsis if it overflows
                      ),
                    ),

                    SizedBox(
                        width: screenWidth *
                            0.02), // Add some space between title and price if needed

                    // Use Flexible or Expanded for the price as well
                    Text(
                      '${widget.pricePerKg} Rs\n1 Kg', // Line break after the price
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left, // Right-align the price text
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                // Location Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First Card
                    Flexible(
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.015),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.eco,
                                    color: Colors.black,
                                    size: screenWidth * 0.05,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Flexible(
                                    child: Text(
                                      widget.category,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                        width: screenWidth * 0.02), // Spacing between the cards

                    // Second Card
                    Flexible(
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.015),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: screenWidth * 0.05,
                                  ),
                                  SizedBox(width: screenWidth * 0.005),
                                  Flexible(
                                    child: Text(
                                      '4.8',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.amber,
                                      ),
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Flexible(
                                    child: Text(
                                      '11 Reviews',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                        width: screenWidth * 0.02), // Spacing between the cards

                    // Third Card
                    Flexible(
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.015),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: screenWidth * 0.05,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Flexible(
                                    child: Text(
                                      widget.location,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Description in a Card
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: screenWidth * 0.999, // Full width of the screen
                    constraints: BoxConstraints(
                      minHeight: screenHeight *
                          0.1, // Minimum height of 20% of the screen
                      maxHeight: screenHeight *
                          0.6, // Maximum height to avoid overflow
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.01),
                          Center(
                            child: Text(
                              widget.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Quantity:  ${widget.quantity} Kg',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Shipping Details :',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.35,
                      child: Radio<String>(
                        value: 'Pick-Up',
                        groupValue: _selectedShipping,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedShipping = value!;
                          });
                        },
                      ),
                    ),
                    Icon(
                      Icons.store, // Pick-Up icon
                      color: Colors.black,
                      size: screenWidth * 0.06,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Pick-Up',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.2),
                    Transform.scale(
                      scale: 1.35,
                      child: Radio<String>(
                        value: 'Delivery',
                        groupValue: _selectedShipping,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedShipping = value!;
                          });
                        },
                      ),
                    ),
                    Icon(
                      Icons.local_shipping, // Delivery icon
                      color: Colors.black,
                      size: screenWidth * 0.06,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Delivery',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add the product to the database
                    },
                    child: Text(
                      'Add To Cart',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2,
                        vertical: screenHeight * 0.013,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
