import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class MeditationDetailScreen extends StatelessWidget {
  const MeditationDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text(
            'Basics Meditation',
            style: GoogleFonts.redHatDisplay(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return TimerDialog(sessionMinutes: 1);
                          },
                        );
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

class TimerDialog extends StatefulWidget {
  final int sessionMinutes;

  const TimerDialog({Key? key, required this.sessionMinutes}) : super(key: key);

  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  late int remainingTime;
  late Timer _timer;
  late AudioPlayer _audioPlayer;
  late double progress;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.sessionMinutes * 60;
    progress = 0.0;
    _audioPlayer = AudioPlayer();
    _startSession();
  }

  void _startSession() async {
    await _audioPlayer.play(AssetSource('sound/tune.mp3'));
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
          progress = 1 - (remainingTime / (widget.sessionMinutes * 60));
        } else {
          _endSession();
        }
      });
    });
  }

  void _endSession() async {
    _timer.cancel();
    await _audioPlayer.stop();
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You have completed the session."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close completion dialog
                Navigator.pop(context); // Close timer dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    String seconds = (remainingTime % 60).toString().padLeft(2, '0');

    return AlertDialog(
      title: const Text('Meditation Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            '$minutes:$seconds',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Session in progress. Focus and relax.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer.cancel();
            _audioPlayer.stop();
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
