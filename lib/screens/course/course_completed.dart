import 'package:flutter/material.dart';

class CourseCompletedCard extends StatelessWidget {
  const CourseCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Background decorative elements
          Stack(
            alignment: Alignment.center,
            children: [
              // Confetti dots and shapes
              Positioned(top: 0, left: 10, child: _colorDot(Colors.orange)),
              Positioned(top: 10, right: 0, child: _colorDot(Colors.yellow)),
              Positioned(top: 0, right: 30, child: _colorDot(Colors.brown)),
              Positioned(bottom: 0, left: 30, child: _colorDot(Colors.red)),
              Positioned(bottom: 0, right: 40, child: _colorDot(Colors.blue)),
              Positioned(bottom: 10, left: 10, child: _colorDot(Colors.green)),

              // Headphone with graduation cap icon (as placeholder)
              const Icon(Icons.headphones, size: 64, color: Colors.black),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Course Completed",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A214C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Complete your Course. Please Write a\nReview",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Your review action here
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Write a Review"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A214C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Mini colorful circle
  Widget _colorDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
