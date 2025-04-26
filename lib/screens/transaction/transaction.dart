import 'package:finbedu/screens/transaction/receipt.dart';
import 'package:flutter/material.dart';
import 'package:finbedu/widgets/bottom_menu.dart';

class TransactionPage extends StatelessWidget {
  final transactions = [
    {
      "title": "Build Personal Branding",
      "category": "Web Designer",
      "status": "Paid",
    },
    {
      "title": "Mastering Blender 3D",
      "category": "UI/UX Designer",
      "status": "Paid",
    },
    {
      "title": "Full Stack Web Developm..",
      "category": "Web Development",
      "status": "Paid",
    },
    {
      "title": "Complete UI Designer",
      "category": "HR Management",
      "status": "Paid",
    },
    {
      "title": "Sharing Work with Team",
      "category": "Finance & Accounting",
      "status": "Paid",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        leading: const BackButton(),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 1, // memastikan rasio 1:1
                child: Image.asset(
                  "assets/images/course1.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              item["title"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item["category"]!),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF167F71),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text("Paid", style: TextStyle(color: Colors.white)),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReceiptPage()),
              );
            },
          );
        },
      ),
    );
  }
}
