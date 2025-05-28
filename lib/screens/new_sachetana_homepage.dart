
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sachetana_firebase/screens/assessment/self_eval_introcards.dart';
import 'package:sachetana_firebase/screens/breathing/newBreathing.dart';
import 'package:sachetana_firebase/screens/general_settings.dart';
import 'package:sachetana_firebase/screens/posts/posts_page.dart';
import 'package:sachetana_firebase/screens/posts/safespace.dart';
import 'package:sachetana_firebase/screens/profile_screen.dart';
import 'package:sachetana_firebase/screens/upskilling.dart';
import 'dart:async';
import 'dart:math';

import '../widgets/open_modal.dart';
import 'gemini/gemini_intro_screen.dart';
import 'journal_records_page.dart';

class JournalEntry {
  final String content;
  final String date;
  final String mood;
  final DateTime timestamp;
  final String userId;

  JournalEntry({
    required this.content,
    required this.date,
    required this.mood,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'date': date,
      'mood': mood,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      mood: map['mood'] ?? 'Unknown',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userId: map['userId'] ?? '',
    );
  }
}

// Journal Entry Card Widget
class JournalEntryCard extends StatelessWidget {
  final String content;
  final String date;
  final String mood;

  const JournalEntryCard({
    Key? key,
    required this.content,
    required this.date,
    required this.mood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontFamily: 'PoltawskiNowy',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    mood,
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewBuddyhome extends StatefulWidget {
  @override
  _NewBuddyhomeState createState() => _NewBuddyhomeState();
}

class _NewBuddyhomeState extends State<NewBuddyhome> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final TextEditingController _journalController = TextEditingController();
  int _currentIndex = 0;
  int _selectedNavIndex = 0;
  String _userName = "User";
  String _currentQuestion = " ";
  String selectMood = 'Select Mood';


  void _getRandomQuestion() {
    // Generate a random index
    final randomIndex = Random().nextInt(_questions.length);
    // Update the current question
    setState(() {
      _currentQuestion = _questions[randomIndex];
    });
  }
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

  // Navigate to the Profile screen
  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProfilePage()), // Ensure you have a ProfileScreen
    );
  }

  //Navigate to settings
  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SettingsScreen()), // Ensure you have a ProfileScreen
    );
  }

  // Navigate to the Gemini Chatbot intro screen
  void _openChatBot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeminiIntroScreen()),
    );
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

  Future<void> _addJournalEntry(String mood) async {
    String content = _journalController.text.trim();
    if (content.isNotEmpty) {
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        JournalEntry entry = JournalEntry(
          content: content,
          date: DateTime.now().toString().split(" ")[0],
          mood: mood ,
          timestamp: DateTime.now(),
          userId: userId,
        );

        await FirebaseFirestore.instance
            .collection('journal_entries')
            .add(entry.toMap());

        _journalController.clear();

        //close pop up after data entry
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Journal entry added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        print('Error adding journal entry: $e'); // Debug print statement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add journal entry. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showMoodSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView(
            children: ['Happy', 'Sad', 'Excited', 'Calm', 'Angry']
                .map((mood) => ListTile(
              title: Text(mood),
              onTap: () {
                setState(() {
                  selectMood = mood;
                });
                Navigator.pop(context);
              },
            ))
                .toList(),
          ),
        );
      },
    );
  }

  void _openJournalModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        String weekNumber = 'w.${((now.day - 1) ~/ 7) + 1}';
        String date = DateFormat('dd MMM yy').format(now);
        String selectMood = 'Select Mood';

        return Dialog(
          backgroundColor: Color.fromRGBO(200, 235, 224, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section with Week Number, Date, and Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$weekNumber   $date',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 101, 89, 1),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.green.shade900),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Mood Selection Container
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              child: ListView(
                                children: ['Happy', 'Sad', 'Excited', 'Calm', 'Angry']
                                    .map((mood) => ListTile(
                                  title: Text(mood),
                                  onTap: () {
                                    setState(() {
                                      selectMood = mood;
                                    });
                                    Navigator.pop(context);
                                  },
                                ))
                                    .toList(),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(168, 219, 203, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          selectMood,
                          style: TextStyle(color: Color.fromRGBO(0, 101, 89, 1), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Title
                    Text(
                      _currentQuestion,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: Color.fromRGBO(0, 101, 89, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Journal Entry TextField with Arrow Button
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade400, width: 0.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _journalController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "What's on your mind?",
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15, fontFamily: 'Poppins'),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _addJournalEntry(selectMood);
                            },
                            icon: Transform.rotate(
                              angle: 40 * pi / 180,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.green.shade900,
                                size: 24,
                              ),
                            ),
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
    );
  }




  final List<String> _questions = [
    "How are you feeling today?",
    "What made you\nsmile recently?",
    "What are you\ngrateful for right now?",
    "What’s one thing\nyou want to achieve today?",
    "How can you improve\nyour mood today?",
    "What’s something\nthat inspired you this week?",
    "What do you love\nabout yourself?",
    "What are your\ncurrent goals?"
  ];

  final List<String> carouselTexts = [
    'We have questions that will help you',
    'Maintain mental clarity daily',
    'Reflect on your emotions',
    'Track your mental progress'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _getRandomQuestion();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // maintain consistency with device widths

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 255, 254, 1),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top section: App name, greeting, settings, profile
            SizedBox(height: 100),
            _buildTopBar(),
            SizedBox(height: 40),
            _buildDateContainer(),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Journaling helps\nnavigate your thoughts',
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            buildCarousel(),
            SizedBox(height: 20),
            buildProgressIndicator(),

            SizedBox(height: 40),

            // Green container with date, question, and input field

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(49, 169, 134, 1),
                borderRadius: BorderRadius.circular(45.0),
                border: Border.all(color: Colors.white, width: 4.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10.0,
                      offset: Offset(0, 4))
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          _currentQuestion,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _openJournalModal,
                              child: Container(
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: Text(
                                    "What's on your mind?",
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 10,
                                        fontFamily: 'PoltawskiNowy'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _getRandomQuestion(); // Change question on tap
                                },
                                child: Container(
                                    padding: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text(
                                            'Next Prompt',
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 101, 89, 1), // Change color as desired
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.book,
                              size: 20.0,
                              color: Color.fromRGBO(0, 101, 89, 1),
                            ),
                          ),
                        ),

                    ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Text(
                '“We help you sort your issues so that you don’t have to cry at night, all alone.”',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                  fontSize: 10.0,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade800, width: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Explore Activities',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade800, // Green text
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Do a self checkup',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                // fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            // Carousel of detailed cards
            SizedBox(
              height: 350,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelfEval()),
                      );
                    },
                    child:
                        // buildDetailedCard('Self\nEvaluation', Icons.air, '60s', 'assets/images/calm.jpg'),
                        buildDetailedCard('Self\nEvaluation', Icons.air, '60s'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpskillScreen2()),
                      );
                    },
                    child: buildDetailedCard('Mindfulness\nActivity',
                        Icons.self_improvement, '5 min'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BreathingScreen()),
                      );
                    },
                    child: buildDetailedCard(
                        'Gratitude\nPractice', Icons.favorite, '3 min'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade800, width: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade800, // Green text
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Explore our Community to share good knowledge',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Ask your doubts, get advice, know better',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
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
                SizedBox(width: 15),
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

            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(color: Colors.grey.shade800, width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Journal',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade800, // Green text
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Records',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          color: Colors.green[900],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // handle submission
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JournalRecordsPage()),
                          );
                        },
                        icon: Transform.rotate(
                          angle: -40 * (3.14159 / 180),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.green.shade900,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // _buildRecentJournalEntries(),
                  _buildRelaxingSection(),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(height: 50),
            // Journal Records section
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavButton(0, Icons.home_rounded, 'Home'),
            SizedBox(width: 24),
            _buildNavButton(1, Icons.menu_rounded, 'Menu'),
            SizedBox(width: 24),
            _buildNavButton(2, Icons.auto_awesome, 'AI'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _openProfile,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  Icons.person,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Poppins')),
                Text(
                  'Hey, $_userName',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'PoltawskiNowy',
                    fontWeight: FontWeight.w200,
                    color: Color.fromRGBO(2, 75, 53, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              child: GestureDetector(
                // onTap: _openSettings, // _openNotification
                child: Icon(Icons.notifications_active_outlined,
                    color: Colors.grey.shade700, size: 25),
              ),
            ),
            SizedBox(width: 15),
            Container(
              child: GestureDetector(
                onTap: _openSettings,
                child: Icon(
                  Icons.settings_rounded,
                  color: Colors.grey.shade700,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateContainer() {
    String formattedDate = DateFormat('EEEE, d MMM, yyyy').format(DateTime.now());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(208, 241, 231, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        formattedDate,
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }


  Widget _buildGreenOptionTile(String title) {
    return Container(
      width: 160,
      height: 160,
      padding: const EdgeInsets.all(10),
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
                fontFamily: 'Poppins',
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

  Widget _buildViewMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JournalRecordsPage()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'View More',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade800,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JournalRecordsPage()),
              );
            },
            icon: Transform.rotate(
              angle: -40 * (3.14159 / 180),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.green.shade900,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(int index, IconData icon, String label) {
    bool isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => _onNavButtonTapped(index),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? Color.fromRGBO(0, 195, 138, 1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Color.fromRGBO(0, 68, 47, 1),
          size: 24,
        ),
      ),
    );
  }

  void _onNavButtonTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home page
        print("Home Button tapped");
        break;
      case 1:
        _openMenuModal();
        break;
      case 2:
        _openChatBot();
        break;
    }
  }

  Widget _buildRecentJournalEntries() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('journal_entries')
          .where('userId', isEqualTo: userId) // Filter by current user
          .orderBy('timestamp', descending: true)
          .limit(4)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No journal entries yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          );
        }

        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    JournalEntry entry = JournalEntry.fromMap(
                        doc.data() as Map<String, dynamic>);
                    return JournalEntryCard(
                      content: entry.content,
                      date: entry.date,
                      mood: entry.mood,
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 20),
            _buildViewMoreButton(context),
          ],
        );
      },
    );
  }

  Widget _buildRelaxingSection() {
    return Column(
      children: [
        SizedBox(height: 40),
        Center(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade800, width: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            ),
            child: Text(
              'About Us',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
        SizedBox(height: 40),

        SizedBox(height: 40),
        Text(
          '"Relax, breathe, and enjoy the moment."',
          style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildCarousel() {
    return SizedBox(
      height: 70,
      child: PageView.builder(
        controller: _pageController,
        itemCount: carouselTexts.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          // Circular selection logic
          final isActive = index == _currentIndex;
          final text = carouselTexts[index];

          return buildCarouselCard(text, isActive);
        },
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(carouselTexts.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: index == _currentIndex ? 9 : 6,
          height: index == _currentIndex ? 9 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _currentIndex ? Colors.green : Colors.grey[300],
          ),
        );
      }),
    );
  }

  // Color.fromRGBO(211, 255, 225, 1)
  Widget buildCarouselCard(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isActive
              ? Color.fromRGBO(250, 255, 254, 1)
              : Color.fromRGBO(211, 255, 225, 1),
          // color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 20, // Adjust size as needed
                    backgroundColor:
                        Colors.teal.shade50, // Teal color for the avatar
                  ),
                  Icon(Icons.sticky_note_2_rounded,
                      color: Colors.black87, size: 20)
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isActive ? Colors.green[900] : Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 12),
              ),
            ))
          ],
        ),
      ),
    );
  }

  // Widget buildDetailedCard(String title, IconData icon, String duration, String imagePath) {
  Widget buildDetailedCard(String title, IconData icon, String duration) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 101, 89, 1),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(40),
            //   child: Image.asset(
            //     imagePath,
            //     width: 300,
            //     height: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // Top Left Container
            Positioned(
                top: 20,
                left: 20,
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      duration,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PoltawskiNowy',
                          fontSize: 14),
                    ),
                  ),
                )),

            //Top Right Icon
            Positioned(
              top: 20,
              right: 20,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(icon, color: Colors.green[800], size: 30),
              ),
            ),

            // Bottom Left Container
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'PoltawskiNowy'),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
