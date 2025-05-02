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

  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

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
                          onTap: () {
                            Navigator.pushNamed(context, route.login);
                          },
                          child: Text(
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
                  itemBuilder: (context, index, realIdx) => Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                    (index) => Container(
                      width: _currentBanner == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentBanner == index
                            ? const Color(0xFF202244)
                            : const Color(0xFFFAC840),
                      ),
                    ),
                  ),
                ),

                /// Overview Section
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOverviewCard('Total Courses', '12', Icons.book),
                    _buildOverviewCard('Total Students', '150', Icons.people),
                    _buildOverviewCard('Average Rating', '4.8', Icons.star),
                  ],
                ),
                const SizedBox(height: 16),

                /// Top Students Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Students',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman semua siswa
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    _buildStudentTile('Alice Johnson', '95%', 'assets/images/student1.jpg'),
                    _buildStudentTile('Bob Smith', '92%', 'assets/images/student2.jpg'),
                    _buildStudentTile('Charlie Davis', '90%', 'assets/images/student3.jpg'),
                  ],
                ),
                const SizedBox(height: 16),

                /// Recent Reviews Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman semua ulasan
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    _buildReviewTile('David Lee', 'Great course!', 5),
                    _buildReviewTile('Eva Green', 'Very informative.', 4),
                    _buildReviewTile('Frank Wright', 'Loved the content.', 5),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentTile(String name, String progress, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text('Progress: $progress'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigasi ke detail siswa
      },
    );
  }

  Widget _buildReviewTile(String studentName, String comment, int rating) {
    return ListTile(
      leading: const Icon(Icons.comment, color: Colors.blue),
      title: Text(studentName),
      subtitle: Text(comment),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          rating,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
        ),
      ),
    );
  }
}
