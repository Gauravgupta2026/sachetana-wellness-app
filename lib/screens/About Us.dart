// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class AboutUsScreen extends StatelessWidget {
//   final String reportUrl = 'https://forms.gle/R1UmhSWyTM2RnxtN7';
//
//   final Map<String, String> teamUrls = {
//     'Gaurav': 'https://',
//     'Sarvagya': 'https:',
//     'Prakhar': 'https:',
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(230, 230, 230, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: _buildMainPage(context),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainPage(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           color: Color.fromRGBO(230, 230, 230, 1),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),
//                     Center(
//                       child: OutlinedButton(
//                         onPressed: () {},
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.grey.shade800, width: 0.5),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         ),
//                         child: Text(
//                           'About Us ',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontFamily: 'Poppins',
//                             color: Colors.grey.shade800, // Green text
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     Center(
//                       child: Text(
//                         'Welcome to Sachetna',
//                         style: TextStyle(
//                           color: Color.fromRGBO(2, 75, 53, 1),
//                           fontSize: 30,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Center(
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFE6EEFF),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           'Beta',
//                           style: TextStyle(
//                             color: Color(0xFF4B7BE5),
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     Text(
//                       'Thank you for being among the first to try Sachetna and welcome to the Beta program. If you have features to request or bugs to report, DM us from the settings and we\'ll address it ASAP',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 16,
//                         fontFamily: 'Poppins',
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 60),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildTeamMember('Gaurav', '🟢'),
//                     SizedBox(width: 20),
//                     _buildTeamMember('Sarvagya', '🔵'),
//                     SizedBox(width: 20),
//                     _buildTeamMember('Prakhar', '🔴'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           color: Colors.white,
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Beta Status',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontFamily: 'Poppins',
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
//               _buildFeatureItem('Assessment', 'Live'),
//               _buildFeatureItem('Upskilling', 'Live'),
//               _buildFeatureItem('Journaling', 'In Dev'),
//               _buildFeatureItem('Safe Space', 'Live'),
//               _buildFeatureItem('SOS', 'Live'),
//               _buildFeatureItem('Home UI', 'In Dev'),
//               SizedBox(height: 40),
//               Center(
//                 child: GestureDetector(
//                   onTap: () async {
//                     final Uri url = Uri.parse(reportUrl);
//                     if (await canLaunchUrl(url)) {
//                       await launchUrl(url);
//                     }
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                     child: Text(
//                       'Send us Reports',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Poppins',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTeamMember(String name, String emoji) {
//     return Row(
//       children: [
//         Text(emoji, style: TextStyle(fontSize: 16)),
//         SizedBox(width: 4),
//         GestureDetector(
//           onTap: () async {
//             final Uri url = Uri.parse(teamUrls[name] ?? '');
//             if (await canLaunchUrl(url)) {
//               await launchUrl(url);
//             }
//           },
//           child: Text(
//             name,
//             style: TextStyle(
//               color: Colors.black,
//               fontFamily: 'Poppins',
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeatureItem(String feature, String status) {
//     // Map features to Material Icons
//     final Map<String, IconData> featureIcons = {
//       'Assessment': Icons.assignment,
//       'Upskilling': Icons.trending_up,
//       'Journaling': Icons.book,
//       'Safe Space': Icons.security,
//       'SOS': Icons.emergency,
//       'Home UI': Icons.home,
//     };
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Row(
//         children: [
//           Icon(
//             featureIcons[feature] ?? Icons.circle, // Fallback icon
//             size: 24,
//             color: Color(0xFF4B7BE5),
//           ),
//           SizedBox(width: 16),
//           Text(
//             feature,
//             style: TextStyle(
//               color: Colors.black87,
//               fontFamily: 'Poppins',
//               fontSize: 16,
//             ),
//           ),
//           Spacer(),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             decoration: BoxDecoration(
//               color: status == 'Live'
//                   ? Color(0xFFE7F5EC).withOpacity(0.5)
//                   : Color(0xFFE6EEFF).withOpacity(0.5),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               status,
//               style: TextStyle(
//                 color: status == 'Live' ? Color(0xFF1B8B55) : Color(0xFF4B7BE5),
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins'
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReportPage(BuildContext context) {
//     return Container(
//       color: Colors.grey[100],
//       padding: EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Send us Reports',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           // Add your report form here
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  final String reportUrl = 'https://forms.gle/R1UmhSWyTM2RnxtN7';

  final Map<String, String> teamUrls = {
    'Gaurav': 'https://',
    'Sarvagya': 'https://',
    'Prakhar': 'https://',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 230, 230, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildMainPage(context),
        ),
      ),
    );
  }

  Widget _buildMainPage(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              color: Color.fromRGBO(230, 230, 230, 1),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: screenWidth * 0.05, // Responsive padding
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.grey.shade800, width: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1, // Responsive width
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              'About Us ',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: Text(
                            'Welcome to Sachetna',
                            style: TextStyle(
                              color: Color.fromRGBO(2, 75, 53, 1),
                              fontSize: screenWidth * 0.08, // Responsive font size
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFE6EEFF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Beta',
                              style: TextStyle(
                                color: Color(0xFF4B7BE5),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Thank you for being among the first to try Sachetna and welcome to the Beta program. If you have features to request or bugs to report, DM us from the settings and we\'ll address it ASAP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth * 0.04, // Responsive font size
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTeamMember('Gaurav', '🟢'),
                        SizedBox(width: screenWidth * 0.05), // Responsive spacing
                        _buildTeamMember('Sarvagya', '🔵'),
                        SizedBox(width: screenWidth * 0.05), // Responsive spacing
                        _buildTeamMember('Prakhar', '🔴'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: screenWidth * 0.05, // Responsive padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beta Status',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildFeatureItem('Assessment', 'Live'),
                  _buildFeatureItem('Upskilling', 'Live'),
                  _buildFeatureItem('Journaling', 'In Dev'),
                  _buildFeatureItem('Safe Space', 'Live'),
                  _buildFeatureItem('SOS', 'Live'),
                  _buildFeatureItem('Home UI', 'In Dev'),
                  SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(reportUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.06, // Responsive padding
                          horizontal: screenWidth * 0.1, // Responsive padding
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          'Send us Reports',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: screenWidth * 0.045, // Responsive font size
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTeamMember(String name, String emoji) {
    return Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: 16)),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () async {
            final Uri url = Uri.parse(teamUrls[name] ?? '');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          child: Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String feature, String status) {
    final Map<String, IconData> featureIcons = {
      'Assessment': Icons.assignment,
      'Upskilling': Icons.trending_up,
      'Journaling': Icons.book,
      'Safe Space': Icons.security,
      'SOS': Icons.emergency,
      'Home UI': Icons.home,
    };

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 12.0, horizontal: 8.0), // Increased padding for readability
      child: Row(
        children: [
          Icon(
            featureIcons[feature] ?? Icons.circle,
            size: 24,
            color: Color(0xFF4B7BE5),
          ),
          SizedBox(width: 16),
          Text(
            feature,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: status == 'Live'
                  ? Color(0xFFE7F5EC).withOpacity(0.5)
                  : Color(0xFFE6EEFF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Live' ? Color(0xFF1B8B55) : Color(0xFF4B7BE5),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportPage(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
