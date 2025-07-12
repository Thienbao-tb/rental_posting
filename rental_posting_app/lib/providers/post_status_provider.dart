import 'package:flutter/material.dart';

import '../services/post_service.dart';

class PostStatusProvider extends ChangeNotifier {
  int _trangThaiHienTai = 0;
  String _ngayBatDau = '';
  String _ngayKetThuc = '';
  bool _isLoading = false;
  int get trangThaiHienTai => _trangThaiHienTai;
  String get ngayBatDau => _ngayBatDau;
  String get ngayKetThuc => _ngayKetThuc;

  bool get isLoading => _isLoading;

  void setInitialStatus(int status, String ngayBatDau, String ngayKetThuc) {
    _trangThaiHienTai = status;
    _ngayBatDau = ngayBatDau;
    _ngayKetThuc = ngayKetThuc;
    notifyListeners(); // 👈 Cái này rất quan trọng
  }

  Future<void> updateTrangThai({
    required int postId,
    required int status,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Gọi API cập nhật trạng thái
      final result = await PostService().updatePostStatus(
        postId: postId,
        status: status,
      );
      _trangThaiHienTai = status;
      _ngayBatDau = result.thoigian_batdau ?? '';
      _ngayKetThuc = result.thoigian_ketthuc ?? '';

      print('Ngày bắt đầu: $_ngayBatDau');
      print('Ngày kết thúc: $_ngayKetThuc');
    } catch (e) {
      debugPrint('❌ Lỗi update trạng thái: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // 👈 Phải gọi lại để UI rebuild
    }
  }
}
