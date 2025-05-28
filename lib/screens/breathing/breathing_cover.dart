import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sachetana_firebase/screens/breathing/newBreathing.dart';
import 'package:url_launcher/url_launcher.dart';


class BreathingOnboardingScreen extends StatelessWidget {
  const BreathingOnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C3324), // Dark green background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildMainCard(context),
                const SizedBox(height: 30),
                _buildTechniquesSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildMainCard(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Added padding around the entire widget
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF244535),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.spa_rounded,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 40),
                const Text(
                  "healing\nby breathing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tangerine',
                    fontSize: 60,
                    color: Color(0xFFE7D5B8),
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: 70),
                const Text(
                  " - often a simple 2 min breathing exercise will help you calm yourself, and take charge of your body",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    iconSize: 70,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BreathingScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      size: 80,
                      CupertinoIcons.play_circle_fill,
                      color: Color(0xFFE7D5B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 15,
          //   left: 15, // Added left padding
          //   right: 15,
          //   bottom: 15,// Added right padding
          //   child: Container(
          //     height: 370,
          //     // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced horizontal padding
          //     decoration: BoxDecoration(
          //       border: Border.all(color: const Color(0xFFE7D5B8), width: 1),
          //       borderRadius: BorderRadius.circular(40),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  Widget _buildTechniquesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Art & Music",
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildBreathingTechniqueTile(
          "Browse Art to Relax and Unwind",
          "A curated collection of relaxing art pieces to help you unwind.",
          "assets/images/art.jpeg",
          context,
          "https://public.work/mind",
        ),
        const SizedBox(height: 20),
        _buildBreathingTechniqueTile(
          "Breathe Like a Yogi",
          "A Beginners Guide on How To Do Pranayama",
          "assets/images/yogi.jpg",
          context,
          "https://medium.com/@smithgreen2111/a-beginners-guide-on-how-to-do-pranayama-92d89f79501a",
        ),
        const SizedBox(height: 20),
        _buildBreathingTechniqueTile(
          "Non Sleep Deep Rest by Andrew Huberman",
          "A 20-minute audio designed to help you enter a state of deep rest.",
          "assets/images/andrew.jpg",
          context,
          "https://open.spotify.com/track/4jomG2TtGLGcbUxwjpS6q4?si=23917cb95bd74554",
        ),
      ],
    );
  }

  Widget _buildBreathingTechniqueTile(String title, String description,
      String thumbnailPath, BuildContext context, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFE7D5B8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.asset(
                thumbnailPath,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C3324),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      color: Color(0xFF1C3324),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.arrow_right,
              color: Color(0xFF1C3324),
              size: 24,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}


//

//
//
// import 'breathing_exercise.dart'; // Import the Breathing Exercise
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class BreathingOnboardingScreen extends StatelessWidget {
//   const BreathingOnboardingScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1C3324), // Dark green background
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 _buildMainCard(context), // Build the main card
//                 const SizedBox(height: 30),
//                 _buildTechniquesSection(
//                     context), // Build the techniques section
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Method to build the main card
//   Widget _buildMainCard(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xFF244535),
//         borderRadius: BorderRadius.circular(50),
//         border: Border.all(color: const Color(0xFFE7D5B8), width: 1), // Border
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           children: [
//             const Icon(
//               Icons.spa_rounded,
//               color: Colors.white,
//               size: 60,
//             ),
//             const SizedBox(height: 40),
//             const Text(
//               "healing\nby breathing",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Tangerine',
//                 fontSize: 60,
//                 color: Color(0xFFE7D5B8),
//                 height: 1.0,
//               ),
//             ),
//             const SizedBox(height: 70),
//             const Text(
//               " - often a simple 2 min breathing exercise will help you calm yourself, and take charge of your body",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'DMSans',
//                 fontStyle: FontStyle.italic,
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 30),
//             // Play button on top of the container without being blocked
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color(0xFFE7D5B8),
//                 ),
//                 child: IconButton(
//                   iconSize: 40,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const BreathingScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(
//                       size: 40,
//                       CupertinoIcons.play_circle_fill,
//                       color: Color(0xFFE7D5B8),
//                     ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Method to build the techniques section
//   Widget _buildTechniquesSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Art & Music",
//           style: TextStyle(
//             fontFamily: 'DMSans',
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 20),
//         _buildBreathingTechniqueTile(
//           "Browse Art to Relax and Unwind",
//           "A curated collection of relaxing art pieces to help you unwind.",
//           "assets/art.jpeg",
//           context,
//           "https://public.work/mind",
//         ),
//         const SizedBox(height: 20),
//         _buildBreathingTechniqueTile(
//           "Breathe Like a Yogi",
//           "A Beginners Guide on How To Do Pranayama",
//           "assets/yogi.jpg",
//           context,
//           "https://medium.com/@smithgreen2111/a-beginners-guide-on-how-to-do-pranayama-92d89f79501a",
//         ),
//         const SizedBox(height: 20),
//         _buildBreathingTechniqueTile(
//           "Non Sleep Deep Rest by Andrew Huberman",
//           "A 20-minute audio designed to help you enter a state of deep rest.",
//           "assets/andrew.jpg",
//           context,
//           "https://open.spotify.com/track/4jomG2TtGLGcbUxwjpS6q4?si=23917cb95bd74554",
//         ),
//       ],
//     );
//   }
//
//   // Method to build each breathing technique tile with title, description, thumbnail, and URL
//   Widget _buildBreathingTechniqueTile(String title, String description,
//       String thumbnailPath, BuildContext context, String url) {
//     return GestureDetector(
//       onTap: () async {
//         if (await canLaunch(url)) {
//           await launch(url);
//         } else {
//           throw 'Could not launch $url';
//         }
//       },
//       child: Container(
//         height: 120,
//         decoration: BoxDecoration(
//           color: const Color(0xFFE7D5B8),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//               ),
//               child: Image.asset(
//                 thumbnailPath,
//                 height: 120,
//                 width: 120,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'DMSans',
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1C3324),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     description,
//                     style: const TextStyle(
//                       fontFamily: 'DMSans',
//                       fontSize: 12,
//                       color: Color(0xFF1C3324),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               CupertinoIcons.arrow_right,
//               color: Color(0xFF1C3324),
//               size: 24,
//             ),
//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }