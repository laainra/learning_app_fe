import 'package:finbedu/widgets/CustomHeader.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';

class PopularCoursePage extends StatefulWidget {
  const PopularCoursePage({super.key});

  @override
  State<PopularCoursePage> createState() => _PopularCoursePageState();
}

class _PopularCoursePageState extends State<PopularCoursePage> {
  final List<String> categories = [
    'All',
    'Perpajakan',
    'Akutansi',
    'Digital Skill',
    'Manajemen',
  ];

  int selectedCategory = 0;

  final List<Map<String, dynamic>> courses = [
    {
      'image': 'assets/images/course1.jpg',
      'category': 'Akuntansi Perbankan',
      'title': 'Pengantar Akuntansi',
      'price': '705K',
      'rating': 4.2,
      'students': 7830,
      'isBookmarked': true,
    },
    {
      'image': 'assets/images/course2.jpg',
      'category': 'Keuangan dan Analisi',
      'title': 'Manajemen Keuangan',
      'price': '800K',
      'rating': 3.3,
      'students': 12600,
      'isBookmarked': false,
    },
    {
      'image': 'assets/images/course1.jpg',
      'category': 'Akuntansi Sektor Publik',
      'title': 'Akuntansi Pemerintahan',
      'price': '599K',
      'rating': 4.2,
      'students': 990,
      'isBookmarked': true,
    },
    {
      'image': 'assets/images/course2.jpg',
      'category': 'Sistem Informasi Akuntansi',
      'title': 'Sistem Informasi Akuntansi',
      'price': '499K',
      'rating': 4.9,
      'students': 14850,
      'isBookmarked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(
        title: 'Courses',
        trailingIcon: Icons.search,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCategory == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _buildCourseCard(course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              course['image'],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['category'],
                  style: const TextStyle(fontSize: 12, color: Colors.orange),
                ),
                const SizedBox(height: 4),
                Text(
                  course['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text('${course['rating']}'),
                    const SizedBox(width: 10),
                    Text('${course['students']} Std'),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            course['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
            color: course['isBookmarked'] ? Colors.teal : Colors.grey,
          ),
        ],
      ),
    );
  }
}
