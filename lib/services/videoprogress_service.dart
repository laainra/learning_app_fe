import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart'; // import constants

class VideoProgressService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  VideoProgressService();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  Future<bool> markVideoAsWatched(int videoId) async {
    final token = await _getToken();

    if (token == null) {
      print('Token tidak ditemukan.');
      return false;
    }

    final url = Uri.parse('${Constants.baseUrl}/video-progress/watch');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'video_id': videoId}),
      );

      if (response.statusCode == 200) {
        print('Berhasil menandai video $videoId sebagai ditonton.');
        return true;
      } else {
        print('Gagal menandai video. Status: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Terjadi kesalahan saat menandai video: $e');
      return false;
    }
  }
}
