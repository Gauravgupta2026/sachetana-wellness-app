// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SafeSpacePage extends StatefulWidget {
//   const SafeSpacePage({super.key});
//
//   @override
//   _SafeSpacePageState createState() => _SafeSpacePageState();
// }
//
// class _SafeSpacePageState extends State<SafeSpacePage> {
//   final TextEditingController _postController = TextEditingController();
//   final TextEditingController _commentController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _selectedTag = '';
//   final bool _isLoading = false;
//
//   // Add this list of predefined tags at the class level
//   final List<String> predefinedTags = [
//     'anxiety',
//     'depression',
//     'suicide',
//     'stress',
//     'disorder',
//     'hurt'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/greenhome.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               _buildTagList(),
//               Expanded(
//                 child: _buildPostList(),
//               ),
//               _buildPostInput(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildTagList() {
//     return SizedBox(
//       height: 50,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: predefinedTags.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ChoiceChip(
//               label: Text(predefinedTags[index]),
//               selected: _selectedTag == predefinedTags[index],
//               selectedColor: Colors.blue,
//               onSelected: (bool selected) {
//                 setState(() {
//                   _selectedTag = selected ? predefinedTags[index] : '';
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildPostList() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: StreamBuilder<QuerySnapshot>(
//         stream: _getPostsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return _buildErrorWidget(snapshot.error);
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           var posts = snapshot.data!.docs;
//
//           if (posts.isEmpty) {
//             return const Center(child: Text('No posts found for this tag.'));
//           }
//
//           return ListView.builder(
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               return _buildPostCard(posts[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//
//
//
//
//   Stream<QuerySnapshot> _getPostsStream() {
//     Query query = _firestore.collection('safe_space_posts');
//
//     if (_selectedTag.isNotEmpty) {
//       query = query.where('tags', arrayContains: _selectedTag);
//     }
//
//     return query.orderBy('timestamp', descending: true).snapshots();
//   }
//
//   Widget _buildErrorWidget(dynamic error) {
//     if (error is FirebaseException && error.code == 'failed-precondition') {
//       // This error likely means that the required index doesn't exist
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const Text(
//                 'An index is required for this query. Please check the Firebase console.',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 child: const Text('Clear Tag Filter'),
//                 onPressed: () {
//                   setState(() {
//                     _selectedTag = '';
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       // For other types of errors, display a generic error message
//       return Center(child: Text('Error: ${error.toString()}'));
//     }
//   }
//
//   Widget _buildPostCard(DocumentSnapshot post) {
//     Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
//     String username = postData['username'] as String? ?? 'Anonymous';
//     String content = postData['content'] as String? ?? '';
//     List<dynamic> tags = postData['tags'] as List<dynamic>? ?? [];
//     List<dynamic> likedBy = postData['likedBy'] as List<dynamic>? ?? [];
//     int likes = postData['likes'] as int? ?? 0;
//
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.grey[300],
//                   child: Text(username == 'Anonymous'
//                       ? 'A'
//                       : username[0].toUpperCase()),
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   username == 'Anonymous' ? 'Anonymous' : '@$username',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(content),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 4,
//               children: tags.map((tag) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       _selectedTag = tag.toString();
//                     });
//                   },
//                   child: Chip(
//                     label: Text('#$tag'),
//                     backgroundColor: Colors.blue[100],
//                   ),
//                 );
//               }).toList(),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   child: Text('Comment'),
//                   onPressed: () => _showCommentDialog(post.id),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.favorite,
//                         color: likedBy.contains(_auth.currentUser?.uid)
//                             ? Colors.red
//                             : null,
//                       ),
//                       onPressed: () => _likePost(post.id),
//                     ),
//                     Text('$likes'),
//                   ],
//                 ),
//               ],
//             ),
//             _buildCommentsList(post.id),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCommentsList(String postId) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('safe_space_posts')
//           .doc(postId)
//           .collection('comments')
//           .orderBy('timestamp', descending: false)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return SizedBox.shrink();
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: snapshot.data!.docs.map((comment) {
//             Map<String, dynamic> commentData =
//                 comment.data() as Map<String, dynamic>;
//             bool isAnonymous = commentData['isAnonymous'] as bool? ?? true;
//             String username = commentData['username'] as String? ?? 'Anonymous';
//             String content = commentData['content'] as String? ?? '';
//             return Padding(
//               padding: const EdgeInsets.only(left: 16, top: 8),
//               child: Text('${isAnonymous ? 'Anonymous' : username}: $content'),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
//
//   Widget _buildPostInput() {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _postController,
//               decoration: const InputDecoration(
//                 hintText: 'Share your thoughts...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _showPostConfirmationDialog,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _submitPost(bool isAnonymous) async {
//     if (_postController.text.isEmpty) return;
//
//     User? user = _auth.currentUser;
//     if (user != null) {
//       String content = _postController.text.toLowerCase();
//
//       // Check for predefined tags in the content
//       List<String> tags =
//           predefinedTags.where((tag) => content.contains(tag)).toList();
//
//       // Also include any hashtags used in the post
//       tags.addAll(content
//           .split(' ')
//           .where((word) => word.startsWith('#'))
//           .map((tag) => tag.substring(1).toLowerCase()));
//
//       // Remove duplicates
//       tags = tags.toSet().toList();
//
//       await _firestore.collection('safe_space_posts').add({
//         'userId': user.uid,
//         'username': isAnonymous
//             ? 'Anonymous'
//             : (user.displayName ?? user.email ?? 'User'),
//         'content': _postController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//         'likes': 0,
//         'likedBy': [],
//         'tags': tags,
//         'isAnonymous': isAnonymous,
//       });
//       _postController.clear();
//     }
//   }
//
//   void _likePost(String postId) async {
//     User? user = _auth.currentUser;
//     if (user == null) return;
//
//     DocumentReference postRef =
//         _firestore.collection('safe_space_posts').doc(postId);
//
//     await _firestore.runTransaction((transaction) async {
//       DocumentSnapshot postDoc = await transaction.get(postRef);
//
//       if (!postDoc.exists) {
//         print('Post does not exist');
//         return;
//       }
//
//       Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
//       List<dynamic> likedBy = postData['likedBy'] as List<dynamic>? ?? [];
//       int likes = postData['likes'] as int? ?? 0;
//
//       if (likedBy.contains(user.uid)) {
//         likedBy.remove(user.uid);
//         likes--;
//       } else {
//         likedBy.add(user.uid);
//         likes++;
//       }
//
//       transaction.update(postRef, {
//         'likes': likes,
//         'likedBy': likedBy,
//       });
//     });
//   }
//
//   void _showCommentDialog(String postId) {
//     bool _isAnonymousComment = false;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Add a comment'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _commentController,
//                     decoration: const InputDecoration(hintText: 'Your comment'),
//                   ),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: _isAnonymousComment,
//                         onChanged: (value) {
//                           setState(() {
//                             _isAnonymousComment = value!;
//                           });
//                         },
//                       ),
//                       const Text('Comment anonymously'),
//                     ],
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: const Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _commentController.clear();
//                   },
//                 ),
//                 TextButton(
//                   child: const Text('Submit'),
//                   onPressed: () {
//                     _submitComment(postId, _isAnonymousComment);
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _submitComment(String postId, bool isAnonymous) async {
//     if (_commentController.text.isEmpty) return;
//
//     User? user = _auth.currentUser;
//     if (user == null) return;
//
//     await _firestore
//         .collection('safe_space_posts')
//         .doc(postId)
//         .collection('comments')
//         .add({
//       'content': _commentController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isAnonymous': isAnonymous,
//       'username': isAnonymous ? 'Anonymous' : user.displayName ?? user.email,
//       'userId': user.uid,
//     });
//     _commentController.clear();
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           const Text(
//             'Safe Space',
//             style: TextStyle(
//               fontFamily: 'DMSans',
//               color: Colors.white,
//               fontSize: 24,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPostConfirmationDialog() {
//     bool isAnonymous = false;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Create Post'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Do you want to post anonymously?'),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: isAnonymous,
//                         onChanged: (value) {
//                           setState(() {
//                             isAnonymous = value!;
//                           });
//                         },
//                       ),
//                       const Text('Post anonymously'),
//                     ],
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: const Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: const Text('Post'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _submitPost(isAnonymous);
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }













//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SafeSpacePage extends StatefulWidget {
//   const SafeSpacePage({super.key});
//
//   @override
//   _SafeSpacePageState createState() => _SafeSpacePageState();
// }
//
// class _SafeSpacePageState extends State<SafeSpacePage> {
//   final TextEditingController _postController = TextEditingController();
//   final TextEditingController _commentController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _selectedTag = '';
//   bool _isLoading = false;
//
//
//   // List of predefined tags
//   final List<String> predefinedTags = [
//     'anxiety',
//     'depression',
//     'suicide',
//     'stress',
//     'disorder',
//     'hurt',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/greenhome.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//        SafeArea(
//           child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 // Align Safe Space to the left
//                 children: [
//                   // Safe Space Header
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Safe Space',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'DMSans',
//                         fontSize: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 60),
//                   Container(
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
//                             style: const TextStyle(
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
//                   ),
//                   const SizedBox(height: 8),
//                   // Horizontal Scrollable Category List
//                 ],
//               ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.7, // Increased height to 0.7
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(1.0), // Transparent white background
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//                   ),
//                   child: Column(
//                     children: [
//                       // Post List
//                       Expanded(
//                         child: StreamBuilder<QuerySnapshot>(
//                           stream: _getPostsStream(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return _buildErrorWidget(snapshot.error);
//                             }
//                             if (!snapshot.hasData) {
//                               return Center(child: CircularProgressIndicator());
//                             }
//
//                             var posts = snapshot.data!.docs;
//
//                             if (posts.isEmpty) {
//                               return Center(child: Text('No posts found for this tag.'));
//                             }
//
//                             return ListView.builder(
//                               itemCount: posts.length,
//                               itemBuilder: (context, index) {
//                                 return _buildPostCard(posts[index]);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//
//                       // Input Field and Send Button in Bottom Sheet
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0), // Increased padding for better alignment
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: _postController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Type a message...',
//                                   filled: true,
//                                   fillColor: Colors.grey[300],
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   hintStyle: TextStyle(fontFamily: 'DMSans'),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.blueAccent,
//                               ),
//                               child: IconButton(
//                                 icon: Icon(Icons.send, color: Colors.white),
//                                 onPressed:() {
//                                   _submitPost;
//                                 }
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//
//
//   Widget _buildBottomSheet() {
//     return Container(
//       height: MediaQuery
//           .of(context)
//           .size
//           .height * 0.7, // Set height to 70% of the screen
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(1.0),
//         // Set background color to solid white
//         borderRadius: BorderRadius.vertical(
//             top: Radius.circular(30)), // Rounded top corners
//       ),
//       child: Column(
//         children: [
//           // Post List
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _getPostsStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return _buildErrorWidget(snapshot.error);
//                 }
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 var posts = snapshot.data!.docs;
//
//                 if (posts.isEmpty) {
//                   return Center(child: Text('No posts found for this tag.'));
//                 }
//
//                 return ListView.builder(
//                   itemCount: posts.length,
//                   itemBuilder: (context, index) {
//                     return _buildPostCard(posts[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//
//           // Input Field and Send Button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
//             // Padding from code 1
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _postController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       filled: true,
//                       fillColor: Colors.grey[300],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                       hintStyle: TextStyle(fontFamily: 'DMSans'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.blueAccent,
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: () {
//                       _showPostConfirmationDialog();
//                     },
//
//                   ),
//                 ),
//               ],
//             ),
//
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTagList() {
//     return SizedBox(
//       height: 50,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: predefinedTags.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ChoiceChip(
//               label: Text(
//                 predefinedTags[index],
//                 style: TextStyle(
//                   fontFamily: 'DMSans',
//                   color: Colors.black, // Text color
//                 ),
//               ),
//               selected: _selectedTag == predefinedTags[index],
//               selectedColor: Colors.transparent,
//               // Transparent background for selected
//               backgroundColor: Colors.transparent,
//               // Transparent background for unselected
//               shadowColor: Colors.white.withOpacity(0.9),
//               // White shadow for selected
//               elevation: _selectedTag == predefinedTags[index] ? 3 : 0,
//               // Elevation for shadow effect
//               onSelected: (bool selected) {
//                 setState(() {
//                   _selectedTag = selected ? predefinedTags[index] : '';
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
//   Widget _buildPostList() {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: StreamBuilder<QuerySnapshot>(
//         stream: _getPostsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return _buildErrorWidget(snapshot.error);
//           }
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           var posts = snapshot.data!.docs;
//
//           if (posts.isEmpty) {
//             return Center(child: Text('No posts found for this tag.'));
//           }
//
//           return ListView.builder(
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               return _buildPostCard(posts[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Stream<QuerySnapshot> _getPostsStream() {
//     Query query = _firestore.collection('safe_space_posts');
//     if (_selectedTag.isNotEmpty) {
//       query = query.where('tags', arrayContains: _selectedTag);
//     }
//     return query.orderBy('timestamp', descending: true).snapshots();
//   }
//
//   Widget _buildErrorWidget(dynamic error) {
//     if (error is FirebaseException && error.code == 'failed-precondition') {
//       // This error likely means that the required index doesn't exist
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'An index is required for this query. Please check the Firebase console.',
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 child: Text('Clear Tag Filter'),
//                 onPressed: () {
//                   setState(() {
//                     _selectedTag = '';
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       // For other types of errors, display a generic error message
//       return Center(child: Text('Error: ${error.toString()}'));
//     }
//   }
//
//
//   Widget _buildHeader() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Safe Space',
//             style: TextStyle(
//                 fontSize: 30,
//
//                 color: Colors.white,
//                 fontFamily: 'DMSans'
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPostCard(DocumentSnapshot post) {
//     Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
//     String username = postData['username'] as String? ?? 'Anonymous';
//     String content = postData['content'] as String? ?? '';
//     List<dynamic> tags = postData['tags'] as List<dynamic>? ?? [];
//     List<dynamic> likedBy = postData['likedBy'] as List<dynamic>? ?? [];
//     int likes = postData['likes'] as int? ?? 0;
//
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
//                   child: Text(username == 'Anonymous'
//                       ? 'A'
//                       : username[0].toUpperCase()),
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   username == 'Anonymous' ? 'Anonymous' : '@$username',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(content),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 4,
//               children: tags.map((tag) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       _selectedTag = tag.toString();
//                     });
//                   },
//                   child: Chip(
//                     label: Text('#$tag'),
//                     backgroundColor: Colors.blue[100],
//                   ),
//                 );
//               }).toList(),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   child: Text('Comment'),
//                   onPressed: () => _showCommentDialog(post.id),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.favorite,
//                         color: likedBy.contains(_auth.currentUser?.uid)
//                             ? Colors.red
//                             : null,
//                       ),
//                       onPressed: () => _likePost(post.id),
//                     ),
//                     Text('$likes'),
//                   ],
//                 ),
//               ],
//             ),
//             _buildCommentsList(post.id),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildCommentsList(String postId) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('safe_space_posts')
//           .doc(postId)
//           .collection('comments')
//           .orderBy('timestamp', descending: false)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return SizedBox.shrink();
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: snapshot.data!.docs.map((comment) {
//             Map<String, dynamic> commentData =
//             comment.data() as Map<String, dynamic>;
//             bool isAnonymous = commentData['isAnonymous'] as bool? ?? true;
//             String username = commentData['username'] as String? ?? 'Anonymous';
//             String content = commentData['content'] as String? ?? '';
//             return Padding(
//               padding: EdgeInsets.only(left: 16, top: 8),
//               child: Text('${isAnonymous ? 'Anonymous' : username}: $content'),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
//
//   Widget _buildPostInput() {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _postController,
//               decoration: InputDecoration(
//                 hintText: 'Share your thoughts...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: _showPostConfirmationDialog,
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   void _submitPost(bool isAnonymous) async {
//     if (_postController.text.isEmpty) return;
//
//     User? user = _auth.currentUser;
//     if (user != null) {
//       String content = _postController.text.toLowerCase();
//
//       // Check for predefined tags in the content
//       List<String> tags =
//       predefinedTags.where((tag) => content.contains(tag)).toList();
//
//       // Also include any hashtags used in the post
//       tags.addAll(content
//           .split(' ')
//           .where((word) => word.startsWith('#'))
//           .map((tag) => tag.substring(1).toLowerCase()));
//
//       // Remove duplicates
//       tags = tags.toSet().toList();
//
//       await _firestore.collection('safe_space_posts').add({
//         'userId': user.uid,
//         'username': isAnonymous
//             ? 'Anonymous'
//             : (user.displayName ?? user.email ?? 'User'),
//         'content': _postController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//         'likes': 0,
//         'likedBy': [],
//         'tags': tags,
//         'isAnonymous': isAnonymous,
//       });
//       _postController.clear();
//     }
//   }
//
//
//
//   void _likePost(String postId) async {
//     User? user = _auth.currentUser;
//     if (user == null) return;
//
//     DocumentReference postRef =
//     _firestore.collection('safe_space_posts').doc(postId);
//
//     await _firestore.runTransaction((transaction) async {
//       DocumentSnapshot postDoc = await transaction.get(postRef);
//
//       if (!postDoc.exists) {
//         print('Post does not exist');
//         return;
//       }
//
//       Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
//       List<dynamic> likedBy = postData['likedBy'] as List<dynamic>? ?? [];
//       int likes = postData['likes'] as int? ?? 0;
//
//       if (likedBy.contains(user.uid)) {
//         likedBy.remove(user.uid);
//         likes--;
//       } else {
//         likedBy.add(user.uid);
//         likes++;
//       }
//
//       transaction.update(postRef, {
//         'likes': likes,
//         'likedBy': likedBy,
//       });
//     });
//   }
//
//   void _showCommentDialog(String postId) {
//     bool _isAnonymousComment = false;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Add a comment'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(hintText: 'Your comment'),
//                   ),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: _isAnonymousComment,
//                         onChanged: (value) {
//                           setState(() {
//                             _isAnonymousComment = value!;
//                           });
//                         },
//                       ),
//                       Text('Comment anonymously'),
//                     ],
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _commentController.clear();
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Submit'),
//                   onPressed: () {
//                     _submitComment(postId, _isAnonymousComment);
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _submitComment(String postId, bool isAnonymous) async {
//     if (_commentController.text.isEmpty) return;
//
//     User? user = _auth.currentUser;
//     if (user == null) return;
//
//     await _firestore
//         .collection('safe_space_posts')
//         .doc(postId)
//         .collection('comments')
//         .add({
//       'content': _commentController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isAnonymous': isAnonymous,
//       'username': isAnonymous ? 'Anonymous' : user.displayName ?? user.email,
//       'userId': user.uid,
//     });
//     _commentController.clear();
//   }
//
//
//   void _showPostConfirmationDialog() {
//     bool isAnonymous = false;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Create Post'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Do you want to post anonymously?'),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: isAnonymous,
//                         onChanged: (value) {
//                           setState(() {
//                             isAnonymous = value!;
//                           });
//                         },
//                       ),
//                       Text('Post anonymously'),
//                     ],
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Post'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _submitPost(isAnonymous);
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }





























import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class SafeSpacePage extends StatefulWidget {
  const SafeSpacePage({Key? key}) : super(key: key);

  @override
  _SafeSpacePageState createState() => _SafeSpacePageState();
}

class _SafeSpacePageState extends State<SafeSpacePage> {
  final TextEditingController _postController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedTag = '';
  bool _isLoading = false;
  bool _isAnonymous = false;

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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Safe Space',
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
                    decoration: const BoxDecoration(
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
      height: 30,
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
            fontSize: 14,
            fontFamily: 'DMSans',
            shadows: isSelected
                ? [
              Shadow(
                color: Colors.white.withOpacity(0.7),
                blurRadius: 13,
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
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
            padding: const EdgeInsets.symmetric(vertical: 8),
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
          .collection('safe_space_posts')
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
              TextButton(
                onPressed: () {
                  _showAllComments(postId);
                },
                child: Text('View all comments'),
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
                SizedBox(height: 2),
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

  void _showAllComments(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.65,
          maxChildSize: 0.65,
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('safe_space_posts')
                        .doc(postId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      var post = snapshot.data!.data() as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _buildPostCardWithoutComments(post, postId),
                      );
                    },
                  ),
                  const Divider(thickness: 1),
                  Expanded(
                    child: _buildCommentList(postId, controller),
                  ),
                  _buildCommentInput(postId),
                ],
              ),
            );
          },
        );
      },
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
                borderRadius: BorderRadius.circular(30),
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
              onPressed: () => _showPostDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getPostsStream() {
    if (_selectedTag.isNotEmpty) {
      return _firestore
          .collection('safe_space_posts')
          .where('tags', arrayContains: _selectedTag)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return _firestore
          .collection('safe_space_posts')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Text('Error: ${error.toString()}'),
    );
  }

  void _showPostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post Anonymously?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'If you are not comfortable sharing sensitive issues',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Yes'),
                      onPressed: () {
                        _isAnonymous = true;
                        _submitPost();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Share publicly'),
                      onPressed: () {
                        _isAnonymous = false;
                        _submitPost();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        String username =
        _isAnonymous ? 'Anonymous' : (userData['name'] ?? 'Anonymous');
        String? profilePictureBase64 =
        _isAnonymous ? null : userData['profilePictureBase64'];

        String content = _postController.text.toLowerCase();
        List<String> contentWords = content.split(RegExp(r'\s+'));

        // Find tags based on related words
        Set<String> tags = {};
        tagWords.forEach((tag, relatedWords) {
          if (contentWords.any((word) => relatedWords.contains(word))) {
            tags.add(tag);
          }
        });

        // Add hashtags from the content
        tags.addAll(contentWords
            .where((word) => word.startsWith('#'))
            .map((tag) => tag.substring(1)));

        await _firestore.collection('safe_space_posts').add({
          'content': _postController.text,
          'username': username,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'likes': 0,
          'likedBy': [],
          'tags': tags.toList(),
          'isAnonymous': _isAnonymous,
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

    final postRef = _firestore.collection('safe_space_posts').doc(postId);

    try {
      if (isLiked) {
        await postRef.update({
          'likes': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update like. Please try again.')),
      );
    }
  }

  void _showCommentDialog(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController commentController = TextEditingController();
        bool isAnonymous = false;
        return StatefulBuilder(
          builder: (context, setState) {
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
                        const Text(
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
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isAnonymous,
                          onChanged: (value) {
                            setState(() {
                              isAnonymous = value!;
                            });
                          },
                        ),
                        Text('Comment anonymously'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            _submitComment(
                                postId, commentController.text, isAnonymous);
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submitComment(
      String postId, String commentText, bool isAnonymous) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
        await _firestore.collection('users').doc(user.uid).get();
        String username =
        isAnonymous ? 'Anonymous' : (userData['name'] ?? 'Anonymous');
        String? profilePictureBase64 =
        isAnonymous ? null : userData['profilePictureBase64'];

        await _firestore
            .collection('safe_space_posts')
            .doc(postId)
            .collection('comments')
            .add({
          'content': commentText,
          'username': username,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'isAnonymous': isAnonymous,
          'profilePictureBase64': profilePictureBase64,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added successfully')),
        );
      }
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add comment. Please try again.')),
      );
    }
    // Remove this line:
    // Navigator.of(context).pop(); // Close the comment dialog
  }

  Widget _buildPostCardWithoutComments(
      Map<String, dynamic> post, String postId) {
    String username = post['username'] ?? 'Anonymous';
    String content = post['content'] ?? '';
    List<dynamic> tags = post['tags'] ?? [];
    int likes = post['likes'] ?? 0;
    List<dynamic> likedBy = post['likedBy'] ?? [];
    String userId = _auth.currentUser?.uid ?? '';
    bool isLiked = likedBy.contains(userId);
    String? profilePictureBase64 = post['profilePictureBase64'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 20,
              child: profilePictureBase64 != null
                  ? ClipOval(
                child: Image.memory(
                  base64Decode(profilePictureBase64),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
                  : Text(
                username[0].toUpperCase(),
                style: TextStyle(fontFamily: 'DMSans', fontSize: 16),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@$username',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(fontFamily: 'DMSans', fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 4,
          children: tags.map((tag) {
            return Chip(
              label: Text(
                '#$tag',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 12),
              ),
              backgroundColor: Colors.blue[50],
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
                size: 24,
              ),
              onPressed: () => _toggleLike(postId, isLiked),
            ),
            Text('$likes',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 16)),
            SizedBox(width: 16),
            IconButton(
              icon: Icon(
                Icons.comment_outlined,
                size: 24,
              ),
              onPressed: () => _showCommentDialog(postId),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentList(String postId, ScrollController controller) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('safe_space_posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading comments'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var comments = snapshot.data?.docs ?? [];
        return ListView.builder(
          controller: controller,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            var commentData = comments[index].data() as Map<String, dynamic>;
            return _buildCommentItem(commentData);
          },
        );
      },
    );
  }

  Widget _buildCommentInput(String postId) {
    final TextEditingController commentController = TextEditingController();
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
              controller: commentController,
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
              if (commentController.text.isNotEmpty) {
                _submitComment(postId, commentController.text, false);
                commentController
                    .clear(); // Clear the text field after submitting
              }
            },
          ),
        ],
      ),
    );
  }
}




























