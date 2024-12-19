import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:meditator_app/screens/login_screen.dart'; // Import the LoginScreen
import 'package:meditator_app/screens/profile_screen.dart';
import 'package:meditator_app/screens/splash_screen.dart'; // Import the ProfileScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditator App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // Define named routes
      routes: {
        '/': (context) => SplashScreen(), // Home screen is LoginScreen
        '/login': (context) => LoginScreen(), // Define the /login route
        '/profile': (context) => ProfileScreen(), // Define the /profile route
      },
      // Optionally handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginScreen()); // Default to login screen if unknown route
      },
    );
  }
}
