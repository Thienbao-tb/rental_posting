import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/recharge_history_model.dart';

class RechargeService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<Map<String, dynamic>> fetchRechargeHistory() async {
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
        Uri.parse('${ApiConfig.apiBaseUrl}/recharge-history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List<RechargeHistory> historyList = (data['data'] as List)
            .map((item) => RechargeHistory.fromJson(item))
            .toList();
        return {
          'success': true,
          'data': historyList,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy lịch sử nạp tiền.',
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
