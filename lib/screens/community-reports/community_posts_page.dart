import 'package:agro_mart/screens/community-reports/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'upload_post_page.dart';
import 'edit_post.dart';

class CommunityPostsPage extends StatefulWidget {
  @override
  _CommunityPostsPageState createState() => _CommunityPostsPageState();
}

class _CommunityPostsPageState extends State<CommunityPostsPage> {
  String searchQuery = "";
  bool _showSearchBar = true;
 
  Map<String, bool> _expandedPosts = {}; // Track expanded posts
  ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _posts = []; // Store posts locally
  bool _isLoading = true; // Add loading state for the initial fetch
  Set<String> likedPosts = Set(); // To store locally liked posts (without authentication)
  Map<String, dynamic>? postData; // Define this at the state level
  Map<String, int> _postLikeCounts = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showSearchBar) {
          setState(() {
            _showSearchBar = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_showSearchBar) {
          setState(() {
            _showSearchBar = true;
          });
        }
      }
    });

    _fetchPosts(); // Fetch posts when the widget is initialized
  }
  

  Future<void> _fetchPosts() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _posts = querySnapshot.docs;
        _isLoading = false; // Set loading to false when the data is fetched
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchPosts(); // Refresh posts
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleLike(DocumentSnapshot post) async {
    String postId = post.id;
    bool isLiked = likedPosts.contains(postId);

    // Get the current like count from Firestore
    int currentLikeCount = post['likes'] ?? 0;

    // Calculate the new like count (increment or decrement by 1)
    int newLikeCount = isLiked ? currentLikeCount  : currentLikeCount + 1;

    // Update the Firestore
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': newLikeCount,
      });

      // Update local state after Firestore update
      setState(() {
        if (isLiked) {
          likedPosts.remove(postId); // Remove the like locally
        } else {
          likedPosts.add(postId); // Add the like locally
        }

        // Update the like count for this post
        _postLikeCounts[postId] = newLikeCount;
      });
    } catch (e) {
      print('Error updating like count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community Posts',
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
            backgroundImage: NetworkImage('https://images.pexels.com/photos/2379003/pexels-photo-2379003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _showSearchBar
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                )
              : SizedBox.shrink(), // Hide search bar when scrolling
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshPosts, // Pull-to-refresh
                    child: _buildPostList(),
                  ),
          ),
        ],
      ),


// Floating Action Buttons
floatingActionButton: Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    // Messages Button (aligned to bottom right)
    if (_showSearchBar) // Only show this button if _showSearchBar is true
      Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 10.0), // Adjust the spacing
        child: Align(
          alignment: Alignment.bottomRight, // Align to bottom right corner
          child: FloatingActionButton(
            onPressed: () {
              // Navigate to your Messages page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommunityChatPage()), // Your MessagesPage
              );
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.message, color: Colors.white), // White icon
          ),
        ),
      ),
    // Add Post Button (centered)
    if (_showSearchBar) // Only show this button if _showSearchBar is true
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0), // Adjust this value for desired space
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadPostPage()), // Your UploadPostPage
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white), // White icon
        ),
      ),
  ],
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,




      
    );
    


    
    
  }

  Widget _buildPostList() {
    List<DocumentSnapshot> filteredPosts = _posts.where((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return data['user'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          data['description'].toString().toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        var post = filteredPosts[index].data() as Map<String, dynamic>;
        List<dynamic> imageUrls = post['images'] ?? [];
        bool isExpanded = _expandedPosts[filteredPosts[index].id] ?? false;
        String postId = filteredPosts[index].id;
        String _userProfileImage = post['userProfileImage'] ?? 'https://via.placeholder.com/150';
        int likeCount = _postLikeCounts[postId] ?? post['likes'] ?? 0;

        // Show short description if not expanded
        String shortDescription = post['description'] ?? '';
        if (!isExpanded && shortDescription.length > 107) {
          shortDescription = shortDescription.substring(0, 107) + '...';
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _expandedPosts[filteredPosts[index].id] = !isExpanded;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_userProfileImage),
                      radius: 20.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      post['username'] ?? 'Unknowkjjjjn user',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
             Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  child: RichText(
    text: TextSpan(
      text: shortDescription,
      style: GoogleFonts.poppins(
        fontSize: 12.0,
        color: Colors.black,
      ),
      // Show "Read More" only when the post is not expanded and the full description is longer than 100 characters
      children: !isExpanded && post['description'].length > 100
          ? [
              TextSpan(
                text: ' Read More',
                style: TextStyle(color: Colors.green),
              ),
            ]
          : [],
    ),
  ),
),
              Stack(
                children: [
                  Column(
                    children: [
                      if (isExpanded)
                        Column(
                          children: imageUrls.map<Widget>((image) {
                            return CachedNetworkImage(
                              imageUrl: image,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            );
                          }).toList(),
                        )
                      else
                        _buildImageGrid(imageUrls),
                    ],
                  ),
                  Positioned(
  bottom: 8.0,
  left: 8.0,
  child: Row(
    children: [
      IconButton(
        icon: Icon(
          likedPosts.contains(filteredPosts[index].id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: likedPosts.contains(filteredPosts[index].id)
              ? Colors.red
              : Colors.grey,
        ),
        onPressed: () {
          _toggleLike(filteredPosts[index]);
        },
      ),
     Text(
                          '$likeCount', // Display the correct like count
                          style: TextStyle(color: Colors.white),
                        ),
    ],
  ),
),
                  
                ],
              ),
              // Divider(thickness: 1),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGrid(List<dynamic> imageUrls) {
    if (imageUrls.length == 1) {
      // If there is only one image, show it full size
      return CachedNetworkImage(
        imageUrl: imageUrls[0],
        width: double.infinity, // Full width of the screen
        height: MediaQuery.of(context).size.width, // Height equal to width (square)
        fit: BoxFit.cover, // Ensures the image covers the full space
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      // For multiple images, show them in a grid
      int displayedImageCount = imageUrls.length > 4 ? 4 : imageUrls.length;
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: displayedImageCount,
        itemBuilder: (context, index) {
          if (index == 3 && imageUrls.length > 4) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      '+${imageUrls.length - 4}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            );
          }
          return CachedNetworkImage(  imageUrl: imageUrls[index],
        fit: BoxFit.cover,
      );
    },
  );
}}}