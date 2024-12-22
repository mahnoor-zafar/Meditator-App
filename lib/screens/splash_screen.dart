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
      backgroundColor: Colors.white,  // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie Animation at the center of the screen
            Image.asset(
              'assets/main1.jpg', // Replace with your asset
              width: 400,
              height: 400,
            ),
            SizedBox(height: 20),
            // App name at the bottom of the screen
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Meditopia',  // App name
                style: TextStyle(
                  fontFamily: 'Ephesis',  // Use the font family name, not the file name
                  fontSize: 70,
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
