import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../services/ auth_service.dart';
import '../theme.dart';
import 'bill_details_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List<Map<String, dynamic>> transactionHistory = [];

  @override
  void initState() {
    super.initState();
    fetchTransactionHistory();
  }

  Future<void> fetchTransactionHistory() async {
    try {
      final token = await AuthService.instance.getAccessToken();
      final response = await http.get(
        Uri.parse('http://10.17.19.43:5244/api/Order'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            transactionHistory = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      } else {
        throw Exception('Failed to load transaction history');
      }
    } catch (e) {
      print('Error fetching transaction history: $e');
    }
  }

  String formatCurrency(num value) {
    return '${NumberFormat('#,###', 'vi').format(value)} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử thanh toán',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: transactionHistory.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: transactionHistory.length,
          itemBuilder: (context, index) {
            final transaction = transactionHistory[index];

            return GestureDetector(
                onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillDetailsPage(
                    orderId: transaction['id'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: pinkColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Hóa đơn số : ${transaction['id']}',
                        style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Địa chỉ: ${transaction['address']}',
                        style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: blackColor,
                        ),
                      ),
                      subtitle: Text(
                        'Ghi chú: ${transaction['note'] ?? "Không có"}',
                        style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: Text(
                        formatCurrency(transaction['totalAmount']),
                        style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}
