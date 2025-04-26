import 'package:finbedu/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.black,
                height: 250,
                width: double.infinity,
                child: const Center(
                  child: Icon(Icons.play_circle, color: Colors.white, size: 64),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Graphic Design",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.orange, size: 16),
                                      SizedBox(width: 4),
                                      Text("4.2"),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Design Principles: Organizing ..",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  Icon(Icons.menu_book, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("23 Class"),
                                  SizedBox(width: 12),
                                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("42 Hours"),
                                  SizedBox(width: 12),
                                  Icon(Icons.group, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("7830 Std"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildCurriculumSection(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Back Button
          Positioned(
            left: 20,
            top: 48,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),

          // Bottom Action Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ActionButton(
              label: "Enroll Course - 499/-",
              color: const Color(0xFF202244),
              height: 60,
              width: double.infinity,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _curriculumItem("01", "Why Using Graphic Design Tools", "15 Mins"),
        const SizedBox(height: 12),
        _curriculumItem("02", "Setup Your Graphic Design Project", "30 Mins"),
      ],
    );
  }

  Widget _curriculumItem(String index, String title, String duration) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(index, style: const TextStyle(color: Colors.blue)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(duration),
          const Icon(Icons.play_circle, color: Colors.blue),
        ],
      ),
    );
  }
}
