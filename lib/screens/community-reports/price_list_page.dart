import 'package:agro_mart/screens/community-reports/price_reports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketTrendsScreen extends StatefulWidget {
  @override
  _MarketTrendsScreenState createState() => _MarketTrendsScreenState();
}

class _MarketTrendsScreenState extends State<MarketTrendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> displayedItems = [];
  bool isSearching = false;
  int currentPage = 1;
  int itemsPerPage = 5; // Changed to show 5 items per page
  late Stream<QuerySnapshot> itemsStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    itemsStream = FirebaseFirestore.instance.collection('market_items').snapshots();
    _fetchItems();
  }

  void _fetchItems() {
    itemsStream.listen(
      (snapshot) {
        setState(() {
          allItems = snapshot.docs.map((doc) {
            return {
              'name': doc['name'],
              'priceRange': doc['priceRange'],
              'image': doc['image'],
            };
          }).toList();
          _pageItems();
        });
      },
      onError: (error) {
        // Handle errors appropriately
        print('Error fetching items: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load items')),
        );
      },
    );
  }

  void _searchItems() {
    String query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isNotEmpty) {
        displayedItems = allItems.where((item) {
          return item['name'].toString().toLowerCase().contains(query);
        }).toList();
        isSearching = true;
      } else {
        _pageItems();
        isSearching = false;
      }
    });
  }

  void _pageItems() {
    setState(() {
      int startIndex = (currentPage - 1) * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (startIndex >= allItems.length) {
        startIndex = 0;
        currentPage = 1;
      }
      displayedItems = allItems.sublist(
        startIndex,
        endIndex.clamp(0, allItems.length),
      );
      isSearching = false;
    });
  }

  void _nextPage() {
    if (currentPage * itemsPerPage < allItems.length) {
      setState(() {
        currentPage++;
        _pageItems();
      });
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        _pageItems();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (allItems.length / itemsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market Trends',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
          ),
          SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          indicatorColor: Color(0xFF055A2F),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 1),
          onTap: (index) {
            setState(() {});
          },
          tabs: [
            Tab(
              icon: Icon(Icons.bar_chart, color: _tabController.index == 0 ? Color(0xFF089F4D) : Colors.grey),
              text: "Market Trends",
            ),
            Tab(
              icon: Icon(Icons.insert_chart_outlined, color: _tabController.index == 1 ? Color(0xFF089F4D) : Colors.grey),
              text: "Price Reports",
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_tabController.index == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  Average Prices',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF055A2F),
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the topic and search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            // Optional: Implement real-time search
                            //_searchItems();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _searchItems,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                buildPriceList(),
                PriceReportsPage(),
              ],
            ),
          ),
          if (_tabController.index == 0 && !isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26, // Fixed width
                    height: 24, // Fixed height
                    decoration: BoxDecoration(
                      color: Color(0xFFD1E655), // Set the yellow background color
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10), // Rounded corners with a radius of 10
                    ),
                    child: IconButton(
                      icon: Icon(Icons.navigate_before_outlined),
                      onPressed: _previousPage,
                      color: currentPage > 1 ? Colors.black : Colors.grey,
                      iconSize: 16, // Reduced icon size to fit within the fixed width and height
                      splashColor: Color(0xFFD1E655), // Splash color on click
                      highlightColor: Color(0xFFD1E655), // Highlight color on click
                      padding: EdgeInsets.zero, // Remove extra padding
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('$currentPage of $totalPages', style: TextStyle(color: Colors.black)),
                  ),
                  Container(
                    width: 26, // Fixed width
                    height: 24, // Fixed height
                    decoration: BoxDecoration(
                      color: Color(0xFFD1E655), // Set the yellow background color
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10), // Rounded corners with a radius of 10
                    ),
                    child: IconButton(
                      icon: Icon(Icons.navigate_next_outlined),
                      onPressed: _nextPage,
                      color: currentPage * itemsPerPage < allItems.length ? Colors.black : Colors.grey,
                      iconSize: 16, // Reduced icon size to fit within the fixed width and height
                      splashColor: Color(0xFFD1E655), // Splash color on click
                      highlightColor: Color(0xFFD1E655), // Highlight color on click
                      padding: EdgeInsets.zero, // Remove extra padding
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPriceList() {
    if (displayedItems.isEmpty) {
      return Center(
        child: Text(
          'No items found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: displayedItems.length,
      itemBuilder: (context, index) {
        final item = displayedItems[index];
        return Card(
          margin: EdgeInsets.all(1),
          color: Color(0xFFDDFFD6),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['priceRange'],
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 118, 191, 120), width: 2),
                      borderRadius: BorderRadius.circular(10), // Adds rounded corners
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Ensures the image fits the rounded corners
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, color: Colors.grey);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}