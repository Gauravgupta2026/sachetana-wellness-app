// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(SettingsScreen());
// }
//
// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(),
//       home: SettingsPage(),
//     );
//   }
// }
//
// class SettingsPage extends StatefulWidget {
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   bool isDarkMode = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Top Image Container
//           Container(
//             height: 350,
//             color: Colors.blue, // Replace with your image or color
//             width: double.infinity,
//             child: Center(
//               child: Text(
//                 "App Logo",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Content below the "General Settings" is now scrollable
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Heading
//                   const Text(
//                     "GENERAL SETTINGS",
//                     style: TextStyle(
//                       fontFamily: 'DMSans',
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Scrollable content
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           // Row of Two Tiles
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               // Dark Mode Tile
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       isDarkMode = !isDarkMode; // Toggle dark mode
//                                     });
//                                   },
//                                   child: Container(
//                                     height: 130,
//                                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                                     margin: EdgeInsets.only(right: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(30),
//                                       border: Border.all(color: Colors.grey.shade400, width: 1), // Thin border
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         // Circle Icon at top-left
//                                         Positioned(
//                                           top: 0,
//                                           left: 0,
//                                           child: Transform.scale(
//                                             scale: 0.8, // Scale down the switch
//                                             child: Switch(
//                                               value: isDarkMode,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   isDarkMode = value;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                         // Text at bottom-left
//                                         Positioned(
//                                           bottom: 0,
//                                           left: 0,
//                                           child: Text(
//                                             "DARK MODE",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//
//                               // Log Out Tile with Icon
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Log out function logic here
//                                     print("Log Out Pressed");
//                                   },
//                                   child: Container(
//                                     height: 130,
//                                     padding: EdgeInsets.all(20),
//                                     margin: EdgeInsets.only(left: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(30),
//                                       border: Border.all(color: Colors.grey.shade400, width: 1), // Thin border
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         // Circle Icon at top-left
//                                         Positioned(
//                                           top: 0,
//                                           left: 0,
//                                           child: CircleAvatar(
//                                             backgroundColor: Colors.red.shade100,
//                                             radius: 20,
//                                             child: Icon(Icons.logout, color: Colors.red),
//                                           ),
//                                         ),
//                                         // Text at bottom-left
//                                         Positioned(
//                                           bottom: 0,
//                                           left: 0,
//                                           child: Text(
//                                             "LOG OUT",
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//
//                           // About Us Tile
//                           GestureDetector(
//                             onTap: () {
//                               // Action for About Us
//                               print("About Us Pressed");
//                             },
//                             child: Container(
//                               height: 120,
//                               padding: EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(30),
//                                 border: Border.all(color: Colors.grey.shade400, width: 1), // Thin border
//                               ),
//                               child: Stack(
//                                 children: [
//                                   // Circle Icon at top-left
//                                   Positioned(
//                                     top: 0,
//                                     left: 0,
//                                     child: CircleAvatar(
//                                       backgroundColor: Colors.grey.shade200,
//                                       radius: 20,
//                                       child: Icon(Icons.info_outline, color: Colors.grey),
//                                     ),
//                                   ),
//                                   // Text at bottom-left
//                                   Positioned(
//                                     bottom: 0,
//                                     left: 0,
//                                     child: Text(
//                                       "ABOUT US",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//
//                           // Suggest Improvements Tile
//                           GestureDetector(
//                             onTap: () {
//                               // Link to URL here
//                               print("Suggest Improvements Pressed");
//                             },
//                             child: Container(
//                               height: 130,
//                               padding: EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(30),
//                                 border: Border.all(color: Colors.grey.shade400, width: 1), // Thin border
//                               ),
//                               child: Stack(
//                                 children: [
//                                   // Circle Icon at top-left
//                                   Positioned(
//                                     top: 0,
//                                     left: 0,
//                                     child: CircleAvatar(
//                                       backgroundColor: Colors.yellow.shade100,
//                                       radius: 20,
//                                       child: Icon(Icons.lightbulb_outline, color: Colors.grey),
//                                     ),
//                                   ),
//                                   // Text at bottom-left
//                                   Positioned(
//                                     bottom: 0,
//                                     left: 0,
//                                     child: Text(
//                                       "SUGGEST IMPROVEMENTS",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                           ),
//                           const SizedBox(height: 40),
//                           const Text(
//                             "v1.1",
//                             style: TextStyle(
//                               fontFamily: 'DMSans',
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//
//                             ),
//                           ),
//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sachetana_firebase/screens/About%20Us.dart';

void main() {
  runApp(SettingsScreen());
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  Future<void> _handleLogout(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Image Container
          Container(
            height: 350,
            color: Colors.blue, // Replace with your image or color
            width: double.infinity,
            child: Center(
              child: Text(
                "App Logo",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Content below the "General Settings" is now scrollable
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Heading
                  const Text(
                    "GENERAL SETTINGS",
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Row of Two Tiles
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Dark Mode Tile
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isDarkMode =
                                      !isDarkMode; // Toggle dark mode
                                    });
                                  },
                                  child: Container(
                                    height: 130,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1), // Thin border
                                    ),
                                    child: Stack(
                                      children: [
                                        // Circle Icon at top-left
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Transform.scale(
                                            scale: 0.8, // Scale down the switch
                                            child: Switch(
                                              value: isDarkMode,
                                              onChanged: (value) {
                                                setState(() {
                                                  isDarkMode = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        // Text at bottom-left
                                        const Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Text(
                                            "DARK MODE",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Log Out Tile with Icon
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _handleLogout(context),
                                  child: Container(
                                    height: 130,
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1), // Thin border
                                    ),
                                    child: Stack(
                                      children: [
                                        // Circle Icon at top-left
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: CircleAvatar(
                                            backgroundColor:
                                            Colors.red.shade100,
                                            radius: 20,
                                            child: Icon(Icons.logout,
                                                color: Colors.red),
                                          ),
                                        ),
                                        // Text at bottom-left
                                        const Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Text(
                                            "LOG OUT",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
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
                          const SizedBox(height: 20),

                          // About Us Tile
                          GestureDetector(
                            onTap: () {
                              // Action for About Us
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AboutUsScreen())
                              );
                              print("About Us Pressed");
                            },
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1), // Thin border
                              ),
                              child: Stack(
                                children: [
                                  // Circle Icon at top-left
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 20,
                                      child: Icon(Icons.info_outline,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  // Text at bottom-left
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Text(
                                      "ABOUT US",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Suggest Improvements Tile
                          GestureDetector(
                            onTap: () {
                              // Link to URL here
                              print("Suggest Improvements Pressed");
                            },
                            child: Container(
                              height: 130,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1), // Thin border
                              ),
                              child: Stack(
                                children: [
                                  // Circle Icon at top-left
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.yellow.shade100,
                                      radius: 20,
                                      child: Icon(Icons.lightbulb_outline,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  // Text at bottom-left
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Text(
                                      "SUGGEST IMPROVEMENTS",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            "v1.3",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

