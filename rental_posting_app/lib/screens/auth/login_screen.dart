import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/screens/auth/forgot_password_screen.dart';
import 'package:rental_posting_app/screens/auth/register_screen.dart';

import '../../custom_widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../home/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    print(
        "Chuẩn bị gọi login với email: ${_emailController.text.trim()}, password: ${_passwordController.text}");
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 40),
                  // Title
                  Text(
                    'ĐĂNG NHẬP TÀI KHOẢN',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  // Subtitle
                  // const Text(
                  //   'Đăng nhập vào Tài khoản của bạn để Tiếp tục sử dụng dịch vụ.',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.black54,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 32),
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Mật Khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Remember Me and Forgot Password Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Nhớ mật khẩu',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()));
                        },
                        child: Text('Quên mật khẩu?',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator()
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                    width: 8), // khoảng cách giữa chữ và icon
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Divider with "Hoặc tiếp tục với"
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Hoặc tiếp tục với',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Google and Apple Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Logic đăng nhập bằng Google
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Đăng nhập bằng Google chưa được triển khai!')),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/google_icon.png',
                          // Thay bằng đường dẫn icon Google
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          // Logic đăng nhập bằng Apple
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Đăng nhập bằng Apple chưa được triển khai!')),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/apple_icon.png',
                          // Thay bằng đường dẫn icon Apple
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn đã chưa có tài khoản? ',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: Text(
                          'Đăng Ký',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
