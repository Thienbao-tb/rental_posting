import 'package:dio/dio.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/models/post_model.dart';

class SimilarService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<List<Post>> fetchSimilarPost({int idPost = 0}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/posts/$idPost/similar',
      ); // endpoint tùy chỉnh theo API

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchSimilarPost: $e');
    }
  }
}
