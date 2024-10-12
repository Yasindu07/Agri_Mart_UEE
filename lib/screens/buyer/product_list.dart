import 'dart:async';
import 'package:agro_mart/screens/buyer/buyer_product_preview.dart';
import 'package:agro_mart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/model/product_model.dart';
import '../buyer/cart/productList_cartPage.dart';

class ProductList extends StatefulWidget {
  final String userId; // Add userId parameter to track the logged-in user

  const ProductList({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductService _productService = ProductService(); // Firestore Service
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;
  String selectedCategory = ''; // Track selected category

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  // Method to handle category selection
  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category; // Set selected category
      searchQuery = ''; // Clear search query
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: GoogleFonts.poppins(
            color: const Color(0xFFDDFFD6),
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        backgroundColor: Color(0xFF28A745),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: const Color(0xFFDDFFD6),
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartDisplayPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with Product List title
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          //   child: Center(
          //     child: Text(
          //       'Product List',
          //       style: GoogleFonts.poppins(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //         fontSize: screenWidth * 0.06,
          //       ),
          //     ),
          //   ),
          // ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.015,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.green),
                hintText: 'Search your product',
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.018,
                  horizontal: screenWidth * 0.05,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Categories (Scrollable horizontally)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryCard(screenWidth, screenHeight, 'All'),
                  _buildCategoryCard(screenWidth, screenHeight, 'Vegetable'),
                  _buildCategoryCard(screenWidth, screenHeight, 'Fruits'),
                  _buildCategoryCard(screenWidth, screenHeight, 'Seeds'),
                  _buildCategoryCard(screenWidth, screenHeight, 'Dry Foods'),
                ],
              ),
            ),
          ),

          // Product List from Firestore
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  // Category Card Builder
  Widget _buildCategoryCard(
      double screenWidth, double screenHeight, String title) {
    double cardWidth = screenWidth * 0.3;
    double cardHeight = screenHeight * 0.07;

    return GestureDetector(
      onTap: () => _selectCategory(title), // Set selected category on tap
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          color:
              selectedCategory == title ? Color(0xFF28A745) : Color(0xFFDDFFD6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: selectedCategory == title ? 6 : 3, // Add elevation
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color:
                        selectedCategory == title ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Product List Builder
  Widget _buildProductList() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<List<Product>>(
      stream: _productService.getAllProducts(), // Stream from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error loading products: ${snapshot.error}');
          return Center(child: Text('Error loading products'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        }

        final products = snapshot.data!.where((product) {
          final matchesSearchQuery =
              product.title.toLowerCase().contains(searchQuery) ||
                  product.category.toLowerCase().contains(searchQuery);

          final matchesCategory =
              selectedCategory.toLowerCase().trim() == 'all' ||
                  selectedCategory.toLowerCase().trim().isEmpty ||
                  product.category.toLowerCase().trim() ==
                      selectedCategory.toLowerCase().trim();

          return matchesSearchQuery && matchesCategory;
        }).toList();

        if (products.isEmpty) {
          return Center(child: Text('No matching products found'));
        }

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (screenWidth / 200).floor(),
            mainAxisSpacing: screenHeight * 0.015,
            crossAxisSpacing: screenWidth * 0.03,
            childAspectRatio: screenWidth < 600 ? 0.75 : 1.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(
                products[index], screenWidth, screenHeight);
          },
        );
      },
    );
  }

  // Product Card Builder
  Widget _buildProductCard(
      Product product, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuyerProductPreviewPage(
              product: product,
              userId: widget.userId, // Pass the userId to the preview page
            ),
          ),
        );
      },
      child: Material(
        elevation: 2,
        color: Color.fromARGB(255, 249, 253, 255), // Light green
        borderRadius: BorderRadius.circular(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image with Bookmark Icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      child: Image.network(
                        product.imageUrls.isNotEmpty
                            ? product.imageUrls[0]
                            : 'https://via.placeholder.com/70',
                        width: double.infinity,
                        height: screenWidth * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Product Details
                    Text(
                      product.title,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Quantity: ${product.quantity} kg',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.032,
                        color: const Color.fromARGB(255, 99, 98, 98),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    // Button to View Product
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyerProductPreviewPage(
                                  product: product,
                                  userId: widget
                                      .userId, // Pass the userId to the preview page
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'View',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF28A745),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Bookmark Icon
                Positioned(
                  top: 10, // Adjust this value to position the icon vertically
                  right:
                      10, // Adjust this value to position the icon horizontally
                  child: Container(
                    width: 30, // Width of the circular background
                    height: 40, // Height of the circular background
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(
                          255, 255, 255, 255), // Background color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          blurRadius: 4, // Shadow blur
                          offset: Offset(0, 2), // Shadow offset
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove default padding
                      icon: Icon(
                        Icons.bookmark_border_outlined,
                        color: Color(0xFF5C5B64), // Icon color
                      ),
                      onPressed: () {
                        // Handle bookmark action here
                        // print('Bookmarked ${product.title}');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
