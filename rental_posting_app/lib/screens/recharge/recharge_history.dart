import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/models/recharge_history_model.dart';

import '../../providers/recharge_provider.dart';

class LichSuNapTien extends StatefulWidget {
  const LichSuNapTien({super.key});

  @override
  State<LichSuNapTien> createState() => _LichSuNapTienState();
}

class _LichSuNapTienState extends State<LichSuNapTien> {
  @override
  void initState() {
    super.initState();
    // Gọi sau frame đầu tiên để tránh lỗi context chưa sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RechargeProvider>().fetchRechargeHistory();
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
                    'Lịch sử nạp tiền',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<RechargeProvider>(
                builder: (context, rechargeProvider, child) {
                  if (rechargeProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = rechargeProvider.history;

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không có lịch sử nạp tiền',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionCard(transaction: transaction);
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
  final RechargeHistory transaction;

  const TransactionCard({super.key, required this.transaction});

  String _mapLoaiToText(int loai) {
    switch (loai) {
      case 1:
        return 'Tiền mặt';
      case 2:
        return 'Chuyển khoản';
      case 3:
        return 'Internet Banking';
      default:
        return 'Khác';
    }
  }

  String _mapTrangThaiToText(int trangthai) {
    switch (trangthai) {
      case 1:
        return 'Khởi tạo';
      case 2:
        return 'Hoàn thành';
      case -1:
        return 'Đã huỷ';
      case -2:
        return 'Lỗi';
      default:
        return 'Khác';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(label: 'Mã giao dịch: ', value: transaction.ma),
            InfoRow(
                label: 'Hình thức: ', value: _mapLoaiToText(transaction.loai)),
            InfoRow(
                label: 'Trạng thái: ',
                value: _mapTrangThaiToText(transaction.trangthai)),
            InfoRow(
                label: 'Khuyến mãi: ',
                value: NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                    .format(transaction.giamgia)),
            InfoRow(
                label: 'Số tiền: ',
                value: NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                    .format(transaction.tien)),
            InfoRow(
                label: 'Tổng tiền: ',
                value: NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                    .format(transaction.tongtien),
                valueColor: Colors.red),
            InfoRow(
              label: 'Ngày tạo: ',
              value: DateFormat('dd-MM-yyyy HH:mm:ss')
                  .format(transaction.createdAt),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
