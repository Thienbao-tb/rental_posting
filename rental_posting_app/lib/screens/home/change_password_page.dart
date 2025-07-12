import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isOldPassVisible = false;
  bool _isNewPassVisible = false;
  bool _isConfirmPassVisible = false;

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';

    final hasUpper = RegExp(r'[A-Z]');
    final hasLower = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

    if (!hasUpper.hasMatch(value)) return 'Phải có ít nhất 1 chữ in hoa';
    if (!hasLower.hasMatch(value)) return 'Phải có ít nhất 1 chữ thường';
    if (!hasDigit.hasMatch(value)) return 'Phải có ít nhất 1 số';
    if (!hasSpecial.hasMatch(value)) return 'Phải có ít nhất 1 ký tự đặc biệt';

    return null;
  }

  void _onUpdatePressed() async {
    if (_formKey.currentState!.validate()) {
      final oldPass = _oldPassController.text.trim();
      final newPass = _newPassController.text.trim();
      final confirmPass = _confirmPassController.text.trim();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.changePassword(
        currentPassword: oldPass,
        newPassword: newPass,
        newPasswordConfirmation: confirmPass,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message'] ?? 'Đổi mật khẩu thành công!')),
        );
        Navigator.pop(context);
      } else {
        final errors = result['errors'] as Map<String, dynamic>?;

        String errorMsg = result['message'] ?? 'Đổi mật khẩu thất bại';
        if (errors != null) {
          if (errors.containsKey('current_password')) {
            errorMsg = errors['current_password'][0];
          } else if (errors.containsKey('new_password')) {
            errorMsg = errors['new_password'][0];
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Đổi mật khẩu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Mật khẩu cũ
              TextFormField(
                controller: _oldPassController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu cũ',
                  suffixIcon: IconButton(
                    icon: Icon(_isOldPassVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isOldPassVisible = !_isOldPassVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isOldPassVisible,
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập mật khẩu cũ'
                    : null,
              ),
              // Mật khẩu mới
              TextFormField(
                controller: _newPassController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(_isNewPassVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isNewPassVisible = !_isNewPassVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isNewPassVisible,
                validator: _validatePassword,
              ),
              // Nhập lại mật khẩu mới
              TextFormField(
                controller: _confirmPassController,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPassVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isConfirmPassVisible = !_isConfirmPassVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPassVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu';
                  }
                  if (value != _newPassController.text) {
                    return 'Mật khẩu nhập lại không khớp';
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
      ),
    );
  }
}
