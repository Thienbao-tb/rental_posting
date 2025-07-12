import 'package:dio/dio.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/models/post_model.dart';

class CategoryService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<List<Category>> fetchCategory() async {
    try {
      final response = await _dio.get(
        '$baseUrl/categories',
      ); // endpoint tùy chỉnh theo API

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchSimilarPost: $e');
    }
  }
}
