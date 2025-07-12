import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rental_posting_app/config/api_config.dart';

import '../models/post_model.dart';

class PostService {
  final Dio _dio = Dio();
  final String baseUrl = ApiConfig.apiBaseUrl;

  Future<PostPagination> fetchPosts({
    int page = 1,
    bool onlyNoiBat = false,
    bool onlyMoiNhat = false,
  }) async {
    try {
      final response = await _dio.get('$baseUrl/posts', queryParameters: {
        'page': page,
        'noibat': onlyNoiBat,
        'moinhat': onlyMoiNhat,
      });

      if (response.statusCode == 200) {
        final postsJson = response.data['posts'];
        return PostPagination.fromJson(postsJson);
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchPosts: $e');
    }
  }

  Future<PostPagination> fetchPostsByFilter({
    int page = 1,
    List<int>? categoryIds,
    List<int>? districtIds,
    List<int>? wardIds,
    List<int>? priceRanges,
    List<int>? areaRanges,
    String keyword = '',
    bool noiBat = false,
    bool moiNhat = false,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
      };

      // Các filter, chuyển thành chuỗi '1,2,3' nếu có
      if (categoryIds != null && categoryIds.isNotEmpty) {
        queryParameters['danhmuc_id'] = categoryIds.join(',');
      }
      if (districtIds != null && districtIds.isNotEmpty) {
        queryParameters['qhuyen_id'] = districtIds.join(',');
      }
      if (wardIds != null && wardIds.isNotEmpty) {
        queryParameters['phuongxa_id'] = wardIds.join(',');
      }
      if (priceRanges != null && priceRanges.isNotEmpty) {
        queryParameters['khoanggia'] = priceRanges.join(',');
      }
      if (areaRanges != null && areaRanges.isNotEmpty) {
        queryParameters['khoangkhuvuc'] = areaRanges.join(',');
      }
      if (keyword.isNotEmpty) {
        queryParameters['keyword'] = keyword;
      }
      if (noiBat) {
        queryParameters['noibat'] = noiBat;
      }
      if (moiNhat) {
        queryParameters['moinhat'] = moiNhat;
      }

      final response =
          await _dio.get('$baseUrl/posts', queryParameters: queryParameters);
      print('URL gọi API: ${response.requestOptions.uri}');
      if (response.statusCode == 200) {
        final postsJson = response.data['posts'];
        return PostPagination.fromJson(postsJson);
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchPostsByFilter: $e');
    }
  }

  Future<PostPagination> fetchPostsByUser({int page = 1, int? userId}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'user_id': userId,
      };

      final response =
          await _dio.get('$baseUrl/posts', queryParameters: queryParameters);
      print('URL gọi API: ${response.requestOptions.uri}');
      if (response.statusCode == 200) {
        final postsJson = response.data['posts'];
        return PostPagination.fromJson(postsJson);
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetchPostsByFilter: $e');
    }
  }

