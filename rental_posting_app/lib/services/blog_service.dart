import 'package:dio/dio.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/models/blog_model.dart';

class BlogService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<List<Blog>> fetchBlog({int page = 1, int? blogId}) async {
    final Map<String, dynamic> queryParameters = {};

    try {
      final response =
          await _dio.get('$baseUrl/blogs', queryParameters: queryParameters);
      print('URL gọi API: ${response.requestOptions.uri}');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Blog.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchHotLocations: $e');
    }
  }
}
