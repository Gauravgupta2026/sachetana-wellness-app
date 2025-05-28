import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PHQ9AdditionalInfoPage extends StatefulWidget {
  final double totalScore;
  final String assessmentType = 'PHQ-9';

  const PHQ9AdditionalInfoPage({required this.totalScore});

  @override
  _PHQ9AdditionalInfoPageState createState() => _PHQ9AdditionalInfoPageState();
}

class _PHQ9AdditionalInfoPageState extends State<PHQ9AdditionalInfoPage> {
  final TextEditingController _detailsController = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Evaluation Summary',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.blue[700],
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please take your time and explain your feelings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _detailsController,
                          decoration: const InputDecoration(
                            hintText: 'your reflection...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          maxLines: 8,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            String details = _detailsController.text;
                            if (details.isNotEmpty) {
                              await storeAdditionalDetails(details);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Thank you for providing the details.'),
                              ));
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Please enter some details before submitting.'),
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('SUBMIT'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Resources',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _launchURL(
                            'https://www.nimh.nih.gov/health/topics/depression'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text('Learn More About Depression'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _launchURL('https://khmanipal.com/'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text('Speak to a Professional'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}
