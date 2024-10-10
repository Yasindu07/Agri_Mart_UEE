import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'community_posts_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadPostPage extends StatefulWidget {
  @override
  _UploadPostPageState createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final _descriptionController = TextEditingController();
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Variables to store user information
  String _username = '';
  String _userId = '';
  String _userProfileImage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch the current authenticated user's details from Firestore
  Future<void> _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userId = user.uid;
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _username = userDoc.get('displayName') ?? 'Anonymous';
            _userProfileImage = userDoc.get('profilePicture') ??'https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
          });
        } else {
          _showMessage('User data not found.');
        }
      } else {
        _showMessage('No user is currently signed in.');
        // Optionally, redirect to the login page
      }
    } catch (e) {
      _showMessage('Error fetching user details: $e');
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _images =
              pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        });
      } else {
        _showMessage('No images selected');
      }
    } catch (e) {
      _showMessage('Error picking images: $e');
    }
  }

  Future<void> _uploadPost() async {
    String description = _descriptionController.text.trim();

    if (description.isEmpty || _images.isEmpty) {
      _showMessage('Please fill in the description and select at least one image');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imageUrls = [];
      for (File image in _images) {
        if (image.existsSync()) {
          String fileName = '${_userId}_${DateTime.now().millisecondsSinceEpoch}';
          final storageRef =
              FirebaseStorage.instance.ref().child('post_images/$fileName');
          await storageRef.putFile(image);
          String downloadUrl = await storageRef.getDownloadURL();
          imageUrls.add(downloadUrl);
        } else {
          _showMessage('Image not found or could not be accessed.');
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Save post to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': _userId,
        'username': _username,
        'description': description,
        'images': imageUrls,
        'likes': 0,
        'userProfileImage' :_userProfileImage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showMessage('Post uploaded successfully!');
      // Optionally, navigate to the CommunityPostsPage after successful upload
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CommunityPostsPage()),
      );
    } catch (e) {
      _showMessage('Failed to upload post: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handlePost() {
    _uploadPost();
    // Optionally, you can navigate immediately and show a loading indicator on the next page
     Navigator.pushReplacement(
      context,
       MaterialPageRoute(builder: (context) => CommunityPostsPage()),
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload a Post',
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
            backgroundImage: NetworkImage(_userProfileImage),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Username (Optional: Read-only)
                  Text(
                    'Posting as: $_username',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),
                  // Image Selection Section
                  SizedBox(
                    height: 120,
                    child: _images.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Image.file(
                                      _images[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 16,
                                    top: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _images.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.add_a_photo, color: Colors.green),
                                onPressed: _pickImages,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: Icon(Icons.upload_file, color: Colors.white),
                      label: Text(
                        'Upload Images',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Post Description Field
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Post Description',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 24),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _handlePost,
                        icon: Icon(Icons.send, color: Colors.white),
                        label: Text('Post',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 27, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.cancel),
                        label: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[600],
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60), // Space for bottom navigation bar
                ],
              ),
            ),
    );
  }
}