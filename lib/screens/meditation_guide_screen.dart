import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class MeditationGuideScreen extends StatefulWidget {
  const MeditationGuideScreen({Key? key}) : super(key: key);

  @override
  _MeditationGuideScreenState createState() => _MeditationGuideScreenState();
}

class _MeditationGuideScreenState extends State<MeditationGuideScreen> {
  int _selectedIndex = 1;
  final ValueNotifier<int> _notifier = ValueNotifier<int>(1);

  Future<List<dynamic>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.10/flutter/mediator.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          'Meditation Guide',
          style: GoogleFonts.redHatDisplay(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _notifier,
        builder: (context, selectedIndex, _) {
          if (selectedIndex == 1) {
            return FutureBuilder<List<dynamic>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final category = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(category['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${category['focus']} - ${category['minutes']} minutes'),
                          onTap: () {
                            // Show dialog with detailed information
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(category['name']),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Focus:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(category['focus']),
                                      SizedBox(height: 10),
                                      Text(
                                        'Instructions:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(category['instructions']),
                                      SizedBox(height: 10),
                                      Text(
                                        'Estimated Time:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('${category['minutes']} minutes'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                      );
                    },
                  );
                } else {
                  return Center(child: Text('No categories found.'));
                }
              },
            );
          } else {
            return Center(
              child: Text(
                'To be implemented',
                style: TextStyle(fontSize: 24, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
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
            selectedItemColor: Colors.grey, // Active item color
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

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: _selectedIndex == index ? 1.2 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
