import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meditator_app/screens/home_screen.dart';    // Import HomeScreen
import 'package:meditator_app/screens/login_screen.dart';
import 'package:meditator_app/services/auth_service.dart';   // Import AuthService
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Initialize Firebase and check if the user is logged in
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // Function to simulate loading resources and check authentication state
  Future<void> _initializeApp() async {
    await Firebase.initializeApp();  // Initialize Firebase
    await Future.delayed(Duration(seconds: 5));  // Show splash screen for 5 seconds

    // Check if the user is already logged in
    if (AuthService().getCurrentUser() != null) {
      // Navigate to Home screen if the user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Navigate to Startup screen if the user is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF3DC),  // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie Animation at the center of the screen
            Lottie.asset(
              'assets/animations/meditator.json',  // Lottie animation file
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            // App name at the bottom of the screen
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Meditator App',  // App name
                style: TextStyle(
                  fontFamily: 'HelveticaNeue-Bold.otf',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,  // Set text color to black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
