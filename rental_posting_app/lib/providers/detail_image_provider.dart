import 'package:flutter/material.dart';

import '../models/detail_image_model.dart';
import '../services/detail_image_service.dart';

class DetailImageProvider extends ChangeNotifier {
  final DetailImageService _detailImageService = DetailImageService();

  List<DetailImage> _detailImage = [];
  bool _isLoading = false;
  String? _error;

  List<DetailImage> get detailImages => _detailImage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDetailImage({int id = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _detailImage = await _detailImageService.fetchHotLocations(id: id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
