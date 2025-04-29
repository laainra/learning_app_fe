import 'package:finbedu/providers/category_providers.dart';
import 'package:finbedu/providers/course_image_provider.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/providers/section_provider.dart';
import 'package:finbedu/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the package
import 'routes/app_routes.dart' as route;
import './providers/auth_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storage = FlutterSecureStorage(); // Create instance of FlutterSecureStorage
  
  // Get the stored values from secure storage
  String? isLoggedInString = await storage.read(key: 'isLoggedIn');
  bool isLoggedIn = isLoggedInString == 'true';
  String? role = await storage.read(key: 'role'); 

  runApp(MyApp(isLoggedIn: isLoggedIn, role: role));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role; // Role data

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FINBEDU',
        theme: ThemeData(fontFamily: 'Poppins'),
        initialRoute: isLoggedIn
            ? (role == 'student'
                ? route.student_dashboard
                : route.mentor_dashboard)
            : route.login,
        onGenerateRoute: route.controller,
      ),
    );
  }
}
