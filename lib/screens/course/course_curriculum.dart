import 'package:finbedu/widgets/CustomHeader.dart';
import 'package:flutter/material.dart';

class CurriculumPage extends StatelessWidget {
  const CurriculumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: const CustomHeader(
        title: 'Popular Courses',
        trailingIcon: Icons.search,
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [


            // White Container with Curriculum List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    sectionTitle("Section 01 · Introduction", "25 Mins"),
                    lessonTile("01", "Why Using Graphic Design?", "15 Mins", unlocked: true),
                    lessonTile("02", "Setup Your Graphic Design Tools", "10 Mins", unlocked: true),

                    const SizedBox(height: 20),
                    sectionTitle("Section 02 · Graphic Design", "55 Mins"),
                    lessonTile("03", "Take a Look Graphic Design Tools", "08 Mins"),
                    lessonTile("04", "Working with Graphic Design", "20 Mins"),
                    lessonTile("05", "Working with Frame & Layout", "12 Mins"),
                    lessonTile("06", "Using Graphic Plugins", "15 Mins"),

                    const SizedBox(height: 20),
                    sectionTitle("Section 03 · Let's Practice", "35 Mins"),
                    lessonTile("07", "Let’s Design a Sign Up Form", "15 Mins"),
                    lessonTile("08", "Sharing work with Team", "20 Mins"),

                    const SizedBox(height: 80), // Space before button
                  ],
                ),
              ),
            ),

            // Bottom Enroll Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Enroll Course - \$55"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title, String duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          duration,
          style: TextStyle(color: Colors.blue[700]),
        ),
      ],
    );
  }

  Widget lessonTile(String number, String title, String duration, {bool unlocked = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: unlocked ? Colors.blue : Colors.grey[300],
            child: Text(
              number,
              style: TextStyle(
                color: unlocked ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Text(duration),
          const SizedBox(width: 10),
          Icon(
            unlocked ? Icons.play_circle_fill : Icons.lock,
            color: unlocked ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
}
