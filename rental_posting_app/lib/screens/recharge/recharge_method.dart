import 'package:flutter/material.dart';

import 'cash.dart';
import 'internet_banking.dart';
import 'transfer.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Tiền mặt', 'icon': Icons.money},
    {'name': 'Chuyển khoản', 'icon': Icons.account_balance},
    {'name': 'Thẻ ATM Internet Banking', 'icon': Icons.credit_card},
  ];

  Widget _buildPaymentMethodTile(
      String method, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        onPressed: () {
          setState(() {
            _selectedMethod = method;
          });
          if (method == 'Tiền mặt') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TienMat()),
            );
          } else if (method == 'Chuyển khoản') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChuyenKhoan()),
            );
          } else if (method == 'Thẻ ATM Internet Banking') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BankingScreen()),
            );
          }
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    'Phương thức nạp tiền',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  children: paymentMethods.map((method) {
                    return _buildPaymentMethodTile(
                      method['name'],
                      method['icon'],
                      _selectedMethod == method['name'],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
