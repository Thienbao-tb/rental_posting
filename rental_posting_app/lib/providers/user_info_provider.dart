import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_info_service.dart';

class UserInfoProvider extends ChangeNotifier {
  final UserInfoService _userInfoService = UserInfoService();
  User? _user; // chỉ một user
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserInfo({int postId = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userInfoService.fetchUserInfo(postId: postId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
