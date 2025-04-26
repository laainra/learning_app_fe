import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:flutter/material.dart';
import 'certificate_page.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final completedCourses = [
    {
      'title': 'Graphic Design Advanced',
      'category': 'Graphic Design',
      'rating': 4.2,
      'duration': '2 Hrs 36 Mins',
    },
    {
      'title': 'Advance Diploma in Gra...',
      'category': 'Graphic Design',
      'rating': 4.7,
      'duration': '3 Hrs 28 Mins',
    },
  ];

  final ongoingCourses = [
    {
      'title': 'Intro to UI/UX Design',
      'category': 'UI/UX Design',
      'rating': 4.4,
      'duration': '3 Hrs 06 Mins',
      'progress': '93/125',
    },
    {
      'title': 'Wordpress website Dev...',
      'category': 'Web Development',
      'rating': 3.9,
      'duration': '1 Hr 58 Mins',
      'progress': '12/31',
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Transactions"),
        leading: const BackButton(),
        // actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          TabBar(
            padding: EdgeInsets.symmetric(horizontal: 16),
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            tabs: const [Tab(text: "Completed"), Tab(text: "Ongoing")],
            indicator: BoxDecoration(
              color: Color(0xFF202244),
              borderRadius: BorderRadius.circular(25),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF202244),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCourseList(completedCourses, completed: true),
                _buildCourseList(ongoingCourses, completed: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(
    List<Map<String, dynamic>> courses, {
    required bool completed,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseDetailPage()),
            );
          },
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Gambar memenuhi 1/4 lebar card
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/course1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Info course dan tombol view certificate / progress
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course['category'],
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${course['rating']} | ${course['duration']}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (completed)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const CertificatePage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "VIEW CERTIFICATE",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (!completed)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  course['progress'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Icon centang hijau di pojok kanan atas jika completed
              if (completed)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
