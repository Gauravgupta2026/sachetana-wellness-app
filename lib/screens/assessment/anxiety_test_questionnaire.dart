import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'anxiety_feedback.dart';

class GAD7TestPage extends StatefulWidget {
  @override
  _GAD7TestPageState createState() => _GAD7TestPageState();
}

class _GAD7TestPageState extends State<GAD7TestPage> {
  final List<String> questions = [
    'Feeling nervous, anxious, or on edge',
    'Not being able to stop or control worrying',
    'Worrying too much about different things',
    'Trouble relaxing',
    'Being so restless that it\'s hard to sit still',
    'Becoming easily annoyed or irritable',
    'Feeling afraid as if something awful might happen',
  ];

  List<double> sliderValues = List.filled(7, 0.0);
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

    if (totalScore > 10) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EvaluationSummary(
            totalScore: totalScore,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Your results have been submitted. Consider learning more about anxiety.',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.blue[700],
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> storeResponses(double totalScore) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference assessments =
          FirebaseFirestore.instance.collection('assessments');
      await assessments.add({
        'userId': user.uid,
        'testType': 'GAD-7',
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
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.4, // 30% more compact
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      backgroundColor: Colors.blue[600],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
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
                                color: Colors.grey[500],
                                fontFamily: 'DMSans',
                              ),
                            ),
                            SizedBox(height: 30),
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
                            const SizedBox(height: 40),
                            _buildCustomEmoji(
                                sliderValues[currentQuestionIndex].toInt()),
                            const SizedBox(height: 30),
                            Slider(
                              value: sliderValues[currentQuestionIndex],
                              min: 0,
                              max: 3,
                              divisions: 3,
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
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'DMSans'),
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
    final labels = [
      'Not at all',
      'Several days',
      'More than half the days',
      'Nearly every day'
    ];
    return labels[value];
  }

  Widget _buildCustomEmoji(int value) {
    final images = [
      'assets/images/emojis/very_happy.png',
      'assets/images/emojis/happy.png',
      'assets/images/emojis/neutral.png',
      'assets/images/emojis/sad.png'
    ];
    return Image.asset(
      images[value],
      width: 162,
      height: 162,
    );
  }
}
