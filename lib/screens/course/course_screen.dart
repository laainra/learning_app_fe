import 'package:finbedu/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart' as route;
class CourseScreenPage extends StatefulWidget {
  const CourseScreenPage({super.key});

  @override
  State<CourseScreenPage> createState() => _CourseScreenPageState();
}

class _CourseScreenPageState extends State<CourseScreenPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
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
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 16,
                                    ),
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
                                Icon(
                                  Icons.menu_book,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text("23 Class"),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey,
                                ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: const Color(0xFF202244),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFF202244),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: "Completed"),
                          Tab(text: "Ongoing"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAboutSection(),
                          _buildCurriculumSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

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

  Widget _buildAboutSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Graphic Design is now a popular profession..."),
          const SizedBox(height: 24),
          const Text(
            "Instructor",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage("assets/images/mentor.jpg"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Robert Jr",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Akuntansi Perpajakan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chat, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "What You'll Get",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _infoItem(Icons.play_circle, "25 Lessons"),
          _infoItem(Icons.devices, "Access Mobile, Desktop & TV"),
          _infoItem(Icons.lock_open, "Lifetime Access"),
          _infoItem(Icons.quiz, "6 Quizzes"),
          _infoItem(Icons.verified, "Certificate of Completion"),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reviews",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to the reviews page
                  Navigator.pushNamed(
                    context,
                    route.reviews_list,
                  ); // Update with your actual route name
                },
                child: const Text(
                  "SEE ALL",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _reviewItem(
            "Will",
            4.5,
            "This course has been very useful...",
            "2 Weeks Ago",
          ),
          const SizedBox(height: 12),
          _reviewItem(
            "Martha E. Thompson",
            4.5,
            "Very insightful and fun sessions",
            "2 Weeks Ago",
          ),
          const SizedBox(height: 100), // ✅ Tambahkan padding bawah
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _reviewItem(String name, double rating, String comment, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(child: Icon(Icons.person)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(comment),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurriculumSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _curriculumSection(
            sectionTitle: "Section 01 - Introduction",
            duration: "45 Mins",
            items: [
              {
                "number": "01",
                "title": "Why Using Graphic Design Tools",
                "time": "15 Mins",
              },
              {
                "number": "02",
                "title": "Setup Your Graphic Design Project",
                "time": "30 Mins",
              },
            ],
          ),
          const SizedBox(height: 20),
          _curriculumSection(
            sectionTitle: "Section 02 - Working with Layers",
            duration: "60 Mins",
            items: [
              {
                "number": "03",
                "title": "Understanding Layers",
                "time": "20 Mins",
              },
              {
                "number": "04",
                "title": "Layering Techniques",
                "time": "40 Mins",
              },
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _curriculumSection({
    required String sectionTitle,
    required String duration,
    required List<Map<String, String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionTitle,
                style: const TextStyle(
                  color: Color(0xFF3D5AFE),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.clip,
              ),
              Text(
                duration,
                style: const TextStyle(
                  color: Color(0xFF3D5AFE),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Items
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _curriculumItem(
                item["number"]!,
                item["title"]!,
                item["time"]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _curriculumItem(String number, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF202244),
            radius: 18,
            child: Text(number, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill, color: Colors.blue),
        ],
      ),
    );
  }
}
