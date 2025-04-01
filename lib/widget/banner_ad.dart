import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class BannerAd extends StatelessWidget {
  const BannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'assets/Banner/banner1.png',
      'assets/Banner/banner2.png',
      'assets/Banner/banner3.png',
      'assets/Banner/banner1.png',
      'assets/Banner/banner2.png',
      'assets/Banner/banner3.png',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FlutterCarousel(
        // Các tùy chọn cho carousel
        options: FlutterCarouselOptions(
          height: 150, // Chiều cao của carousel
          autoPlay: true, // Tự động chuyển slide
          autoPlayInterval: const Duration(seconds: 5), // Thời gian giữa các slide
          enlargeCenterPage: true, // Phóng to slide ở giữa
          viewportFraction: 0.8, // Tỉ lệ kích thước slide
          showIndicator: false, // Hiển thị chỉ mục
        ),
        items: bannerImages.map((image) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12), // Bo góc banner
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Image.asset(
                image,
                fit: BoxFit.cover, // Co giãn ảnh để lấp đầy
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
