
import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/loginSignup/new_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/authentication.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isStudent = false;
  bool showLoginPrompt = false;
  bool signUpSuccessful = false; // New variable for button text and color change

  Future<void> signUpUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String result = await AuthServices().signUpUser(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          phoneNum: phoneController.text,
        );

        if (result == "Successfully\nSigned Up") {
          setState(() {
            signUpSuccessful = true; // Indicates successful sign-up
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(

              content: const Text(
                "Sign Up\nSuccessful",
                style: TextStyle(color: Colors.white, fontSize: 13),

              ),
              width: 350.0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 15),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Handle sign-up failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(

              content: const Text(
                "Sign Up Failed",
                style: TextStyle(color: Colors.white, fontSize: 13),

              ),
              width: 350.0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 15),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void proceedToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/spectral.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome_sharp,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome to Sachetana.',
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'DMSans',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Begin creating your account',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: proceedToLogin,
                          child: Text(
                            'Existing User? Login',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DMSans'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                          nameController, 'Name', 'Please enter your name'),
                      const SizedBox(height: 10),
                      _buildTextField(phoneController, 'Phone Number',
                          'Please enter your phone number'),
                      const SizedBox(height: 10),
                      _buildEmailField(),
                      const SizedBox(height: 10),
                      _buildPasswordField(),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isStudent = !isStudent;
                              });
                            },
                            child: Center(
                              child: Icon(
                                isStudent ? Icons.check : Icons.circle_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "This app is meant for the students of MAHE and the officials as well. If you are a student, check the circle",
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                  width: 350.0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 15),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            },
                            child: const Text(
                              "Are you a student?",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'DMSans'),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'By continuing, you agree to our\nTerms and Privacy Policy',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: signUpSuccessful ? proceedToLogin : signUpUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: signUpSuccessful
                              ? Colors.blue
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 17.0, horizontal: 130.0),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                            color: Colors.blueAccent)
                            : Text(
                          signUpSuccessful ? 'Proceed to Login' : 'Sign Up',
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
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

  Widget _buildTextField(TextEditingController controller, String labelText,
      String validationMessage) {
    return TextFormField(
      style: const TextStyle(
          color: Colors.white, fontSize: 12, fontFamily: 'DMSans'),
      controller: controller,
      decoration: InputDecoration(
          hintText: labelText,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 11),
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35),
              borderSide: BorderSide.none),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      style: const TextStyle(
          color: Colors.white, fontSize: 12, fontFamily: 'DMSans'),
      controller: emailController,
      decoration: InputDecoration(
          hintText: 'Email ID',
          hintStyle: const TextStyle(
              color: Colors.white70, fontFamily: 'DMSans', fontSize: 12),
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35),
              borderSide: BorderSide.none),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: const TextStyle(
          color: Colors.white, fontSize: 12, fontFamily: 'DMSans'),
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(
              color: Colors.white70, fontFamily: 'DMSans', fontSize: 12),
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35),
              borderSide: BorderSide.none),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }
}
