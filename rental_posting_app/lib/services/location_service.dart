import 'package:dio/dio.dart';
import 'package:rental_posting_app/config/api_config.dart';
import 'package:rental_posting_app/models/location_model.dart';

class LocationService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<List<Location>> fetchHotLocations({
    bool onlyNoibat = false,
    bool qhuyen = false,
    bool phuongxa = false,
  }) async {
    try {
      final response = await _dio.get('$baseUrl/locations', queryParameters: {
        'noibat': onlyNoibat,
        'qhuyen': qhuyen,
        'phuongxa': phuongxa,
      }); // endpoint tùy chỉnh theo API

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchHotLocations: $e');
    }
  }

  Future<List<Location>> fetchPhuongXaByQhuyen(int qhuyenId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/locations/phuongxa-by-qhuyen',
        queryParameters: {
          'id': qhuyenId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchPhuongXaByQhuyen: $e');
    }
  }
}
