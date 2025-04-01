import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/ auth_service.dart';
import 'thank_you_page.dart';

class OrderConfirmationPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderedProducts;
  final int totalAmount;
  final bool isFromHomePage; // Thêm cờ xác định nguồn

  OrderConfirmationPage({
    required this.orderedProducts,
    required this.totalAmount,
    required this.isFromHomePage,
  });

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ giao hàng',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.orderedProducts.length,
                itemBuilder: (context, index) {
                  final product = widget.orderedProducts[index];
                  return ListTile(
                    leading: Image.network(product['image']),
                    title: Text(product['title']),
                    subtitle: Text('Số lượng: ${product['quantity']}'),
                    trailing: Text('${product['price']} VND'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Tổng cộng: ${widget.totalAmount} VND',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_addressController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Thông báo'),
                      content: const Text('Vui lòng nhập địa chỉ giao hàng.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                final String address = _addressController.text;
                final String note = _noteController.text;

                try {
                  final String token = await _getToken();

                  http.Response response;

                  if (widget.isFromHomePage) {
                    // Thanh toán một sản phẩm từ HomePage
                    final product = widget.orderedProducts.first;
                    response = await http.post(
                      Uri.parse('http://10.17.19.43:5244/api/Order/create-order1'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: json.encode({
                        'address': address,
                        'note': note,
                        'productId': product['id'],
                        'quantity': product['quantity'],
                      }),
                    );
                  } else {
                    // Thanh toán giỏ hàng
                    response = await http.post(
                      Uri.parse('http://10.17.19.43:5244/api/Order'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: json.encode({
                        'address': address,
                        'note': note,
                      }),
                    );
                  }

                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThankYouPage(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Lỗi'),
                        content: Text('Không thể đặt hàng: ${response.reasonPhrase}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Lỗi'),
                      content: Text('Đã xảy ra lỗi: $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}