import 'package:flutter/material.dart';
import '../routes/app_routes.dart' as route;
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    if (user == null) {
      return const SizedBox.shrink(); // Widget kosong
    }
    final Color activeColor = Color(0xFFFFC100);
    final Color inactiveColor = Color(0xFF202244);

    final userRole = user.role;
    String dashboardRoute;
    if (userRole == 'student') {
      dashboardRoute = route.student_dashboard; // Navigate to student dashboard
    } else if (userRole == 'mentor') {
      dashboardRoute = route.mentor_dashboard; // Navigate to mentor dashboard
    } else {
      dashboardRoute =
          route.student_dashboard; // Fallback route if role is unknown
    }

    return Container(
      margin: const EdgeInsets.all(16), // Supaya terlihat lebih mengambang
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Warna background grey
        borderRadius: BorderRadius.circular(30), // Rounded menu
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 220, 219, 219),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.home,
            label: 'Home',
            index: 0,
            routeName: dashboardRoute,
            isActive: currentIndex == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.menu_book,
            label: 'My Courses',
            index: 1,
            routeName: route.my_course,
            isActive: currentIndex == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, route.inbox),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: inactiveColor,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.account_balance_wallet,
            label: 'Transaction',
            index: 3,
            routeName: route.transaction,
            isActive: currentIndex == 3,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person,
            label: 'Profile',
            index: 4,
            routeName: route.student_profile,
            isActive: currentIndex == 4,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required String routeName,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? activeColor : inactiveColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
