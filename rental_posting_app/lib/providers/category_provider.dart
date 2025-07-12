import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categorys = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categorys => _categorys;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categorys = await _categoryService.fetchCategory();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
