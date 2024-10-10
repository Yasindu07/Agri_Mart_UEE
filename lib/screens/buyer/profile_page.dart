import 'dart:io';
import 'package:agro_mart/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'add_location_page.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  bool _isEditing = false;

  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      var data = userDoc.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _addressController.text = data['address'] ?? '';
      _phoneNoController.text = data['phoneNo'] ?? '';

      _profileImageUrl = data['profileImageUrl'];
      setState(() {});
    }
  }

  Future<void> _saveUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'name': _nameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'phoneNo': _phoneNoController.text,
        'profileImageUrl': _profileImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      _loadUserData();
      setState(() {
        _isEditing = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');

      UploadTask uploadTask = reference.putFile(File(image.path));
      await uploadTask;

      _profileImageUrl = await reference.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully!')),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profileImageUrl': _profileImageUrl});

      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
      // Wrap the body in a Container for background color
      body: Container(
        color: Color(0xFFDDFFD6), // Set your desired background color here
        child: currentUser != null
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error fetching user data'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.exists) {
                    var data = snapshot.data!.data() as Map<String, dynamic>?;

                    if (data != null) {
                      String email = data['email'] ?? 'N/A';
                      String name = data['name'] ?? 'N/A';
                      String address = data['address'] ?? 'N/A';
                      String phoneNo = data['phoneNo'] ?? 'N/A';

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeaderSection(context, name, email),
                              const SizedBox(height: 20),
                              _buildProfileInfo(
                                  context, name, email, address, phoneNo),
                              const SizedBox(height: 20),
                              // _buildAddLocationButton(context),
                              const SizedBox(height: 20),
                              _buildEditProfileButton(),
                              const SizedBox(height: 30),
                              _buildLogoutButton(context),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: Text('User data not found'));
                    }
                  } else {
                    return const Center(child: Text('User data not found'));
                  }
                },
              )
            : const Center(child: Text('No user signed in')),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, String name, String email) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(
            0xFF28A745), // You can keep your existing color or change it
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Adjust the value for rounding
          bottomRight: Radius.circular(20.0), // Adjust the value for rounding
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Colors.transparent, // Changed to transparent
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : const AssetImage('assets/images/placeholder.png')
                            as ImageProvider,
                    child: _profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Color.fromARGB(255, 255, 255, 255),
                          )
                        : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, String name, String email,
      String address, String phoneNo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(context, Icons.phone, 'Phone Number', phoneNo),
        _buildInfoCard(context, Icons.location_on, 'Address', address),
        _buildInfoCard(context, Icons.email, 'Email', email),
      ],
    );
  }

  Widget _buildInfoCard(
      BuildContext context, IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.0),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Widget _buildAddLocationButton(BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const AddLocationPage(),
  //         ),
  //       );
  //     },
  //     style: ElevatedButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(vertical: 16),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     ),
  //     child: const Text(
  //       'Edit Location',
  //       style: TextStyle(fontSize: 16),
  //     ),
  //   );
  // }

  Widget _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        if (_isEditing) {
          // Save changes when in edit mode
          _saveUserData();
        } else {
          // Enter edit mode
          _showEditProfileDialog();
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF28A745), // Text color
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
    );
  }

  // Method to show the Edit Profile dialog
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 600, // Set your desired width
          height: 400, // Set your desired height
          child: AlertDialog(
            backgroundColor: const Color(0xFF28A745), // Set background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            title: const Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Name', _nameController),
                  const SizedBox(height: 16.0),
                  _buildTextField('Email', _emailController),
                  const SizedBox(height: 16.0),
                  _buildTextField('Address', _addressController),
                  const SizedBox(height: 16.0),
                  _buildTextField('Phone Number', _phoneNoController,
                      keyboardType: TextInputType.phone),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255,
                      255), // Change this color to your desired color
                ),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _saveUserData(); // Save the data and close the dialog
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255,
                      255), // Change this color to your desired color
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

// Custom method to build a styled text field
  Widget _buildTextField(String hintText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true, // Ensures the background is filled
        fillColor: Colors.white, // Sets the background color to white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 25.0, horizontal: 15.0), // Increases the height
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Color(0xFFEE7A6A),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
