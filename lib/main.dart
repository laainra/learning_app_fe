import 'package:finbedu/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_routes.dart' as route;
import './providers/auth_provider.dart';

import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Await for SharedPreferences initialization
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the user is logged in
  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isLoggedIn =  false;

  // Run the app after initializing
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(isLoggedIn)),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (_) => CategoryProvider()), // Add UserProvider here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FINBEDU',
        theme: ThemeData(fontFamily: 'Poppins'),
        initialRoute: isLoggedIn ? route.student_dashboard : route.splashScreen,
        onGenerateRoute: route.controller,
      ),
    );
  }
}
