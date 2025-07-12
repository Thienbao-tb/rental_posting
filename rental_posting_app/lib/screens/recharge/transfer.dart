import 'package:flutter/material.dart';

import '../../config/format_function.dart';

class ChuyenKhoan extends StatelessWidget {
  const ChuyenKhoan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FormatFunction.buildCustomAppBar(
                title: 'Chuyển khoản',
                onPressed: () {
                  Navigator.pop(context);
                }),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Warning message card
                      _buildWarningCard(),
                      const SizedBox(height: 16),

                      // First bank card - Vietcombank
                      _buildBankCard(
                        bankName: 'VIETCOMBANK',
                        bankFullName:
                            'NGÂN HÀNG THƯƠNG MẠI CỔ PHẦN NGOẠI THƯƠNG VIỆT NAM',
                        branchName: 'Chi nhánh TP.CẦN THƠ',
                        accountNumber: '12345678',
                        accountHolder: 'VŨ TUẤN ANH',
                        transferNote: 'PTCT - 104768/0999 - 0949083414',
                        isHighlighted: false,
                      ),

                      const SizedBox(height: 16),

                      // Second bank card - BIDV
                      _buildBankCard(
                        bankName: 'BIDV',
                        bankFullName: 'NGÂN HÀNG ĐẦU TƯ VÀ PHÁT TRIỂN VIỆT NAM',
                        branchName: 'Chi nhánh TP CẦN THƠ',
                        accountNumber: '12345678',
                        accountHolder: 'VŨ TUẤN ANH',
                        transferNote: 'PTCT - 104768/0999 - 0949083414',
                        isHighlighted: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFFF3CD), // Light yellow background
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lưu ý quan trọng:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff856404),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '- Nội dung chuyển tiền bên vui lòng ghi đúng thông tin sau:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff856404),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '"PTCT - 104768 - 0949083414"',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xffFF0000),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Trong đó 104768 là mã thanh viên, 0949083414 là số điện thoại của bạn đăng ký trên ứng dụng canthohost!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff856404),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Xin cảm ơn!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff856404),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard({
    required String bankName,
    required String bankFullName,
    required String branchName,
    required String accountNumber,
    required String accountHolder,
    required String transferNote,
    required bool isHighlighted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            isHighlighted ? const Color(0xFFE3F2FD) : const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank name header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  isHighlighted ? Colors.blue.shade100 : Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Ngân hàng:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  bankName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Bank details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankFullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Chi nhánh:', branchName),
                const SizedBox(height: 8),
                _buildInfoRow('Số tài khoản:', accountNumber),
                const SizedBox(height: 8),
                _buildInfoRow('Chủ tài khoản:', accountHolder),
                const SizedBox(height: 12),

                // Transfer note
                const Text(
                  'Nội dung chuyển khoản:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Text(
                    transferNote,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
