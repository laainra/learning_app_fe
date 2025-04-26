import 'package:flutter/material.dart';
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {"text": "Hi, Nicholas Good Evening 😊", "isMe": true, "time": "10:45"},
      {"text": "How was your UI/UX Design Course Like.? 😄", "isMe": true, "time": "12:45"},
      {"text": "Hi, Morning too Ronald", "isMe": false, "time": "15:29"},
      {"image": true, "isMe": false},
      {"text": "Hello, I also just finished the Sketch Basic ⭐️⭐️⭐️⭐️", "isMe": false, "time": "15:29"},
      {"text": "OMG, This is Amazing..", "isMe": true, "time": "13:59"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.call),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Chip(
                label: Text("Today"),
                backgroundColor: Color(0xFFECEFF1),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["isMe"] == true;
                final bgColor = isMe ? Colors.green : const Color(0xFFE7F0FC);
                final textColor = isMe ? Colors.white : Colors.black87;

                if (msg.containsKey("image")) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _imageBubble(),
                        const SizedBox(width: 8),
                        _imageBubble(),
                      ],
                    ),
                  );
                }

                return Container(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg["text"] as String,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg["time"] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }

  Widget _imageBubble() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: "Message",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.mic, color: Color(0xFF0A214C)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0A214C)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
