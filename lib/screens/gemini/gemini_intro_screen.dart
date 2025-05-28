import 'package:flutter/material.dart';
import 'gemini_chat_screen.dart';  // Ensure this file exists and is correctly referenced

class GeminiIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
              children: [
                // Text elements
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 40.0), // Shifted lower and to the left
                  child: const Text(
                    "Sachetana",
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontFamily: 'Tangerine', // Set font family to Tangerine
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20.0), // Shifted lower and to the left
                  child: const Text(
                    "Have any questions?",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'DMSans', // Set font family to DMSans
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0), // Added another line of text
                  child: const Text(
                    "Use the power of Gemini AI and solve your doubts",
                    textAlign: TextAlign.left, // Align text to the left
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'DMSans', // Set font family to DMSans
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 0.0), // New line of text
                  child: const Text(
                    "Let’s get started!",
                    textAlign: TextAlign.left, // Align text to the left
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'DMSans', // Set font family to DMSans
                    ),
                  ),
                ),

                // Image widget
                Expanded(
                  child: Image.asset(
                    'assets/icons/gemini.png',  // Ensure this path is correct and image exists
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            // Circular button positioned at the bottom center
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeminiChatScreen(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black, // Changed button color to black
                    child: Icon(
                      Icons.star ,  // Customize the icon as needed
                      color: Colors.blue, // Changed icon color to blue
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}