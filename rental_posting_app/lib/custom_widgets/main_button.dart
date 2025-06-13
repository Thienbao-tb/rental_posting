import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color; // Thêm tham số color

  const MainButton({
    required this.label,
    this.onPressed,
    this.color = Colors.red, // Mặc định màu đỏ nếu không truyền tham số
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // Flutter sẽ tự disable nếu null
      style: TextButton.styleFrom(
        backgroundColor: color, // Dùng màu từ tham số
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 12, color: Colors.white)),
    );
  }
}
