import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/screens/course/add_course.dart';
import 'package:finbedu/screens/course/add_section_video.dart';
import 'package:finbedu/services/constants.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:flutter/material.dart';
import 'certificate_page.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/user_provider.dart'; // Assuming UserProvider is available
import '../../routes/app_routes.dart' as route;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    if (userProvider.user?.role == 'mentor') {
      final mentorId = userProvider.user?.id;
      if (mentorId != null) {
        courseProvider.fetchCoursesByMentor(mentorId);
      }
    }

    if (userProvider.user?.role == 'student') {
      final studentId = userProvider.user?.id;
      if (studentId != null) {
        courseProvider.fetchStudentCourses(studentId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get role from the user provider
    final userProvider = Provider.of<UserProvider>(context);
    final userRole = userProvider.user?.role;
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(title: const Text("Courses"), leading: const BackButton()),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search...',
          //       prefixIcon: const Icon(Icons.search),
          //       filled: true,
          //       fillColor: const Color(0xFFF5F5F5),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide.none,
          //       ),
          //     ),
          //   ),
          // ),
          // Show the 'Add Course' button only for mentors
          if (userRole == 'mentor')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route.add_course);
                },
                child: const Text(
                  "Add Course",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF202244),
                ),
              ),
            ),
          if (userRole == 'student')
            TabBar(
              padding: EdgeInsets.symmetric(horizontal: 16),
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              tabs: const [Tab(text: "Ongoing"), Tab(text: "Completed")],
              indicator: BoxDecoration(
                color: Color(0xFF202244),
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF202244),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          Expanded(
            child:
                userRole == 'mentor'
                    ? courseProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : courseProvider.mentorCourses.isEmpty
                        ? const Center(child: Text("No courses found."))
                        : _buildMentorCourseList(courseProvider.mentorCourses)
                    : courseProvider.isLoadingStudentCourses
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                      controller: _tabController,
                      children: [
                        // Ongoing Courses Tab
                        courseProvider.studentOngoingCourses.isEmpty
                            ? const Center(
                              child: Text(
                                "Tidak ada course yang sedang berlangsung.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            : _buildStudentCourseList(
                              courseProvider.studentOngoingCourses,
                            ),
                        // Completed Courses Tab
                        courseProvider.studentCompletedCourses.isEmpty
                            ? const Center(
                              child: Text(
                                "Tidak ada course yang telah diselesaikan.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            : _buildStudentCourseList(
                              courseProvider.studentCompletedCourses,
                            ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Edit Course: ${course.name}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup modal

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddCourseScreen(course: course),
                    ),
                  );
                },
                child: const Text(
                  "Edit Course",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF202244),
                ),
              ),

              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup modal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddSectionScreen(courseId: course.id!),
                    ),
                  );
                },

                child: const Text(
                  "Edit Curriculum",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 50, 120),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Uint8List> generateCertificatePdf(
    String userName,
    String courseTitle,
  ) async {
    final pdf = pw.Document();

    // Load logo dan medal dari assets
    final logoData = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final medalData = await rootBundle.load('assets/images/medal.png');
    final medalImage = pw.MemoryImage(medalData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green, width: 4),
            ),
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header dengan logo dan teks di satu baris
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  color: PdfColors.green,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        height: 60,
                        width: 60,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(
                            color: PdfColors.white,
                            width: 2,
                          ),
                        ),
                        child: pw.ClipOval(
                          child: pw.Image(logoImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                      pw.SizedBox(width: 15),
                      pw.Text(
                        'CERTIFICATE OF COMPLETION',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      pw.Container(
                        height: 60,
                        width: 60,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(
                            color: PdfColors.white,
                            width: 2,
                          ),
                        ),
                        child: pw.ClipOval(
                          child: pw.Image(medalImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 40),

                // Medal di kanan bawah (aligned right)
                pw.Text(
                  'This is to certify that',
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.grey800),
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  userName,
                  style: pw.TextStyle(
                    fontSize: 36,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  'Has successfully completed',
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.grey800),
                ),

                pw.SizedBox(height: 8),

                pw.Text(
                  courseTitle,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),

                pw.Spacer(),

                pw.SizedBox(height: 20),

                // Footer dengan garis atas dan date/signature
                pw.Container(
                  width: double.infinity,
                  // decoration: pw.BoxDecoration(
                  //   border: pw.Border(
                  //     top: pw.BorderSide(color: PdfColors.grey400, width: 1),
                  //   ),
                  // ),
                  padding: const pw.EdgeInsets.only(top: 15),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            'Date',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            '${DateTime.now().toLocal().toString().split(" ")[0]}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            'Signature',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Text(
                            'FINBEDU',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text('_________________________'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Widget _buildStudentCourseList(List<Course> courses) {
    UserProvider user = Provider.of<UserProvider>(context);
    String userName = user.user?.name ?? 'Student';
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseDetailPage(courseId: course.id!),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image:
                            course.image != null
                                ? NetworkImage(
                                  '${Constants.imgUrl}/${course.image}',
                                )
                                : const AssetImage('assets/images/course1.jpg')
                                    as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.category ?? 'Unknown Category',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ClipOval(
                              child:
                                  course.user != null
                                      ? Image.network(
                                        '${Constants.imgUrl}/${course.user?.photo}', // Assuming user has an image field
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                            child: const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                      : Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                        child: const Icon(
                                          Icons.person,
                                          size: 70,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.user?.name ??
                                        'Unknown Mentor', // Assuming user has a name field
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Text(
                                    "Mentor",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (course.accessStatus == 'completed')
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () async {
                                final pdfData = await generateCertificatePdf(
                                  userName,
                                  course.name,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => Scaffold(
                                          appBar: AppBar(
                                            title: const Text(
                                              'Preview Certificate',
                                            ),
                                          ),
                                          body: PdfPreview(
                                            build: (format) async => pdfData,
                                            // initialPageFormat:
                                            //     PdfPageFormat
                                            //         .a4
                                            //         .landscape, // 👉 Tambahkan ini
                                            canChangePageFormat: false,
                                            canChangeOrientation: false,
                                            canDebug: false,
                                            allowPrinting: true,
                                            allowSharing: true,
                                          ),
                                        ),
                                  ),
                                );
                              },

                              child: const Text(
                                "VIEW CERTIFICATE",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMentorCourseList(List<Course> courses) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CourseDetailPage(courseId: course.id!),
                  ),
                );
              },
              child: Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image:
                                    course.image != null
                                        ? NetworkImage(
                                          '${Constants.imgUrl}/${course.image}',
                                        )
                                        : const AssetImage(
                                              'assets/images/course1.jpg',
                                            ) // Use a default image if no image is provided
                                            as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  course.category ?? 'Unknown Category',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Text(
                                //   course.id.toString(),
                                //   style: const TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                                // Row(
                                //   children: [
                                //     const Icon(
                                //       Icons.star,
                                //       size: 16,
                                //       color: Colors.amber,
                                //     ),
                                //     const SizedBox(width: 4),
                                //     Text(
                                //       "- | {course.duration}",
                                //       style: const TextStyle(fontSize: 12),
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditModal(context, course);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Hapus Course'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus course ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              final courseProvider =
                                  Provider.of<CourseProvider>(
                                    context,
                                    listen: false,
                                  );
                              final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              );

                              final success = await courseProvider.deleteCourse(
                                course.id!,
                                userProvider.user!.id!,
                              );

                              if (success) {
                                await Provider.of<CourseProvider>(
                                  context,
                                  listen: false,
                                ).fetchCoursesByMentor(userProvider.user!.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Course berhasil dihapus'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menghapus course'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}
