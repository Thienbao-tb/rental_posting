import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/care_about_service.dart';

class SimilarProvider extends ChangeNotifier {
  final SimilarService _similarService = SimilarService();
  List<Post> _similarPosts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get similarPosts => _similarPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSimilar({int idPost = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _similarPosts = await _similarService.fetchSimilarPost(idPost: idPost);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
