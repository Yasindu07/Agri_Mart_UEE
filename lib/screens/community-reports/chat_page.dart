// community_chat_page.dart

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For uploading images
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

class CommunityChatPage extends StatefulWidget {
  @override
  _CommunityChatPageState createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  String _username = 'Anonymous';
  String _userProfileImage =
      'https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  String _userId = '';
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _selectedImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the chat screen is initialized.
  }

  /// Fetches current user details from FirebaseAuth and Firestore
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
            _userProfileImage = userDoc.get('profilePicture') ??
                'https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
          });
        } else {
          _showMessage('User data not found.');
        }
      } else {
        _showMessage('No user is currently signed in.');
      }
    } catch (e) {
      _showMessage('Error fetching user details: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Sends a message to Firestore
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _selectedImageUrl.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('community_chat').add({
        'message': _messageController.text.trim(),
        'imageUrl': _selectedImageUrl,
        'senderId': _userId,
        'senderName': _username,
        'senderProfileImage': _userProfileImage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _messageController.clear();
        _selectedImageUrl = '';
      });

      _scrollToBottom();
    } catch (e) {
      _showMessage('Error sending message: $e');
    }
  }

  /// Picks an image from the gallery and uploads it to Firebase Storage
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        // Upload image to Firebase Storage
        String fileName = 'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = firebaseStorageRef.putFile(File(pickedFile.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _selectedImageUrl = downloadUrl;
        });

        // Optionally, you can send the message immediately after selecting the image
        // await _sendMessage();
      }
    } catch (e) {
      _showMessage('Error picking image: $e');
    }
  }

  /// Scrolls the chat to the bottom
  void _scrollToBottom() {
    // Delay to ensure that the new message has been rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  /// Builds each chat message bubble
  Widget _buildMessageItem(Map<String, dynamic> data) {
    bool isCurrentUser = data['senderId'] == _userId;

    // Format timestamp
    String time = '';
    if (data['timestamp'] != null) {
      DateTime dateTime = (data['timestamp'] as Timestamp).toDate();
      time = DateFormat('hh:mm a').format(dateTime);
    }

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.green[300] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(isCurrentUser ? 15 : 0),
            bottomRight: Radius.circular(isCurrentUser ? 0 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender's Name and Profile Picture
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isCurrentUser)
                  CircleAvatar(
                    backgroundImage: NetworkImage(data['senderProfileImage']),
                    radius: 12,
                  ),
                if (!isCurrentUser) SizedBox(width: 5),
                Text(
                  data['senderName'] ?? 'Anonymous',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            // Message Text
            if (data['message'] != null && data['message'].toString().trim().isNotEmpty)
              Text(
                data['message'],
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            // Image Message
            if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty)
              SizedBox(
                height: 150,
                width: 150,
                child: CachedNetworkImage(
                  imageUrl: data['imageUrl'],
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            // Timestamp
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isCurrentUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of messages
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('community_chat')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var messages = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          controller: _scrollController,
          reverse: true, // To display the latest message at the bottom
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  /// Builds the message input field
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey[300]!, blurRadius: 2, offset: Offset(0, -1)),
        ],
      ),
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.green),
            onPressed: _pickImage,
          ),
          // Expanded Text Field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
                maxLines: null, // Allows multi-line input
              ),
            ),
          ),
          // Send Button
          IconButton(
            icon: Icon(Icons.send, color: Colors.green),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // WhatsApp uses white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_userProfileImage),
              radius: 18,
            ),
            SizedBox(width: 10),
            Text(
              'Community Chat',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              // Implement additional options if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }
}