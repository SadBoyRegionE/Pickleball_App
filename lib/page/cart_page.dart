import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../services/ auth_service.dart';
import '../theme.dart';
import 'order_confirmation_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartProducts = [];
  bool isLoading = true;
  bool isError = false;

  final String apiUrl = "http://10.17.19.43:5244/api/Cart";

  // Lấy token từ một dịch vụ hoặc hard-code tạm thời
  Future<String> _getToken() async {
    try {
      // Sử dụng AuthService để lấy access token
      final String token = await AuthService().getAccessToken();
      return token;
    } catch (e) {
      print("Lỗi khi lấy token: $e");
      throw Exception('Không thể lấy token');
    }
  }

  // Gọi API để lấy dữ liệu giỏ hàng
  Future<void> _fetchCart() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> products = jsonResponse['data'] ?? [];

        // Lấy thông tin sản phẩm chi tiết từ endpoint /api/Product/{id}
        for (var product in products) {
          final productId = product['productId'];

          // Fetch thông tin sản phẩm dựa trên productId
          final productResponse = await http.get(
            Uri.parse('http://10.17.19.43:5244/api/Product/$productId'),
          );

          if (productResponse.statusCode == 200) {
            final productData = json.decode(productResponse.body)['data'];
            // Cập nhật thông tin image, title và thêm originalPrice vào giỏ hàng
            product['image'] = productData['image'];
            product['title'] = productData['name'];
            product['originalPrice'] = productData['price']; // Thêm originalPrice
          }
        }

        setState(() {
          cartProducts = products.map((product) => Map<String, dynamic>.from(product)).toList();
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
        throw Exception("Failed to fetch cart");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print("Error fetching cart: $e");
    }
  }

  // Gọi API để xóa sản phẩm khỏi giỏ hàng
  Future<void> _deleteCartItem(int productId) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$apiUrl/$productId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          cartProducts.removeWhere((item) => item['productId'] == productId);
        });
      } else {
        throw Exception("Failed to delete cart item");
      }
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  // Gọi API để cập nhật số lượng sản phẩm
  Future<void> _updateQuantity(int productId, int quantity) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$apiUrl/update-quantity'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({"productId": productId, "quantity": quantity}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final product = cartProducts.firstWhere(
                  (item) => item['productId'] == productId,
              orElse: () => {});
          if (product.isNotEmpty) {
            product['quantity'] = quantity;
          }
        });
      } else {
        throw Exception("Failed to update quantity");
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  String formatCurrency(int value) {
    return '${NumberFormat('#,###', 'vi').format(value)} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giỏ Hàng',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: whiteColor,
          ),
        ),
        backgroundColor: pinkColor,
        centerTitle: true,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: whiteColor),
            onPressed: () async {
              for (var product in cartProducts) {
                await _deleteCartItem(product['productId']);
              }
              setState(() {
                cartProducts.clear();
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return _buildCartItem(
                  image: product['image'],
                  title: product['title'],
                  price: product['originalPrice'], // Sử dụng originalPrice
                  quantity: product['quantity'],
                  onRemove: () async {
                    await _deleteCartItem(product['productId']);
                  },
                  onIncrease: () async {
                    await _updateQuantity(product['productId'],
                        product['quantity'] + 1);
                  },
                  onDecrease: () async {
                    if (product['quantity'] > 1) {
                      await _updateQuantity(product['productId'],
                          product['quantity'] - 1);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng số tiền',
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                ),
                Text(
                  formatCurrency(cartProducts.fold(
                      0,
                          (sum, item) =>
                      sum +
                          (item['originalPrice'] as int) *
                              (item['quantity'] as int))), // Dùng originalPrice
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w700,
                    color: insideColorIconOnColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  final int totalAmount = cartProducts.fold(
                    0,
                        (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationPage(
                        orderedProducts: cartProducts,
                        totalAmount: totalAmount,
                        isFromHomePage: false,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  shadowColor: Colors.black26,
                  elevation: 6,
                ),
                child: Center(
                  child: Text(
                    'Thanh toán',
                    style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                  ),
                ),
              )
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String image,
    required String title,
    required int price,
    required int quantity,
    required VoidCallback onRemove,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatCurrency(price),
                          style: GoogleFonts.firaSans(
                            fontWeight: FontWeight.w600,
                            color: insideColorIconOnColor,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: onDecrease,
                              icon: Icon(Icons.remove_circle,
                                  color: insideIconInactiveColor),
                            ),
                            Text(
                              '$quantity',
                              style: GoogleFonts.firaSans(
                                fontWeight: FontWeight.w500,
                                color: blackColor,
                              ),
                            ),
                            IconButton(
                              onPressed: onIncrease,
                              icon: Icon(Icons.add_circle,
                                  color: insideColorIconOnColor),
                            ),
                            IconButton(
                              onPressed: onRemove,
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
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
