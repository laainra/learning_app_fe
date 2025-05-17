import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/models/user_model.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:finbedu/services/constants.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> recentSearches = ['Akuntansi Keuangan', 'Perpajakan', 'Audit'];
  List<Course> searchCourses = [];
  List<UserModel> searchMentors = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final keyword = _searchController.text.trim();
    if (keyword.isNotEmpty) {
      _searchData(keyword);
    } else {
      setState(() {
        searchCourses.clear();
        searchMentors.clear();
      });
    }
  }

  Future<void> _searchData(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/search?keyword=$query'),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // <-- ini yang ditambahkan

        final data = jsonDecode(response.body);

        setState(() {
          searchCourses =
              (data['courses'] as List)
                  .map((courseJson) => Course.fromJson(courseJson))
                  .toList();

          searchMentors =
              (data['mentors'] as List)
                  .map((mentorJson) => UserModel.fromJson(mentorJson))
                  .toList();
        });
      } else {
        setState(() {
          searchCourses.clear();
          searchMentors.clear();
        });
        print('Error status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        searchCourses.clear();
        searchMentors.clear();
      });
      print('Error fetching data: $e');
    }
  }

  void _addToRecent(String keyword) {
    if (!recentSearches.contains(keyword)) {
      setState(() {
        recentSearches.insert(0, keyword);
      });
    }
  }

  void removeSearch(String item) {
    setState(() {
      recentSearches.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _searchController.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search course or mentor...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child:
                  keyword.isEmpty
                      ? _buildRecentSearch()
                      : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearch() {
    return ListView.builder(
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final item = recentSearches[index];
        return ListTile(
          title: Text(item),
          leading: const Icon(Icons.history),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => removeSearch(item),
          ),
          onTap: () {
            _searchController.text = item;
            _searchData(item);
            _addToRecent(item);
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (searchCourses.isEmpty && searchMentors.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView(
      children: [
        if (searchCourses.isNotEmpty) ...[
          const Text(
            'Courses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...searchCourses.map((course) => _buildCourseCard(course)).toList(),
          const SizedBox(height: 16),
        ],
        if (searchMentors.isNotEmpty) ...[
          const Text(
            'Mentors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...searchMentors.map((mentor) => _buildMentorCard(mentor)).toList(),
        ],
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading:
            (course.image != null && course.image!.isNotEmpty)
                ? Image.network(
                  '${Constants.imgUrl}/${course.image}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
                : _buildPlaceholderImage(),
        title: Text(course.name),
        subtitle: Text(
          course.category ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          _addToRecent(course.name);
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

  Widget _buildMentorCard(UserModel mentor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: ClipOval(
          child:
              (mentor.photo ?? '').isNotEmpty
                  ? Image.network(
                    '${Constants.imgUrl}/${mentor.photo}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultPersonIcon();
                    },
                  )
                  : _buildDefaultPersonIcon(),
        ),
        title: Text(mentor.name),
        onTap: () {
          _addToRecent(mentor.name);
          // Navigasi ke detail mentor jika ada
        },
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.white),
    );
  }

  Widget _buildDefaultPersonIcon() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[300],
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }
}
