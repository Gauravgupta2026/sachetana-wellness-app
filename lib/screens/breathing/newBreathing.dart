import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late VideoPlayerController _videoController;
  late Animation<double> _progress;
  bool _isRunning = false;
  int elapsedTime = 0;
  Timer? _timer;
  bool _isDarkMode = true;
  final int _totalDuration =
      66; // Total duration in seconds (matching video length)
  int remainingTime = 66; // Start countdown from total duration

  final Color themeColor = const Color.fromRGBO(49, 169, 134, 1); // Green shade

  void toggleBreathing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        elapsedTime++;
        remainingTime--;

        if (remainingTime <= 0) {
          _timer?.cancel();
          _controller.stop();
          _videoController.pause();
          showCompletionDialog();
        }
      });
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      elapsedTime = 0;
      remainingTime = _totalDuration;
    });
    _controller.forward();
    _videoController.play();
    toggleBreathing();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the exercise?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _controller.stop();
                  _timer?.cancel();
                  _videoController.pause();
                  setState(() {
                    _isRunning = false;
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kudos!'),
        content: const Text('You have completed your breathing exercise.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _controller.stop();
              _timer?.cancel();
              _videoController.pause();
              setState(() {
                _isRunning = false;
              });
              Navigator.of(context).pop(); // Exit dialog
              Navigator.of(context).pop(); // Exit the breathing screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 66), // Match duration to video length
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    // Initialize video controller
    _videoController = VideoPlayerController.asset('assets/video/breathing.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        color: themeColor.withOpacity(0.1),
        child: Scaffold(
          backgroundColor: themeColor.withOpacity(0.1),
          body: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (_isRunning) {
                        bool shouldExit = await _onWillPop();
                        if (shouldExit) Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: themeColor,
                    ),
                  ),
                  Text(
                    "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 16,
                      color: themeColor.withOpacity(0.7),
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleDarkMode,
                    icon: Icon(
                      _isDarkMode
                          ? CupertinoIcons.moon_stars_fill
                          : CupertinoIcons.sun_max_fill,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (_videoController.value.isInitialized) ...[
                SizedBox.square(
                  dimension: MediaQuery.sizeOf(context).width - 40,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        left: 30,
                        top: 30,
                        bottom: 30,
                        right: 30,
                        child: CircularProgressIndicator(
                          color: themeColor,
                          value: _progress.value,
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
                          backgroundColor: themeColor.withOpacity(0.4),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).width - 80,
                            width: MediaQuery.sizeOf(context).width - 80,
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                "Relax and follow the breathing pattern",
                style: TextStyle(
                  fontSize: 16,
                  color: themeColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              if (!_isRunning)
                ElevatedButton(
                  onPressed: startBreathingExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                  ),
                  child: Text(
                    "Start",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late VideoPlayerController _videoController;
  late Animation<double> _progress;
  bool _isRunning = false;
  int elapsedTime = 0;
  Timer? _timer;
  bool _isDarkMode = true;
  final int _totalDuration =
      66; // Total duration in seconds (matching video length)
  int remainingTime = 66; // Start countdown from total duration

  // Set the theme color to a green shade similar to the one inside the circle
  final Color themeColor = const Color.fromRGBO(
      49, 169, 134, 1); // Replace with exact green if needed

  void toggleBreathing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        elapsedTime++;
        remainingTime--;

        if (remainingTime <= 0) {
          _timer?.cancel();
          _controller.stop();
          _videoController.pause();
          showCompletionDialog();
        }
      });
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      elapsedTime = 0;
      remainingTime = _totalDuration;
    });
    _controller.forward();
    _videoController.play();
    toggleBreathing();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the exercise?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _controller.stop();
                  _timer?.cancel();
                  _videoController.pause();
                  setState(() {
                    _isRunning = false;
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kudos!'),
        content: const Text('You have completed your breathing exercise.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _controller.stop();
              _timer?.cancel();
              _videoController.pause();
              setState(() {
                _isRunning = false;
              });
              Navigator.of(context).pop(); // Exit dialog
              Navigator.of(context).pop(); // Exit the breathing screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 66), // Match duration to video length
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    // Initialize video controller
    _videoController = VideoPlayerController.asset('assets/breathing.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        color: themeColor.withOpacity(0.1),
        child: Scaffold(
          backgroundColor: themeColor.withOpacity(0.1),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_isRunning) {
                          bool shouldExit = await _onWillPop();
                          if (shouldExit) Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_backspace_rounded,
                        color: themeColor,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleDarkMode,
                      icon: Icon(
                        _isDarkMode
                            ? CupertinoIcons.moon_stars_fill
                            : CupertinoIcons.sun_max_fill,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_videoController.value.isInitialized) ...[
                  SizedBox.square(
                    dimension: MediaQuery.sizeOf(context).width - 40,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          left: 30,
                          top: 30,
                          bottom: 30,
                          right: 30,
                          child: CircularProgressIndicator(
                            color: themeColor,
                            value: _progress.value,
                            strokeCap: StrokeCap.round,
                            strokeWidth: 10,
                            backgroundColor: themeColor.withOpacity(0.4),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ClipOval(
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).width - 80,
                              width: MediaQuery.sizeOf(context).width - 80,
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Display the elapsed time
                Text(
                  "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 20,
                    color: themeColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 20),
                // Start button
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: startBreathingExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  "Relax and follow the breathing pattern",
                  style: TextStyle(
                    fontSize: 16,
                    color: themeColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toggle dark mode without changing functionality here
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

*/
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _lottieController; // Controller for Lottie animation
  late Animation<double> _progress;
  final ValueNotifier<String> _breathCommand =
      ValueNotifier<String>("Inhale...");
  bool _isRunning = false;
  Timer? _timer;
  bool _isDarkMode = true; // Switched to dark mode initially
  int _currentCycle = 0;
  final int _totalCycles = 2; // Two cycles of 4-7-8 breathing
  int _cycleTime = 0; // Time within the current breathing cycle
  final int _totalDuration = 38; // Total exercise duration in seconds
  int remainingTime = 38; // Time remaining, starting from total duration

  // Function to alternate between 4-7-8 breathing steps
  void toggleBreathing() {
    const int inhaleTime = 4; // 4 seconds for "Inhale"
    const int holdTime = 7; // 7 seconds for "Hold your breath"
    const int exhaleTime = 8; // 8 seconds for "Exhale"
    const int totalCycleTime = inhaleTime + holdTime + exhaleTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _cycleTime++;
        remainingTime--; // Countdown from total duration

        if (_cycleTime <= inhaleTime) {
          _breathCommand.value = "Inhale...";
        } else if (_cycleTime <= inhaleTime + holdTime) {
          _breathCommand.value = "Now Hold Your Breath";
        } else if (_cycleTime <= totalCycleTime) {
          _breathCommand.value = "Exhale...";
        }

        // If the cycle is over
        if (_cycleTime >= totalCycleTime) {
          _cycleTime = 0;
          _currentCycle++;
        }

        // If the exercise is complete (two cycles)
        if (_currentCycle >= _totalCycles || remainingTime <= 0) {
          _timer?.cancel();
          _controller.stop();
          _lottieController.stop(); // Stop the Lottie animation
          showCompletionDialog(); // Show dialog upon completion
        }
      });
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      _currentCycle = 0;
      _cycleTime = 0;
      remainingTime = _totalDuration; // Reset remaining time
    });
    _controller.forward(); // Start the circular animation
    _lottieController.forward(); // Start the Lottie animation
    toggleBreathing(); // Start breathing commands
  }

  // Function to toggle light and dark modes
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the exercise?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _controller.stop();
                  _timer?.cancel();
                  setState(() {
                    _isRunning = false;
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kudos!'),
        content: const Text('You have completed your breathing exercise.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _controller.stop();
              _timer?.cancel();
              setState(() {
                _isRunning = false;
              });
              Navigator.of(context).pop(); // Exit dialog
              Navigator.of(context).pop(); // Exit the breathing screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 38), // Two cycles of 4-7-8 breathing
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _lottieController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        color: _isDarkMode
            ? Colors.blue.withOpacity(.1)
            : Colors.black, // Dark mode swapped to blue initially
        child: Scaffold(
          backgroundColor:
              _isDarkMode ? Colors.blue.withOpacity(.1) : Colors.black,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_isRunning) {
                          bool shouldExit = await _onWillPop();
                          if (shouldExit) Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_backspace_rounded,
                        color: _isDarkMode
                            ? Colors.blue.shade300
                            : Colors.white, // Adjust color for the icon
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleDarkMode, // Toggle dark mode on click
                      icon: Icon(
                        _isDarkMode
                            ? CupertinoIcons.moon_stars_fill
                            : CupertinoIcons.sun_max_fill,
                        color: _isDarkMode
                            ? Colors.blue.shade300
                            : Colors.white, // Adjust icon color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox.square(
                  dimension: MediaQuery.sizeOf(context).width - 40,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        left: 30,
                        top: 30,
                        bottom: 30,
                        right: 30,
                        child: CircularProgressIndicator(
                          color:
                              _isDarkMode ? Colors.blue.shade300 : Colors.white,
                          value: _progress.value, // Progress indicator
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
                          backgroundColor: _isDarkMode
                              ? Colors.blue.withOpacity(.4)
                              : Colors.white.withOpacity(.4),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Container(
                            //height: 200,
                            //width: 200,
                            color: _isDarkMode
                                ? Colors.blue.shade300
                                : Colors.white,
                            child: Transform.scale(
                              scale: 1,
                              child: Lottie.asset('assets/lottie/breathe.json',
                                  controller:
                                      _lottieController, // Use the controller
                                  onLoaded: (composition) {
                                _lottieController.duration =
                                    composition.duration;
                                _lottieController.reset();
                              } // Reset at start // Your yoga Lottie animation
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Show Inhale/Exhale/Hold text
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 500), // Smooth transition
                  child: ValueListenableBuilder<String>(
                    valueListenable: _breathCommand,
                    builder: (context, value, _) {
                      return Text(
                        value,
                        key: ValueKey<String>(value),
                        textAlign: value == "Now Hold Your Breath"
                            ? TextAlign.center
                            : TextAlign.start, // Center align for hold breath
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color:
                              _isDarkMode ? Colors.blue.shade300 : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Display the remaining time as a countdown
                Text(
                  "Remaining Time: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}", // Countdown format as MM:SS
                  style: TextStyle(
                    fontSize: 20,
                    color: _isDarkMode
                        ? Colors.blue.shade300.withOpacity(.7)
                        : Colors.white.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 20),
                // Start button
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: startBreathingExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isDarkMode ? Colors.blue.shade300 : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(
                          fontSize: 20,
                          color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  "Relax and follow the breathing pattern\n                Inhale-Hold-Exhale",
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode
                        ? Colors.blue.shade300.withOpacity(.7)
                        : Colors.white.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the main animation controller
    _lottieController.dispose(); // Dispose the Lottie animation controller
    _timer?.cancel(); // Cancel the timer if it's still active
    super.dispose(); // Call the superclass' dispose method
  }
}
*/
/*
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _lottieController; // Controller for Lottie animation
  late Animation<double> _progress;
  final ValueNotifier<String> _breathCommand = ValueNotifier<String>("Start");
  bool _isRunning = false;
  int elapsedTime = 0;
  Timer? _timer;
  bool _isDarkMode = true; // Switched to dark mode initially
  int _currentCycle = 0;
  final int _totalCycles = 2; // Two cycles of 4-7-8 breathing
  int _cycleTime = 0; // Time within the current breathing cycle

  // Function to alternate between 4-7-8 breathing steps
  void toggleBreathing() {
    const int inhaleTime = 4; // 4 seconds for "Inhale"
    const int holdTime = 7; // 7 seconds for "Hold your breath"
    const int exhaleTime = 8; // 8 seconds for "Exhale"
    const int totalCycleTime = inhaleTime + holdTime + exhaleTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _cycleTime++;
        elapsedTime++;

        if (_cycleTime <= inhaleTime) {
          _breathCommand.value = "Inhale...";
        } else if (_cycleTime <= inhaleTime + holdTime) {
          _breathCommand.value = "Now Hold Your Breath";
        } else if (_cycleTime <= totalCycleTime) {
          _breathCommand.value = "Exhale...";
        }

        // If the cycle is over
        if (_cycleTime >= totalCycleTime) {
          _cycleTime = 0;
          _currentCycle++;
        }

        // If the exercise is complete (two cycles)
        if (_currentCycle >= _totalCycles) {
          _timer?.cancel();
          _controller.stop();
          _lottieController.stop(); // Stop the Lottie animation
          showCompletionDialog(); // Show dialog upon completion
        }
      });
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      elapsedTime = 0;
      _currentCycle = 0;
      _cycleTime = 0;
    });
    _controller.forward(); // Start the circular animation
    _lottieController.forward(); // Start the Lottie animation
    toggleBreathing(); // Start breathing commands
  }

  // Function to toggle light and dark modes
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the exercise?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _controller.stop();
                  _timer?.cancel();
                  setState(() {
                    _isRunning = false;
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kudos!'),
        content: const Text('You have completed your breathing exercise.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _controller.stop();
              _timer?.cancel();
              setState(() {
                _isRunning = false;
              });
              Navigator.of(context).pop(); // Exit dialog
              Navigator.of(context).pop(); // Exit the breathing screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 38), // Two cycles of 4-7-8 breathing
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _lottieController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        color: _isDarkMode
            ? Colors.blue.withOpacity(.1)
            : Colors.black, // Dark mode swapped to blue initially
        child: Scaffold(
          backgroundColor:
              _isDarkMode ? Colors.blue.withOpacity(.1) : Colors.black,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_isRunning) {
                          bool shouldExit = await _onWillPop();
                          if (shouldExit) Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_backspace_rounded,
                        color: _isDarkMode
                            ? Colors.blue.shade300
                            : Colors.white, // Adjust color for the icon
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleDarkMode, // Toggle dark mode on click
                      icon: Icon(
                        _isDarkMode
                            ? CupertinoIcons.moon_stars_fill
                            : CupertinoIcons.sun_max_fill,
                        color: _isDarkMode
                            ? Colors.blue.shade300
                            : Colors.white, // Adjust icon color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox.square(
                  dimension: MediaQuery.sizeOf(context).width - 40,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        left: 30,
                        top: 30,
                        bottom: 30,
                        right: 30,
                        child: CircularProgressIndicator(
                          color:
                              _isDarkMode ? Colors.blue.shade300 : Colors.white,
                          value: _progress.value, // Progress indicator
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
                          backgroundColor: _isDarkMode
                              ? Colors.blue.withOpacity(.4)
                              : Colors.white.withOpacity(.4),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Container(
                            //height: 200,
                            //width: 200,
                            color: _isDarkMode
                                ? Colors.blue.shade300
                                : Colors.white,
                            child: Transform.scale(
                              scale: 1,
                              child: Lottie.asset('assets/lottie/breathe.json',
                                  controller:
                                      _lottieController, // Use the controller
                                  onLoaded: (composition) {
                                _lottieController.duration =
                                    composition.duration;
                                _lottieController.reset();
                              } // Reset at start // Your yoga Lottie animation
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Show Inhale/Exhale/Hold text
                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 0), // Smooth transition
                  child: ValueListenableBuilder<String>(
                    valueListenable: _breathCommand,
                    builder: (context, value, _) {
                      return Text(
                        value,
                        key: ValueKey<String>(value),
                        textAlign: value == "Now Hold Your Breath"
                            ? TextAlign.center
                            : TextAlign.start, // Center align for hold breath
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color:
                              _isDarkMode ? Colors.blue.shade300 : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Display the elapsed time
                Text(
                  "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
                  style: TextStyle(
                    fontSize: 20,
                    color: _isDarkMode
                        ? Colors.blue.shade300.withOpacity(.7)
                        : Colors.white.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 20),
                // Start button
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: startBreathingExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isDarkMode ? Colors.blue.shade300 : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(
                          fontSize: 20,
                          color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  "Relax and follow the breathing pattern\n                Inhale-Hold-Exhale",
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode
                        ? Colors.blue.shade300.withOpacity(.7)
                        : Colors.white.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
*/

/*
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  final ValueNotifier<String> _breathCommand = ValueNotifier<String>("Start");
  bool _isRunning = false;
  int elapsedTime = 0;
  Timer? _timer;
  bool _isDarkMode = false;
  int _currentCycle = 0;
  final int _totalCycles = 2; // Two cycles of 4-7-8 breathing
  int _cycleTime = 0; // Time within the current breathing cycle

  // Function to alternate between 4-7-8 breathing steps
  void toggleBreathing() {
    const int inhaleTime = 4; // 4 seconds for "Inhale"
    const int holdTime = 7; // 7 seconds for "Hold your breath"
    const int exhaleTime = 8; // 8 seconds for "Exhale"
    const int totalCycleTime = inhaleTime + holdTime + exhaleTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _cycleTime++;
        elapsedTime++;

        if (_cycleTime <= inhaleTime) {
          _breathCommand.value = "Inhale...";
        } else if (_cycleTime <= inhaleTime + holdTime) {
          _breathCommand.value = "Now Hold your breath";
        } else if (_cycleTime <= totalCycleTime) {
          _breathCommand.value = "Exhale...";
        }

        // If the cycle is over
        if (_cycleTime >= totalCycleTime) {
          _cycleTime = 0;
          _currentCycle++;
        }

        // If the exercise is complete (two cycles)
        if (_currentCycle >= _totalCycles) {
          _timer?.cancel();
          _controller.stop();
          showCompletionDialog(); // Show dialog upon completion
        }
      });
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      elapsedTime = 0;
      _currentCycle = 0;
      _cycleTime = 0;
    });
    _controller.forward(); // Start the circular animation
    toggleBreathing(); // Start breathing commands
  }

  // Function to toggle dark mode
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the exercise?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _controller.stop();
                  _timer?.cancel();
                  setState(() {
                    _isRunning = false;
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kudos!'),
        content: const Text('You have completed your breathing exercise.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _controller.stop();
              _timer?.cancel();
              setState(() {
                _isRunning = false;
              });
              Navigator.of(context).pop(); // Exit dialog
              Navigator.of(context).pop(); // Exit the breathing screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 38), // Two cycles of 4-7-8 breathing
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        color: _isDarkMode
            ? Colors.black
            : Colors.white, // Adjust color based on dark mode
        child: Scaffold(
          backgroundColor:
              _isDarkMode ? Colors.black : Colors.blue.withOpacity(.1),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_isRunning) {
                          bool shouldExit = await _onWillPop();
                          if (shouldExit) Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_backspace_rounded,
                        color: _isDarkMode
                            ? Colors.white
                            : Colors.blue.shade300, // Adjust color for the icon
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleDarkMode, // Toggle dark mode on click
                      icon: Icon(
                        _isDarkMode
                            ? CupertinoIcons.sun_max_fill
                            : CupertinoIcons.moon_stars_fill,
                        color: _isDarkMode
                            ? Colors.white
                            : Colors.blue.shade300, // Adjust icon color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox.square(
                  dimension: MediaQuery.sizeOf(context).width - 40,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        left: 30,
                        top: 30,
                        bottom: 30,
                        right: 30,
                        child: CircularProgressIndicator(
                          color:
                              _isDarkMode ? Colors.white : Colors.blue.shade300,
                          value: _progress.value, // Progress indicator
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
                          backgroundColor: _isDarkMode
                              ? Colors.white.withOpacity(.4)
                              : Colors.blue.withOpacity(.4),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Container(
                            padding: const EdgeInsets.only(top: 120, left: 20),
                            height: 200,
                            width: 200,
                            color: _isDarkMode
                                ? Colors.white
                                : Colors.blue.shade300,
                            child: Transform.scale(
                              scale: 3,
                              child: Lottie.asset(
                                  'assets/lottie/yoga.json'), // Your yoga Lottie animation
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Show Inhale/Exhale/Hold text
                ValueListenableBuilder<String>(
                  valueListenable: _breathCommand,
                  builder: (context, value, _) {
                    return Text(
                      value,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        color:
                            _isDarkMode ? Colors.white : Colors.blue.shade300,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Display the elapsed time
                Text(
                  "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
                  style: TextStyle(
                    fontSize: 20,
                    color: _isDarkMode
                        ? Colors.white.withOpacity(.7)
                        : Colors.blue.shade300.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 20),
                // Start button
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: startBreathingExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isDarkMode ? Colors.white : Colors.blue.shade300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(
                          fontSize: 20,
                          color: _isDarkMode ? Colors.black : Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  "Relax and follow the breathing pattern",
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode
                        ? Colors.white.withOpacity(.7)
                        : Colors.blue.shade300.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
*/

/*

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  final ValueNotifier<String> _breathCommand =
      ValueNotifier<String>("Inhale"); // Control breathing commands
  bool _isExhaling = false; // To toggle between "Inhale" and "Exhale"
  bool _isRunning = false; // To track whether the timer is running or not
  int elapsedTime = 0; // To track elapsed time in seconds
  Timer? _timer;
  bool _isDarkMode = false; // Track if dark mode is on

  // Function to alternate between Inhale and Exhale
  void toggleBreathing() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _isExhaling = !_isExhaling;
          _breathCommand.value = _isExhaling ? "Exhale..." : "Inhale...";
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      elapsedTime = 0;
    });
    _controller.forward(); // Start the circular animation
    toggleBreathing(); // Start breathing commands
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        setState(() {
          elapsedTime++; // Update elapsed time every second
        });
      } else {
        timer.cancel(); // Stop the timer if the exercise is no longer running
      }
    });
  }

  // Function to toggle dark mode
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 180), // 4 minutes (240 seconds)
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _isDarkMode
          ? Colors.black
          : Colors.white, // Adjust color based on dark mode
      child: Scaffold(
        backgroundColor:
            _isDarkMode ? Colors.black : Colors.blue.withOpacity(.1),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Back button functionality
                    },
                    icon: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: _isDarkMode
                          ? Colors.white
                          : Colors.blue.shade300, // Adjust color for the icon
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleDarkMode, // Toggle dark mode on click
                    icon: Icon(
                      _isDarkMode
                          ? CupertinoIcons.sun_max_fill
                          : CupertinoIcons.moon_stars_fill,
                      color: _isDarkMode
                          ? Colors.white
                          : Colors.blue.shade300, // Adjust icon color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox.square(
                dimension: MediaQuery.sizeOf(context).width - 40,
                child: Stack(
                  children: [
                    Positioned.fill(
                      left: 30,
                      top: 30,
                      bottom: 30,
                      right: 30,
                      child: CircularProgressIndicator(
                        color:
                            _isDarkMode ? Colors.white : Colors.blue.shade300,
                        value: _progress.value, // Progress indicator
                        strokeCap: StrokeCap.round,
                        strokeWidth: 10,
                        backgroundColor: _isDarkMode
                            ? Colors.white.withOpacity(.4)
                            : Colors.blue.withOpacity(.4),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Container(
                          padding: const EdgeInsets.only(top: 120, left: 20),
                          height: 200,
                          width: 200,
                          color:
                              _isDarkMode ? Colors.white : Colors.blue.shade300,
                          child: Transform.scale(
                            scale: 3,
                            child: Lottie.asset(
                                'assets/lottie/yoga.json'), // Your yoga Lottie animation
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Show Inhale/Exhale text
              ValueListenableBuilder<String>(
                valueListenable: _breathCommand,
                builder: (context, value, _) {
                  return Text(
                    value,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: _isDarkMode ? Colors.white : Colors.blue.shade300,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Display the elapsed time
              Text(
                "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
                style: TextStyle(
                  fontSize: 20,
                  color: _isDarkMode
                      ? Colors.white.withOpacity(.7)
                      : Colors.blue.shade300.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 20),
              // Start button
              if (!_isRunning)
                ElevatedButton(
                  onPressed: startBreathingExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isDarkMode ? Colors.white : Colors.blue.shade300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                  ),
                  child: Text(
                    "Start",
                    style: TextStyle(
                        fontSize: 20,
                        color: _isDarkMode ? Colors.black : Colors.white),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                "Relax and follow the breathing pattern",
                style: TextStyle(
                  fontSize: 16,
                  color: _isDarkMode
                      ? Colors.white.withOpacity(.7)
                      : Colors.blue.shade300.withOpacity(.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
*/
/*
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  final ValueNotifier<String> _breathCommand =
      ValueNotifier<String>("Inhale"); // Control breathing commands
  bool _isExhaling = false; // To toggle between "Inhale" and "Exhale"
  bool _isRunning = false; // To track whether the timer is running or not
  int elapsedTime = 0; // To track elapsed time in seconds
  Timer? _timer;

  // Function to alternate between Inhale and Exhale
  void toggleBreathing() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          _isExhaling = !_isExhaling;
          _breathCommand.value = _isExhaling ? "Exhale..." : "Inhale...";
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Function to start the breathing exercise
  void startBreathingExercise() {
    setState(() {
      _isRunning = true;
      elapsedTime = 0;
    });
    _controller.forward(); // Start the circular animation
    toggleBreathing(); // Start breathing commands
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        setState(() {
          elapsedTime++; // Update elapsed time every second
        });
      } else {
        timer.cancel(); // Stop the timer if the exercise is no longer running
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 180), // 4 minutes (240 seconds)
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // Adjust background color
      child: Scaffold(
        backgroundColor: Colors.blue
            .withOpacity(.1), // Adjust the background opacity if needed
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Back button functionality
                    },
                    icon: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: Colors.blue.shade300, // Adjust color for the icon
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox.square(
                dimension: MediaQuery.sizeOf(context).width - 40,
                child: Stack(
                  children: [
                    Positioned.fill(
                      left: 30,
                      top: 30,
                      bottom: 30,
                      right: 30,
                      child: CircularProgressIndicator(
                        color: Colors.blue.shade300,
                        value: _progress.value, // Progress indicator
                        strokeCap: StrokeCap.round,
                        strokeWidth: 10,
                        backgroundColor: Colors.blue.withOpacity(.4),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Container(
                          padding: const EdgeInsets.only(top: 120, left: 20),
                          height: 200,
                          width: 200,
                          color: Colors.blue.shade300,
                          child: Transform.scale(
                            scale: 3,
                            child: Lottie.asset(
                                'assets/lottie/yoga.json'), // Your yoga Lottie animation
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Show Inhale/Exhale text
              ValueListenableBuilder<String>(
                valueListenable: _breathCommand,
                builder: (context, value, _) {
                  return Text(
                    value,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue.shade300,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Display the elapsed time
              Text(
                "Elapsed Time: ${elapsedTime ~/ 60}:${(elapsedTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue.shade300.withOpacity(.7),
                ),
              ),
              const SizedBox(height: 20),
              // Start button
              if (!_isRunning)
                ElevatedButton(
                  onPressed: startBreathingExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                "Relax and follow the breathing pattern",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade300.withOpacity(.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}


class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  final ValueNotifier<String> _breathCommand =
      ValueNotifier<String>("Inhale"); // Control breathing commands
  bool _isExhaling = false; // To toggle between "Inhale" and "Exhale"

  // Function to alternate between Inhale and Exhale
  void toggleBreathing() {
    Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          _isExhaling = !_isExhaling;
          _breathCommand.value = _isExhaling ? "Inhale..." : "Exhale...";
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward(); // Automatically start the animation
    toggleBreathing(); // Start breathing commands
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // Adjust background color
      child: Scaffold(
        backgroundColor: Colors.blue
            .withOpacity(.1), // Adjust the background opacity if needed
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Back button functionality
                    },
                    icon: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: Colors.blue.shade300, // Adjust color for the icon
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox.square(
                dimension: MediaQuery.sizeOf(context).width - 40,
                child: Stack(
                  children: [
                    Positioned.fill(
                      left: 30,
                      top: 30,
                      bottom: 30,
                      right: 30,
                      child: ValueListenableBuilder<double>(
                          valueListenable: _controller,
                          builder: (context, value, _) {
                            return CircularProgressIndicator(
                              color: Colors.blue.shade300,
                              value: value,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 10,
                              backgroundColor: Colors.blue.withOpacity(.4),
                            );
                          }),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Container(
                          padding: const EdgeInsets.only(top: 120, left: 20),
                          height: 200,
                          width: 200,
                          color: Colors.blue.shade300,
                          child: Transform.scale(
                            scale: 3,
                            child: Lottie.asset(
                                'assets/lottie/monkeyyoga.json'), // Your yoga Lottie animation
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: _breathCommand,
                builder: (context, value, _) {
                  return Text(
                    value,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue.shade300,
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Text(
                "Relax and follow the breathing pattern",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade300.withOpacity(.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
*/
