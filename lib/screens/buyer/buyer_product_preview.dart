import 'package:flutter/material.dart';
import 'package:agro_mart/model/product_model.dart';
import 'order_summery_page.dart';

class BuyerProductPreviewPage extends StatelessWidget {
  final Product product;

  const BuyerProductPreviewPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  Widget _buildRatingStars(double rating, double screenWidth) {
    int fullStars = rating.floor(); // Full star count
    int halfStars = (rating - fullStars >= 0.5) ? 1 : 0; // Half star count
    int emptyStars = 5 - fullStars - halfStars; // Empty star count

    return Row(
      children: [
        // Full stars
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.045),
        // Half stars
        for (int i = 0; i < halfStars; i++)
          Icon(Icons.star_half, color: Colors.amber, size: screenWidth * 0.045),
        // Empty stars
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border,
              color: Colors.amber, size: screenWidth * 0.045),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: screenWidth * 0.06,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              // Product Image
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrls.isNotEmpty
                        ? product.imageUrls[0]
                        : 'https://via.placeholder.com/300'), // Fallback image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Title and Price in a Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns price to the top
                children: [
                  // Product Title
                  Flexible(
                    child: Text(
                      product.title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow:
                          TextOverflow.visible, // Allow overflow to be visible
                      maxLines: 2, // Limit to 2 lines
                    ),
                  ),
                  // Product Price
                  Container(
                    alignment:
                        Alignment.topRight, // Align price to the top right
                    child: Text(
                      'Rs ${product.pricePerKg.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              // Location Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                      screenWidth * 0.04), // Add padding to the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on, // Location icon
                            color: const Color(0xFF28A745), // Set icon color
                            size: screenWidth *
                                0.05, // Adjust size based on screen width
                          ),
                          SizedBox(
                            width: screenWidth *
                                0.02, // Add spacing between icon and text
                          ),
                          Flexible(
                            child: Text(
                              product.location,
                              style: TextStyle(
                                fontSize:
                                    screenWidth * 0.045, // Adjust font size
                                color: const Color(
                                    0xFF000000), // Set text color to black
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                              maxLines: 1, // Limit to one line
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.01), // Spacing between location and quantity
                      // Available Quantity
                      Text(
                        'Available: ${product.quantity} Kg',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Adjust font size
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Description in a Card
              Card(
                color: const Color(0xFFDDFFD6),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: screenWidth * 0.999, // Full width of the screen
                  height: screenHeight * 0.2, // 20% of screen height
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black, // Set text color to black
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Checkout Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Assuming you have a product object with quantity and pricePerKg
                    double totalCost = product.pricePerKg *
                        product.quantity; // Calculate total cost

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSummaryPage(
                          totalItems: product.quantity
                              .toInt(), // Pass total items as an integer
                          pricePerKg: product.pricePerKg, // Pass price per kg
                          availableQuantity:
                              product.quantity, // Pass available quantity
                          deliveryCharge: 50.0, // Example delivery charge
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(40, 167, 69, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 140, vertical: 10),
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
