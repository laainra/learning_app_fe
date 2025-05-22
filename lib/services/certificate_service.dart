import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/certificate_model.dart';
import 'constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<Certificate?> generateCertificate(int courseAccessId) async {
  try {
    final token = await storage.read(key: 'token');
    if (token == null) {
      print('Token tidak ditemukan. Harap login terlebih dahulu.');
      return null;
    }

    final url = Uri.parse(
      '${Constants.baseUrl}/course-accesses/$courseAccessId/generate-certificate',
    );

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['certificate'] != null) {
        return Certificate.fromJson(data['certificate']);
      } else {
        print('Sertifikat tidak ditemukan di response.');
        return null;
      }
    } else {
      print('Gagal generate sertifikat. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Terjadi kesalahan saat generate sertifikat: $e');
    return null;
  }
}
