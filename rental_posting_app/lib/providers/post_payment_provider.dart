import 'package:flutter/material.dart';

import '../services/post_service.dart';

class PostPaymentProvider extends ChangeNotifier {
  final PostService _postService = PostService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _paymentResult;
  Map<String, dynamic>? get paymentResult => _paymentResult;

  Future<void> payForPost({
    required int postId,
    required int roomType,
    required int day,
    required String startDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _paymentResult = null;
    notifyListeners();

    try {
      final response = await _postService.payForPost(
        postId: postId,
        roomType: roomType,
        day: day,
        startDate: startDate,
      );

      if (response['status'] == true) {
        _paymentResult = response['data'];
      } else {
        _errorMessage = response['message'] ?? 'Thanh toán thất bại';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _paymentResult = null;
    notifyListeners();
  }
}
