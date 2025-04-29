import 'package:flutter/material.dart';

class MentorProfilePage extends StatefulWidget {
  final String name;
  final String skill;
  final String image;

  const MentorProfilePage({
    super.key,
    required this.name,
    required this.skill,
    required this.image,
  });

  @override
  State<MentorProfilePage> createState() => _MentorProfilePageState();
}

class _MentorProfilePageState extends State<MentorProfilePage> {
  int _selectedTab = 0; // 0 = Courses, 1 = Ratings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f5ff),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            widget.image,
                          ), // Use passed image
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.name, // Use passed name
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.skill, // Use passed skill
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "26",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Courses",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(width: 40),
                            Column(
                              children: [
                                Text(
                                  "8750",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Ratings",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1c1b4b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: const Text("Message"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Description box & Tab
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    '"But can one now do so much as they did in the past? Nor am I unaware that there is utility in history, not only pleasure."',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      _selectedTab == 0
                                          ? Colors.blue
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Courses",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _selectedTab == 0
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      _selectedTab == 1
                                          ? Colors.blue
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Ratings",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _selectedTab == 1
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Content: Courses or Ratings
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _selectedTab == 0 ? buildCourses() : buildRatings(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCourses() {
    return ListView(
      children: [
        courseItem(
          "Graphic Design",
          "Graphic Design Advanced",
          "799K",
          "4.2",
          "7830 Std",
        ),
        const SizedBox(height: 12),
        courseItem(
          "Graphic Design",
          "Graphic Design Advanced",
          "799K",
          "4.1",
          "990 Std",
        ),
      ],
    );
  }

  Widget courseItem(
    String category,
    String title,
    String price,
    String rating,
    String students,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/course.jpg", // Ganti sesuai assetmu
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(rating),
                    const SizedBox(width: 8),
                    Text(students, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border),
        ],
      ),
    );
  }

  Widget buildRatings() {
    return ListView(
      children: [
        ratingItem(
          "assets/student1.jpg",
          "Mary",
          "4.2",
          "This course has been very useful. Mentor was well spoken totally loved it.",
          "2 Weeks Ago",
        ),
        const SizedBox(height: 12),
        ratingItem(
          "assets/student2.jpg",
          "Natasha B. Lambert",
          "4.8",
          "This course has been very useful. Mentor was well spoken totally loved it.",
          "2 Weeks Ago",
        ),
      ],
    );
  }

  Widget ratingItem(
    String avatarPath,
    String name,
    String rating,
    String review,
    String time,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(review),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
