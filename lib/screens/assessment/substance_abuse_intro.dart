import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cage_test_page.dart'; // For URL launching

class SubstanceAbuseIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bento.png"), // Background image
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
                      const Center(
                        child: Icon(
                          Icons.psychology_outlined,
                          color: Colors.green,
                          size: 60,
                        ),
                      ),
                      SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Substance Abuse\nQuestionnaire",
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
                          "This assessment uses standardized questions to give you a sense of your risk of substance abuse - a condition that can be addressed.",
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
                            // Action to begin the questionnaire
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CAGETestPage()));
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
                          child: const Text(
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
                      const Center(
                        child: Text(
                          "About Substance Abuse",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Substance abuse risk refers to an individual’s likelihood of experiencing issues related to the use of substances. This assessment reflects standardized methods to understand risk levels.",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'DMSans',
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Articles on Substance Abuse",
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildCard(
                        title: "Understanding Substance Abuse",
                        subtitle:
                        "Learn about the causes and effects of substance abuse",
                        imagePath: "assets/images/subs1.jpeg",
                        url:
                        "https://nida.nih.gov/publications/drugfacts/understanding-drug-use-addiction",
                      ),
                      SizedBox(height: 10),
                      _buildCard(
                        title: "Managing Substance Abuse",
                        subtitle:
                        "Practical steps to help manage and overcome substance abuse",
                        imagePath: "assets/images/subs2.jpeg",
                        url:
                        "https://www.helpguide.org/mental-health/addiction/substance-abuse-and-mental-health",
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
                style: const TextStyle(
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

