import 'package:flutter/material.dart';

import '../services/vn_pay_service.dart';

class VnPayProvider extends ChangeNotifier {
  bool isLoading = false;
  String? paymentUrl;
  String? errorMessage;

  final VnPayService _vnPayService = VnPayService();

  Future<void> createPayment(int amount) async {
    isLoading = true;
    paymentUrl = null;
    errorMessage = null;
    notifyListeners();

    print('amount: $amount');
    try {
      final url = await _vnPayService.createTransaction(amount);
      if (url != null) {
        paymentUrl = url;
      } else {
        errorMessage = "Không thể tạo giao dịch.";
      }
    } catch (e) {
      errorMessage = "Lỗi: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  void reset() {
    isLoading = false;
    paymentUrl = null;
    errorMessage = null;
    notifyListeners();
  }
}
