import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rental_posting_app/config/api_config.dart';

class PostService {
  Future<Map<String, dynamic>> getAllPost(
      {int? page, int? status, int? categoryId, int? userId}) async {
    try {
      Uri uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.posts}')
          .replace(queryParameters: {
        if (userId != null) 'user_id': userId.toString(),
        if (page != null) 'page': page.toString(),
        if (status != null) 'status': status.toString(),
        if (categoryId != null) 'danhmuc_id': categoryId.toString(),
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Không thể tải bài đăng.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối đến máy chủ.'};
    }
  }
}
