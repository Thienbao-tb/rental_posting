import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rental_posting_app/services/post_service.dart';

import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<Map<String, dynamic>> submitPost({
    required String ten,
    required String motat,
    required int qhuyenId,
    required int phuongxaId,
    required int gia,
    required int dientich,
    required int danhmucId,
    required String sophong,
    required String chitietdiachi,
    required String map,
    File? anhdaidien,
    List<File> albumFiles = const [],
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await PostService().createPost(
        ten: ten,
        motat: motat,
        qhuyen_id: qhuyenId,
        phuongxa_id: phuongxaId,
        gia: gia,
        dientich: dientich,
        danhmuc_id: danhmucId,
        sophong: sophong,
        chitietdiachi: chitietdiachi,
        map: map,
        anhdaidien: anhdaidien,
        albumFiles: albumFiles,
      );

      isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return {
        'status': false,
        'message': 'Đã xảy ra lỗi khi đăng tin: $errorMessage',
      };
    }
  }

  Future<Map<String, dynamic>> updatePost({
    required int idPost,
    required String ten,
    required String motat,
    required int qhuyenId,
    required int phuongxaId,
    required int gia,
    required int dientich,
    required int danhmucId,
    required String sophong,
    required String chitietdiachi,
    required String map,
    File? anhdaidien,
    List<File> albumFiles = const [],
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await PostService().updatePost(
        idPost: idPost,
        ten: ten,
        motat: motat,
        qhuyen_id: qhuyenId,
        phuongxa_id: phuongxaId,
        gia: gia,
        dientich: dientich,
        danhmuc_id: danhmucId,
        sophong: sophong,
        chitietdiachi: chitietdiachi,
        map: map,
        anhdaidien: anhdaidien,
        albumFiles: albumFiles,
      );

      isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return {
        'status': false,
        'message': 'Đã xảy ra lỗi khi cập nhật tin: $errorMessage',
      };
    }
  }

  Post? postDetail;
  Future<void> fetchPostById({required int idPost}) async {
    isLoading = true;
    notifyListeners();
    print('idPost : $idPost');

    try {
      postDetail = await PostService().getPostById(idPost: idPost);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      postDetail = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
