import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  bool isLoading = false;

  Future<void> getAllPost({
    int? userId,
    int? page,
    int? status,
    int? categoryId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _postService.getAllPost(
        userId: userId,
        page: page,
        status: status,
        categoryId: categoryId,
      );
      if (result['status'] == true && result['posts'] != null) {
        final postResponse = PostResponse.fromJson(result);
        _posts = postResponse.posts.data;
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
