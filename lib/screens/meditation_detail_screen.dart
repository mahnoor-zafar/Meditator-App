import 'package:flutter/material.dart';

class MeditationDetailScreen extends StatelessWidget {
  const MeditationDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basics Meditation'),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/home.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title and Description
            const Text(
              "Basics Meditation",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Learn the basics of meditation with our 17 guided sessions. This program will help you establish mindfulness, focus, and balance in your daily life.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Session List
            const Text(
              "Sessions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text("Session ${index + 1}"),
                    subtitle: const Text("5 minutes - Guided Meditation"),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow_outlined, color: Colors.black),
                      onPressed: () {
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
