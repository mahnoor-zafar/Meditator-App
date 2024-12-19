import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!) // Load user's profile picture
                    : const AssetImage('assets/default_avatar.png')
                as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),

            // User Name
            Text(
              'Name: ${user?.displayName ?? "Anonymous"}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // User Email
            Text(
              'Email: ${user?.email ?? "No Email Provided"}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to an Edit Profile Screen (if implemented)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Profile not implemented')),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
            const Spacer(),

            // Logout Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellowAccent),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
