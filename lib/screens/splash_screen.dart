import 'package:flutter/material.dart';
import 'package:meditator_app/screens/home_screen.dart';
import 'package:meditator_app/screens/login_screen.dart';
import 'package:meditator_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 5));

    if (AuthService().getCurrentUser() != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/main1.jpg',
              width: screenWidth * 0.8,
              height: screenHeight * 0.4,
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Text(
                'Meditopia',
                style: TextStyle(
                  fontFamily: 'Ephesis',
                  fontSize: screenWidth * 0.15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
