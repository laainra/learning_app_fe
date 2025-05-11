import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/section_provider.dart';
import 'package:finbedu/providers/video_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
class CourseDetailPage extends StatefulWidget {
  final Course course; // Tambahkan parameter course

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    final course = widget.course; // Ambil data course dari widget

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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    course.category?.name ?? "Unknown Category",
                                    style: const TextStyle(color: Colors.orange),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.orange, size: 16),
                                      const SizedBox(width: 4),
                                      Text(course.rating?.toString() ?? "-"),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.menu_book, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text("${course.totalLessons ?? 0} Lessons"),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  // Text(course.duration ?? "Unknown Duration"),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.group, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text("${course.totalStudents ?? 0} Students"),
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
              label: "Enroll Course - ${course.price}",
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
  final sectionProvider = Provider.of<SectionProvider>(context);
  final videoProvider = Provider.of<VideoProvider>(context);

  return FutureBuilder(
    future: sectionProvider.fetchSections(widget.course.id!), // Ambil sections berdasarkan course ID
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (sectionProvider.sections.isEmpty) {
        return const Center(child: Text("No sections available"));
      }

      final sections = sectionProvider.sections;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sections.length,
        itemBuilder: (context, sectionIndex) {
          final section = sections[sectionIndex];

          return ExpansionTile(
            title: Text(
              section.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              FutureBuilder(
                future: videoProvider.fetchVideos(section.id), // Ambil video berdasarkan section ID
                builder: (context, videoSnapshot) {
                  if (videoSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (videoSnapshot.hasError) {
                    return Center(child: Text("Error: ${videoSnapshot.error}"));
                  } else if (videoProvider.videos.isEmpty) {
                    return const Center(child: Text("No videos available"));
                  }

                  final videos = videoProvider.videos;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: videos.length,
                    itemBuilder: (context, videoIndex) {
                      final video = videos[videoIndex];

                      return ListTile(
                        leading: const Icon(Icons.play_circle, color: Colors.blue),
                        title: Text(video.title),
                        subtitle: Text(video.duration ?? "Unknown Duration"),
                        onTap: () {
                          _playVideo(video.url); // Panggil fungsi untuk memutar video
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );
}
void _playVideo(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Could not launch $url")),
    );
  }
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