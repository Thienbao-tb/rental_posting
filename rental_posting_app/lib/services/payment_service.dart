import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rental_posting_app/models/payment_model.dart';

import '../config/api_config.dart';

class PaymentService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<Map<String, dynamic>> fetchPaymentHistory() async {
    final token = await _getToken();
    print('token $token');
    print(
      Uri.parse('${ApiConfig.apiBaseUrl}/recharge-history'),
    );
    if (token == null) {
      return {
        'success': false,
        'message': 'Chưa đăng nhập.',
      };
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.apiBaseUrl}/payment-history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List<Payment> paymentList = (data['data'] as List)
            .map((item) => Payment.fromJson(item))
            .toList();
        return {
          'success': true,
          'data': paymentList,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy lịch sử thanh toán.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }
}
