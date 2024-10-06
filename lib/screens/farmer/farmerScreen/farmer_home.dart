import 'dart:async';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_product_add.dart';
import 'package:agro_mart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/model/product_model.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  final ProductService _productService = ProductService(); // Firestore Service
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi Yasindu!',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header with Product List title and Add button
          Row(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: Text(
                  'Product List',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmerProductAdd(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ],
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
                  _buildCategoryCard(
                      screenWidth, screenHeight, 'Vegetables', '5'),
                  _buildCategoryCard(screenWidth, screenHeight, 'Fruits', '5'),
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
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3.0,
                  ),
                ),
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
      double screenWidth, double screenHeight, String title, String count) {
    double cardWidth = screenWidth * 0.3;
    double cardHeight = screenHeight * 0.1;

    return SizedBox(
      width: cardWidth,
      height: cardHeight, // Ensures square cards
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

  // Product List Builder
  Widget _buildProductList() {
    return StreamBuilder<List<Product>>(
      stream: _productService.getUserProducts(), // Stream from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading state
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading products')); // Error state
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found')); // No data state
        }

        final products = snapshot.data!
            .where((product) =>
                product.title.toLowerCase().contains(searchQuery) ||
                product.category.toLowerCase().contains(searchQuery))
            .toList();

        if (products.isEmpty) {
          return Center(child: Text('No matching products found'));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(
                products[index],
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height);
          },
        );
      },
    );
  }

  // Product Card Builder
  Widget _buildProductCard(
      Product product, double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              child: Image.network(
                product.imageUrls.isNotEmpty
                    ? product.imageUrls[0]
                    : 'https://via.placeholder.com/70', // Fallback image if no URL is available
                width: screenWidth * 0.22,
                height: screenWidth * 0.22, // Responsive image size
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.036,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'PID: ${product.id}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.025,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Category: ${product.category}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.028,
                      color: const Color.fromARGB(255, 99, 98, 98),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Quantity: ${product.quantity}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.028,
                      color: const Color.fromARGB(255, 99, 98, 98),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
