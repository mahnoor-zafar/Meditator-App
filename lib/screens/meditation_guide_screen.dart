import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MeditationGuideScreen extends StatefulWidget {
  const MeditationGuideScreen({Key? key}) : super(key: key);

  @override
  _MeditationGuideScreenState createState() => _MeditationGuideScreenState();
}

class _MeditationGuideScreenState extends State<MeditationGuideScreen> {
  int _selectedIndex = 1; // Initial selected index (Medi)
  final ValueNotifier<int> _notifier = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: const Text(
          'To be implemented', // Display the message in the center
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _notifier,
        builder: (context, selectedIndex, _) {
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            items: [
              _buildBottomNavItem(FontAwesomeIcons.home, 'Home', 0),
              _buildBottomNavItem(FontAwesomeIcons.handHoldingHand, 'Medi', 1),
              _buildBottomNavItem(FontAwesomeIcons.bookAtlas, 'Timer', 2),
              _buildBottomNavItem(FontAwesomeIcons.userCircle, 'Profile', 3),
            ],
            selectedItemColor: Colors.orange, // Active item color
            unselectedItemColor: Colors.black, // Inactive item color
            onTap: (index) {
              _notifier.value = index; // Update the selected index
              // Handle navigation based on the index
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:

                  break;
                case 2:
                  Navigator.pushNamed(context, '/timer');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/profile');
                  break;
              }
            },
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
      IconData icon, String label, int index,
      ) {
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: _selectedIndex == index ? 1.2 : 1.0, // Scale the icon when selected
        duration: Duration(milliseconds: 200), // Duration of the animation
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
