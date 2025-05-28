

import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/loginSignup/new_login.dart';
import 'package:sachetana_firebase/screens/loginSignup/new_signup.dart';
import 'package:dots_indicator/dots_indicator.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  final List<String> _imagePaths = [
    'assets/images/mainbg.png',
    'assets/images/calmrest.jpeg',
    'assets/images/niceview.jpeg',
    'assets/images/twofriends.jpeg',
    'assets/images/ducks.jpg',
  ];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startSlider();
  }

  // auto-slide images every 1.5s
  void _startSlider() {
    Future.delayed(Duration(milliseconds: 1600), () {
      if(_pageController.hasClients) {
        setState(() {
          _currentIndex = ( _currentIndex + 1) % _imagePaths.length;
          _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 700), curve: Curves.easeIn,
          );
        });
        _startSlider(); // continue the sliding
      }
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          PageView.builder(
            controller: _pageController,
            itemCount: _imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_imagePaths[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          // Black gradient container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(1.0),
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sachetana text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Sachetana',
                  style: TextStyle(
                    fontFamily: 'Tangerine',
                    color: Colors.white,
                    fontSize: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  'We help you collect your emotions together',
                  textAlign: TextAlign.center, // Aligning subtext to center
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Poppins'
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Dotted progress bar
              DotsIndicator(
                dotsCount: _imagePaths.length,
                position: _currentIndex.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Colors.deepOrangeAccent,
                  color: Colors.white,
                  size: const Size.square(6.0),
                  activeSize:  const Size(10, 10),
                  spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
              ),


              SizedBox(height: 40),
              // Buttons: Sign Up and Log In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sign Up button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text('Sign Up',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Log In button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Log In',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 55, vertical: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40), // Space at the bottom
              // Align Terms of Use | Privacy Policy to center
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Terms of Use', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                    SizedBox(width: 12), // Space between texts
                    Text('|', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                    SizedBox(width: 12), // Space between texts
                    Text('Privacy Policy', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                  ],
                ),
              ),
              SizedBox(height: 80), // Space below the bottom text
            ],
          ),

          // Circular Logos on the top left corner
          Positioned(
            top: 70, // Adjust as needed
            left: 30, // Adjust as needed
            child: Row(
              children: [
                ClipOval( // Circular logo for the first logo
                  child: Image.asset(
                    'assets/images/gerbera.png', // Replace with your actual logo path
                    height: 50, // Adjust size as needed
                    width: 50, // Adjust size as needed
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15), // Space between logos
                ClipOval( // Circular logo for the second logo
                  child: Image.asset(
                    'assets/images/mitlogo.png', // Replace with your actual logo path
                    height: 55, // Adjust size as needed
                    width: 55, // Adjust size as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
