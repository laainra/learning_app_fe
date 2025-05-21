import 'package:flutter/material.dart';
import '../models/certificate_model.dart';
import '../services/certificate_service.dart'
    as cert_service; // tambahkan alias

class CertificateProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Certificate? _certificate;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Certificate? get certificate => _certificate;

  // Fungsi untuk generate sertifikat
  Future<void> generateCertificateProvider(int courseAccessId) async {
    _isLoading = true;
    _errorMessage = null;
    _certificate = null;
    notifyListeners();

    try {
      final cert = await cert_service.generateCertificate(courseAccessId);
      if (cert != null) {
        _certificate = cert;
      } else {
        _errorMessage = 'Gagal generate sertifikat.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearCertificate() {
    _certificate = null;
    notifyListeners();
  }
}

// Ganti nama fungsi generateCertificateService jika di service kamu namanya generateCertificate
