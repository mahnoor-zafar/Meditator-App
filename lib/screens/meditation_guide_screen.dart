import 'package:flutter/material.dart';

class MeditationGuideScreen extends StatelessWidget {
  const MeditationGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Guide'),
      ),
      body: Center(
        child: const Text(
          'Here are some steps for a successful meditation session:\n\n'
              '1. Sit comfortably.\n'
              '2. Close your eyes.\n'
              '3. Take deep breaths.\n'
              '4. Focus on your breathing and relax.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
