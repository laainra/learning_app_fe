import 'package:flutter/material.dart';

class TopMentorsPage extends StatelessWidget {
  TopMentorsPage({super.key});

  final List<Map<String, String>> mentors = [
    {
      'name': 'Jiya Shetty',
      'skill': '3D Design',
      'image': 'assets/images/mentor1.jpg',
    },
    {
      'name': 'Donald S',
      'skill': 'Arts & Humanities',
      'image': 'assets/images/mentor2.jpg',
    },
    {
      'name': 'Aman',
      'skill': 'Personal Development',
      'image': 'assets/images/mentor3.jpg',
    },
    {
      'name': 'Vrushab. M',
      'skill': 'SEO & Marketing',
      'image': 'assets/images/mentor4.jpg',
    },
    {
      'name': 'Robert William',
      'skill': 'Office Productivity',
      'image': 'assets/images/mentor5.jpg',
    },
    {
      'name': 'Soman',
      'skill': 'Web Development',
      'image': 'assets/images/mentor6.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Mentors'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(mentor['image']!),
            ),
            title: Text(
              mentor['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              mentor['skill']!,
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
