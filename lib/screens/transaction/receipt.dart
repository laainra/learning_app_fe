import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Receipt"),
        leading: const BackButton(),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.send),
                  title: Text('Share'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'download',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Download'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset('assets/images/receipt.png', height: 100), // replace with your image
            const SizedBox(height: 10),
            Image.asset('assets/images/barcode.png', height: 60), // dummy barcode

            const SizedBox(height: 10),
            const Text("25234567     28464345"),

            const SizedBox(height: 20),
            infoRow("Name", "Alex"),
            infoRow("Email ID", "alexreall@gmail.com"),
            infoRow("Course", "3d Character Illustration Cre.."),
            infoRow("Category", "Web Development"),
            infoRowWithCopy("TransactionID", "SK345680976"),
            infoRow("Price", "799/-"),
            infoRow("Date", "Nov 20, 2023    /   15:45"),
            infoRow("Status", "Paid", isStatus: true),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          isStatus
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Paid",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Text(value),
        ],
      ),
    );
  }

  Widget infoRowWithCopy(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Row(
            children: [
              Text(value),
              const SizedBox(width: 4),
              Icon(Icons.copy, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
