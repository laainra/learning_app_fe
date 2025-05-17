import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:finbedu/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart' as route;
import '../../providers/user_provider.dart';
import '../../widgets/bottom_menu.dart';

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({super.key});

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  int _currentBanner = 0;
  List<Course> mentorCourses = [];

  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner1.jpg',
    'assets/images/banner1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchMentorCourses();
  }

  Future<void> _fetchMentorCourses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    if (userProvider.user != null) {
      await courseProvider.fetchCoursesByMentor(userProvider.user!.id!);
      if (mounted) {
        setState(() {
          mentorCourses = courseProvider.mentorCourses;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Greeting and Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${user?.name ?? "Mentor"}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202244),
                          ),
                        ),
                        const Text(
                          'Here is your dashboard overview.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (user == null)
                          GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(context, route.login),
                            child: const Text(
                              'Login now',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman notifikasi
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFF2F7FF),
                        child: Icon(
                          Icons.notifications,
                          color: Color(0xFF202244),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Banner Carousel
                CarouselSlider.builder(
                  itemCount: banners.length,
                  itemBuilder:
                      (context, index, _) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(banners[index], fit: BoxFit.cover),
                      ),
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() => _currentBanner = index);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentBanner == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentBanner == index
                                ? const Color(0xFF202244)
                                : const Color(0xFFFAC840),
                      ),
                    ),
                  ),
                ),

                /// Overview Section
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildOverviewCard(
                  'Total Courses',
                  mentorCourses.length.toString(),
                  Icons.book,
                ),
                const SizedBox(height: 16),

                /// Mentor Courses Section
                const Text(
                  'Your Courses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                mentorCourses.isEmpty
                    ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'You have not created any courses yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            mentorCourses.map((course) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CourseDetailPage(
                                            courseId: course.id!,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width:
                                      250, // Lebar card agar lebih cocok untuk horizontal scroll
                                  margin: const EdgeInsets.only(right: 12),
                                  child: _buildCourseCard(
                                    course.name,
                                    course.user?.name ?? 'Unknown Mentor',
                                    course.image ?? '',
                                    course.user?.photo ?? '',
                                    course.category ?? 'No category',
                                    course.desc ?? 'No description',
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF2F7FF),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: const Color(0xFF202244)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String mentorName,
    String courseImage,
    String mentorImage,
    String category,
    String description,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child:
                courseImage.isNotEmpty
                    ? Image.network(
                      '${Constants.imgUrl}/$courseImage',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              _buildImagePlaceholder(),
                    )
                    : _buildImagePlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image, size: 50, color: Colors.white),
      ),
    );
  }
}
