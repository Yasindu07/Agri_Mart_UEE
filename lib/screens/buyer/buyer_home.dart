import 'package:flutter/material.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final PageController _carouselController = PageController();
  final PageController _servicesController = PageController();
  int _currentCarouselPage = 0;
  int _currentServicesPage = 0;

  // List of your existing images for carousel
  final List<String> _carouselImages = [
    'assets/heading1.png',
    'assets/heading2.png',
    'assets/heading3.png',
  ];

  // List of service images
  final List<String> _serviceImages = [
    'assets/service1.jpeg',
    'assets/service2.jpeg',
    'assets/service3.jpeg',
    'assets/service4.jpeg',
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
            elevation: 0, // Remove AppBar shadow
            backgroundColor: Colors.grey[200],
            title: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Search...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    child: const Icon(Icons.person),
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
                ],
              ),
            ),

            // Carousel Pagination Dots
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_carouselImages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentCarouselPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselPage == index
                          ? Colors.blue
                          : Colors.grey[400],
                    ),
                  );
                }),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2 / 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle tap action here
                      // For example, navigate to another page
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Icon(Icons.image, size: 40)),
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
            const SizedBox(height: 10),
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
