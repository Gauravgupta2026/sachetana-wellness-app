import 'package:flutter/material.dart';


class AboutProject extends StatefulWidget {
  @override
  _AboutProjectState createState() => _AboutProjectState();
}

class _AboutProjectState extends State<AboutProject> {
  bool _isAboutUsVisible = false;

  void _toggleAboutUs() {
    setState(() {
      _isAboutUsVisible = !_isAboutUsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Translucent "About Us" screen
          if (_isAboutUsVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleAboutUs, // Close when tapping outside
                child: Container(
                  color: Colors.black.withOpacity(0.7), // Translucent background
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sachetana',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'A wellness app that helps its users to analyze their mood, made beautifully, backed by science clinically.\n\nA project by MIT x KMC under MAHE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _toggleAboutUs, // Close button
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
