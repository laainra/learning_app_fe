import 'package:flutter/material.dart';
import 'package:finbedu/services/videoprogress_service.dart';

class VideoProgressProvider with ChangeNotifier {
  final VideoProgressService _service = VideoProgressService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> markVideoAsWatched(int videoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _service.markVideoAsWatched(videoId);

    _isLoading = false;
    if (!success) {
      _errorMessage = 'Gagal menandai video sebagai ditonton.';
    }

    notifyListeners();
    return success;
  }
}
