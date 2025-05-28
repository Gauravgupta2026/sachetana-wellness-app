

import 'package:flutter/material.dart';

class FloatingNav extends StatefulWidget {
  final Function onHomeTap;
  final Function onMenuTap;
  final Function onChatBotTap;

  const FloatingNav({
    Key? key,
    required this.onHomeTap,
    required this.onMenuTap,
    required this.onChatBotTap,
  }) : super(key: key);

  @override
  _FloatingNavState createState() => _FloatingNavState();
}

class _FloatingNavState extends State<FloatingNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            color: _currentIndex == 0 ? Colors.pinkAccent : Colors.black,
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
              widget.onHomeTap();
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            color: _currentIndex == 1 ? Colors.pinkAccent : Colors.black,
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
              widget.onMenuTap();
            },
          ),
          IconButton(
            icon: Icon(Icons.auto_awesome_sharp), // Sparkle button
            color: _currentIndex == 2 ? Colors.pinkAccent : Colors.black,
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
              widget.onChatBotTap(); // Navigate to GeminiIntroScreen
            },
          ),
        ],
      ),
    );
  }
}
