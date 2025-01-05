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
        textTheme: GoogleFonts.redHatDisplayTextTheme(
          Theme.of(context).textTheme,
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
  final ValueNotifier<int> _bottomNavNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _expandedTileNotifier = ValueNotifier<int>(-1);
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 3;
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
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _bottomNavNotifier.dispose();
    _expandedTileNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFaqData = faqData
        .where((faq) =>
    faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Frequently Asked Questions',
          style: GoogleFonts.redHatDisplay(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              height: 350,
              child: ListView(
                children: filteredFaqData.isEmpty
                    ? [const Center(child: Text("No results found"))]
                    : filteredFaqData
                    .asMap()
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

  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

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
                _expandedTileNotifier.value = isExpanded ? index : -1;
              },
              initiallyExpanded: expandedIndex == index,
            );
          },
        ),
      ),
    );
  }
}
