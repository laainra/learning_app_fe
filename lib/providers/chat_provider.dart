import 'dart:io';

import 'package:flutter/material.dart';
import 'package:finbedu/models/chat_room_model.dart';
import 'package:finbedu/models/chat_model.dart';
import 'package:finbedu/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<ChatRoom> _chatRooms = [];
  List<Chat> _chats = [];

  List<ChatRoom> get chatRooms => _chatRooms;
  List<Chat> get chats => _chats;

  Future<List<ChatRoom>> fetchChatRooms() async {
    try {
      _chatRooms = await _chatService.fetchChatRooms();
      notifyListeners();
      return _chatRooms;
    } catch (e) {
      print('Error fetching chat rooms: $e');
      rethrow;
    }
  }

  Future<void> fetchChats(int chatRoomId) async {
    _chats = await _chatService.fetchChats(chatRoomId);
    notifyListeners();
  }

  Future<ChatRoom> createChatRoom(int mentorId, int studentId) async {
    try {
      final chatRoom = await _chatService.createChatRoom(mentorId, studentId);
      await fetchChatRooms(); // Refresh chat rooms
      return chatRoom;
    } catch (e) {
      print('Error creating chat room: $e');
      rethrow;
    }
  }

  
Future<void> sendMessage(int chatRoomId, String message) async {
  final tempMessage = Chat(
    id: DateTime.now().millisecondsSinceEpoch, // Gunakan ID sementara
    userId: 0, // ID pengguna bisa diisi dengan nilai default
    text: message,
    isMe: true,
    time: "Sending...",
    status: "sending", // Status sementara
    attachment: null,
    user: null,
  );

  // Tambahkan pesan sementara ke daftar pesan
  _chats.add(tempMessage);
  notifyListeners();

  try {
    await _chatService.sendMessage(chatRoomId, message);

    // Jika berhasil, perbarui status pesan
    tempMessage.status = "sent";
    tempMessage.time = "Just now";
  } catch (e) {
    // Jika gagal, perbarui status pesan
    tempMessage.status = "failed";
    tempMessage.time = "Failed to send";
    print('Error sending message: $e');
  }

  notifyListeners();
}


 

  Future<void> fetchMessages(int chatRoomId) async {
    try {
      _chats = await _chatService.fetchChats(chatRoomId);
      notifyListeners();
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }
  Future<void> sendMessageWithAttachment(int chatRoomId, String message, File? file) async {
  final tempMessage = Chat(
    id: DateTime.now().millisecondsSinceEpoch,
    userId: 0,
    text: message,
    isMe: true,
    time: "Sending...",
    status: "sending",
    attachment: file?.path,
    user: null,
  );

  _chats.add(tempMessage);
  notifyListeners();

  try {
    await _chatService.sendMessageWithAttachment(chatRoomId, message, file);
    tempMessage.status = "sent";
    tempMessage.time = "Just now";
  } catch (e) {
    tempMessage.status = "failed";
    tempMessage.time = "Failed to send";
    print('Error sending message: $e');
  }

  notifyListeners();
}

}
