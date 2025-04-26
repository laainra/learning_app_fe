import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Notifications', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Today'),
          _buildNotificationItem(Icons.category, 'New Category Course.!', 'New the 3D Design Course is Availa..', Colors.grey.shade200),
          _buildNotificationItem(Icons.category, 'New Category Course.!', 'New the 3D Design Course is Availa..', Colors.deepPurple.shade100),
          _buildNotificationItem(Icons.local_offer, 'Today’s Special Offers', 'You Have made a Course Payment.', Colors.grey.shade200),
          const SizedBox(height: 16),
          _buildSectionTitle('Yesterday'),
          _buildNotificationItem(Icons.credit_card, 'Credit Card Connected.!', 'Credit Card has been Linked.!', Colors.grey.shade200),
          const SizedBox(height: 16),
          _buildSectionTitle('Nov 20, 2022'),
          _buildNotificationItem(Icons.verified_user, 'Account Setup Successful.!', 'Your Account has been Created.', Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNotificationItem(IconData icon, String title, String subtitle, Color bgColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
