import 'package:flutter/material.dart';

class BuyerSearch extends StatefulWidget {
  const BuyerSearch({super.key});

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
              const SizedBox(height: 76.0), // Space between AppBar and GridView
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
                        'color': const Color.fromRGBO(76, 175, 80, 1),
                      },
                      {
                        'name': 'Fruits',
                        'image': 'assets/fruits.jpeg',
                        'color': const Color.fromRGBO(76, 175, 80, 1),
                      },
                      {
                        'name': 'Seeds',
                        'image': 'assets/seeds.jpeg',
                        'color': const Color.fromRGBO(76, 175, 80, 1),
                      },
                      {
                        'name': 'Dry Foods',
                        'image': 'assets/dryfood.jpeg',
                        'color': const Color.fromRGBO(76, 175, 80, 1),
                      },
                    ];
                    return CategoryCard(
                      name: categories[index]['name']!,
                      image: categories[index]['image']!,
                      backgroundColor: categories[index]['color']
                          as Color, // Cast to Color type
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
  final Color backgroundColor; // Background color parameter

  const CategoryCard({
    Key? key,
    required this.name,
    required this.image,
    this.backgroundColor =
        const Color.fromRGBO(76, 175, 80, 1), // Default background color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Set the background color
          borderRadius: BorderRadius.circular(12), // Match the card's radius
        ),
        child: Column(
          children: [
            // Image section
            Padding(
              padding: const EdgeInsets.all(8.0), // Padding around the image
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  height: 167, // Set the desired height for the image
                  width: double.infinity, // Keep the width as full
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
                  color: Colors
                      .white, // Optional: change text color for better contrast
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
