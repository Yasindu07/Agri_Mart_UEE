import 'package:flutter/material.dart';

// Import Screens
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_completeOrder.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_faq.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_home.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_pendingOrder.dart';
import 'package:agro_mart/screens/community-reports/community_posts_page.dart';
import 'package:agro_mart/screens/community-reports/price_list_page.dart';

class BottomNav extends StatefulWidget {
  final int initialIndex;
  const BottomNav({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Initialize with the passed index
  }

  // Define labels for each screen
  final List<String> _tabNames = [
    "Home",
    "Pending",
    "Completed",
    "FAQ",
    "Community",
    "Reports",
  ];

  // Define icons for each tab
  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.pending_actions_outlined,
    Icons.done,
    Icons.lightbulb,
    Icons.people,
    Icons.bar_chart,
  ];

  // Define colors
  final Color _activeColor = Colors.green;
  final Color _inactiveColor = Colors.grey;

  // Define screens
  final List<Widget> _screens = [
    const FarmerHomePage(),
    FarmerPendingOrder(),
    const FarmerCompleteOrder(),
    FarmerFaq(),
    CommunityPostsPage(),
    MarketTrendsScreen(),
  ];

  // Function to build each navigation item
  Widget _buildNavItem(int index) {
    bool isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the name above the icon if active
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: Text(
                  _tabNames[index],
                  style: TextStyle(
                    color: _activeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Icon
            Icon(
              _tabIcons[index],
              color: isActive ? _activeColor : _inactiveColor,
              size: 24,
            ),
            // Label below the icon
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              // child: Text(
              //   _tabNames[index],
              //   style: TextStyle(
              //     color: isActive ? _activeColor : _inactiveColor,
              //     fontSize: 12,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the current screen
      body: _screens[_currentIndex],
      // Custom Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: List.generate(
              _tabNames.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }
}
