import 'package:agro_mart/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_location_page.dart'; // Import the Add Location page

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24.0),
            _buildProfileDetails(),
            SizedBox(height: 24.0),
            _buildAddLocationButton(context),
          ],
        ),
      ),
    );
  }

  // Widget to build profile header
  Widget _buildProfileHeader() {
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
              'John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'johndoe@example.com',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  // Widget to build profile details section
  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        _buildDetailRow('Phone:', '123-456-7890'),
        SizedBox(height: 8.0),
        _buildDetailRow('Address:', '123 Main Street, City, Country'),
      ],
    );
  }

  // Widget to build individual detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: Colors.grey[600])),
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
              builder: (context) => AddLocationPage(),
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
