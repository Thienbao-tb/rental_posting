import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/config/format_function.dart';
import 'package:rental_posting_app/models/payment_model.dart'; // Import đúng model
import 'package:rental_posting_app/providers/payment_provider.dart';

class LichSuThanhToan extends StatefulWidget {
  const LichSuThanhToan({super.key});

  @override
  State<LichSuThanhToan> createState() => _LichSuThanhToanState();
}

class _LichSuThanhToanState extends State<LichSuThanhToan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchPaymentHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Lịch sử thanh toán',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<PaymentProvider>(
                builder: (context, paymentProvider, child) {
                  if (paymentProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = paymentProvider.history;

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không có lịch sử thanh toán',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(transaction: transactions[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Payment
      transaction; // sửa Transaction thành Payment nếu đó là model bạn đặt tên

  const TransactionCard({super.key, required this.transaction});

  String _mapLoaiTin(int loai) {
    switch (loai) {
      case 1:
        return 'Tin thường';
      case 2:
        return 'Tin VIP 3';
      case 3:
        return 'Tin VIP 2';
      case 4:
        return 'Tin VIP 1';
      default:
        return 'Tin Nổi bật';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Mã giao dịch:', transaction.id.toString()),
          _buildInfoRowWidget(
              'Loại:', FormatFunction.formatPostType(transaction.loai)),
          _buildInfoRow(
              'Tổng tiền:',
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                  .format(transaction.tien),
              isAmount: true),
          _buildInfoRow('Mã tin đăng:', '#${transaction.phongId.toString()}'),
          _buildInfoRow(
            'Ngày tạo:',
            DateFormat('dd-MM-yyyy HH:mm:ss').format(transaction.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isAmount ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWidget(String label, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }
}
