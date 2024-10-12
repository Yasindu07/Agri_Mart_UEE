import 'dart:io';

import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:agro_mart/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';

class TranspoterProfile extends StatefulWidget {
  const TranspoterProfile({super.key});

  @override
  State<TranspoterProfile> createState() => _TranspoterProfileState();
}

class _TranspoterProfileState extends State<TranspoterProfile> {
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
  bool isPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TransporterScreen()));
          },
        ),
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image and Name
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // replace with actual image URL
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Inupa Udara",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "PB-1234",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Name TextField
            buildTextField(
              icon: Icons.person,
              hintText: "Inupa",
              initialValue: "Inupa",
            ),

            // Email TextField
            buildTextField(
              icon: Icons.email,
              hintText: "inupa@gmail.com",
              initialValue: "inupa@gmail.com",
            ),

            // Password TextField with toggle visibility
            TextFormField(
              initialValue: "Password",
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                    color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number TextField
            buildTextField(
              icon: Icons.phone,
              hintText: "077412890",
              initialValue: "077412890",
            ),

            // Location TextField
            buildTextField(
              icon: Icons.location_pin,
              hintText: "Matara",
              initialValue: "Matara",
            ),

            const SizedBox(height: 20),
            // Update Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Update Profile",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await AuthServices().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                child: Text(
                  "Sign Out",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Reusable TextField Widget
  }
}

Widget buildTextField({
  required IconData icon,
  required String hintText,
  required String initialValue,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      style: GoogleFonts.poppins(),
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF28A745)),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
