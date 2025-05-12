import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/screens/course/add_course.dart';
import 'package:finbedu/screens/course/add_section_video.dart';
import 'package:finbedu/services/constants.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:flutter/material.dart';
import 'certificate_page.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/user_provider.dart'; // Assuming UserProvider is available
import '../../routes/app_routes.dart' as route;

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    if (userProvider.user?.role == 'mentor') {
      final mentorId = userProvider.user?.id;
      if (mentorId != null) {
        courseProvider.fetchCoursesByMentor(mentorId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get role from the user provider
    final userProvider = Provider.of<UserProvider>(context);
    final userRole = userProvider.user?.role;
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(title: const Text("Courses"), leading: const BackButton()),
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
          // Show the 'Add Course' button only for mentors
          if (userRole == 'mentor')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route.add_course);
                },
                child: const Text(
                  "Add Course",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF202244),
                ),
              ),
            ),
          if (userRole == 'student')
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
            child:
                userRole == 'mentor'
                    ? courseProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : courseProvider.mentorCourses.isEmpty
                        ? const Center(child: Text("No courses found."))
                        : _buildMentorCourseList(courseProvider.mentorCourses)
                    : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCourseList(
                          completedCourses,
                          completed: true,
                          userRole: userRole,
                        ),
                        _buildCourseList(
                          ongoingCourses,
                          completed: false,
                          userRole: userRole,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Edit Course: ${course.name}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup modal

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddCourseScreen(course: course),
                    ),
                  );
                },
                child: const Text("Edit Course"),
              ),

              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup modal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddSectionScreen(courseId: course.id!),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text("Edit Curriculum"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseList(
    List<Map<String, dynamic>> courses, {
    required bool completed,
    required String? userRole,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)),
            // );
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image:
                                course['image']! != null
                                    ? NetworkImage(
                                      '${ApiConstants.imgUrl}/${course['image']!}',
                                    )
                                    : const AssetImage(
                                          'assets/images/course1.jpg',
                                        ) // Use a default image if no image is provided
                                        as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
              // Edit and Delete Buttons for mentors
              if (userRole == 'mentor' && !completed)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigate to the edit page
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Handle course deletion
                        },
                      ),
                    ],
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

  Widget _buildMentorCourseList(List<Course> courses) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(course: course),
                  ),
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image:
                                    course.image != null
                                        ? NetworkImage(
                                          '${ApiConstants.imgUrl}/${course.image}',
                                        )
                                        : const AssetImage(
                                              'assets/images/course1.jpg',
                                            ) // Use a default image if no image is provided
                                            as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  course.category ?? 'Unknown Category',
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
                                      "- | {course.duration}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditModal(context, course);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Hapus Course'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus course ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              final courseProvider =
                                  Provider.of<CourseProvider>(
                                    context,
                                    listen: false,
                                  );
                              final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              );

                              final success = await courseProvider.deleteCourse(
                                course.id!,
                                userProvider.user!.id!,
                              );

                              if (success) {
                                await Provider.of<CourseProvider>(
                                  context,
                                  listen: false,
                                ).fetchCoursesByMentor(userProvider.user!.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Course berhasil dihapus'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menghapus course'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
