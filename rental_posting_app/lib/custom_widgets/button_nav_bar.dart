import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add),
          label: 'Đăng tin',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Đăng xuất',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.app_registration),
          label: 'Profile',
        ),
      ],
    );
  }
}
