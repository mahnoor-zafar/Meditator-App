import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final List<Map<String, dynamic>> _journalEntries = [];
  int _selectedIndex = 2; // For bottom navigation
  final ValueNotifier<int> _notifier = ValueNotifier<int>(2);

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  // Load journal entries from SharedPreferences
  void _loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedEntries = prefs.getString('journalEntries');
    if (savedEntries != null) {
      setState(() {
        _journalEntries.addAll(List<Map<String, dynamic>>.from(jsonDecode(savedEntries)));
      });
    }
  }

  // Save journal entries to SharedPreferences
  void _saveJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('journalEntries', jsonEncode(_journalEntries));
  }

  // Show dialog to add a new journal entry
  void _showAddJournalDialog() {
    final _formKey = GlobalKey<FormState>();
    double mood = 5.0;
    DateTime selectedDate = DateTime.now();
    final TextEditingController _topicController = TextEditingController();
    final TextEditingController _entryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Journal Entry"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Mood Picker (Slider)
                  const Text("How is your mood? (1-10)", style: TextStyle(fontSize: 16)),
                  Slider(
                    value: mood,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: mood.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        mood = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Date Picker
                  Row(
                    children: [
                      const Text("Date: ", style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Topic Name
                  _buildTextField("Topic Name", _topicController),
                  // Journal Entry
                  _buildTextField("Your Thoughts", _entryController, multiline: true),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _journalEntries.add({
                      "mood": mood.round(),
                      "date": "${selectedDate.toLocal()}".split(' ')[0],
                      "topic": _topicController.text,
                      "entry": _entryController.text,
                    });
                  });
                  _saveJournalEntries(); // Save to SharedPreferences
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Journal entry added successfully!")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Show journal details in a dialog
  void _showJournalDetails(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(entry['topic']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mood: ${entry['mood']}/10"),
                Text("Date: ${entry['date']}"),
                const SizedBox(height: 8),
                Text(entry['entry']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal',
          style: GoogleFonts.redHatDisplay(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _journalEntries.isEmpty
          ? const Center(child: Text("No journal entries yet."))
          : ListView.builder(
        itemCount: _journalEntries.length,
        itemBuilder: (context, index) {
          final entry = _journalEntries[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(entry['topic']),
              subtitle: Text("Date: ${entry['date']} | Mood: ${entry['mood']}/10"),
              onTap: () => _showJournalDetails(entry),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _journalEntries.removeAt(index);
                  });
                  _saveJournalEntries();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Journal entry deleted.")),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddJournalDialog,
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _notifier,
        builder: (context, selectedIndex, _) {
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            items: [
              _buildBottomNavItem(FontAwesomeIcons.home, 'Home', 0),
              _buildBottomNavItem(FontAwesomeIcons.handHoldingHand, 'Medi', 1),
              _buildBottomNavItem(FontAwesomeIcons.bookAtlas, 'Create', 2),
              _buildBottomNavItem(FontAwesomeIcons.userCircle, 'Profile', 3),
            ],
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              _notifier.value = index;
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/meditation');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/create');
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

  Widget _buildTextField(String label, TextEditingController controller, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: multiline ? 5 : 1,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
