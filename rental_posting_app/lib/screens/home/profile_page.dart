import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/config/format_function.dart';
import 'package:rental_posting_app/providers/auth_provider.dart';
import 'package:rental_posting_app/screens/auth/login_screen.dart';

import '../../providers/recharge_provider.dart';
import '../payment/payment_history.dart';
import '../price/price_table.dart';
import '../recharge/recharge_history.dart';
import '../recharge/recharge_method.dart';
import 'change_password_page.dart';
import 'tin_da_dang.dart';
import 'update_account_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Thông tin người dùng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            FormatFunction.buildAvatarUrl(
                                user?.anhdaidien ?? '')),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user!.ten,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Số dư khả dụng: ${FormatFunction.formatPrice(user.sodukhadung.toString())}',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 32),
                      ListTile(
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Cập nhật tài khoản'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UpdateAccountPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Đổi mật khẩu'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.payment),
                        title: const Text('Nạp tiền'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PaymentMethodScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('Lịch sử nạp tiền'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LichSuNapTien()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.receipt),
                        title: const Text('Lịch sử thanh toán'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LichSuThanhToan()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.post_add),
                        title: const Text('Tin đã đăng'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TinDaDang()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.price_check),
                        title: const Text('Bảng giá'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BangGiaScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Đăng xuất'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.read<RechargeProvider>().clearHistory();
                          context.read<AuthProvider>().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
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
}
