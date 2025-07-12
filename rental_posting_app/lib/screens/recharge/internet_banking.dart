import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/screens/recharge/web_view.dart';

import '../../config/format_function.dart';
import '../../providers/vn_pay_provider.dart';

class BankingScreen extends StatefulWidget {
  const BankingScreen({super.key});

  @override
  State<BankingScreen> createState() => _BankingScreenState();
}

class _BankingScreenState extends State<BankingScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment(BuildContext context) async {
    final provider = Provider.of<VnPayProvider>(context, listen: false);
    final amountText = _amountController.text.trim();

    if (amountText.isEmpty || int.tryParse(amountText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập số tiền hợp lệ")),
      );
      return;
    }

    final int amount = int.parse(amountText);

    await provider.createPayment(amount);

    if (provider.paymentUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VnPayWebViewPage(paymentUrl: provider.paymentUrl!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Lỗi không xác định")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VnPayProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FormatFunction.buildCustomAppBar(
              title: 'Thẻ ATM Internet Banking',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Text('Thanh toán qua cổng thanh toán VNPAY-QR:',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff856404),
                                  fontWeight: FontWeight.bold)),
                          Text(
                            'Cổng trung gian kết nối các đơn vị kinh doanh với các ngân hàng...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff856404),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Số tiền nạp:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _handlePayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA00),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Tiếp tục',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
