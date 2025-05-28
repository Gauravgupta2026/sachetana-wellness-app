import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sachetana_firebase/screens/assessment/anxiety_feedback.dart';

class CAGETestPage extends StatefulWidget {
  @override
  _CAGETestPageState createState() => _CAGETestPageState();
}

class _CAGETestPageState extends State<CAGETestPage> {
  final List<String> questions = [
    'Have you ever felt you should Cut down on your drinking?',
    'Have people Annoyed you by criticizing your drinking?',
    'Have you ever felt bad or Guilty about your drinking?',
    'Have you ever had a drink first thing in the morning to steady your nerves or get rid of a hangover (Eye-opener)?',
  ];

  List<double> sliderValues = List.filled(4, 0.0);
  int currentQuestionIndex = 0;

  final List<String> emojiIcons = ['😊', '🙂', '😐', '😟'];

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      finishAssessment();
    }
  }

  void finishAssessment() async {
    double totalScore = sliderValues.reduce((a, b) => a + b);
    await storeResponses(totalScore);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationSummary(
          totalScore: totalScore,
        ),
      ),
    );
  }

  Future<void> storeResponses(double totalScore) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference assessments =
          FirebaseFirestore.instance.collection('assessments');
      await assessments.add({
        'userId': user.uid,
        'testType': 'CAGE',
        'sliderValues': sliderValues,
        'totalScore': totalScore,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.4, // 30% more compact
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      backgroundColor: Colors.blue[600],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 90),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Question ${currentQuestionIndex + 1} of ${questions.length}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                fontFamily: 'DMSans',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              questions[currentQuestionIndex],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              _getEmojiLabel(
                                  sliderValues[currentQuestionIndex].toInt()),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildCustomEmoji(
                                sliderValues[currentQuestionIndex].toInt()),
                            const SizedBox(height: 20),
                            Slider(
                              value: sliderValues[currentQuestionIndex],
                              min: 0,
                              max: 1,
                              divisions: 1,
                              onChanged: (double value) {
                                setState(() {
                                  sliderValues[currentQuestionIndex] =
                                      value.roundToDouble();
                                });
                              },
                              activeColor: Colors.blue[700],
                              inactiveColor: Colors.grey[300],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.4, // 30% more compact
                          child: ElevatedButton(
                            onPressed: nextQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              currentQuestionIndex < questions.length - 1
                                  ? 'Next'
                                  : 'Finish',
                              style: const TextStyle(fontSize: 16, fontFamily: 'DMSans'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmojiLabel(int value) {
    final labels = ['No', 'Yes'];
    return labels[value];
  }

  Widget _buildCustomEmoji(int value) {
    final images = ['assets/images/emojis/very_happy.png', 'assets/images/emojis/sad.png'];
    return Image.asset(
      images[value],
      width: 162,
      height: 162,
    );
  }
}
