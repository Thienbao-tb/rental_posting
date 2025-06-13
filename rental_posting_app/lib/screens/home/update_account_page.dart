import 'package:flutter/material.dart';

class UpdateAccountPage extends StatelessWidget {
  const UpdateAccountPage({super.key});

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
        title: const Text('Cập nhật tài khoản'),
      ),
      body: Container(
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
                  child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Mã thành viên:'),
              initialValue: '#21',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              initialValue: '0977555434',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Họ và tên'),
              initialValue: 'Nguyễn Hoàng Thiên Bảo',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: 'thienbao1212003@gmail.com',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật thành công!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cập nhật'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