  Future<Post> updatePostStatus({
    required int postId,
    required int status,
  }) async {
    try {
      final FlutterSecureStorage _storage = const FlutterSecureStorage();

      Future<String?> _getToken() async {
        return await _storage.read(key: 'auth_token');
      }

      final token = await _getToken();

      print('🔑 Token: $token');
      print('URL gọi API: $baseUrl/posts/$postId/status');
      print('Dữ liệu gửi lên: { status: $status }');

      final response = await _dio.put(
        '$baseUrl/posts/$postId/status',
        data: {
          'status': status,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        print('Cập nhật thành công!');
        return Post.fromJson(response.data['data']);
      } else {
        print('Cập nhật thất bại: ${response.data['message']}');
        throw Exception(response.data['message'] ?? 'Cập nhật thất bại');
      }
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái: $e');
      throw Exception('Lỗi khi cập nhật trạng thái: $e');
    }
  }

  Future<Map<String, dynamic>> payForPost({
    required int postId,
    required int roomType,
    required int day,
    required String startDate,
  }) async {
    try {
      final FlutterSecureStorage _storage = const FlutterSecureStorage();
      final token = await _storage.read(key: 'auth_token');

      final response = await _dio.post(
        '$baseUrl/posts/$postId/pay',
        data: {
          'room_type': roomType,
          'day': day,
          'thoigian_batdau': startDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => true, // 👈 Cho phép xử lý thủ công cả lỗi
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return {
          'status': true,
          'data': response.data['data'],
        };
      } else {
        return {
          'status': false,
          'message': response.data['message'] ?? 'Thanh toán thất bại',
        };
      }
    } catch (e) {
      print('❌ Exception khi thanh toán: $e');
      throw Exception('Lỗi khi thanh toán tin: $e');
    }
  }

  Future<Map<String, dynamic>> createPost({
    required String ten,
    required String motat,
    required int qhuyen_id,
    required int phuongxa_id,
    required int gia,
    required int dientich,
    required int danhmuc_id,
    required String sophong,
    required String chitietdiachi,
    required String map,
    required File? anhdaidien,
    required List<File> albumFiles,
  }) async {
    try {
      final FlutterSecureStorage _storage = const FlutterSecureStorage();
      final token = await _storage.read(key: 'auth_token');
      print('Token: $token');
      List<MultipartFile> multipartFiles = [];
      if (albumFiles.isNotEmpty) {
        for (File file in albumFiles) {
          MultipartFile multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
          multipartFiles.add(multipartFile);
        }
      }

      // Tạo FormData để gửi multipart
      final formData = FormData.fromMap({
        'ten': ten,
        'mota': motat,
        'qhuyen_id': qhuyen_id,
        'phuongxa_id': phuongxa_id,
        'gia': gia,
        'khuvuc': dientich,
        'danhmuc_id': danhmuc_id,
        'sophong': sophong,
        'chitietdiachi': chitietdiachi,
        'map': map,
        if (anhdaidien != null)
          'anhdaidien': await MultipartFile.fromFile(anhdaidien.path,
              filename: anhdaidien.path.split('/').last),
        if (albumFiles.isNotEmpty) 'album[]': multipartFiles
      });

      print('anhdaidien: $anhdaidien');
      print('albumFiles: $albumFiles');

      final response = await _dio.post(
        '$baseUrl/posts/store',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 201 && response.data['status'] == true) {
        print("satus code: 201");
        print(response.data['b']);
        return {
          'status': true,
          'data': response.data['data'],
        };
      } else {
        print(response.data);
        return {
          'status': false,
          'message': response.data['message'] ?? 'Đăng tin thất bại',
        };
      }
    } catch (e) {
      print('❌ Exception khi đăng tin: $e');
      throw Exception('Lỗi khi đăng tin: $e');
    }
  }

  //Update post
  Future<Map<String, dynamic>> updatePost({
    required int idPost,
    required String ten,
    required String motat,
    required int qhuyen_id,
    required int phuongxa_id,
    required int gia,
    required int dientich,
    required int danhmuc_id,
    required String sophong,
    required String chitietdiachi,
    required String map,
    File? anhdaidien,
    List<File> albumFiles = const [],
  }) async {
    try {
      final FlutterSecureStorage _storage = const FlutterSecureStorage();
      final token = await _storage.read(key: 'auth_token');

      List<MultipartFile> multipartFiles = [];
      if (albumFiles.isNotEmpty) {
        for (File file in albumFiles) {
          MultipartFile multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
          multipartFiles.add(multipartFile);
        }
      }

      final formData = FormData.fromMap({
        'ten': ten,
        'mota': motat,
        'qhuyen_id': qhuyen_id,
        'phuongxa_id': phuongxa_id,
        'gia': gia,
        'khuvuc': dientich,
        'danhmuc_id': danhmuc_id,
        'sophong': sophong,
        'chitietdiachi': chitietdiachi,
        'map': map,
        if (anhdaidien != null)
          'anhdaidien': await MultipartFile.fromFile(
            anhdaidien.path,
            filename: anhdaidien.path.split('/').last,
          ),
        if (albumFiles.isNotEmpty) 'album[]': multipartFiles,
      });

      final response = await _dio.post(
        '$baseUrl/posts/$idPost/update',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return {
          'status': true,
          'data': response.data['data'],
        };
      } else {
        return {
          'status': false,
          'message': response.data['message'] ?? 'Cập nhật thất bại',
        };
      }
    } catch (e) {
      print('❌ Exception khi cập nhật tin: $e');
      return {
        'status': false,
        'message': 'Lỗi khi cập nhật tin: $e',
      };
    }
  }

  // Get post by ID
  Future<Post> getPostById({int? idPost}) async {
    try {
      final response = await _dio.get('$baseUrl/posts/$idPost');

      if (response.statusCode == 200) {
        final data = response.data['post'];
        return Post.fromJson(data); // Dữ liệu là 1 object, không phải list
      } else {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi fetch post by ID: $e');
    }
  }
}
