import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPreviewPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Preview Product',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              // Display Images
              Text(
                'Images',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    images.length,
                    (index) => images[index] != null
                        ? Container(
                            margin: EdgeInsets.only(right: screenWidth * 0.03),
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              image: DecorationImage(
                                image: FileImage(images[index]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Title
              Text('Title: $title',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.01),
              // Category
              Text('Category: $category',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.01),
              // Quantity
              Text('Quantity: $quantity Kg',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.01),
              // Description
              Text('Description: $description',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.01),
              // Location
              Text('Location: $location',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.01),
              // Price Per Kg
              Text('Price: Rs $pricePerKg per Kg',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.045)),
              SizedBox(height: screenHeight * 0.03),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // You can trigger the product submission here if needed
                  },
                  child: Text(
                    'Submit Product',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
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
