import 'package:finbedu/providers/chat_provider.dart';
import 'package:finbedu/providers/review_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:finbedu/providers/certificate_provider.dart';
import 'package:finbedu/providers/category_providers.dart';
import 'package:finbedu/providers/course_image_provider.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/providers/quiz_provider.dart';
import 'package:finbedu/providers/section_provider.dart';
import 'package:finbedu/providers/video_provider.dart';
import 'package:finbedu/providers/videoprogress_provider.dart';
import 'package:finbedu/providers/access_provider.dart'; // pastikan importnya benar
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_preview/device_preview.dart';
import 'routes/app_routes.dart' as route;
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage =
      FlutterSecureStorage(); // Create instance of FlutterSecureStorage

  String? isLoggedInString = await storage.read(key: 'isLoggedIn');
  bool isLoggedIn = isLoggedInString == 'true';
  String? role = await storage.read(key: 'role');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(isLoggedIn: isLoggedIn, role: role),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;

  const MyApp({super.key, required this.isLoggedIn, required this.role});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(isLoggedIn)),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => SectionProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => CourseImageProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AccessProvider()),
        ChangeNotifierProvider(create: (_) => VideoProgressProvider()),
        ChangeNotifierProvider(create: (_) => CertificateProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true, // Required for DevicePreview
        locale: DevicePreview.locale(context), // Optional
        builder: DevicePreview.appBuilder, // Required
        title: 'FINBEDU',
        theme: ThemeData(fontFamily: 'Poppins'),
        initialRoute:
            isLoggedIn
                ? (role == 'student'
                    ? route.student_dashboard
                    : route.mentor_dashboard)
                : route.splashScreen,
        onGenerateRoute: route.controller,
      ),
    );
  }
}
