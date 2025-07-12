import 'package:dio/dio.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/models/detail_image_model.dart';

class DetailImageService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<List<DetailImage>> fetchHotLocations({int id = 0}) async {
    try {
      final response = await _dio.get('$baseUrl/detailImage/$id');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => DetailImage.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchHotLocations: $e');
    }
  }
}
