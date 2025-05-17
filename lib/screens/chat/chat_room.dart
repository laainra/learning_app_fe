import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:finbedu/models/chat_room_model.dart';
import 'package:finbedu/providers/user_provider.dart';
import 'package:finbedu/providers/chat_provider.dart';
import 'package:finbedu/services/constants.dart';

class ChatRoomPage extends StatefulWidget {
  final int chatRoomId;

  const ChatRoomPage({super.key, required this.chatRoomId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  File? _selectedFile;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.fetchMessages(widget.chatRoomId);
  }

  Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _removeAttachment() {
    setState(() {
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    final chatProvider = Provider.of<ChatProvider>(context);
    final chatRoom = chatProvider.chatRooms.firstWhere(
      (room) => room.id == widget.chatRoomId,
      orElse: () => throw Exception("Chat room not found"),
    );
    final messages = chatProvider.chats;

    final otherUser =
        chatRoom.mentor.id == currentUser?.id
            ? chatRoom.student
            : chatRoom.mentor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            ClipOval(
              child:
                  (otherUser.photo ?? '').isNotEmpty
                      ? Image.network(
                        '${Constants.imgUrl}/${otherUser.photo}',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _defaultAvatar();
                        },
                      )
                      : _defaultAvatar(),
            ),
            const SizedBox(width: 10),
            Text(
              otherUser.name ?? "Unknown",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
            child:
                messages.isEmpty
                    ? const Center(child: Text("No messages yet"))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.isMe == true;
                        final bgColor =
                            isMe ? Colors.green : const Color(0xFFE7F0FC);
                        final textColor = isMe ? Colors.white : Colors.black87;

                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment:
                                isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              if (msg.attachment != null)
                                _buildAttachment(msg.attachment!),
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  msg.text ?? '',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              Text(
                                msg.time ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
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

  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedFile != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(_selectedFile!.path.split('/').last)),
                  GestureDetector(
                    onTap: _removeAttachment,
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: _pickAttachment,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: "Type your message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF0A214C)),
                onPressed: () async {
                  final text = _messageController.text.trim();
                  if (text.isNotEmpty || _selectedFile != null) {
                    final chatProvider = Provider.of<ChatProvider>(
                      context,
                      listen: false,
                    );
                    await chatProvider.sendMessageWithAttachment(
                      widget.chatRoomId,
                      text,
                      _selectedFile,
                    );
                    _messageController.clear();
                    _removeAttachment();
                    await _loadMessages();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(String url) {
    if (url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.gif')) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Image.network(
          '${Constants.imgUrl}/$url',
          width: 200,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Text("Image failed to load"),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.black54),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  url.split('/').last,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.download, size: 16),
            ],
          ),
        ),
      );
    }
  }

  Widget _defaultAvatar() {
    return Container(
      width: 40,
      height: 40,
      color: Colors.white,
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }
}
