// edit_delete_post_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // For selecting images
import 'dart:io'; // For handling files
import 'package:firebase_auth/firebase_auth.dart'; // For authentication

class EditDeletePostPage extends StatefulWidget {
  @override
  _EditDeletePostPageState createState() => _EditDeletePostPageState();
}

class _EditDeletePostPageState extends State<EditDeletePostPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _selectedImage;
  String _searchText = '';
  String _userId = '';
  bool _isLoading = true;

  // Function to fetch the current user's ID
  Future<void> _fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    } else {
      // Handle the case where no user is logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is currently signed in.')),
      );
      Navigator.pop(context); // Navigate back or redirect to login
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Function to update post
  Future<void> _updatePost(String postId, String newDescription) async {
    try {
      Map<String, dynamic> updateData = {'description': newDescription};

      // Check if a new image was selected
      if (_selectedImage != null) {
        // Create a reference to Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('post_images/${_userId}_${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the image to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(_selectedImage!);
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL
        String newImageUrl = await snapshot.ref.getDownloadURL();
        updateData['images'] = FieldValue.arrayUnion([newImageUrl]); // Add new image URL to the list
      }

      await _firestore.collection('posts').doc(postId).update(updateData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post updated successfully!')),
      );
      setState(() {
        _selectedImage = null; // Reset the selected image
      });
    } catch (e) {
      print('Error updating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post!')),
      );
    }
  }

  // Function to delete post
  Future<void> _deletePost(String postId) async {
    try {
      // Optionally, delete associated images from Firebase Storage
      DocumentSnapshot postDoc = await _firestore.collection('posts').doc(postId).get();
      if (postDoc.exists) {
        List<dynamic> images = postDoc['images'] ?? [];
        for (String imageUrl in images) {
          try {
            Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
            await imageRef.delete();
          } catch (e) {
            print('Error deleting image: $e');
            // Continue deleting other images even if one fails
          }
        }
      }

      await _firestore.collection('posts').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post!')),
      );
    }
  }

  // Function to fetch posts belonging to the current user
  Stream<QuerySnapshot> _fetchUserPosts() {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: _userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit or Delete Posts'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search your posts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _fetchUserPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Error fetching posts: ${snapshot.error}');
                  return Center(child: Text('Error fetching posts.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No posts available.'));
                }

                // Filter posts based on search text
                final filteredPosts = snapshot.data!.docs.where((doc) {
                  String description = doc['description']?.toString().toLowerCase() ?? '';
                  String username = doc['username']?.toString().toLowerCase() ?? '';
                  return description.contains(_searchText.toLowerCase()) ||
                      username.contains(_searchText.toLowerCase());
                }).toList();

                return RefreshIndicator(
                  onRefresh: () async {
                    // Since we're using StreamBuilder, pull-to-refresh isn't necessary.
                    // But if you have additional refresh logic, implement it here.
                  },
                  child: ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot post = filteredPosts[index];
                      String postId = post.id;
                      List<dynamic> images = post['images'] ?? [];
                      String description = post['description']?.toString() ?? 'No description';
                      int likes = post['likes'] is int ? post['likes'] as int : 0;
                      String username = post['username']?.toString() ?? 'Anonymous';

                      // Shorten the description for display
                      String shortDescription = description.length > 50 ? description.substring(0, 50) + '...' : description;

                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image of the post
                            images.isNotEmpty
                                ? _buildImageGrid(images)
                                : SizedBox(
                                    height: 200,
                                    child: Center(child: Text('No Image Available')),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                shortDescription,
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            // Edit and Delete Buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Display like count
                                  Text('Likes: $likes', style: TextStyle(color: Colors.grey[600])),
                                  Row(
                                    children: [
                                      // Edit Button
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          _showEditDialog(postId, description);
                                        },
                                      ),
                                      // Delete Button
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          // Confirm deletion
                                          bool? confirm = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Delete Post'),
                                              content: Text('Are you sure you want to delete this post?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm != null && confirm) {
                                            await _deletePost(postId);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  // Build grid for images (show all images)
  Widget _buildImageGrid(List<dynamic> imageUrls) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside GridView
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: imageUrls.length == 1 ? 1 : 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: imageUrls[index],
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      },
    );
  }

  // Dialog for editing post
  void _showEditDialog(String postId, String currentDescription) {
    TextEditingController _descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Post'),
          content: SingleChildScrollView( // To prevent overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Description Input
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Update description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                // Image Picker for updating image
                Row(
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: Colors.grey[600]),
                          ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Update Image'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newDescription = _descriptionController.text.trim();
                if (newDescription.isEmpty && _selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide a description or select an image to update.')),
                  );
                  return;
                }
                await _updatePost(postId, newDescription);
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}