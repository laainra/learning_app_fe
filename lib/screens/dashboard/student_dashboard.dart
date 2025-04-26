import 'package:finbedu/providers/category_providers.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:finbedu/screens/course/course_screen.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../routes/app_routes.dart' as route;
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../models/category_model.dart' as catModel;


class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentBanner = 0;
  int _currentCategory = 0;

  // final List<String> categories = [
  //   'Akutansi Keuangan',
  //   'Audit dan Assurance',
  //   'Perpajakan',
  //   'Akutansi Sektor Publik',
  //   'Etika Hukum dan Profesi',
  //   'Keuangan dan Analisis',
  //   'Sistem Informasi Akutansi',
  //   'Akutansi Manajerial/ Biaya',
  // ];
 List<catModel.Category> categories = []; // List to hold categories

  final List<String> banners = [
    'assets/images/course1.jpg',
    'assets/images/course2.jpg',
    'assets/images/course1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
    _fetchCategories();
  }
 Future<void> _fetchCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.fetchCategories(); // Fetch categories from the provider
    setState(() {
      categories = categoryProvider.categories; // Update the local categories list
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final  user = userProvider.user;
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
                          'HI, ${user?.name ?? "Guest"}', // Handle null user
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202244),
                          ),
                        ),
                        Text(
                          'What would you like to learn today?\nSearch below.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, route.notification);
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

                /// Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(
                      Icons.filter_list,
                      color: Color(0xFFFAC840),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF2F7FF),
                  ),
                ),
                const SizedBox(height: 16),

                /// Banner Carousel
                CarouselSlider.builder(
                  itemCount: banners.length,
                  itemBuilder:
                      (context, index, realIdx) => Container(
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
                        color:
                            _currentBanner == index
                                ? const Color(0xFF202244)
                                : const Color(0xFFFAC840),
                      ),
                    ),
                  ),
                ),

                /// Categories Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, route.category);
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label:  Text(categories[index].name), 
                            selected: _currentCategory == index,
                            selectedColor: const Color(0xFF202244),
                            backgroundColor: const Color(0xFFF2F7FF),
                            labelStyle: TextStyle(
                              color:
                                  _currentCategory == index
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onSelected:
                                (val) =>
                                    setState(() => _currentCategory = index),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Popular Courses Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Courses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, route.popular_course);
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 270,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CourseScreenPage(
                                    // title: 'Perpajakan',
                                    // image: 'assets/images/course2.jpg',
                                    // kamu bisa tambahkan data lain juga
                                  ),
                            ),
                          );
                        },
                        child: _buildCourseCard(
                          'Perpajakan',
                          'Aman',
                          'assets/images/course2.jpg',
                          'assets/images/mentor2.jpg',
                          4.5,
                          '4h 43m',
                          32,
                        ),
                      ),

                      _buildCourseCard(
                        'Akutansi Keuangan',
                        'Jiya',
                        'assets/images/course1.jpg',
                        'assets/images/mentor1.jpg',
                        4.9,
                        '5h 33m',
                        45,
                      ),

                      // Kamu bisa tambah lagi course berikutnya di sini...
                    ],
                  ),
                ),

                /// Top Mentor Section
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Mentor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildMentor('assets/images/mentor1.jpg', 'Jiya'),
                      _buildMentor('assets/images/mentor2.jpg', 'Aman'),
                      _buildMentor('assets/images/mentor3.jpg', 'Rahul.J'),
                      _buildMentor('assets/images/mentor4.jpg', 'Manav'),
                    ],
                  ),
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

  Widget _buildCourseCard(
    String title,
    String mentorName,
    String courseImage,
    String mentorImage,
    double rating,
    String duration,
    int lessons,
  ) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                courseImage,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage(mentorImage),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mentorName,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const Text(
                              "Educator",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_circle_outline,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$lessons Lessons',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.bookmark_border,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentor(String image, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
          const SizedBox(height: 4),
          Text(name),
        ],
      ),
    );
  }
}
