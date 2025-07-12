import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/format_function.dart';
import '../../providers/auth_provider.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({super.key});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  File? _pickedImage;

  late String oldTen;
  late String oldEmail;
  late String oldSdt;
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    oldTen = user?.ten ?? '';
    oldEmail = user?.email ?? '';
    oldSdt = user?.sodienthoai ?? '';
    _tenController.text = oldTen;
    _emailController.text = oldEmail;
    _sdtController.text = oldSdt;
  }

  @override
  void dispose() {
    _tenController.dispose();
    _emailController.dispose();
    _sdtController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chọn ảnh đại diện',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Chọn từ thư viện'),
              onTap: () async {
                final picked =
                    await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() {
                    _pickedImage = File(picked.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Chụp ảnh'),
              onTap: () async {
                final picked =
                    await picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() {
                    _pickedImage = File(picked.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdatePressed() async {
    if (!_formKey.currentState!.validate()) return; // 👈 Check form is valid

    final newTen = _tenController.text.trim();
    final newEmail = _emailController.text.trim();
    final newSdt = _sdtController.text.trim();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.updateUserInfo(
      ten: newTen,
      email: newEmail,
      sodienthoai: newSdt,
      avatarFile: _pickedImage,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!')),
      );
    } else {
      int errorCount = (result['errors'] as Map).length;

      if (errorCount == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email và số điện thoại đã tồn tại!!!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (errorCount == 1 && result['errors'].containsKey('email')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Email đã tồn tại !!!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[400],
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (errorCount == 1 &&
          result['errors'].containsKey('sodienthoai')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Số điện thoại đã tồn tại !!!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[400],
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

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
                    'Cập nhật tài khoản',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : NetworkImage(
                                    FormatFunction.buildAvatarUrl(
                                        user?.anhdaidien ?? ''),
                                  ) as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.teal,
                                child: Icon(Icons.camera_alt,
                                    size: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Mã thành viên:'),
                        initialValue: '#${user?.id.toString()}',
                        readOnly: true,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Số điện thoại'),
                        controller: _sdtController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          final phoneRegExp = RegExp(r'^\d{10}$');
                          if (!phoneRegExp.hasMatch(value)) {
                            return 'Số điện thoại phải gồm đúng 10 chữ số';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Họ và tên'),
                        controller: _tenController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập họ và tên';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _onUpdatePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
