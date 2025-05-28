import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:sachetana_firebase/screens/about_project.dart';
import 'package:sachetana_firebase/screens/gemini/const.dart';
import 'package:sachetana_firebase/screens/general_settings.dart';
import 'package:sachetana_firebase/screens/new_homepage.dart';
import 'package:sachetana_firebase/screens/new_sachetana_homepage.dart';
import 'package:sachetana_firebase/screens/welcome_screen.dart';
import 'firebase_options.dart';

void main() async{
  Gemini.init(apiKey: GEMINI_API_KEY,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sachetana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  AuthWrapper(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomePage(isLoggedIn: true),
        '/settings': (context) => SettingsScreen(),
        '/aboutproject': (context) => AboutProject(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return WelcomeScreen();
          }
          return NewBuddyhome();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}