import 'package:finbedu/providers/category_providers.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:finbedu/screens/course/course_screen.dart';
import 'package:finbedu/screens/search/mentor_list.dart';
import 'package:finbedu/screens/search/search.dart';
import 'package:finbedu/services/constants.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../routes/app_routes.dart' as route;
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../models/category_model.dart' as catModel;
import '../../models/course_model.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentBanner = 0;
  int _currentCategory = 0;

  List<catModel.Category> categories = []; // List to hold categories
  List<Course> courses = [];

  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
    _fetchCategories();
    _fetchCourses();
    _fetchMentors(); // tambahkan ini
  }

  Future<void> _fetchCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.fetchCourses();
    setState(() {
      courses = courseProvider.allCourses;
    });
  }

  Future<void> _fetchCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    await categoryProvider
        .fetchCategories(); // Fetch categories from the provider
    setState(() {
      categories =
          categoryProvider.categories; // Update the local categories list
    });
  }

  Future<void> _fetchMentors() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchMentors();
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

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  },
                  child: IgnorePointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for...',
                        suffixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF2F7FF),
                      ),
                    ),
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

                // /// Categories Section
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(
                //       'Categories',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.pushNamed(context, route.category);
                //       },
                //       child: const Text(
                //         'See All',
                //         style: TextStyle(color: Colors.blue),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 8),
                // SizedBox(
                //   height: 70,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: categories.length,
                //     itemBuilder:
                //         (context, index) => Padding(
                //           padding: const EdgeInsets.only(right: 8),
                //           child: ChoiceChip(
                //             label: Text(categories[index].name),
                //             selected: _currentCategory == index,
                //             selectedColor: const Color(0xFF202244),
                //             backgroundColor: const Color(0xFFF2F7FF),
                //             labelStyle: TextStyle(
                //               color:
                //                   _currentCategory == index
                //                       ? Colors.white
                //                       : Colors.black,
                //             ),
                //             onSelected:
                //                 (val) =>
                //                     setState(() => _currentCategory = index),
                //           ),
                //         ),
                //   ),
                // ),
                const SizedBox(height: 16),

                /// Popular Courses Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Courses',
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
                  height: 304,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CourseDetailPage(courseId: course.id!),
                            ),
                          );
                        },
                        child: _buildCourseCard(
                          course.name ?? 'No title',
                          course.user?.name ?? 'Unknown Mentor',
                          course.image ?? '',
                          course.user?.photo ?? '',
                          course.category ?? 'No category',
                          course.desc ?? 'No description',
                        ),
                      );
                    },
                  ),
                ),

                /// Top Mentor Section
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mentors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorListPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    final mentors = userProvider.mentors;

                    if (mentors.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mentors.length,
                        itemBuilder: (context, index) {
                          final mentor = mentors[index];
                          return _buildMentor(
                            mentor.photo ??
                                '', // ganti dengan key gambar yang sesuai
                            mentor.name ??
                                '', // ganti dengan key nama yang sesuai
                          );
                        },
                      ),
                    );
                  },
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
    String duration,
    String lessons,
  ) {
    print(courseImage);
    return Container(
      width: 300,

      margin: const EdgeInsets.only(right: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child:
                  courseImage != null
                      ? Image.network(
                        '${Constants.imgUrl}/${courseImage}',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover, // Agar gambar memenuhi area
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Jika loading selesai, tampilkan gambar
                          }
                          return Container(
                            height: 150,
                            width: double.infinity,
                            color:
                                Colors
                                    .grey
                                    .shade200, // Latar belakang saat loading
                            child: const Center(
                              child:
                                  CircularProgressIndicator(), // Indikator loading
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.black, // Latar belakang saat error
                            child: const Center(
                              child: Icon(
                                Icons.broken_image, // Ikon untuk error
                                color: Colors.white,
                                size: 72,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 72,
                          ),
                        ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            lessons,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,

                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.play_circle_outline,
                      //       size: 14,
                      //       color: Colors.grey,
                      //     ),
                      //     const SizedBox(width: 4),
                      //     Text(
                      //       '$lessons Lessons',
                      //       style: const TextStyle(
                      //         fontSize: 12,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const Icon(
                      //   Icons.bookmark_border,
                      //   size: 18,
                      //   color: Colors.grey,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipOval(
                        child:
                            mentorImage.isNotEmpty
                                ? Image.network(
                                  '${Constants.imgUrl}/${mentorImage}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                                : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.white,
                                  child: const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.grey,
                                  ),
                                ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mentorName,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              "Mentor",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: const [
                      //     Icon(Icons.star, color: Colors.amber, size: 16),
                      //     SizedBox(width: 4),
                      //     Text('-', style: TextStyle(fontSize: 12)),
                      //   ],
                      // ),
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

  Widget _buildImagePlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }

  Widget _buildMentor(String imageUrl, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipOval(
            child:
                imageUrl.isNotEmpty
                    ? Image.network(
                      '${Constants.imgUrl}/${imageUrl}',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 70,
                          height: 70,
                          color: Colors.white,
                          child: const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                    : Container(
                      width: 70,
                      height: 70,
                      color: Colors.white,
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),
          ),
          const SizedBox(height: 4),
          Text(name),
        ],
      ),
    );
  }
}
