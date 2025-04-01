import 'package:flutter/material.dart';
import '../theme.dart'; // Import file theme

class ProductCategory extends StatelessWidget {
  final List<Map<String, dynamic>> categories; // Định nghĩa tham số categories
  final Function(int, String) onCategorySelected; // Cập nhật kiểu của callback

  const ProductCategory({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          // Kiểm tra nếu là mục "Tất cả"
          final categoryId = categories[index]["name"] == "Tất cả" ? 0 : categories[index]["id"];
          return CategoryItem(
            icon: categories[index]["icon"],
            name: categories[index]["name"],
            categoryId: categoryId,  // Truyền categoryId cho mục "Tất cả" là 0
            onCategorySelected: onCategorySelected,
          );
        },
      )
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final int categoryId;
  final Function(int, String) onCategorySelected;

  const CategoryItem({
    required this.icon,
    required this.name,
    required this.categoryId,
    required this.onCategorySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCategorySelected(categoryId, name);  // Truyền categoryId là 0 cho "Tất cả"
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: pinkColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: whiteColor,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

