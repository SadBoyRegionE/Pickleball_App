import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart'; // Thêm thư viện Salomon Bottom Bar
import '../theme.dart'; // Import file theme

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration:
          const Duration(milliseconds: 300), // Thời gian chuyển động mượt mà
      child: SalomonBottomBar(
        key: ValueKey<int>(
            currentIndex), // Đảm bảo rằng hiệu ứng chuyển đổi xảy ra mỗi khi chỉ mục thay đổi
        currentIndex: currentIndex, // Chỉ mục mục hiện tại
        onTap: onTap, // Gọi hàm xử lý khi mục được nhấn
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            selectedColor: insideColorIconOnColor, // Màu khi được chọn
            unselectedColor: darkModeIconSquareColor, // Màu khi không được chọn
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Tài khoản'),
            selectedColor: insideColorIconOnColor, // Màu khi được chọn
            unselectedColor: darkModeIconSquareColor, // Màu khi không được chọn
          ),
        ],
      ),
    );
  }
}
