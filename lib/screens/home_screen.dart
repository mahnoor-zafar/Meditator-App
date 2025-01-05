import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditator_app/screens/meditation_detail_screen.dart';
import 'package:meditator_app/screens/meditation_guide_screen.dart';
import 'package:meditator_app/screens/profile_screen.dart';
import 'package:meditator_app/screens/timer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  int _selectedIndex = 0;
  final ValueNotifier<int> _notifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName != null ? "Welcome Back, $userName!" : "Loading...",
                style: const TextStyle(
                  fontFamily: 'Ephesis',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
               Text(
                'How are you feeling today?',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFDBDCD7),
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/main.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ready to start meditation",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Restore your life balance",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.timer, size: 16, color: Colors.black45,),
                              const SizedBox(width: 4),
                              const Text("15 mins" ,
                                  style: TextStyle(color: Colors.black)),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Icon(Icons.play_arrow, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recommended Section
              const Text(
                "Recommended",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildRecommendationCard(
                      title: "Basics",
                      subtitle: "17 sessions",
                      color: Color(0xFFDBDBD9),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MeditationDetailScreen(),
                          ),
                        );
                      },
                    ),
                    _buildRecommendationCard(
                      title: "Happiness",
                      subtitle: "21 sessions",
                      color: Color(0xFFF2F2F2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MeditationDetailScreen(),
                          ),
                        );
                      },
                    ),
                    _buildRecommendationCard(
                      title: "Sweet Sleep",
                      subtitle: "15 sounds",
                      color: Color(0xFFAAAAAA),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MeditationDetailScreen(),
                          ),
                        );
                      },
                    ),
                    _buildRecommendationCard(
                      title: "Row Your Boat",
                      subtitle: "10 sounds",
                      color: Colors.orange[50]!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // In Progress Section
              const Text(
                "In progress",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildRecommendationCard(
                      title: "Basics",
                      subtitle: "5/17 sessions completed",
                      color: Color(0xFFBDBDBD),
                    ),
                    _buildRecommendationCard(
                      title: "Happiness",
                      subtitle: "2/21 sessions completed",
                      color: Color(0xFFDBDBD9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _notifier,
        builder: (context, selectedIndex, _) {
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            items: [
              _buildBottomNavItem(FontAwesomeIcons.home, 'Home', 0),
              _buildBottomNavItem(FontAwesomeIcons.handHoldingHand, 'Meditation', 1),
              _buildBottomNavItem(FontAwesomeIcons.bookAtlas, 'Timer', 2),
              _buildBottomNavItem(FontAwesomeIcons.userCircle, 'Profile', 3),
            ],
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              _notifier.value = index;
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.pushNamed(context, '/meditation');
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
      IconData icon,
      String label,
      int index,
      ) {
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: _selectedIndex == index ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.play_circle_fill, size: 32, color: Colors.white),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
