import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'anxiety_test_questionnaire.dart'; // Import for URL launching

class AnxietyIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bento.png"), // Background image
              fit: BoxFit.fitHeight, // Avoid stretching
              alignment: Alignment.topCenter, // Align to the top
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0), // Set desired padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 270), // Placeholder for the background image
                // Questionnaire title and description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.psychology_outlined,
                          color: Colors.green,
                          size: 60,
                        ),
                      ),
                      SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Anxiety Risk\nQuestionnaire",
                          textAlign: TextAlign.center, // Center align the text
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "This assessment uses standardized questions to give you a sense of your risk of anxiety - a very common and treatable condition.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'DMSans',
                              color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GAD7TestPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical:
                                12), // Increased vertical padding for better touch target
                          ),
                          child: Text(
                            "BEGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'DMSans',
                                fontSize:
                                12), // Increased font size for better visibility
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      Center(
                        child: Text(
                          "About Anxiety Risk",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Anxiety risk refers to an individual’s risk of anxiety-related mental health conditions. This reflects the recent mental health assessment score based on the Generalised Anxiety Disorder Questionnaire-7 (GAD-7). The GAD-7 is a tool doctors use to help screen for and measure someone’s anxiety symptoms over a two-week period.",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'DMSans',
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Common Concerns about Mental Health",
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildCard(
                        title: "Understanding Anxiety",
                        subtitle:
                        "Learn more about anxiety disorders and how to cope with them",
                        imagePath: "assets/images/anxiety1.jpeg",
                        url: "https://www.medicalnewstoday.com/articles/323454",
                      ),
                      SizedBox(height: 10),
                      _buildCard(
                        title: "Managing Anxiety",
                        subtitle:
                        "Tips and techniques to help you manage anxiety effectively",
                        imagePath: "assets/images/anxiety2.jpeg",
                        url:
                        "https://hbr.org/2020/09/how-to-manage-your-anxiety",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create card widgets with image and link
  Widget _buildCard({
    required String title,
    required String subtitle,
    required String imagePath, // Asset image path
    required String url, // URL to navigate when card is pressed
  }) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image for the card
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                    color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

