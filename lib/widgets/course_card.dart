import 'package:flutter/material.dart';

Widget buildCourseCard(String title, String mentor, String image, double rating, String duration, int lessons) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(image, height: 100, width: 100, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/images/mentor.jpg')),
                      const SizedBox(width: 6),
                      Text(mentor),
                      const Spacer(),
                      const Icon(Icons.bookmark_border),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 14, color: Colors.grey),
                      Text(' $duration'),
                      const SizedBox(width: 10),
                      Icon(Icons.play_circle_fill, size: 14, color: Colors.grey),
                      Text(' $lessons Lessons'),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }