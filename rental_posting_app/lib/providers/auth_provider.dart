import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _errorDetails;
  Map<String, dynamic>? get errorDetails => _errorDetails;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  User? _user;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  User? get user => _user;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _setLoading(true);
    final loggedIn = await _authService.isLogged();
    if (loggedIn) {
      final result = await _authService.getUser();
      if (result['success']) {
        _user = result['user'];
        _isAuthenticated = true;
      } else {
        _error = result['message'];
        _isAuthenticated = false;
      }
    }
    _setLoading(false);
  }

  Future<bool> register(String name, String email, String password,
      String confirmPassword, String sdt) async {
    _setLoading(true);

    final result = await _authService.register(
        name, email, password, confirmPassword, sdt);

    print(result['success']);
    print(result['message']);

    if (result['success']) {
      _user = _authService.currentUser;
      _isAuthenticated = true;
    } else {
      _error = result['message'];
      _isAuthenticated = false;
    }

    _setLoading(false);
    return result['success'];
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    final result = await _authService.login(email, password);
    print(result['message']);
    if (result['success']) {
      _user = _authService.currentUser;
      _isAuthenticated = true;
    } else {
      _error = result['message'];
      _isAuthenticated = false;
    }

    _setLoading(false);
    return result['success'];
  }

  Future<bool> refreshUser() async {
    _setLoading(true);
    final result = await _authService.getUser();

    if (result['success']) {
      _user = result['user'];
    } else {
      _error = result['message'];
      _isAuthenticated = false;
    }

    _setLoading(false);
    return result['success'];
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    _setLoading(false);
  }

  Future<Map<String, dynamic>> updateUserInfo({
    required String ten,
    required String email,
    required String sodienthoai,
    File? avatarFile,
  }) async {
    _setLoading(true);
    _error = null;
    _errorDetails = null;

    final result = await _authService.updateUserInfo(
      ten: ten,
      email: email,
      sodienthoai: sodienthoai,
      avatarFile: avatarFile,
    );

    if (result['success']) {
      final refreshResult = await _authService.getUser();
      if (refreshResult['success']) {
        _user = refreshResult['user'];
      }
    } else {
      _errorDetails = result['errors'];
    }

    _setLoading(false);
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _setLoading(true);
    _error = null;
    _errorDetails = null;

    final result = await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
    print(result['success']);
    print(result['message']);
    print(result['errors']);
    if (result['success']) {
      // Nếu đổi mật khẩu thành công thì không cần cập nhật user
    } else {
      _error = result['message'];
      _errorDetails = result['errors'];
    }

    _setLoading(false);
    notifyListeners();
    return result;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
