import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rental_posting_app/config/api_config.dart';

class VnPayService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> createTransaction(int amount) async {
    print('$baseUrl/vnpay/create');

    try {
      final token = await _storage.read(key: 'auth_token');

      if (token == null) {
        print('Token không tồn tại');
        return null;
      }
      print('$baseUrl/vnpay/create');
      final response = await _dio.post(
        '$baseUrl/vnpay/create',
        data: {'amount': amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['payment_url'];
      } else {
        print('Lỗi khi tạo giao dịch: ${response.data}');
        return null;
      }
    } catch (e) {
      print('Exception khi gọi API: $e');
      return null;
    }
  }
}
