import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/assessment/anxiety_intro.dart';
import 'package:sachetana_firebase/screens/assessment/depression_intro.dart';
import 'package:sachetana_firebase/screens/assessment/substance_abuse_intro.dart';

class SelfEval extends StatefulWidget {
  const SelfEval({super.key});

  @override
  _SelfEvalScreenState createState() => _SelfEvalScreenState();
}

class _SelfEvalScreenState extends State<SelfEval> {
  int _activeCardIndex = -1; // Tracks the active card

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // Solid Color Background
          Container(
            color: Colors.white, // Set a solid background color
          ),
          // White Rectangle at the Top
          Container(
            height: MediaQuery.of(context).size.height * 0.37, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
          ),
          // Texts placed at the top of the screen
          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100), // Space for the top of the screen
                // Center "Self Evaluation" Text
                Text(
                  'Self Evaluation',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 35), // Space between titles
                // Two-line "Check out these measurements of self evaluation" text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check out these',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'measurements of self evaluation',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Individual Card Components Centered in Middle of Section
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4, // Cards start below middle of screen
            left: 10,
            right: 10,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6, // Adjustable size for card container
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 30),
                itemCount: 3, // Number of cards
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0), // Add space between cards
                    child: _buildCard(
                      index,
                      index == 0
                          ? 'Anxiety Risk Evaluation'
                          : index == 1
                          ? 'Depression Risk Evaluation'
                          : 'Substance Abuse Evaluation',
                      index == 0
                          ? 'GAD-7 Standard   |   30 seconds '
                          : index == 1
                          ? 'PHQ-9 Standard   |   45 seconds '
                          : 'CAGE Standard   |   30 seconds ',
                      index == 0
                          ? 'assets/images/aggresive.jpg'
                          : index == 1
                          ? 'assets/images/stress.jpg'
                          : 'assets/images/confusion.jpg',
                      index == 0
                          ? AnxietyIntro()
                          : index == 1
                          ? DepressionIntro()
                          : SubstanceAbuseIntro(),
                      index,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index, String title, String description, String imagePath, Widget destinationScreen, int cardIndex) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destinationScreen));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: _activeCardIndex == cardIndex ? Colors.blueAccent : Colors.white, // Active card color change
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 6,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width, // Full width of the card
              height: MediaQuery.of(context).size.height * 0.18, // Adjusted image size
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(15.0)),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assessment, color:
                      _activeCardIndex == cardIndex ? Colors.white : Colors.black),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          title,
                          style:
                          TextStyle(
                            fontFamily:'DMSans',
                            fontSize:
                            18,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            _activeCardIndex == cardIndex ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color:
                  _activeCardIndex == cardIndex ? Colors.white : Colors.black),
                  const SizedBox(height:
                  5),
                  Text(
                    description,
                    style:
                    TextStyle(fontFamily:'DMSans', fontSize:
                    14, color:_activeCardIndex == cardIndex ? Colors.white : Colors.black,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
