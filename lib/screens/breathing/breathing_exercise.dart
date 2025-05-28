// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter/cupertino.dart';
//
// class BreathingScreen extends StatefulWidget {
//   const BreathingScreen({super.key});
//
//   @override
//   State<BreathingScreen> createState() => _BreathingScreenState();
// }
//
// class _BreathingScreenState extends State<BreathingScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late AnimationController _lottieController; // Controller for Lottie animation
//   late Animation<double> _progress;
//   final ValueNotifier<String> _breathCommand = ValueNotifier<String>("Start");
//   bool _isRunning = false;
//   int elapsedTime = 0;
//   Timer? _timer;
//   bool _isDarkMode = true; // Switched to dark mode initially
//   int _currentCycle = 0;
//   final int _totalCycles = 2; // Two cycles of 4-7-8 breathing
//   int _cycleTime = 0; // Time within the current breathing cycle
//
//   // Function to alternate between 4-7-8 breathing steps
//   void toggleBreathing() {
//     const int inhaleTime = 4; // 4 seconds for "Inhale"
//     const int holdTime = 7; // 7 seconds for "Hold your breath"
//     const int exhaleTime = 8; // 8 seconds for "Exhale"
//     const int totalCycleTime = inhaleTime + holdTime + exhaleTime;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) return;
//       setState(() {
//         _cycleTime++;
//         elapsedTime++;
//
//         if (_cycleTime <= inhaleTime) {
//           _breathCommand.value = "Inhale...";
//         } else if (_cycleTime <= inhaleTime + holdTime) {
//           _breathCommand.value = "Now Hold Your Breath";
//         } else if (_cycleTime <= totalCycleTime) {
//           _breathCommand.value = "Exhale...";
//         }
//
//         // If the cycle is over
//         if (_cycleTime >= totalCycleTime) {
//           _cycleTime = 0;
//           _currentCycle++;
//         }
//
//         // If the exercise is complete (two cycles)
//         if (_currentCycle >= _totalCycles) {
//           _timer?.cancel();
//           _controller.stop();
//           _lottieController.stop(); // Stop the Lottie animation
//           showCompletionDialog(); // Show dialog upon completion
//         }
//       });
//     });
//   }
//
//   // Function to start the breathing exercise
//   void startBreathingExercise() {
//     setState(() {
//       _isRunning = true;
//       elapsedTime = 0;
//       _currentCycle = 0;
//       _cycleTime = 0;
//     });
//     _controller.forward(); // Start the circular animation
//     _lottieController.forward(); // Start the Lottie animation
//     toggleBreathing(); // Start breathing commands
//   }
//
//   // Function to toggle light and dark modes
//   void _toggleDarkMode() {
//     setState(() {
//       _isDarkMode = !_isDarkMode;
//     });
//   }
//
//   Future<bool> _onWillPop() async {
//     return await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Are you sure?'),
//         content: const Text('Do you want to exit the exercise?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () {
//               _controller.stop();
//               _timer?.cancel();
//               setState(() {
//                 _isRunning = false;
//               });
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     ) ??
//         false;
//   }
//
//   void showCompletionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Kudos!'),
//         content: const Text('You have completed your breathing exercise.'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               _controller.stop();
//               _timer?.cancel();
//               setState(() {
//                 _isRunning = false;
//               });
//               Navigator.of(context).pop(); // Exit dialog
//               Navigator.of(context).pop(); // Exit the breathing screen
//             },
//             child: const Text('Done'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 38), // Two cycles of 4-7-8 breathing
//       vsync: this,
//     );
//
//     _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
//       ..addListener(() {
//         if (mounted) {
//           setState(() {});
//         }
//       });
//     _lottieController = AnimationController(vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Material(
//         color: _isDarkMode
//             ? Colors.blue.withOpacity(.1)
//             : Colors.black, // Dark mode swapped to blue initially
//         child: Scaffold(
//           backgroundColor:
//           _isDarkMode ? Colors.blue.withOpacity(.1) : Colors.black,
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 const SizedBox(height: 70),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () async {
//                         if (_isRunning) {
//                           bool shouldExit = await _onWillPop();
//                           if (shouldExit) Navigator.of(context).pop();
//                         } else {
//                           Navigator.of(context).pop();
//                         }
//                       },
//                       icon: Icon(
//                         Icons.keyboard_backspace_rounded,
//                         color: _isDarkMode
//                             ? Colors.blue.shade300
//                             : Colors.white, // Adjust color for the icon
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: _toggleDarkMode, // Toggle dark mode on click
//                       icon: Icon(
//                         _isDarkMode
//                             ? CupertinoIcons.moon_stars_fill
//                             : CupertinoIcons.sun_max_fill,
//                         color: _isDarkMode
//                             ? Colors.blue.shade300
//                             : Colors.white, // Adjust icon color
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox.square(
//                   dimension: MediaQuery.sizeOf(context).width - 40,
//                   child: Stack(
//                     children: [
//                       Positioned.fill(
//                         left: 30,
//                         top: 30,
//                         bottom: 30,
//                         right: 30,
//                         child: CircularProgressIndicator(
//                           color:
//                           _isDarkMode ? Colors.blue.shade300 : Colors.white,
//                           value: _progress.value, // Progress indicator
//                           strokeCap: StrokeCap.round,
//                           strokeWidth: 10,
//                           backgroundColor: _isDarkMode
//                               ? Colors.blue.withOpacity(.4)
//                               : Colors.white.withOpacity(.4),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(1000),
//                           child: Container(
//                             //height: 200,
//                             //width: 200,
//                             color: _isDarkMode
//                                 ? Colors.blue.shade300
//                                 : Colors.white,
//                             child: Transform.scale(
//                               scale: 1,
//                               child: Lottie.asset('assets/animations/breathing.json',
//                                   controller:
//                                   _lottieController, // Use the controller
//                                   onLoaded: (composition) {
//                                     _lottieController.duration =
//                                         composition.duration;
//                                     _lottieController.reset();
//                                   } // Reset at start // Your yoga Lottie animation
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Show Inhale/Exhale/Hold text
//                 AnimatedSwitcher(
//                   duration:
//                   const Duration(milliseconds: 0), // Smooth transition
//                   child: ValueListenableBuilder<String>(
//                     valueListenable: _breathCommand,
//                     builder: (context, value, _) {
//                       return Text(
//                         value,
//                         key: ValueKey<String>(value),
//                         textAlign: value == "Now Hold Your Breath"
//                             ? TextAlign.center
//                             : TextAlign.start, // Center align for hold breath
//                         style: TextStyle(
//                           fontSize: 50,
//                           fontWeight: FontWeight.w900,
//                           color:
//                           _isDarkMode ? Colors.blue.shade300 : Colors.white,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Display the elapsed time
//                 Text(
//                   "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: _isDarkMode
//                         ? Colors.blue.shade300.withOpacity(.7)
//                         : Colors.white.withOpacity(.7),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Start button
//                 if (!_isRunning)
//                   ElevatedButton(
//                     onPressed: startBreathingExercise,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                       _isDarkMode ? Colors.blue.shade300 : Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 10),
//                     ),
//                     child: Text(
//                       "Start",
//                       style: TextStyle(
//                           fontSize: 20,
//                           color: _isDarkMode ? Colors.white : Colors.black),
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//                 Text(
//                   "Relax and follow the breathing pattern\nInhale-Hold-Exhale",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: _isDarkMode
//                         ? Colors.blue.shade300.withOpacity(.7)
//                         : Colors.white.withOpacity(.7),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }
// }
//
