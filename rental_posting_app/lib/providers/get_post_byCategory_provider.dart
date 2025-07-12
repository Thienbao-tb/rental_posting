import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class GetPostByCategoryProvider extends ChangeNotifier {
  final PostService _service = PostService();
  final ListEquality _listEquality = const ListEquality();

  List<Post> posts = [];

  int _currentPage = 1;
  final int _pageSize = 10;
  bool isLoading = false;
  bool hasMore = true;
  String? error;

  List<int> _currentCategoryIds = [];
  List<int> _currentDistrictIds = [];
  List<int> _currentWardIds = [];
  List<int> _currentPriceRanges = [];
  List<int> _currentAreaRanges = [];
  String _currentKeyword = '';
  bool _isFeatured = false;
  bool _isNewest = false;

  Future<void> fetchPostByCategory({
    List<int>? categoryIds,
    List<int>? districtIds,
    List<int>? wardIds,
    List<int>? priceRanges,
    List<int>? areaRanges,
    String keyword = '',
    bool noiBat = false,
    bool moiNhat = false,
  }) async {
    if (categoryIds == null) {
      print(
          'fetchPostByCategory: categoryIds bị null => không thực hiện gọi API');
      return;
    }

    final newCategoryIds = categoryIds;
    final newDistrictIds = districtIds ?? [];
    final newWardIds = wardIds ?? [];
    final newPriceRanges = priceRanges ?? [];
    final newAreaRanges = areaRanges ?? [];

    bool shouldReset =
        !_listEquality.equals(_currentCategoryIds, newCategoryIds) ||
            !_listEquality.equals(_currentDistrictIds, newDistrictIds) ||
            !_listEquality.equals(_currentWardIds, newWardIds) ||
            !_listEquality.equals(_currentPriceRanges, newPriceRanges) ||
            !_listEquality.equals(_currentAreaRanges, newAreaRanges) ||
            _currentKeyword != keyword ||
            _isFeatured != noiBat ||
            _isNewest != moiNhat;

    if (shouldReset) {
      _currentCategoryIds = newCategoryIds;
      _currentDistrictIds = newDistrictIds;
      _currentWardIds = newWardIds;
      _currentPriceRanges = newPriceRanges;
      _currentAreaRanges = newAreaRanges;
      _currentKeyword = keyword;
      _isFeatured = noiBat;
      _isNewest = moiNhat;

      _currentPage = 1;
      hasMore = true;
      posts = [];
    }

    error = null;
    isLoading = true;
    notifyListeners();

    try {
      final pagination = await _service.fetchPostsByFilter(
        page: _currentPage,
        categoryIds: _currentCategoryIds,
        districtIds: _currentDistrictIds,
        wardIds: _currentWardIds,
        priceRanges: _currentPriceRanges,
        areaRanges: _currentAreaRanges,
        keyword: _currentKeyword,
        noiBat: _isFeatured,
        moiNhat: _isNewest,
      );

      if (pagination.data.isEmpty) {
        hasMore = false;
      } else {
        posts.addAll(pagination.data);
        _currentPage++;
        if (pagination.data.length < _pageSize) {
          hasMore = false;
        }
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final pagination = await _service.fetchPostsByFilter(
        page: _currentPage,
        categoryIds: _currentCategoryIds,
        districtIds: _currentDistrictIds,
        wardIds: _currentWardIds,
        priceRanges: _currentPriceRanges,
        areaRanges: _currentAreaRanges,
        keyword: _currentKeyword,
        noiBat: _isFeatured,
        moiNhat: _isNewest,
      );

      if (pagination.data.isEmpty) {
        hasMore = false;
      } else {
        posts.addAll(pagination.data);
        _currentPage++;
        if (pagination.data.length < _pageSize) {
          hasMore = false;
        }
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
