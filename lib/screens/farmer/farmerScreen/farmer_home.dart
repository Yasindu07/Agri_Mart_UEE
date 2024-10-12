import 'dart:async';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_product_add.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_product_update.dart';
import 'package:agro_mart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/model/product_model.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  final ProductService _productService = ProductService();
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;
  String selectedCategory = '';
  List<Product> products = []; // Define products list

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

  void _selectCategory(String category) {
    setState(() {
      if (category == 'All') {
        selectedCategory = '';
      } else {
        selectedCategory = category;
      }
      searchQuery = '';
    });
  }

  int _getCategoryCount(String category) {
    if (category == 'All') {
      return products.length;
    } else {
      return products.where((product) => product.category == category).length;
    }
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
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: [
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
                    fontSize: 30,
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
              child: StreamBuilder<List<Product>>(
                stream: _productService.getUserProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading products'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  }

                  products = snapshot.data!; // Store fetched products

                  // Calculate counts dynamically
                  int vegetableCount = _getCategoryCount('Vegetable');
                  int fruitCount = _getCategoryCount('Fruits');
                  int seedsCount = _getCategoryCount('Seeds');
                  int dryFoodsCount = _getCategoryCount('Dry Foods');

                  return Row(
                    children: [
                      _buildCategoryCard(screenWidth, screenHeight, 'All',
                          _getCategoryCount('All')),
                      _buildCategoryCard(screenWidth, screenHeight, 'Vegetable',
                          vegetableCount),
                      _buildCategoryCard(
                          screenWidth, screenHeight, 'Fruits', fruitCount),
                      _buildCategoryCard(
                          screenWidth, screenHeight, 'Seeds', seedsCount),
                      _buildCategoryCard(screenWidth, screenHeight, 'Dry Foods',
                          dryFoodsCount),
                    ],
                  );
                },
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
      double screenWidth, double screenHeight, String title, int count) {
    double cardWidth = screenWidth * 0.3;
    double cardHeight = screenHeight * 0.1;

    return GestureDetector(
      onTap: () => _selectCategory(title),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          color: selectedCategory == title ||
                  (selectedCategory.isEmpty && title == 'All')
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    color: selectedCategory == title ||
                            (selectedCategory.isEmpty && title == 'All')
                        ? Theme.of(context).colorScheme.surface
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  count.toString(), // Display the count
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: selectedCategory == title ||
                            (selectedCategory.isEmpty && title == 'All')
                        ? Theme.of(context).colorScheme.surface
                        : Colors.black,
                  ),
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
    return StreamBuilder<List<Product>>(
      stream: _productService.getUserProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading products'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        }

        products = snapshot.data!; // Store fetched products

        final filteredProducts = products.where((product) {
          final matchesSearch =
              product.title.toLowerCase().contains(searchQuery) ||
                  product.category.toLowerCase().contains(searchQuery);
          final matchesCategory = selectedCategory.isEmpty ||
              product.category.toLowerCase() == selectedCategory.toLowerCase();

          return matchesSearch && matchesCategory;
        }).toList();

        if (filteredProducts.isEmpty) {
          return Center(child: Text('No matching products found'));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(
                filteredProducts[index],
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
    return Slidable(
      key: ValueKey(product.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: "Delete",
            borderRadius: BorderRadius.circular(15),
            onPressed: (context) async {
              await _productService.deleteProduct(
                product.id,
                product.imageUrls,
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: "Edit",
            borderRadius: BorderRadius.circular(15),
            onPressed: (context) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return FarmerProductUpdate(
                    product: product,
                  );
                },
              ));
            },
          ),
        ],
      ),
      child: Card(
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
                      : 'https://via.placeholder.com/70',
                  width: screenWidth * 0.22,
                  height: screenWidth * 0.22,
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
                        fontSize: 16,
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
                        fontSize: 14,
                        color: const Color.fromARGB(255, 99, 98, 98),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        Text(
                          'Quantity: ${product.quantity}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 99, 98, 98),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${product.pricePerKg} RS',
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
