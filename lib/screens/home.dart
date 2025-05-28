//
// import 'package:flutter/material.dart';
// import 'package:sachetana_firebase/screens/assessment/anxiety_feedback.dart';
// import 'package:sachetana_firebase/screens/assessment/anxiety_intro.dart';
// import 'package:sachetana_firebase/screens/assessment/depression_intro.dart';
// import 'package:sachetana_firebase/screens/breathing/breathing_cover.dart';
// import 'package:sachetana_firebase/screens/gemini/gemini_intro_screen.dart';
// import 'package:sachetana_firebase/screens/assessment/self_eval_introcards.dart';
// import 'package:sachetana_firebase/screens/profile_screen.dart';
// import 'package:sachetana_firebase/screens/upskill_courses_clubs.dart';
// import 'package:sachetana_firebase/widgets/bottom_navigation.dart'; // For the navigation bar
// import 'package:sachetana_firebase/widgets/open_modal.dart'; // For the menu modal
// import 'package:url_launcher/url_launcher.dart';
// import 'package:sachetana_firebase/screens/gemini/gemini_chat_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool isLoggedIn; // Track login status
//
//   HomeScreen({required this.isLoggedIn}); // Pass this parameter from your login/signup logic
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;
//
//   // Open menu modal
//   void _openMenuModal() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           height: 200, // Set height property to the modal sheet
//           child: OpenModal(), // The custom modal defined in open_modal.dart
//         );
//       },
//     );
//   }
//
//   // Navigate to the Gemini Chatbot intro screen
//   void _openChatBot(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => GeminiIntroScreen()), // Ensure correct import for the screen
//     );
//   }
//
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
//                 image: AssetImage("assets/images/home.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0), // Adjusted padding
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 40),
//                 const Text(
//                   'Sachetana',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 70,
//                     fontFamily: 'Tangerine',
//                   ),
//                 ),
//                 // SizedBox(height: 30),
//                 const Text(
//                   'Hello Gaurav',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 34,
//                     fontFamily: 'DMSans',
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 150),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: EdgeInsets.only(left: 10.0),
//                   child: RichText(
//                     text: const TextSpan(
//                       text: 'Help based on ',
//                       style: TextStyle(
//                         fontFamily: 'DMSans',
//                         fontSize: 24,
//                         color: Colors.black,
//                       ),
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: 'your needs',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         width: 365,
//                         height: 155,
//                         child: Stack(
//                           children: [
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                                   ),
//                                   child: ListTile(
//                                     title: const Text(
//                                       'Self\nEvaluation',
//                                       style: TextStyle(
//                                         fontFamily: 'DMSans',
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 22,
//                                       ),
//                                     ),
//                                     subtitle: const Padding(
//                                       padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 2),
//                                       child: Text('Clear your doubts'),
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(builder: (context) => SelfEval()),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10), // Gap between tiles
//                     Expanded(
//                       child: Container(
//                         width: 365,
//                         height: 155,
//                         child: Stack(
//                           children: [
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                                   ),
//                                   child: ListTile(
//                                     title: const Text(
//                                       'Upskill Yourself',
//                                       style: TextStyle(
//                                         fontFamily: 'DMSans',
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 22,
//                                       ),
//                                     ),
//                                     subtitle: const Padding(
//                                       padding: EdgeInsets.symmetric(vertical: 25, horizontal: 2),
//                                       child: Text('Control your mood'),
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(builder: (context) => const UpskillScreen()),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Container(
//                   width: 400,
//                   height: 150,
//                   child: Card(
//                     child: Stack(
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             ListTile(
//                               title: const Text(
//                                 'Take a\nBreather',
//                                 style: TextStyle(
//                                   fontFamily: 'DMSans',
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 22,
//                                 ),
//                               ),
//                               subtitle: const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 2),
//                                 child: Text('Calm your breathing'),
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => HealingCard()),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 90,
//             right: 16,
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.white,
//               child: IconButton(
//                 icon: Icon(Icons.person),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 30,
//             left: 80,
//             right: 80,
//             child: FloatingNav(
//               onHomeTap: () {
//                 print("Home button clicked");
//               },
//               onMenuTap: _openMenuModal, // Open the menu modal
//               onChatBotTap: () => _openChatBot(context), // Navigate to GeminiIntroScreen
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
