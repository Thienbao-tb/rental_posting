import 'package:flutter/cupertino.dart';

import '../models/blog_model.dart';
import '../services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  final BlogService _service = BlogService();

  List<Blog> blogs = [];
  bool isLoading = false;

  Future<void> fetchBlog() async {
    isLoading = true;
    notifyListeners();

    try {
      blogs = await _service.fetchBlog();
    } catch (e) {
      print("Lỗi fetchBlog: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
