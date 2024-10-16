import 'package:agro_mart/screens/community-reports/buyer_community_post_page.dart';
import 'package:agro_mart/screens/buyer/buyer_home.dart';
import 'package:agro_mart/screens/buyer/buyer_search.dart';
import 'package:agro_mart/screens/buyer/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class BuyerBottomNav extends StatefulWidget {
  const BuyerBottomNav({super.key});

  @override
  State<BuyerBottomNav> createState() => _BuyerBottomNavState();
}

class _BuyerBottomNavState extends State<BuyerBottomNav> {
  int _currentIndex = 0;

  final _items = [
    SalomonBottomBarItem(
      icon: Icon(Icons.home),
      title: Text("Home"),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.search),
      title: Text("Search"),
    ),
    // SalomonBottomBarItem(
    //   icon: Icon(Icons.shopping_cart),
    //   title: Text("Cart"),
    // ),
    SalomonBottomBarItem(
      icon: Icon(Icons.comment_bank_outlined),
      title: Text("Community"),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.person),
      title: Text("Profile"),
    ),
  ];

  final _screens = [
    const BuyerHomePage(),
    BuyerSearch(
      userId: 'userId',
    ),
    CommunityPostsPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        duration: Duration(seconds: 1),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: _items,
      ),
    );
  }
}
