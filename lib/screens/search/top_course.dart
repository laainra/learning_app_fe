import 'package:finbedu/services/constants.dart';
import 'package:finbedu/widgets/CustomHeader.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';
import '../../models/category_model.dart' as catModel;
import '../../models/course_model.dart';
import 'package:finbedu/providers/category_providers.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import '../../routes/app_routes.dart' as route;
import 'package:provider/provider.dart';

class PopularCoursesPage extends StatefulWidget {
  const PopularCoursesPage({super.key});

  @override
  State<PopularCoursesPage> createState() => _PopularCoursesPageState();
}

class _PopularCoursesPageState extends State<PopularCoursesPage> {
  List<catModel.Category> categories = [];
  List<Course> allCourses = [];
  List<Course> filteredCourses = [];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchCategories();
    await _fetchCourses(); // jalankan setelah kategori siap
    _filterCourses(); // filter setelah kedua data tersedia
  }

  Future<void> _fetchCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    await categoryProvider.fetchCategories();
    setState(() {
      categories = categoryProvider.categories;
    });
  }

  Future<void> _fetchCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.fetchCourses();
    setState(() {
      allCourses = courseProvider.allCourses;
    });
  }

  void _filterCourses() {
    if (allCourses.isEmpty) return;

    // Jika All dipilih (index 0), tampilkan semua course
    if (selectedCategoryIndex == 0) {
      setState(() {
        filteredCourses = allCourses;
      });
      return;
    }

    final selectedCategory =
        categories[selectedCategoryIndex - 1].name.toLowerCase();

    setState(() {
      filteredCourses =
          allCourses
              .where(
                (course) =>
                    course.category != null &&
                    course.category!.toLowerCase() == selectedCategory,
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(
        title: 'Popular Courses',
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
                itemCount: categories.length + 1, // tambah 1 untuk All
                itemBuilder: (context, index) {
                  final isSelected = selectedCategoryIndex == index;
                  final categoryName =
                      index == 0 ? 'All' : categories[index - 1].name;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                      _filterCourses();
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
                          index == 0 ? 'All' : categories[index - 1].name,
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
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];
                  return _buildCourseCard(course);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child:
              course.image != null
                  ? Image.network(
                    '${Constants.imgUrl}/${course.image}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white),
                        ),
                      );
                    },
                  )
                  : _buildPlaceholderImage(),
        ),
        title: Text(
          course.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  course.rating?.toStringAsFixed(1) ?? 'N/A',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  Constants().formatRupiah(course.price),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              course.desc,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(courseId: course.id!),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
