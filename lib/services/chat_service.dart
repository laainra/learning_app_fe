import 'dart:convert';
import 'package:finbedu/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:finbedu/models/chat_room_model.dart';
import 'package:finbedu/models/chat_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ChatService {
  final String baseUrl = ApiConstants.baseUrl;
final storage = const FlutterSecureStorage();

  Future<List<ChatRoom>> fetchChatRooms() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/chat-rooms'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ChatRoom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch chat rooms');
    }
  }

  Future<List<Chat>> fetchChats( int chatRoomId) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatRoomId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Chat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch chats');
    }
  }

  Future<void> sendMessage( int chatRoomId, String message) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'chat_room_id': chatRoomId,
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  Future<ChatRoom> createChatRoom( int mentorId, int studentId) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/chat-rooms'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mentor_id': mentorId,
        'student_id': studentId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return ChatRoom.fromJson(data);
    } else {
      throw Exception('Failed to create chat room');
    }
  }
}