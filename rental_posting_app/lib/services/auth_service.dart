import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _currentUser;
  String? _token;

  User? get currentUser => _currentUser;
  String? get token => _token;

  // Kiểm tra token đã lưu
  Future<bool> isLogged() async {
    _token = await _storage.read(key: 'auth_token');
    return _token != null;
  }

  // Lấy token đã lưu
  Future<String?> getToken() async {
    _token ??= await _storage.read(key: 'auth_token');
    return _token;
  }

  // Lưu token
  Future<void> _saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  // Xóa token
  Future<void> _removeToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  // Đăng ký
  Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation, String sdt) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}${ApiConfig.register}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "ten": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "sodienthoai": sdt,
          "facebook": null,
          "anhdaidien": null
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        final userData = responseData['user'];
        _currentUser = User.fromJson(userData);
        _saveToken(responseData['token']);
        return {'success': true, 'message': 'Đăng ký thành công'};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng ký thất bại',
          'errors': responseData['errors']
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}${ApiConfig.login}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        final userData = responseData['user'];
        _currentUser = User.fromJson(userData);
        _saveToken(responseData['token']);
        return {'success': true, 'message': 'Đăng nhập thành công'};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng nhập thất bại',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Lấy thông tin người dùng
  Future<Map<String, dynamic>> getUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'Chưa đăng nhập'};
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.apiBaseUrl}${ApiConfig.user}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        final userData = responseData['user'];
        _currentUser = User.fromJson(userData);
        return {'success': true, 'user': _currentUser};
      } else {
        // Token có thể đã hết hạn
        _removeToken();
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Không thể lấy thông tin người dùng',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Đăng xuất
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        _removeToken();
        return {'success': true, 'message': 'Đã đăng xuất'};
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}${ApiConfig.logout}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Xóa token ngay cả khi API thất bại
      await _removeToken();
      _currentUser = null;

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Đăng xuất thành công'};
      } else {
        return {'success': true, 'message': 'Đã đăng xuất khỏi thiết bị này'};
      }
    } catch (e) {
      // Xóa token ngay cả khi có lỗi
      await _removeToken();
      _currentUser = null;
      return {'success': true, 'message': 'Đã đăng xuất khỏi thiết bị này'};
    }
  }

  Future<Map<String, dynamic>> updateUserInfo({
    required String ten,
    required String email,
    required String sodienthoai,
    File? avatarFile,
  }) async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Chưa đăng nhập'};
    }

    final dio = Dio();
    final formData = FormData.fromMap({
      'ten': ten,
      'email': email,
      'sodienthoai': sodienthoai,
      if (avatarFile != null)
        'anhdaidien': await MultipartFile.fromFile(avatarFile.path,
            filename: avatarFile.path.split('/').last),
    });

    try {
      print('${ApiConfig.apiBaseUrl}/update-user');
      final response = await dio.post(
        '${ApiConfig.apiBaseUrl}/update-user',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          contentType: 'multipart/form-data',
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final responseData = response.data;

      if (response.statusCode == 200 && responseData['status'] == true) {
        _currentUser = User.fromJson(responseData['user']);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Cập nhật thành công',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Cập nhật thất bại',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'Chưa đăng nhập'};
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/update-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Đổi mật khẩu thành công'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đổi mật khẩu thất bại',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
