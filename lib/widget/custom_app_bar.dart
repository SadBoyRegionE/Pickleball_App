import 'package:flutter/material.dart';
import '../theme.dart'; // Import file theme để sử dụng các màu
import '../page/cart_page.dart'; // Import trang giỏ hàng
import '../page/search_history_page.dart'; // Import trang tìm kiếm

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: pinkColor, // Màu nền AppBar
      elevation: 2, // Thêm một chút bóng
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery address",
            style: TextStyle(
              fontSize: 12, // Giảm kích thước chữ
              color: whiteColor.withOpacity(0.7), // Màu chữ xám nhạt
              fontWeight: FontWeight.w500, // Thay đổi trọng số chữ
            ),
          ),
          Row(
            children: [
              Text(
                "Salatiga City",
                style: TextStyle(
                  fontSize: 18, // Tăng kích thước chữ
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                ),
              ),
              const SizedBox(width: 5), // Thêm khoảng cách giữa chữ và icon
              Icon(
                Icons.keyboard_arrow_down, // Icon mũi tên xuống
                color: whiteColor,
                size: 20,
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Biểu tượng tìm kiếm
        Padding(
          padding: const EdgeInsets.only(right: 1), // Giảm khoảng cách bên phải
          child: IconButton(
            icon: Icon(
              Icons.search, // Biểu tượng tìm kiếm
              color: whiteColor,
              size: 28, // Tăng kích thước biểu tượng
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SearchHistoryPage()), // Chuyển đến SearchHistoryPage
              );
            },
          ),
        ),
        // Thêm khoảng cách giữa biểu tượng tìm kiếm và giỏ hàng
        const SizedBox(width: 2), // Thêm khoảng cách giữa hai biểu tượng
        // Biểu tượng giỏ hàng
        Padding(
          padding:
              const EdgeInsets.only(right: 1.0), // Thêm khoảng cách bên phải
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined, // Biểu tượng giỏ hàng
              color: whiteColor,
              size: 28, // Tăng kích thước biểu tượng
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartPage()), // Chuyển đến CartPage
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
