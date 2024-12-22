import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQ Screen',
      theme: ThemeData(
        // Apply Google Fonts globally to all text
        textTheme: GoogleFonts.redHatDisplayTextTheme(
          Theme.of(context).textTheme,  // Keep existing text properties (color, size, etc.)
        ),
      ),
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);


  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final ValueNotifier<int> _bottomNavNotifier = ValueNotifier<int>(0); // ValueNotifier to track BottomNavigationBar selected index
  final ValueNotifier<int> _expandedTileNotifier = ValueNotifier<int>(-1); // ValueNotifier to track the expanded FAQ tile index
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 3;  // Timer screen is selected in the bottom nav
  final ValueNotifier<int> _notifier = ValueNotifier<int>(3);

  List<Map<String, String>> faqData = [
    {
      'question': 'What is meditation?',
      'answer': 'Meditation is a practice where an individual uses a technique—such as mindfulness, or focusing the mind on a particular object, thought, or activity—to train attention and awareness, and achieve a mentally clear and emotionally calm and stable state.'
    },
    {
      'question': 'How often should I meditate?',
      'answer': 'It is recommended to meditate daily for at least 10-20 minutes, but it can vary depending on your personal goals and schedule. Even a few minutes of meditation can have a positive impact on your well-being.'
    },
    {
      'question': 'Do I need special equipment for meditation?',
      'answer': 'No, meditation can be done anywhere. You just need a quiet space, a comfortable seat, and the willingness to relax and focus your mind. Some people use meditation cushions or apps, but it is not necessary.'
    },
    {
      'question': 'Can meditation help reduce stress?',
      'answer': 'Yes, meditation has been shown to reduce stress, improve focus, and enhance overall mental health. By practicing regularly, you can help lower cortisol levels and achieve a sense of calm.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged); // Listen for changes in the search query
  }

  // Called when the search query changes
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // Clean up the listener when the widget is disposed
    _bottomNavNotifier.dispose();
    _expandedTileNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter the FAQ data based on the search query
    List<Map<String, String>> filteredFaqData = faqData
        .where((faq) =>
    faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar (
        title: const Text(
          "Frequently Asked Questions",
          style: TextStyle(
            color: Colors.white,  // Set the text color to white
          ),
        ),
        backgroundColor: Colors.black87,  // Set the background color to black
        iconTheme: const IconThemeData(
          color: Colors.white,  // Set the back arrow icon color to white
        ),
      ),

      body: SingleChildScrollView( // Add this to make the entire body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            const Text(
              "We’re here to help solve any queries you have regarding Meditation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "If you have any concerns, check out our frequently asked questions below.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search FAQ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // FAQ Section
            const Text(
              "FAQ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // FAQ ListView
            SizedBox(
              height: 350,  // Set a max height that can be adjusted for larger screens
              child: ListView(
                children: filteredFaqData.isEmpty
                    ? [const Center(child: Text("No results found"))]
                    : filteredFaqData
                    .asMap() // Convert the list to a map with index
                    .map((index, faq) {
                  return MapEntry(
                    index,
                    _buildFAQTile(
                      index: index,
                      question: faq['question']!,
                      answer: faq['answer']!,
                    ),
                  );
                })
                    .values
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Footer Section

          ],
        ),
      ),

      // BottomNavigationBar with ValueListenableBuilder
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _bottomNavNotifier,
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
              _bottomNavNotifier.value = index; // Update the selected index
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

  // Helper method to build the bottom navigation items
  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  // Helper method to build FAQ tiles with rounded corners even when expanded
  Widget _buildFAQTile({required int index, required String question, required String answer}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0), // Apply rounded corners to the tile
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ValueListenableBuilder<int>(
          valueListenable: _expandedTileNotifier,
          builder: (context, expandedIndex, _) {
            return ExpansionTile(
              title: Text(
                question,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
              onExpansionChanged: (isExpanded) {
                _expandedTileNotifier.value = isExpanded ? index : -1; // Update expanded tile index
              },
              initiallyExpanded: expandedIndex == index, // Expand this FAQ if it's the selected one
            );
          },
        ),
      ),
    );
  }
}
