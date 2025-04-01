import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Thực hiện hành động tìm kiếm trực tiếp trên trang chủ
        showSearch(
          context: context,
          delegate: SearchDelegateExample(), // Gọi SearchDelegate để tìm kiếm
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Căn lề
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Màu nền của thanh tìm kiếm
            borderRadius: BorderRadius.circular(10), // Bo góc
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.search,
                  color: Colors.grey, // Màu biểu tượng
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "Tìm kiếm...", // Placeholder
                style: TextStyle(
                  color: Colors.grey[600], // Màu chữ placeholder
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tạo một lớp SearchDelegate để xử lý tìm kiếm
class SearchDelegateExample extends SearchDelegate {
  final List<String> searchResults = [
    "Sản phẩm 1",
    "Sản phẩm 2",
    "Sản phẩm 3",
    "Sản phẩm 4",
  ]; // Thay thế danh sách này bằng dữ liệu thực tế

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ""; // Xóa truy vấn
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng tìm kiếm
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Hiển thị kết quả tìm kiếm
    final results = searchResults
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            // Thực hiện hành động khi nhấn vào kết quả
            close(context, results[index]); // Đóng tìm kiếm
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Hiển thị gợi ý tìm kiếm
    final suggestions = searchResults
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            // Thực hiện hành động khi nhấn vào gợi ý
            query = suggestions[index];
            showResults(context); // Hiển thị kết quả tìm kiếm
          },
        );
      },
    );
  }
}
