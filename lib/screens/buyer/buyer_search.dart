import 'package:agro_mart/screens/buyer/product_list.dart';
import 'package:flutter/material.dart';

class BuyerSearch extends StatefulWidget {
  final String userId; // Add userId parameter to track the logged-in user

  const BuyerSearch({Key? key, required this.userId}) : super(key: key);

  @override
  State<BuyerSearch> createState() => _BuyerSearchState();
}

class _BuyerSearchState extends State<BuyerSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[400],
              child: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 66.0), // Space between AppBar and GridView
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 16.0, // Spacing between columns
                    mainAxisSpacing: 16.0, // Spacing between rows
                    childAspectRatio: 0.8, // Aspect ratio of each item
                  ),
                  itemCount: 4, // Number of categories
                  itemBuilder: (context, index) {
                    final List<Map<String, dynamic>> categories = [
                      {
                        'name': 'Vegetables',
                        'image': 'assets/vegetables.jpeg',
                        'color': Color(0xFF28A745),
                      },
                      {
                        'name': 'Fruits',
                        'image': 'assets/fruits.jpeg',
                        'color': Color(0xFF28A745),
                      },
                      {
                        'name': 'Seeds',
                        'image': 'assets/seeds.jpeg',
                        'color': Color(0xFF28A745),
                      },
                      {
                        'name': 'Dry Foods',
                        'image': 'assets/dryfood.jpeg',
                        'color': Color(0xFF28A745),
                      },
                    ];
                    return CategoryCard(
                      name: categories[index]['name']!,
                      image: categories[index]['image']!,
                      backgroundColor: categories[index]['color'] as Color,
                      userId: widget.userId, // Pass the userId here
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;
  final Color backgroundColor;
  final String userId; // Add userId parameter

  const CategoryCard({
    Key? key,
    required this.name,
    required this.image,
    required this.userId, // Include userId in the constructor
    this.backgroundColor = const Color.fromRGBO(76, 175, 80, 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ProductList page and pass the userId when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductList(
              userId: userId, // Pass the userId to ProductList
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Image section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    height: 160,
                    width: double.infinity,
                  ),
                ),
              ),
              // Text section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
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
