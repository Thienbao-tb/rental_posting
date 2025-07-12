import 'package:flutter/material.dart';
import 'package:rental_posting_app/services/recharge_service.dart';

import '../models/recharge_history_model.dart';

class RechargeProvider extends ChangeNotifier {
  final RechargeService _rechargeService = RechargeService();

  bool _isLoading = false;
  String? _error;
  List<RechargeHistory> _history = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<RechargeHistory> get history => _history;

  Future<void> fetchRechargeHistory() async {
    _setLoading(true);
    _error = null;

    final result = await _rechargeService.fetchRechargeHistory();

    if (result['success']) {
      _history = result['data'] as List<RechargeHistory>;
    } else {
      _error = result['message'] ?? 'Đã xảy ra lỗi khi tải dữ liệu';
    }

    _setLoading(false);
  }

  void clearHistory() {
    _history = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
