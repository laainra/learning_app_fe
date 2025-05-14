import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:finbedu/screens/course/video_player.dart';
import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/models/video_model.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/providers/section_provider.dart';
import 'package:finbedu/providers/video_provider.dart';
import 'package:finbedu/widgets/custom_button.dart';
import 'package:finbedu/providers/quiz_provider.dart';
import 'package:finbedu/screens/quiz/quiz_screen.dart';

class CourseDetailPage extends StatefulWidget {
  final int courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

Map<int, List<Video>> _videosPerSection = {};
Set<int> _loadingSections = {};

class _CourseDetailPageState extends State<CourseDetailPage> {
  late Future<void> _loadData;

  @override
  void initState() {
    super.initState();
    _loadData = _initializeData();
  }

  Future<void> _initializeData() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final sectionProvider = Provider.of<SectionProvider>(
      context,
      listen: false,
    );

    await courseProvider.fetchCourseById(widget.courseId);
    if (courseProvider.courseById != null) {
      await sectionProvider.fetchSections(widget.courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final course = courseProvider.courseById;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: FutureBuilder(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (course == null) {
            return const Center(child: Text("Course not found"));
          }

          return Stack(
            children: [
              Column(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      color: Colors.black,
                      height: 250,
                      width: double.infinity,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Deskripsi Kursus
                          Transform.translate(
                            offset: const Offset(0, -30),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Kategori & Rating
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        course.level ?? "Unknown Category",
                                        style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            course.rating?.toString() ?? "-",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Nama Kursus
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Metadata
                                  Row(
                                    children: [
                                      _buildMeta(
                                        Icons.menu_book,
                                        "${course.totalLessons ?? 0} Lessons",
                                      ),
                                      const SizedBox(width: 12),
                                      _buildMeta(
                                        Icons.access_time,
                                        course.name ?? "Unknown Duration",
                                      ),
                                      const SizedBox(width: 12),
                                      _buildMeta(
                                        Icons.group,
                                        "${course.totalStudents ?? 0} Students",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Kurikulum
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
              // Tombol Kembali
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
              // Tombol Enroll
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: ActionButton(
                  label: "Enroll Course - ${course.price}",
                  color: const Color(0xFF202244),
                  height: 56,
                  width: double.infinity,
                  onTap: () {
                    // Implementasi aksi enroll
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }

  Widget _buildCurriculumSection() {
    final sectionProvider = Provider.of<SectionProvider>(context);
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final sections = sectionProvider.sections;

    if (sections.isEmpty) {
      return const Center(child: Text("No sections available"));
    }

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
          onExpansionChanged: (isExpanded) async {
            if (isExpanded &&
                !_videosPerSection.containsKey(section.id) &&
                !_loadingSections.contains(section.id)) {
              setState(() {
                _loadingSections.add(section.id);
              });
              try {
                final videos = await videoProvider.fetchVideos(section.id);
                setState(() {
                  _videosPerSection[section.id] = videos;
                });
              } catch (e) {
                // Bisa ditambahkan error handling di sini jika perlu
                debugPrint(
                  'Failed to load videos for section ${section.id}: $e',
                );
              } finally {
                setState(() {
                  _loadingSections.remove(section.id);
                });
              }
            }
          },
          children: [
            if (_loadingSections.contains(section.id))
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_videosPerSection[section.id] == null)
              const SizedBox.shrink()
            else if (_videosPerSection[section.id]!.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: Text("No videos available")),
              )
            else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _videosPerSection[section.id]!.length,
                itemBuilder: (context, videoIndex) {
                  final video = _videosPerSection[section.id]![videoIndex];
                  return ListTile(
                    leading: const Icon(Icons.play_circle, color: Colors.blue),
                    title: Text(video.title),
                    subtitle: Text(video.duration ?? "Unknown Duration"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  VideoPlayerScreen(videoUrl: video.url),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        'quiz',
                        arguments: {'sectionId': section.id},
                      );
                    },
                    icon: const Icon(Icons.assignment),
                    label: const Text("Kerjakan Quiz"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }

  void _playVideo(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not launch $url")));
    }
  }
}
