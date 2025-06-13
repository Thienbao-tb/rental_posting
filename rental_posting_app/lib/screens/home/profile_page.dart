import 'package:flutter/material.dart';

import '../blog/blog_list_screen.dart';
import 'change_password_page.dart';
import 'tin_da_dang.dart';
import 'update_account_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Thông tin người dùng'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/img1.jpg'),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.teal,
                    child:
                        Icon(Icons.camera_alt, size: 15, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thiên Bảo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'thienbao1212003@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Số dư khả dụng: 12.000.000đ',
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
                        builder: (context) => const UpdateAccountPage()),
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
                        builder: (context) => const ChangePasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Nạp tiền'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const PaymentMethodScreen()),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Lịch sử nạp tiền'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const LichSuNapTien()),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt),
                title: const Text('Lịch sử thanh toán'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const LichSuThanhToan()),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text('Tin đăng'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TinDaDang()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Bài viết'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BlogListScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.price_check),
                title: const Text('Bảng giá'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const BangGiaScreen()),
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Đăng xuất'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
