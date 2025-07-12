import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class NewPostProvider extends ChangeNotifier {
  final PostService _service = PostService();

  List<Post> posts = [];
  int _currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> fetchInitialPosts() async {
    _currentPage = 1;
    hasMore = true;
    posts = [];
    await fetchMorePosts();
  }

  Future<void> fetchMorePosts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final pagination =
          await _service.fetchPosts(page: _currentPage, onlyMoiNhat: true);

      if (pagination.data.isEmpty) {
        hasMore = false;
      } else {
        posts.addAll(pagination.data);
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Lỗi khi tải bài viết: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
