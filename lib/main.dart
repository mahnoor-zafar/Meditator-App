import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditator_app/screens/faq_screen.dart';
import 'package:meditator_app/screens/home_screen.dart';
import 'package:meditator_app/screens/login_screen.dart';
import 'package:meditator_app/screens/meditation_guide_screen.dart';
import 'package:meditator_app/screens/profile_screen.dart';
import 'package:meditator_app/screens/splash_screen.dart';
import 'package:meditator_app/screens/timer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/meditation' : (context) => MeditationGuideScreen(),
        '/timer' : (context) => TimerScreen(),
        '/home' : (context) => HomeScreen(),
        'FAQ' : (context) => FAQScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => HomeScreen());
      },
    );
  }
}
