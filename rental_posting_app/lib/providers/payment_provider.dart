import 'package:flutter/material.dart';
import 'package:rental_posting_app/services/payment_service.dart';

import '../models/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  bool _isLoading = false;
  String? _error;
  List<Payment> _history = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Payment> get history => _history;

  Future<void> fetchPaymentHistory() async {
    _setLoading(true);
    _error = null;

    final result = await _paymentService.fetchPaymentHistory();

    if (result['success']) {
      _history = result['data'] as List<Payment>;
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
