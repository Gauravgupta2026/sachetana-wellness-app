// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:async'; // Import for Timer
//
// class SOSModal extends StatefulWidget {
//   const SOSModal({super.key});
//
//   @override
//   _SOSModalState createState() => _SOSModalState();
// }
//
// class _SOSModalState extends State<SOSModal> with SingleTickerProviderStateMixin {
//   bool _isCountingDown = false;
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   Timer? _timer; // Timer to manage countdown
//
//   int _countdownValue = 5; // Countdown starting value
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     );
//
//     // Create an animation that will scale from 1 to 3 (larger final size)
//     _animation = Tween<double>(begin: 1.0, end: 3.0).animate(_controller);
//
//     _controller.addListener(() {
//       if (_controller.isCompleted) {
//         _launchDialer("1800-123-4567"); // Replace with your emergency number
//         setState(() {
//           _isCountingDown = false;
//           _countdownValue = 5; // Reset countdown value
//         });
//         _timer?.cancel(); // Cancel the timer when the countdown completes
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer?.cancel(); // Cancel the timer on dispose
//     super.dispose();
//   }
//
//   void _startCountdown() {
//     setState(() {
//       _isCountingDown = true;
//       _countdownValue = 5; // Reset countdown value
//       _controller.forward(from: 0); // Start the animation from the beginning
//     });
//
//     // Start a timer to update the countdown value every second
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_countdownValue > 0) {
//         setState(() {
//           _countdownValue--; // Decrease countdown value
//         });
//       } else {
//         timer.cancel(); // Stop the timer when it reaches zero
//       }
//     });
//   }
//
//   void _launchDialer(String number) async {
//     final Uri launchUri = Uri(scheme: 'tel', path: number);
//     if (await canLaunchUrl(launchUri)) { // Check if the URL can be launched
//       await launchUrl(launchUri);
//     } else {
//       throw 'Could not launch $launchUri';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // SOS Button, "or" Text, and Scheduling Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (!_isCountingDown) {
//                           _startCountdown();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: const Text(
//                         'SOS',
//                         style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20), // Space between buttons and text
//                   const Text(
//                     'or',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(width: 10), // Space between text and button
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         launchUrl(Uri.parse('https://khmanipal.com/')); // Replace with your URL
//                       },
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.transparent, // No fill color
//                         padding: EdgeInsets.symmetric(vertical: 19),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8), // Optional rounded corners
//                           side: BorderSide(color: Colors.white), // Optional border color
//                         ),
//                       ),
//                       child: const Text(
//                         'Schedule an\nAppointment',
//                         style:
//                         TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'DMSans', fontSize: 22), // Text color
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Separator line
//               Divider(thickness: 1.5, color: Colors.grey),
//
//               SizedBox(height: 5), // Padding above the list
//
//               // List of contacts
//               Expanded(
//                 child: ListView(
//                   children: _buildContactList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Countdown Overlay with enlarging circle animation
//         if (_isCountingDown)
//           Positioned.fill(
//             child:
//             Center(
//                 child:
//                 AnimatedBuilder(
//                   animation:_animation,
//                   builder:(context,child){
//                     return Container(
//                       width:_animation.value *150, // Adjust size as needed for ripple effect (larger size)
//                       height:_animation.value *150,
//                       decoration:
//                       BoxDecoration(color :Colors.red.withOpacity(0.9), shape : BoxShape.circle),
//                     );
//                   },
//                 )
//             ),
//           ),
//
//         // Countdown Timer Text in the center of the screen
//         if (_isCountingDown)
//           Positioned.fill(
//               child:
//               Center(
//                   child:
//                   Text('Calling in $_countdownValue seconds',
//                     style :TextStyle(fontSize :24,color :Colors.white),)
//               )
//           )
//       ],
//     );
//   }
//
//   List<Widget> _buildContactList() {
//     final contacts = [
//       {'name': 'Student Council', 'number': '1234567890'},
//       {'name': 'Counsellor', 'number': '0987654321'},
//       {'name': 'Father', 'number': '5551234567'},
//       {'name': 'Mother', 'number': '4449876543'},
//     ];
//
//     return contacts.map((contact) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             title: Text(contact['name']!),
//             trailing: IconButton(
//               icon: Icon(Icons.phone),
//               onPressed: () => _launchDialer(contact['number']!),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0), // Indent the phone number
//             child:
//             Text(contact['number']!,
//               style:
//               TextStyle(color :Colors.grey[600],fontSize :14),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }
// }


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // Import for Timer
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SOSModal extends StatefulWidget {
  const SOSModal({Key? key}) : super(key: key);

  @override
  _SOSModalState createState() => _SOSModalState();
}

class _SOSModalState extends State<SOSModal> with SingleTickerProviderStateMixin {
  bool _isCountingDown = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer; // Timer to manage countdown

  int _countdownValue = 5; // Countdown starting value

  String? _fathersContact;
  String? _mothersContact;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Create an animation that will scale from 1 to 3 (larger final size)
    _animation = Tween<double>(begin: 1.0, end: 3.0).animate(_controller);

    _controller.addListener(() {
      if (_controller.isCompleted) {
        _launchDialer("1800-123-4567"); // Replace with your emergency number
        setState(() {
          _isCountingDown = false;
          _countdownValue = 5; // Reset countdown value
        });
        _timer?.cancel(); // Cancel the timer when the countdown completes
      }
    });
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _fathersContact = userData['fathersContact'];
          _mothersContact = userData['mothersContact'];
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _countdownValue = 5; // Reset countdown value
      _controller.forward(from: 0); // Start the animation from the beginning
    });

    // Start a timer to update the countdown value every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownValue > 0) {
        setState(() {
          _countdownValue--; // Decrease countdown value
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches zero
      }
    });
  }

  void _launchDialer(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) { // Check if the URL can be launched
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SOS Button, "or" Text, and Scheduling Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_isCountingDown) {
                          _startCountdown();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'SOS',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Space between buttons and text
                  const Text(
                    'or',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 10), // Space between text and button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse('https://khmanipal.com/')); // Replace with your URL
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent, // No fill color
                        padding: EdgeInsets.symmetric(vertical: 19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Optional rounded corners
                          side: BorderSide(color: Colors.white), // Optional border color
                        ),
                      ),
                      child: const Text(
                        'Schedule an\nAppointment',
                        style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'DMSans', fontSize: 22), // Text color
                      ),
                    ),
                  ),
                ],
              ),

              // Separator line
              Divider(thickness: 1.5, color: Colors.grey),

              SizedBox(height: 5), // Padding above the list

              // List of contacts
              Expanded(
                child: ListView(
                  children: _buildContactList(),
                ),
              ),
            ],
          ),
        ),

        // Countdown Overlay with enlarging circle animation
        if (_isCountingDown)
          Positioned.fill(
            child:
            Center(
                child:
                AnimatedBuilder(
                  animation:_animation,
                  builder:(context,child){
                    return Container(
                      width:_animation.value *150, // Adjust size as needed for ripple effect (larger size)
                      height:_animation.value *150,
                      decoration:
                      BoxDecoration(color :Colors.red.withOpacity(0.9), shape : BoxShape.circle),
                    );
                  },
                )
            ),
          ),

        // Countdown Timer Text in the center of the screen
        if (_isCountingDown)
          Positioned.fill(
              child:
              Center(
                  child:
                  Text('Calling in $_countdownValue seconds',
                    style :TextStyle(fontSize :24,color :Colors.white),)
              )
          )
      ],
    );
  }

  List<Widget> _buildContactList() {
    final contacts = [
      {'name': 'Student Council', 'number': '1234567890'},
      {'name': 'Counsellor', 'number': '0987654321'},
      if (_fathersContact != null) {'name': 'Father', 'number': _fathersContact!},
      if (_mothersContact != null) {'name': 'Mother', 'number': _mothersContact!},
    ];

    return contacts.map((contact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(contact['name']!),
            trailing: IconButton(
              icon: Icon(Icons.phone),
              onPressed: () => _launchDialer(contact['number']!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Indent the phone number
            child:
            Text(contact['number']!,
              style:
              TextStyle(color :Colors.grey[600],fontSize :14),
            ),
          ),
        ],
      );
    }).toList();
  }
}