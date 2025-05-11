import 'package:finbedu/screens/category/category.dart';
import 'package:finbedu/screens/chat/chat_room.dart';
import 'package:finbedu/screens/chat/inbox.dart';
import 'package:finbedu/screens/course/add_course.dart';
import 'package:finbedu/screens/course/certificate_page.dart';
import 'package:finbedu/screens/course/course_curriculum.dart';
import 'package:finbedu/screens/course/course_detail.dart';
import 'package:finbedu/screens/course/course_list.dart';
import 'package:finbedu/screens/course/course_screen.dart';
import 'package:finbedu/screens/course/my_course.dart';
import 'package:finbedu/screens/dashboard/mentor_dashboard.dart';
import 'package:finbedu/screens/dashboard/student_dashboard.dart';
import 'package:finbedu/screens/notification/notification.dart';
import 'package:finbedu/screens/profile/mentor_profile.dart';
import 'package:finbedu/screens/profile/student_profile.dart';
import 'package:finbedu/screens/quiz/quiz_screen.dart';
import 'package:finbedu/screens/reviews/reviews_list.dart';
import 'package:finbedu/screens/reviews/write_reviews.dart';
import 'package:finbedu/screens/search/search.dart';
import 'package:finbedu/screens/search/top_course.dart';
import 'package:finbedu/screens/search/top_mentor.dart';
import 'package:finbedu/screens/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:finbedu/screens/auth/intro_auth.dart';
import 'package:finbedu/screens/auth/login_screen.dart';
import 'package:finbedu/screens/auth/register_screen.dart';
import 'package:finbedu/screens/profile/create_pin.dart';
import 'package:finbedu/screens/profile/edit_profile.dart';
import '../screens/splash_screen.dart';
import '../screens/intro_screen.dart';

const String splashScreen = "splash";
const String introScreen = "intro";
const String introAuth = "intro_auth";
const String login = "login";
const String register = "register";
const String edit_profile = "edit_profile";
const String create_pin = "create_pin";
const String student_dashboard = "student_dashboard";
const String mentor_dashboard = "mentor_dashboard";
const String search = "search";
const String category = "category";
const String top_courses = "top_courses";
const String top_mentor = "top_mentor";
const String course_list = "course_list";
const String popular_course = "popular_course";
const String course = "course";
const String my_course = "my_course";
const String curriculum = "curriculum";
const String write_reviews = "write_reviews";
const String reviews_list = "reviews_list";
const String mentor_profile = "mentor_profile";
const String student_profile = "student_profile";
const String notification = "notification";
const String transaction = "transaction";
const String course_screen = "course_screen";
const String course_detail = "course_detail";
const String certificate = "certificate";
const String quiz = "quiz";
const String inbox = "inbox";
const String chat_room = "chat_room";
const String add_course = "add_course";

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case introScreen:
      return MaterialPageRoute(builder: (_) => const IntroScreen());
    case introAuth:
      return MaterialPageRoute(builder: (_) => const IntroAuth());
    case login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case register:
      return MaterialPageRoute(builder: (_) => RegisterScreen());
    case edit_profile:
      return MaterialPageRoute(builder: (_) => EditProfileScreen());
    case create_pin:
      return MaterialPageRoute(builder: (_) => CreatePinPage());
    case student_dashboard:
      return MaterialPageRoute(builder: (_) => StudentDashboard());
    case mentor_dashboard:
      return MaterialPageRoute(builder: (_) => MentorDashboard());
    case search:
      return MaterialPageRoute(builder: (_) => SearchPage());
    case category:
      return MaterialPageRoute(builder: (_) => AllCategoriesPage());
    case top_courses:
      return MaterialPageRoute(builder: (_) => PopularCoursesPage());
    case top_mentor:
      return MaterialPageRoute(builder: (_) => TopMentorsPage());
    case course_list:
      return MaterialPageRoute(builder: (_) => ListCoursePage());
    case popular_course:
      return MaterialPageRoute(builder: (_) => PopularCoursesPage());
    case course_screen:
      return MaterialPageRoute(builder: (_) => CourseScreenPage());
    case curriculum:
      return MaterialPageRoute(builder: (_) => CurriculumPage());
    case my_course:
      return MaterialPageRoute(builder: (_) => MyCoursesPage());
case course_detail:
  final args = settings.arguments as Map<String, dynamic>;
  return MaterialPageRoute(
    builder: (_) => CourseDetailPage(
      course: args['course'], // Kirim argumen course
    ),
  );
    case certificate:
      return MaterialPageRoute(builder: (_) => CertificatePage());
    case quiz:
        final args = settings.arguments as Map<String, dynamic>;
  return MaterialPageRoute(
    builder: (_) => QuizDetailPage(
      sectionId: args['sectionId'], // Kirim argumen course
    ),
  );
    case reviews_list:
      return MaterialPageRoute(builder: (_) => ReviewsPage());
    case write_reviews:
      return MaterialPageRoute(builder: (_) => WriteReviewPage());
    case mentor_profile:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder:
            (_) => MentorProfilePage(
              name: args['name'],
              skill: args['skill'],
              image: args['image'],
            ),
      );
    case student_profile:
      return MaterialPageRoute(builder: (_) => ProfilePage());
    case notification:
      return MaterialPageRoute(builder: (_) => NotificationPage());
    case inbox:
      return MaterialPageRoute(builder: (_) => InboxPage());
    case chat_room:
      return MaterialPageRoute(builder: (_) => ChatRoomPage());
    case transaction:
      return MaterialPageRoute(builder: (_) => TransactionPage());
    case add_course:
      return MaterialPageRoute(builder: (_) => AddCourseScreen());
    default:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
  }
}
