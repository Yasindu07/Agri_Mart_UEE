import 'package:agro_mart/screens/buyer/buyer_search.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final PageController _carouselController = PageController();
  final PageController _servicesController = PageController();

  int _currentCarouselPage = 0; // Only declare this once
  Timer? _carouselTimer; // Timer for automatic image sliding

  int _currentServicesPage = 0;

  // List of your existing images for carousel
  final List<String> _carouselImages = [
    'assets/heading1.png',
    'assets/heading2.png',
    'assets/heading3.png',
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer(); // Start the carousel timer
  }

  @override
  void dispose() {
    _carouselTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Initialize the timer
  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentCarouselPage < _carouselImages.length - 1) {
        _currentCarouselPage++;
      } else {
        _currentCarouselPage = 0; // Loop back to the first image
      }
      _carouselController.animateToPage(
        _currentCarouselPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update the state to refresh the dots
    });
  }

  // List of service images
  final List<String> _serviceImages = [
    'assets/service1.jpeg',
    'assets/service2.jpeg',
    'assets/service3.jpeg',
    'assets/service4.jpeg',
  ];

  // List of your market view images (either from the network or assets)
  final List<String> _marketViewImages = [
    'assets/Mangoes.jpeg', // Replace with your actual image paths
    'assets/orange.jpeg',
    'assets/tomato.jpeg',
    'assets/greenbeans.jpeg',
  ];

  // List of texts corresponding to each market view image
  final List<String> _marketViewTexts = [
    'Mangoe', // Text for Mangoes image
    'Orange', // Text for Orange image
    'Tomatoe', // Text for Tomato image
    'Green Beans', // Text for Green Beans image
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // Set custom height
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ), // Add border radius to the AppBar
          child: AppBar(
            elevation: 1, // Remove AppBar shadow
            backgroundColor: Color(0xFF28A745),
            title: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Search...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false, // No back button
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel section with pagination dots
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _carouselController,
                    itemCount:
                        _carouselImages.length, // Number of carousel slides
                    onPageChanged: (int page) {
                      setState(() {
                        _currentCarouselPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(
                                  _carouselImages[index]), // Load the image
                              fit: BoxFit.cover, // Cover the whole container
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Carousel Pagination Dots
                  Positioned(
                    bottom: 10, // Position the dots at the bottom
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(_carouselImages.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 15,
                            width: _currentCarouselPage == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselPage == index
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Color(0xFFDDFFD6),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Market View Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Market View',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Inside your Market View section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2 / 1.2, // Adjust aspect ratio if needed
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(_marketViewImages.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuyerSearch(
                                  userId: '',
                                )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(
                            0xFFDDFFD6), // Background color for the container
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            2.0), // Padding inside the container
                        child: Row(
                          children: [
                            // Image Section
                            Container(
                              width:
                                  100, // Set width for the image container (70% of total width)
                              height: 140, // Increased height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(_marketViewImages[
                                      index]), // Load the image
                                  fit: BoxFit
                                      .cover, // Control how the image fits inside the container
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 8), // Space between the image and text
                            // Text Section
                            Expanded(
                              child: Container(
                                alignment: Alignment
                                    .centerLeft, // Align text to the left
                                child: Text(
                                  _marketViewTexts[
                                      index], // Use the corresponding text
                                  style: TextStyle(
                                    fontSize: 16, // Adjust font size as needed
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Services Section with scrollable items and pagination dots
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Text(
                'Services',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 150,
              child: PageView.builder(
                controller: _servicesController,
                itemCount: 2, // Number of service pages
                onPageChanged: (int page) {
                  setState(() {
                    _currentServicesPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (i) {
                        return Expanded(
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(_serviceImages[
                                    i]), // Load the service image
                                fit: BoxFit.cover, // Cover the container
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),

            // Services Pagination Dots
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentServicesPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentServicesPage == index
                          ? Colors.blue
                          : Colors.grey[400],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
