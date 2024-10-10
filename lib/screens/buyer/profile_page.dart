import 'package:agro_mart/screens/login_screen.dart';
//import 'package:agro_mart/screens/add_location_page.dart'; // Import your Add Location page
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_location_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Add logout functionality
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: currentUser != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching user data'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  // Extract just the email field
                  var data = snapshot.data!.data() as Map<String, dynamic>?;

                  if (data != null && data.containsKey('email')) {
                    String email = data['email'];

                    // Display the email and Add Location button
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeader(email),
                          SizedBox(
                              height: 24.0), // Add some space before the button
                          _buildAddLocationButton(
                              context), // Add Location button
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('Email not found'));
                  }
                } else {
                  return Center(child: Text('User data not found'));
                }
              },
            )
          : Center(child: Text('No user signed in')),
    );
  }

  // Widget to build profile header with email
  Widget _buildProfileHeader(String email) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 50, color: Colors.grey),
        ),
        SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Name', // Replace with actual name if needed
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              email, // Display user's email
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  // Widget to build the "Add Location" button
  Widget _buildAddLocationButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddLocationPage(), // Navigate to AddLocationPage
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text('Add Your Location'),
      ),
    );
  }
}
