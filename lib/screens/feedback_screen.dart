import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _commentController = TextEditingController();
  double _rating = 3.0; // Default rating
  String _savedComment = '';
  double _savedRating = 3.0;

  @override
  void initState() {
    super.initState();
    _loadFeedbackData(); // Load saved feedback when the screen initializes
  }

  // Load saved feedback from SharedPreferences
  Future<void> _loadFeedbackData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedRating = prefs.getDouble('rating') ?? 3.0;
      _savedComment = prefs.getString('comment') ?? '';
      _rating = _savedRating;
      _commentController.text = _savedComment;
    });
  }

  // Save the feedback data to SharedPreferences
  Future<void> _saveFeedbackData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rating', _rating); // Save the rating
    await prefs.setString('comment', _commentController.text); // Save the comment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We value your feedback!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Rating Input (using Slider or Star Rating)
            const Text("Rate us:"),
            Slider(
              value: _rating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (double value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Text Input for Comments
            const Text("Your Feedback:"),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your comments here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveFeedbackData(); // Save the feedback data
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
