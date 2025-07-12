import 'package:dio/dio.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/models/user_model.dart';

class UserInfoService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<User> fetchUserInfo({int postId = 0}) async {
    try {
      final response = await _dio.get('$baseUrl/posts/$postId/user');

      if (response.statusCode == 200) {
        final data = response.data['user']; // Đây là Map
        return User.fromJson(data);
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchUserInfo: $e');
    }
  }
}
