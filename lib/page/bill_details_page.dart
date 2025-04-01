import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class BillDetailsPage extends StatefulWidget {
  final int orderId;

  const BillDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _BillDetailsPageState createState() => _BillDetailsPageState();
}

class _BillDetailsPageState extends State<BillDetailsPage> {
  late Future<List<Map<String, dynamic>>> orderDetails;

  // Hàm để gọi API và lấy dữ liệu chi tiết hóa đơn
  Future<List<Map<String, dynamic>>> fetchOrderDetails(int orderId) async {
    final String apiUrl = 'http://10.17.19.43:5244/api/OrderDetail?orderId=$orderId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Chuyển đổi dữ liệu từ API thành danh sách các sản phẩm
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Lấy chi tiết đơn hàng thất bại');
      }
    } else {
      throw Exception('Lỗi kết nối API');
    }
  }

  Future<String> fetchProductImage(int productId) async {
    final String apiUrl = 'http://10.17.19.43:5244/api/Product/$productId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Trả về đường dẫn hình ảnh của sản phẩm
        return data['data']['image'] ?? '';  // Assuming the image is in 'data' field
      } else {
        throw Exception('Không tìm thấy ảnh sản phẩm');
      }
    } else {
      throw Exception('Lỗi kết nối API');
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi API khi trang được khởi tạo
    orderDetails = fetchOrderDetails(widget.orderId);
  }

  String formatCurrency(int value) {
    return '${NumberFormat('#,###', 'vi').format(value)} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết hóa đơn',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w700,
            color: whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: pinkColor,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Gọi FutureBuilder để lấy dữ liệu chi tiết đơn hàng
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có sản phẩm trong hóa đơn.'));
          } else {
            final products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Danh sách sản phẩm
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return FutureBuilder<String>(  // Sử dụng FutureBuilder để tải hình ảnh
                          future: fetchProductImage(product['productId']),  // Lấy hình ảnh từ API
                          builder: (context, imageSnapshot) {
                            if (imageSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();  // Hiển thị khi đang tải ảnh
                            } else if (imageSnapshot.hasError) {
                              return Text('Lỗi tải ảnh');
                            } else {
                              final imageUrl = imageSnapshot.data ?? '';
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,  // Hiển thị hình ảnh lấy từ API
                                      fit: BoxFit.cover,
                                    ).animate().fadeIn(duration: 300.ms),
                                  ),
                                  title: Text(
                                    product['productName'],
                                    style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: blackColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Số lượng: ${product['quantity']}',
                                    style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: Text(
                                    formatCurrency(product['amount']),
                                    style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: pinkColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  // Tổng cộng
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Tổng cộng: ${formatCurrency(products.fold<int>(0, (sum, product) => sum + (product['amount'] as int)))}',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
