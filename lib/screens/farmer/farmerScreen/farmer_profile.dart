// my_profile.dart

import 'dart:io';

import 'package:agro_mart/screens/community-reports/edit_post.dart';
import 'package:agro_mart/screens/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For uploading images
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For selecting images
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FarmerProfile extends StatefulWidget {
  const FarmerProfile({super.key});

  @override
  State<FarmerProfile> createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _error;

  File? _selectedImage;
  bool _isUploading = false;

  // User details variables
  String _userId = '';
  String _username = 'Anonymous';
  String _userProfileImage =
      'https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  String _email = 'N/A';
  String _address = 'N/A';
  String _phoneNumber = 'N/A';
  String _role = 'N/A';
  String _accountCreated = 'N/A';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  /// Fetches current user details from FirebaseAuth and Firestore
  Future<void> _fetchUserDetails() async {
    try {
      // Get the current user from FirebaseAuth
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No user is currently signed in.';
          _isLoading = false;
        });
        // Optionally, redirect to the login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return;
      }

      setState(() {
        _currentUser = user;
        _userId = user.uid;
        _email = user.email ?? 'N/A';
      });

      // Fetch additional user details from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data();
          _username = _userData!['displayName'] ?? 'Anonymous';
          _userProfileImage = _userData!['profilePicture'] ??
              'https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
          _address = _userData!['address'] ?? 'N/A';
          _phoneNumber = _userData!['phone'] ?? 'N/A';
          _role = _userData!['role'] ?? 'N/A';
          _accountCreated = _userData!['createdAt'] != null
              ? (_userData!['createdAt'] as Timestamp)
                  .toDate()
                  .toLocal()
                  .toString()
              : 'N/A';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'User data not found in Firestore.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching user details: $e';
        _isLoading = false;
      });
      print('Error fetching user details: $e');
    }
  }

  /// Picks an image from the gallery
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        await _uploadProfilePicture();
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  /// Uploads the selected image to Firebase Storage and updates Firestore
  Future<void> _uploadProfilePicture() async {
    if (_selectedImage == null || _currentUser == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Define the storage path
      String fileName =
          'profile_pictures/${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = _storage.ref().child(fileName);

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update the user's document in Firestore
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'profilePicture': downloadUrl,
      });

      // Update the local user data
      setState(() {
        _userProfileImage = downloadUrl;
        _selectedImage = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated successfully!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture: $e')),
      );
    }
  }

  /// Logs out the current user
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      Fluttertoast.showToast(
          msg: "Logged out successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    } catch (e) {
      print('Error logging out: $e');
      Fluttertoast.showToast(
          msg: "Failed to log out.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }

  /// Shows a SnackBar message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Builds a ListTile widget to display user information
  Widget _buildUserInfoTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  /// Builds the navigation buttons
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditDeletePostPage()));
          },
          icon: Icon(Icons.post_add),
          label: Text('My Posts'),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 235, 233, 233), // Background color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to another desired page, e.g., EditProfilePage
            // Replace with your actual page
            // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
          },
          icon: Icon(Icons.edit),
          label: Text('Edit Profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 235, 233, 233), // Background color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Main build method
  @override
  Widget build(BuildContext context) {
    // Display a loading indicator while fetching data
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Display an error message if any
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    // If user data is available, display it
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _userData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _userProfileImage.isNotEmpty
                            ? CachedNetworkImageProvider(_userProfileImage)
                            : null,
                        child: _userProfileImage.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: _isUploading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // User Information
                  _buildUserInfoTile('UID', _userId, Icons.fingerprint),
                  _buildUserInfoTile('Email', _email, Icons.email),
                  _buildUserInfoTile('Name', _username, Icons.person),
                  _buildUserInfoTile('Address', _address, Icons.location_on),
                  _buildUserInfoTile('Phone Number', _phoneNumber, Icons.phone),
                  _buildUserInfoTile('Role', _role, Icons.work),
                  _buildUserInfoTile(
                    'Account Created',
                    _accountCreated,
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 20),
                  // Navigation Buttons
                  _buildNavigationButtons(),
                ],
              )
            : const Center(
                child: Text(
                  'No user data available.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
