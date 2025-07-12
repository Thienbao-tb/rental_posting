import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class GetPostByUserProvider extends ChangeNotifier {
  final PostService _service = PostService();

  List<Post> _posts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchInitialPosts(int userId) async {
    _posts = [];
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    await fetchMorePosts(userId);
  }

  Future<void> fetchMorePosts(int userId) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.fetchPostsByUser(
        page: _currentPage,
        userId: userId,
      );

      if (result.data.isNotEmpty) {
        _posts.addAll(result.data);
        _currentPage++;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      print('Lỗi khi tải danh sách bài đăng của user: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
