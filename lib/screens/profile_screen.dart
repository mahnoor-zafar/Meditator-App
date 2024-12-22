import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  final ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  late Future<DocumentSnapshot> _userData;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore based on the current user UID
      _userData = FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF3DC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back to Home Button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ],
            ),

            // Profile Text at the Top
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20), // Space between profile text and profile details

            // Profile Picture and Details
            FutureBuilder<DocumentSnapshot>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("User data not found"));
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  children: [
                    // Profile Picture
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!) // Load user's profile picture
                            : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20), // Space between picture and name

                    // Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text(
                          userData['name'] ?? "Anonymous",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),


                    // Phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text(
                          userData['phone'] ?? "No Phone Provided",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text(
                          user?.email ?? "No Email Provided",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),


                    // Edit Profile Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blueAccent, // Use backgroundColor instead of primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to an Edit Profile Screen (if implemented)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Profile not implemented')),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Log Out Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.yellowAccent, // Use backgroundColor instead of primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      icon: const Icon(Icons.logout, color: Colors.black),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
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
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              _notifier.value = index; // Update the selected index
              // Handle navigation based on the index
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/meditation');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/timer');
                  break;
                case 3:
                // Already on Profile screen
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
        duration: const Duration(milliseconds: 200), // Duration of the animation
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
