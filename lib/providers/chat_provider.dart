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

  Future<void> fetchChatRooms() async {
    try {
      _chatRooms = await _chatService.fetchChatRooms();
      notifyListeners();
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
  }

  Future<void> fetchChats(int chatRoomId) async {
    try {
      _chats = await _chatService.fetchChats( chatRoomId);
      notifyListeners();
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  Future<ChatRoom> createChatRoom(int mentorId, int studentId) async {
    try {
      final chatRoom = await _chatService.createChatRoom( mentorId, studentId);
      await fetchChatRooms(); // Refresh chat rooms
      return chatRoom;
    } catch (e) {
      print('Error creating chat room: $e');
      rethrow;
    }
  }

  Future<void> sendMessage( int chatRoomId, String message) async {
    try {
      await _chatService.sendMessage( chatRoomId, message);
      await fetchChats(chatRoomId); // Refresh chats
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}