import 'dart:convert';
import 'dart:io';
import 'package:finbedu/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:finbedu/models/chat_room_model.dart';
import 'package:finbedu/models/chat_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ChatService {
  final String baseUrl = Constants.baseUrl;
  final storage = const FlutterSecureStorage();

  Future<List<ChatRoom>> fetchChatRooms() async {
    final token = await storage.read(key: 'token');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat-rooms'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ChatRoom.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch chat rooms: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching chat rooms: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(int chatRoomId) async {
    final url = Uri.parse(
      '${Constants.baseUrl}/chat-rooms/$chatRoomId/messages',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((message) => message as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<List<Chat>> fetchChats(int chatRoomId) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatRoomId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Chat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch chats');
    }
  }

  Future<void> sendMessage(int chatRoomId, String message) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'chat_room_id': chatRoomId, 'message': message}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200 || response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  Future<ChatRoom> createChatRoom(int mentorId, int studentId) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/chat-rooms'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'mentor_id': mentorId, 'student_id': studentId}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return ChatRoom.fromJson(data);
    } else {
      throw Exception('Failed to create chat room: ${response.body}');
    }
  }

  Future<void> sendMessageWithAttachment(
    int chatRoomId,
    String message,
    File? file,
  ) async {
    final token = await storage.read(key: 'token');

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/chats'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['chat_room_id'] = chatRoomId.toString();
    request.fields['message'] = message;

    if (file != null) {
      // Menambahkan file gambar
      var mimeType = mime(file.path) ?? 'application/octet-stream';
      var mimeTypeData = mimeType.split('/');
      var multipartFile = http.MultipartFile(
        'attachment',
        file.openRead(),
        await file.length(),
        filename: file.path.split('/').last,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      );
      request.files.add(multipartFile);
      // request.files.add(await http.MultipartFile.fromPath('attachment', file.path));
    }

    final response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
