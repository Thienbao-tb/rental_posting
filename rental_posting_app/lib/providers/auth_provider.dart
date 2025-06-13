import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

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
    print("tới provider");
    print('''
    Họ tên: ${name}
    Email: ${email.trim()}
    Mật khẩu: ${password}
    Xác nhận mật khẩu: ${confirmPassword}
    Số điện thoại: ${sdt}
    ''');
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
