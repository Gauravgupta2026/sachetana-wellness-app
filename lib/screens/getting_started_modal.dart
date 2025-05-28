//
// import 'package:flutter/material.dart';
// import 'package:sachetana_firebase/screens/loginSignup/login_modal.dart';
// import 'package:sachetana_firebase/screens/loginSignup/signup_journey.dart';
// import 'package:sachetana_firebase/screens/loginSignup/signup_journey.dart';
// import 'package:sachetana_firebase/screens/loginSignup/login_modal.dart';
// import 'package:sachetana_firebase/screens/loginSignup/signup_screen.dart';
//
// class GettingStartedModal extends StatelessWidget {
//   const GettingStartedModal({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       padding: const EdgeInsets.all(35.0),
//       height: MediaQuery.of(context).size.height * 0.52,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(35), // Rounded corners for all sides
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image above the "Getting Started" text
//           Row(
//             children: [
//               Image.asset(
//                 'assets/icons/sparkling-1.png', // Replace with your image path
//                 height: 50, // Adjust size as needed
//                 width: 50, // Adjust size as needed
//               ),
//             ],
//           ),
//           const SizedBox(height: 40), // Space between title and buttons
//           const Text(
//             "Getting Started",
//             style: TextStyle(fontSize: 45, fontFamily: 'DMSerifDisplay'),
//           ),
//           // Centered button section
//           const SizedBox(height: 30),
//           Center(
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Simulate sign up success and go to home screen
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => SignupJourney()));
//                   },
//                   child: Text('Continue with Sign Up', style: TextStyle(color: Colors.white, fontSize:13, fontFamily: 'DMSans', fontWeight: FontWeight.bold)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10), // Less rounded edges for buttons
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15), // Space between buttons
//                 ElevatedButton(
//                   onPressed: () {
//                     // Simulate sign up success and go to home screen
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginModal()));
//                   },
//                   child: Text('Continue with Log In', style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'DMSans', fontWeight: FontWeight.bold)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo,
//                     padding: EdgeInsets.symmetric(horizontal: 94, vertical: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10), // Less rounded edges for buttons
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20), // Space before the login prompt
//         ],
//       ),
//     );
//   }
// }