import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/loginSignup/new_signup.dart'; // For Firebase authentication
import 'package:sachetana_firebase/screens/new_sachetana_homepage.dart';
import 'Services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  final AuthServices _authServices = AuthServices(); // AuthServices instance

  // Function to handle login
  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String res;
        // Login with Email and Password
        res = await _authServices.loginUser(email: email, password: password);

      setState(() {
        isLoading = false;
      });

      if (res == "Successfully Logged In") {
        // Login Successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text("Logged In Successfully", style: TextStyle(color: Colors.white)),
              width: 280.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.black),
        );
        // Navigate to HomeScreen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewBuddyhome()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to Login")),
        );
      }
    }
  }


Widget build(BuildContext context) {
    // Screen Width for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/spectral.jpg'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Black card with rounded corners containing login UI
          Center(
            child: SingleChildScrollView(
              child: Container(
              width: screenWidth * 0.85, // Adjust card width as needed
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(45),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Min size for dynamic fitting
                  children: [
                    // Logo image
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Icon(
                        Icons.auto_awesome_sharp, // Replace with your logo or image widget
                        size: 50,
                        color: Colors.white,
                      ),
                    ),

                  // Text: "Welcome to Bud."
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Poppins',
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Subtext: "Begin by creating an account"
                  Padding(
                    padding: const EdgeInsets.only( bottom: 20.0),
                    child: Text(
                      'Continue with Login',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),



                  // Email input field with validation
                  TextFormField(
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35), // Adjust the radius as needed
                        borderSide: BorderSide.none, // No border line
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if ( value == null || value.isEmpty ) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                      return null;
                      },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),

                  // Password input field with validation
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins'),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35), // Adjust the radius as needed
                          borderSide: BorderSide.none, // No border line
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      ),
                      validator: ( value ) {
                        if ( value == null || value.isEmpty ) {
                          return 'Please enter a password';
                        } else if ( value.length < 6 ) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                        },
                      onChanged: ( val ) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                  ),

                  // Forgot Password link
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        // Handle Forgot Password logic
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),


                  // Terms and Privacy Policy
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Handle Forgot Password logic
                  //     },
                  //     child: Text(
                  //       'New User? Sign Up',
                  //       style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'DMSans'),
                  //     ),
                  //   ),
                  // )

                  GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text(
                      "New User? Sign Up",
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'By continuing, you agree to our\nTerms and Privacy Policy',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Continue button
                  ElevatedButton(
                    onPressed: isLoading ? null : _loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 120.0),
                    ),
                    child: isLoading
                      ? CircularProgressIndicator(color: Colors.blueAccent)
                      : const
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                  ),
                ],
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

