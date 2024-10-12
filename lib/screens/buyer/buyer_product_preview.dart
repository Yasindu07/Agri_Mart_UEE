import 'package:agro_mart/screens/buyer/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/model/product_model.dart';

class BuyerProductPreviewPage extends StatefulWidget {
  final Product product;
  final String userId; // Add userId parameter

  const BuyerProductPreviewPage({
    Key? key,
    required this.product,
    required this.userId, // Include userId in the constructor
  }) : super(key: key);

  @override
  _BuyerProductPreviewPageState createState() =>
      _BuyerProductPreviewPageState();
}

class _BuyerProductPreviewPageState extends State<BuyerProductPreviewPage> {
  String _selectedDeliveryMethod = 'Pick up'; // Default selected option

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            // Text(
            //   'step 2/2',
            //   style: GoogleFonts.poppins(
            //     fontSize: screenWidth * 0.04,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              // Product Image
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(widget.product.imageUrls.isNotEmpty
                        ? widget.product.imageUrls[0]
                        : 'https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Product Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.product.title,
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '${widget.product.pricePerKg.toStringAsFixed(2)} Rs\n1 Kg',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Location and Rating Cards
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
                                    widget.product.category,
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

                  // Location Card
                  Flexible(
                    child: Card(
                      color: Theme.of(context).colorScheme.secondary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.015),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Flexible(
                              child: Text(
                                widget.product.location,
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
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  // Rating Card
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
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Description Card
              Card(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: screenWidth * 0.999,
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.1,
                    maxHeight: screenHeight * 0.6,
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        Center(
                          child: Text(
                            widget.product.description,
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
                'Quantity:  ${widget.product.quantity} Kg',
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

              // Radio buttons for Pick up and Delivery
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'Pick up',
                      groupValue: _selectedDeliveryMethod,
                      title: Row(
                        children: [
                          Icon(
                            Icons.store, // Icon for 'Pick up'
                            color: Colors.black,
                          ),
                          SizedBox(
                              width:
                                  8), // Adjusted spacing between icon and text
                          Flexible(
                            child: Text(
                              'Pick up',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handles overflow
                            ),
                          ),
                        ],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedDeliveryMethod = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'Delivery',
                      groupValue: _selectedDeliveryMethod,
                      title: Row(
                        children: [
                          Icon(
                            Icons.local_shipping, // Icon for 'Delivery'
                            color: Colors.black,
                          ),
                          SizedBox(
                              width:
                                  8), // Adjusted spacing between icon and text
                          Flexible(
                            child: Text(
                              'Delivery',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handles overflow
                            ),
                          ),
                        ],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedDeliveryMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Checkout Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          product: widget.product,
                          userId: widget.userId, // Pass the userId here
                        ),
                      ),
                    );
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
    );
  }
}
