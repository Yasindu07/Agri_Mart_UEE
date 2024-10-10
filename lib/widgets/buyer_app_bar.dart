import 'package:agro_mart/screens/buyer/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:agro_mart/screens/farmer/farmerScreen/farmer_profile.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _profileImageUrl =
      'https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
  }

  /// Fetches the current user's profile picture from Firebase
  Future<void> _fetchUserProfileImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _profileImageUrl =
                userDoc.get('profilePicture') ?? _profileImageUrl;
          });
        }
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true, // Centers the title
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundImage: NetworkImage(_profileImageUrl),
            radius: 18,
          ),
          onPressed: () {
            // Navigate to Farmer Profile Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
        SizedBox(width: 16), // Padding to the right edge
      ],
    );
  }
}
