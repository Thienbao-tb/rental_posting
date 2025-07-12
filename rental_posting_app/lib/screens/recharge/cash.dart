import 'package:flutter/material.dart';
import 'package:rental_posting_app/config/format_function.dart';

class TienMat extends StatelessWidget {
  const TienMat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            FormatFunction.buildCustomAppBar(
                title: 'Tiền mặt',
                onPressed: () {
                  Navigator.pop(context);
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentInfoCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // Light yellow background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thanh toán tại văn phòng công ty:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8A6E00), // Dark yellow/brown text
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8A6E00), // Dark yellow/brown text
              ),
              children: [
                TextSpan(
                  text: 'Bạn vui lòng đến địa chỉ văn phòng công ty ',
                ),
                TextSpan(
                  text: 'TBN Hostel ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      'theo địa chỉ sau: 188 Nguyễn Văn Cừ, Ninh Kiều, Cần Thơ.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8A6E00), // Dark yellow/brown text
              ),
              children: [
                TextSpan(
                  text: 'Số điện thoại: ',
                ),
                TextSpan(
                  text: '0949083414.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8A6E00), // Dark yellow/brown text
              ),
              children: [
                TextSpan(
                  text: 'Thu tiền tận nơi: ',
                ),
                TextSpan(
                  text: 'Áp dụng cho khu vực ',
                ),
                TextSpan(
                  text: 'Tp Cần Thơ ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'và số tiền thanh toán lớn hơn ',
                ),
                TextSpan(
                  text: '500.000đ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8A6E00), // Dark yellow/brown text
              ),
              children: [
                TextSpan(
                  text: 'Liên hệ: ',
                ),
                TextSpan(
                  text: '0949083414 ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'để chúng tôi hỗ trợ bạn.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Xin cảm ơn!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A6E00), // Dark yellow/brown text
            ),
          ),
        ],
      ),
    );
  }
}
