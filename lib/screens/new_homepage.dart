import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/upskilling.dart';
import 'package:sachetana_firebase/screens/assessment/self_eval_introcards.dart';
import 'package:sachetana_firebase/screens/breathing/breathing_cover.dart';
import 'package:sachetana_firebase/screens/posts/posts_page.dart';
import 'package:sachetana_firebase/screens/posts/safespace.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/open_modal.dart';
import 'gemini/gemini_intro_screen.dart';
import 'profile_screen.dart'; // Ensure you have the correct import for the profile screen.

class HomePage extends StatefulWidget {
  final bool isLoggedIn;

  HomePage({required this.isLoggedIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _userName = "User";

  // Open menu modal
  void _openMenuModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 280,
          child: OpenModal(),
        );
      },
    );
  }

  // Navigate to the Gemini Chatbot intro screen
  void _openChatBot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeminiIntroScreen()),
    );
  }

  // Navigate to the Profile screen
  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()), // Ensure you have a ProfileScreen
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Ensures the elements are at the ends
                            children: [
                              // Sachetana text
                              Container(
                                // padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adds padding on the left
                                child: const Text(
                                  'Sachetana',
                                  style: TextStyle(
                                    fontFamily: 'Tangerine',
                                    fontSize: 70,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // Profile icon on the right side
                              SizedBox(width: 130),
                              Container(
                                // padding: const EdgeInsets.symmetric(horizontal: 56.0), // Adds padding on the right
                                child: GestureDetector(
                                  onTap: _openProfile,
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(Icons.person, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),
                          Text(
                            'Hello,\n$_userName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DMSans',
                              fontSize: 35,
                            ),
                          ),
                          const Text(
                            'We help you clear your mind',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: _openProfile,
                      //   child: CircleAvatar(
                      //     backgroundColor: Colors.white,
                      //     radius: 30,
                      //     child: Icon(Icons.person, color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Help based on needs container
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Help based on your needs',
                        style: TextStyle(fontSize: 25, fontFamily: 'DMSans'),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SelfEval()),
                              );
                              // Add navigation to the Assess Yourself screen here
                            },
                            child: _buildOptionTile('Assess yourself', 'GAD-7, PHQ-9 & more', Icons.assessment, 'Do you feel good?'),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpskillScreen2()),
                              );
                            },
                            child: _buildOptionTile('Upskill yourself', 'TEDx, Youtube & more', Icons.school, 'Absorb new things'),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BreathingOnboardingScreen()),
                              );
                            },
                            child: _buildOptionTile('Take a breather', '4-7-8', Icons.air, 'Calm yourself'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Advice section
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade900,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask your doubts, get advice from friends and doctors',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 25,
                          color: Colors.yellow.shade100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Anonymous or Publicly!',
                        style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SafeSpacePage()),
                              );
                              // Navigate to Safe Space screen
                              print("Safe Space tapped");
                              // Add navigation to the Safe Space screen here
                            },
                            child: _buildGreenOptionTile('Safe\nSpace'),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostsPage()),
                              );
                              // Navigate to Doc Posts screen
                              print("Doc Posts tapped");
                              // Add navigation to the Doc Posts screen here
                            },
                            child: _buildGreenOptionTile('Doc\nPosts'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // About this app section
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About this App',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'Your mental health matters. Take your time to explore the resources, seek help when needed, and remember that reaching out is a sign of strength, not weakness. SACHETANA is here to support you every step of the way.',
                          style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Floating navigation
          Positioned(
            bottom: 30,
            left: 80,
            right: 80,
            child: FloatingNav(
              onHomeTap: () {
                print("Home button clicked");
              },
              onMenuTap: _openMenuModal,
              onChatBotTap: () => _openChatBot(context),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildOptionTile(String title, String subtitle, IconData icon, String topLeftText) {
    return Container(
      width: 110,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              // child: Transform.rotate(
                // angle: -30 * (3.14159 / 180),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 18,
                ),
              ),
            ),

          Flexible(
            child: Text(
              topLeftText,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'DMSans',
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreenOptionTile(String title) {
    return Container(
      width: 165,
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.teal[900],
                fontFamily: 'DMSans',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Transform.rotate(
                angle: -30 * (3.14159 / 180),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
