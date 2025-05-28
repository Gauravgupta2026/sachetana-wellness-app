


//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class PostsPage extends StatefulWidget {
//   const PostsPage({Key? key}) : super(key: key);
//
//   @override
//   _PostsPageState createState() => _PostsPageState();
// }
//
// class _PostsPageState extends State<PostsPage> {
//   final TextEditingController _postController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _selectedTag = '';
//   bool _isLoading = false;
//   final List<String> predefinedTags = [
//     'anxiety',
//     'depression',
//     'suicide',
//     'stress',
//     'disorder',
//     'hurt'
//   ];
//
//
//   // Add this map to define related words for each tag
//   final Map<String, List<String>> tagWords = {
//     'anxiety': [
//       'anxiety',
//       "anxious",
//       "worry",
//       "worried",
//       "fear",
//       "fearful",
//       "panic",
//       "panic attack",
//       "nervous",
//       "uneasy",
//       "on edge",
//       "overthinking",
//       "racing thoughts",
//       "tense",
//       "restless",
//       "dread",
//       "overwhelmed",
//       "apprehensive",
//       "jittery",
//       "nauseous",
//       "sweaty palms",
//       "tight chest",
//       "butterflies",
//       "hyperventilate",
//       "trembling",
//       "shaking",
//       "paranoid",
//       "catastrophizing"
//     ],
//     'depression': [
//       'depression',
//       'depressed',
//       'sad',
//       'hopeless',
//       'melancholy',
//       "sad",
//       "hopeless",
//       "empty",
//       "worthless",
//       "unmotivated",
//       "tired",
//       "fatigue",
//       "exhausted",
//       "guilty",
//       "guilt",
//       "helpless",
//       "numb",
//       "lost",
//       "unhappy",
//       "isolated",
//       "alone",
//       "disconnected",
//       "apathetic",
//       "tearful",
//       "crying",
//       "heavy",
//       "drained",
//       "useless",
//       "despair",
//       "suffering",
//       "broken",
//       "pain",
//       "melancholy",
//       "low",
//       "failure",
//       "negative",
//       "pessimistic",
//       "withdrawn",
//       "slow",
//       "miserable",
//       "blue",
//       "down",
//       "disheartened",
//       "dark",
//       "bleak"
//     ],
//     'suicide': [
//       'suicide',
//       'suicidal',
//       'self-harm',
//       "end it all",
//       "kill myself",
//       "take my life",
//       "want to die",
//       "no reason to live",
//       "not worth living",
//       "better off dead",
//       "die",
//       "worthless",
//       "hopeless",
//       "no way out",
//       "give up",
//       "can't go on",
//       "self-harm",
//       "cut myself",
//       "jump off",
//       "overdose",
//       "hang myself",
//       "drown myself",
//       "slit my wrists",
//       "final goodbye",
//       "last breath",
//       "nothing left",
//       "end the pain",
//       "sleep forever",
//       "never wake up",
//       "goodbye forever"
//     ],
//     'stress': ['stress', 'stressed', 'overwhelmed', 'pressure', 'burnout'],
//     'hurt': ['hurt', 'pain', 'suffering', 'wounded', 'injured'],
//     'disorder': [
//       'disorder',
//       'illness',
//       'condition',
//       'syndrome',
//       'mental health'
//     ],
//   };
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/greenhome.jpg'),
//                 fit: BoxFit.cover,
//
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, // Align Safe Space to the left
//               children: [
//                 // Safe Space Header
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Posts',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'DMSans',
//                       fontSize: 40,
//
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 60), // Space between header and categories
//
//                 // Horizontal Scrollable Category List
//                 Container(
//                   height: 50,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: predefinedTags.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: ChoiceChip(
//                           label: Text(
//                             predefinedTags[index],
//                             style: TextStyle(
//                               fontFamily: 'DMSans',
//                               color: Colors.black, // White text
//                             ),
//                           ),
//                           selected: _selectedTag == predefinedTags[index],
//                           selectedColor: Colors.transparent, // No background color
//                           onSelected: (bool selected) {
//                             setState(() {
//                               _isLoading = true;
//                               _selectedTag = selected ? predefinedTags[index] : '';
//                             });
//                             // Simulate a delay to show loading state
//                             Future.delayed(Duration(milliseconds: 500), () {
//                               setState(() {
//                                 _isLoading = false;
//                               });
//                             });
//                           },
//                           backgroundColor: Colors.transparent, // Make the background transparent
//                           shape: _selectedTag == predefinedTags[index]
//                               ? RoundedRectangleBorder(
//                             side: BorderSide.none,
//                             borderRadius: BorderRadius.circular(10),
//                           )
//                               : null,
//                           shadowColor: Colors.white.withOpacity(0.9), // Add drop shadow
//                           elevation: _selectedTag == predefinedTags[index] ? 4 : 0,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 8), // SizedBox as requested
//
//               ],
//             ),
//           ),
//
//           // Fixed Bottom Sheet
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.7, // Increased height to 0.7
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(1.0), // Transparent white background
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: Column(
//                 children: [
//                   // Post List
//                   Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: _getPostsStream(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasError) {
//                           return _buildErrorWidget(snapshot.error);
//                         }
//                         if (!snapshot.hasData) {
//                           return Center(child: CircularProgressIndicator());
//                         }
//
//                         var posts = snapshot.data!.docs;
//
//                         if (posts.isEmpty) {
//                           return Center(child: Text('No posts found for this tag.'));
//                         }
//
//                         return ListView.builder(
//                           itemCount: posts.length,
//                           itemBuilder: (context, index) {
//                             return _buildPostCard(posts[index]);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//
//                   // Input Field and Send Button in Bottom Sheet
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0), // Increased padding for better alignment
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _postController,
//                             decoration: InputDecoration(
//                               hintText: 'Type a message...',
//                               filled: true,
//                               fillColor: Colors.grey[300],
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide.none,
//                               ),
//                               hintStyle: TextStyle(fontFamily: 'DMSans'),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.blueAccent,
//                           ),
//                           child: IconButton(
//                             icon: Icon(Icons.send, color: Colors.white),
//                             onPressed: _submitPost,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Stream<QuerySnapshot> _getPostsStream() {
//     Query query = _firestore.collection('posts');
//
//     if (_selectedTag.isNotEmpty) {
//       query = query.where('tags', arrayContains: _selectedTag);
//     }
//
//     return query
//         .orderBy('timestamp', descending: true)
//         .orderBy(FieldPath.documentId, descending: true)
//         .snapshots();
//   }
//
//   Widget _buildPostCard(DocumentSnapshot post) {
//     Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: Padding(
//         padding: EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.grey[300],
//                   child: Text((postData['username'] as String? ?? 'U')[0]
//                       .toUpperCase()),
//                 ),
//                 SizedBox(width: 8),
//                 Text('@${postData['username'] ?? 'Unknown User'}',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, fontFamily: 'DMSans')),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(postData['content'] ?? 'No content',
//                 style: TextStyle(fontFamily: 'DMSans')),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 4,
//               children: (postData['tags'] as List<dynamic>? ?? []).map((tag) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       _selectedTag = tag;
//                     });
//                   },
//                   child: Chip(
//                     label: Text('#$tag'),
//                     backgroundColor: Colors.blue[100],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _submitPost() async {
//     if (_postController.text.isEmpty) return;
//
//     User? user = _auth.currentUser;
//     if (user != null) {
//       String content = _postController.text.toLowerCase();
//
//       List<String> tags =
//       predefinedTags.where((tag) => content.contains(tag)).toList();
//
//       tags.addAll(content
//           .split(' ')
//           .where((word) => word.startsWith('#'))
//           .map((tag) => tag.substring(1).toLowerCase()));
//
//       tags = tags.toSet().toList();
//
//       await _firestore.collection('posts').add({
//         'username':
//         user.displayName ?? user.email?.split('@')[0] ?? 'Anonymous',
//         'content': _postController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//         'likes': 0,
//         'likedBy': [],
//         'tags': tags,
//       });
//       _postController.clear();
//     }
//   }
//
//   Widget _buildErrorWidget(Object? error) {
//     return Center(
//       child: Text('Error: $error', style: TextStyle(color: Colors.red)),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final TextEditingController _postController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedTag = '';
  bool _isLoading = false;

  final List<String> predefinedTags = [
    'anxiety',
    'depression',
    'suicide',
    'stress',
    'hurt',
    'disorder',
  ];

  // Add this map to define related words for each tag
  final Map<String, List<String>> tagWords = {
    'anxiety': [
      'anxiety',
      "anxious",
      "worry",
      "worried",
      "fear",
      "fearful",
      "panic",
      "panic attack",
      "nervous",
      "uneasy",
      "on edge",
      "overthinking",
      "racing thoughts",
      "tense",
      "restless",
      "dread",
      "overwhelmed",
      "apprehensive",
      "jittery",
      "nauseous",
      "sweaty palms",
      "tight chest",
      "butterflies",
      "hyperventilate",
      "trembling",
      "shaking",
      "paranoid",
      "catastrophizing"
    ],
    'depression': [
      'depression',
      'depressed',
      'sad',
      'hopeless',
      'melancholy',
      "sad",
      "hopeless",
      "empty",
      "worthless",
      "unmotivated",
      "tired",
      "fatigue",
      "exhausted",
      "guilty",
      "guilt",
      "helpless",
      "numb",
      "lost",
      "unhappy",
      "isolated",
      "alone",
      "disconnected",
      "apathetic",
      "tearful",
      "crying",
      "heavy",
      "drained",
      "useless",
      "despair",
      "suffering",
      "broken",
      "pain",
      "melancholy",
      "low",
      "failure",
      "negative",
      "pessimistic",
      "withdrawn",
      "slow",
      "miserable",
      "blue",
      "down",
      "disheartened",
      "dark",
      "bleak"
    ],
    'suicide': [
      'suicide',
      'suicidal',
      'self-harm',
      "end it all",
      "kill myself",
      "take my life",
      "want to die",
      "no reason to live",
      "not worth living",
      "better off dead",
      "die",
      "worthless",
      "hopeless",
      "no way out",
      "give up",
      "can't go on",
      "self-harm",
      "cut myself",
      "jump off",
      "overdose",
      "hang myself",
      "drown myself",
      "slit my wrists",
      "final goodbye",
      "last breath",
      "nothing left",
      "end the pain",
      "sleep forever",
      "never wake up",
      "goodbye forever"
    ],
    'stress': ['stress', 'stressed', 'overwhelmed', 'pressure', 'burnout'],
    'hurt': ['hurt', 'pain', 'suffering', 'wounded', 'injured'],
    'disorder': [
      'disorder',
      'illness',
      'condition',
      'syndrome',
      'mental health'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/greenhome.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildTagList(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: _buildPostList(),
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagList() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTagText('All', ''),
          ...predefinedTags.map((tag) => _buildTagText(tag, tag)),
        ],
      ),
    );
  }

  Widget _buildTagText(String label, String tag) {
    bool isSelected = _selectedTag == tag;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTag = isSelected ? '' : tag;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'DMSans',
            shadows: isSelected
                ? [
              Shadow(
                color: Colors.white.withOpacity(0.7),
                blurRadius: 10,
              ),
            ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _buildPostList() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      child: StreamBuilder<QuerySnapshot>(
        stream: _getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var posts = snapshot.data!.docs;

          if (posts.isEmpty) {
            return Center(child: Text('No posts found for this tag.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index].data() as Map<String, dynamic>;
              return _buildPostCard(post, posts[index].id);
            },
            padding: EdgeInsets.symmetric(vertical: 8),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, String postId) {
    String username = post['username'] ?? 'Anonymous';
    String content = post['content'] ?? '';
    List<dynamic> tags = post['tags'] ?? [];
    int likes = post['likes'] ?? 0;
    List<dynamic> likedBy = post['likedBy'] ?? [];
    String userId = _auth.currentUser?.uid ?? '';
    bool isLiked = likedBy.contains(userId);
    String? profilePictureBase64 = post['profilePictureBase64'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 16,
                        child: profilePictureBase64 != null
                            ? ClipOval(
                          child: Image.memory(
                            base64Decode(profilePictureBase64),
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Text(
                          username[0].toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'DMSans', fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@$username',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              content,
                              style:
                              TextStyle(fontFamily: 'DMSans', fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: tags.map((tag) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTag = tag.toString();
                          });
                        },
                        child: Chip(
                          label: Text(
                            '#$tag',
                            style:
                            TextStyle(fontFamily: 'DMSans', fontSize: 12),
                          ),
                          backgroundColor: Colors.blue[50],
                          padding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                          size: 20,
                        ),
                        onPressed: () => _toggleLike(postId, isLiked),
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(width: 4),
                      Text('$likes',
                          style: TextStyle(fontFamily: 'DMSans', fontSize: 14)),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          size: 20,
                        ),
                        onPressed: () => _showCommentDialog(postId),
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildCommentSection(postId),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection(String postId) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .limit(2)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error loading comments');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var comments = snapshot.data?.docs ?? [];

        if (comments.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Text('No comments yet'),
          );
        }

        return Column(
          children: [
            ...comments.map((comment) {
              var commentData = comment.data() as Map<String, dynamic>;
              return _buildCommentItem(commentData);
            }).toList(),
            if (comments.length == 2)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () => _showAllComments(postId),
                  child: Text(
                    'View all comments',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'DMSans',
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    String username = comment['username'] ?? 'Anonymous';
    String content = comment['content'] ?? '';
    String? profilePictureBase64 = comment['profilePictureBase64'];

    print('Building comment item: $username - $content'); // Debug log

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 12,
            child: profilePictureBase64 != null
                ? ClipOval(
              child: Image.memory(
                base64Decode(profilePictureBase64),
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            )
                : Text(
              username[0].toUpperCase(),
              style: TextStyle(fontFamily: 'DMSans', fontSize: 10),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@$username',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  content,
                  style: TextStyle(fontFamily: 'DMSans', fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _postController,
                decoration: InputDecoration(
                  hintText: 'Share your thoughts...',
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  hintStyle:
                  TextStyle(fontFamily: 'DMSans', color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _submitPost,
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getPostsStream() {
    if (_selectedTag.isNotEmpty) {
      return _firestore
          .collection('posts')
          .where('tags', arrayContains: _selectedTag)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Text('Error: ${error.toString()}'),
    );
  }

  void _submitPost() async {
    if (_postController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
        await _firestore.collection('users').doc(user.uid).get();
        String username = userData['name'] ?? 'Anonymous';
        String? profilePictureBase64 = userData['profilePictureBase64'];

        String content = _postController.text.toLowerCase();
        List<String> words = content.split(RegExp(r'\s+'));

        // Find hashtags in the content
        List<String> hashTags = words
            .where((word) => word.startsWith('#'))
            .map((tag) => tag.substring(1))
            .toList();

        // Find predefined tags based on related words
        List<String> contentTags = [];
        tagWords.forEach((tag, relatedWords) {
          if (words.any((word) => relatedWords.contains(word))) {
            contentTags.add(tag);
          }
        });

        // Combine hashtags and content tags, remove duplicates
        List<String> tags = [...hashTags, ...contentTags].toSet().toList();

        await _firestore.collection('posts').add({
          'content': _postController.text,
          'username': username,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'likes': 0,
          'likedBy': [],
          'tags': tags,
          'profilePictureBase64': profilePictureBase64,
        });

        _postController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleLike(String postId, bool isLiked) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final postRef = _firestore.collection('posts').doc(postId);

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) {
          throw Exception('Post does not exist!');
        }

        final currentLikes = snapshot.data()?['likes'] ?? 0;
        final likedBy = List<String>.from(snapshot.data()?['likedBy'] ?? []);

        if (isLiked) {
          transaction.update(postRef, {
            'likes': currentLikes - 1,
            'likedBy': FieldValue.arrayRemove([userId]),
          });
        } else {
          transaction.update(postRef, {
            'likes': currentLikes + 1,
            'likedBy': FieldValue.arrayUnion([userId]),
          });
        }
      });
    } catch (e) {
      print('Error toggling like: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update like. Please try again.')),
      );
    }
  }

  void _showCommentDialog(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController commentController = TextEditingController();
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add a comment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment',
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        _submitComment(postId, commentController.text);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitComment(String postId, String commentText) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
        await _firestore.collection('users').doc(user.uid).get();
        String username = userData['name'] ?? 'Anonymous';
        String? profilePictureBase64 = userData['profilePictureBase64'];

        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .add({
          'content': commentText,
          'username': username,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'profilePictureBase64': profilePictureBase64,
        });

        print('Comment added successfully: $commentText'); // Debug log

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment added successfully')),
        );
      }
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment. Please try again.')),
      );
    }
  }

  void _showAllComments(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                SizedBox(height: 20), // Add top padding
                StreamBuilder<DocumentSnapshot>(
                  stream:
                  _firestore.collection('posts').doc(postId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return SizedBox.shrink();
                    }
                    var post = snapshot.data!.data() as Map<String, dynamic>;
                    return _buildPostCardWithoutComments(post, postId);
                  },
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading comments'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var comments = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        controller: controller,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          var commentData =
                          comments[index].data() as Map<String, dynamic>;
                          return _buildCommentItem(commentData);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInput(String postId, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _submitComment(postId, controller.text);
                controller.clear();
                Navigator.pop(
                    context); // Close the bottom sheet after submitting
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostCardWithoutComments(
      Map<String, dynamic> post, String postId) {
    // This is a simplified version of _buildPostCard without the comment section
    String username = post['username'] ?? 'Anonymous';
    String content = post['content'] ?? '';
    List<dynamic> tags = post['tags'] ?? [];
    int likes = post['likes'] ?? 0;
    List<dynamic> likedBy = post['likedBy'] ?? [];
    String userId = _auth.currentUser?.uid ?? '';
    bool isLiked = likedBy.contains(userId);
    String? profilePictureBase64 = post['profilePictureBase64'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 16,
                    child: profilePictureBase64 != null
                        ? ClipOval(
                      child: Image.memory(
                        base64Decode(profilePictureBase64),
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Text(
                      username[0].toUpperCase(),
                      style:
                      TextStyle(fontFamily: 'DMSans', fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@$username',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          content,
                          style: TextStyle(fontFamily: 'DMSans', fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 0,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(
                      '#$tag',
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 12),
                    ),
                    backgroundColor: Colors.blue[50],
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                      size: 20,
                    ),
                    onPressed: () => _toggleLike(postId, isLiked),
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: 4),
                  Text('$likes',
                      style: TextStyle(fontFamily: 'DMSans', fontSize: 14)),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      Icons.comment_outlined,
                      size: 20,
                    ),
                    onPressed: () => _showCommentDialog(postId),
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Make sure you have the _submitComment method as shown in the previous response
}
