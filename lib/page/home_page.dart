import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../model/Product.dart';
import '../services/ auth_service.dart';
import '../theme.dart';
import '../widget/custom_app_bar.dart';
import '../widget/banner_ad.dart';
import '../widget/product_category.dart';
import '../widget/bottom_navigation_bar.dart';
import '../page/product_detail_page.dart';
import '../page/user_profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'order_confirmation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> recentProducts = [];
  late List<Map<String, dynamic>> categoriesWithId = [];
  bool isLoading = true;
  bool hasError = false;

  final String apiUrl = "http://10.17.19.43:5244/api";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedCategories = await fetchCategories();
      final icons = [
        {"icon": Icons.sports_tennis, "name": "Vợt"},
        {"icon": Icons.sports_baseball, "name": "Bóng"},
        {"icon": Icons.backpack, "name": "Phụ kiện"},
        {"icon": Icons.checkroom, "name": "Quần áo"},
        {"icon": Icons.dashboard, "name": "Tất cả"},
      ];

      categoriesWithId = icons.map((icon) {
        final categoryFromApi = fetchedCategories.firstWhere(
              (category) => category['name'] == icon['name'],
          orElse: () => {"id": null},
        );
        return {
          "icon": icon['icon'],
          "name": icon['name'],
          "id": categoryFromApi['id'],
        };
      }).toList();

      recentProducts = await fetchProduct();
    } catch (e) {
      hasError = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    return await fetchApi("http://10.17.19.43:5244/api/Category");
  }

  Future<List<Product>> fetchProduct() async {
    final List<Map<String, dynamic>> productsJson = await fetchApi("http://10.17.19.43:5244/api/Product");
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchApi(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse("http://10.17.19.43:5244/api/Product/get-by-category?categoryId=$categoryId"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> productsJson = jsonData['data'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserProfilePage()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }
  }

  void onCategorySelected(int categoryId, String categoryName) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (categoryId == 0) {
        final allProducts = await fetchProduct();
        setState(() {
          recentProducts = allProducts;
          isLoading = false;
        });
      } else {
        final productsByCategory = await fetchProductsByCategory(categoryId);
        setState(() {
          recentProducts = productsByCategory;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addToCart(int productId) async {
    try {
      final String accessToken = await AuthService().getAccessToken();
      final response = await http.post(
        Uri.parse('http://10.17.19.43:5244/api/Cart/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"quantity": 1, "productId": productId}),
      );

      if (response.statusCode == 200) {
        showErrorSnackBar("Sản phẩm đã được thêm vào giỏ hàng!");
      } else {
        showErrorSnackBar("Lỗi khi thêm sản phẩm: ${response.body}");
      }
    } catch (e) {
      showErrorSnackBar("Có lỗi xảy ra: $e");
    }
  }

  void onBuyNow(int productId) async {
    // Use 'orElse' to provide a fallback product in case of no match
    final selectedProduct = recentProducts.firstWhere(
          (product) => product.id == productId,
      orElse: () => Product(id: -1, name: 'Unknown', price: 0, image: ''), // Fallback Product
    );

    // Check if the selected product is a valid one (not the fallback)
    if (selectedProduct.id != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            orderedProducts: [
              {
                "id" : selectedProduct.id,
                'title': selectedProduct.name,
                'image': selectedProduct.image,
                'price': selectedProduct.price,
                'quantity': 1
              }
            ],
            totalAmount: selectedProduct.price,
            isFromHomePage: true,
          ),
        ),
      );
    } else {
      // Handle case where the product was not found (fallback case)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text('Failed to load data'))
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const BannerAd().animate().fadeIn(duration: 700.ms),
                const SizedBox(height: 20),
                ProductCategory(
                  categories: categoriesWithId,
                  onCategorySelected: onCategorySelected,
                ).animate().slideX(
                  duration: 800.ms,
                  begin: 1.0,
                  curve: Curves.easeOut,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.55,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = recentProducts[index];
                  return _buildProductItem(product);
                },
                childCount: recentProducts.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ).animate().scaleXY(begin: 0.7, end: 1.0, duration: 400.ms),
              const SizedBox(height: 10),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                product.price.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(product.id);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: pinkColor, // Màu nền
                        foregroundColor: whiteColor,
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onBuyNow(product.id);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Icon(
                        Icons.payment,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
