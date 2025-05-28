import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationSummary extends StatefulWidget {
  final double totalScore;
  final String assessmentType = 'GAD-7';

  EvaluationSummary({required this.totalScore});

  @override
  _EvaluationSummaryState createState() => _EvaluationSummaryState();
}

class _EvaluationSummaryState extends State<EvaluationSummary> {
  TextEditingController _detailsController = TextEditingController();

  Future<void> storeAdditionalDetails(String details) async {
    CollectionReference assessments =
    FirebaseFirestore.instance.collection('assessments');
    await assessments.add({
      'additionalDetails': details,
      'totalScore': widget.totalScore,
      'timestamp': FieldValue.serverTimestamp(),
      'assessmentType': widget.assessmentType,
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Texts placed at the top of the screen
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80), // Space for the top of the screen
                // Center "Evaluation Summary" Text
                Text(
                  'Evaluation Summary',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30), // Space between titles
                // Two-line "Based on your inputs" text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Based on your inputs',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space before white rectangle
              ],
            ),
          ),

          // Curved white rectangle replaced with a structured layout
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Please explain your feelings in depth:",
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Input box for user input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _detailsController,
                        maxLines: 8, // Allow multiple lines
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Remove border
                          hintText: "your reflection...",
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    Center(

                      child:
                      ElevatedButton(
                        onPressed: () async {
                          String details = _detailsController.text;
                          if (details.isNotEmpty) {
                            await storeAdditionalDetails(details);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Thank you for providing the details.'),
                            ));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please enter some details before submitting.'),
                            ));
                          }
                        },
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.black,
                          padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(7),
                          ),
                        ),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DMSans',
                          ),
                        ),

                    ),
                    ),
                    const SizedBox(height: 50),

                    const Text(
                      'Resources',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _launchURL(
                            'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
                        child: Text('Learn More About Anxiety',
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 90, vertical: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child:  ElevatedButton(
                        onPressed: () => _launchURL('https://khmanipal.com/'),
                        child: Text('Speak to a Professional',
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 20),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}
