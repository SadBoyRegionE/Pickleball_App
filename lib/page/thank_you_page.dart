import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cảm Ơn',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: pinkColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(55.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thank you animation (Lottie animation or static image)
                Lottie.asset(
                  'assets/animation/Foxhello.json',
                  height: 150,
                ),
                const SizedBox(height: 24),
                Text(
                  'Cảm ơn bạn đã đặt hàng!',
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Button "Về trang chủ"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    'Về Trang Chủ',
                    style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Button "Xem Chi Tiết Đơn Hàng"
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    side: BorderSide(color: pinkColor),
                  ),
                  onPressed: () {
                    // Navigate to order details page (implement navigation logic)
                  },
                  child: Text(
                    'Xem Chi Tiết Đơn Hàng',
                    style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.w500,
                      color: pinkColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
