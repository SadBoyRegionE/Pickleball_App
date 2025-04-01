import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import thư viện

import '../services/ auth_service.dart';
import '../theme.dart';
import '../widget/bottom_navigation_bar.dart';
import '../page/home_page.dart';
import '../page/transaction_history_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _authService = AuthService(); // Khai báo AuthService instance
  bool _isLoggedIn = false; // Trạng thái đăng nhập
  UserProfile? _profile;    // Thông tin user profile sau khi đăng nhập
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }// Mục mặc định là Tài khoản
  void _checkLoginStatus() async {
    final profile = await _authService.init();
    if (profile != null) {
      setState(() {
        _isLoggedIn = true;
        _profile = profile;
      });
    }
  }
  // Hàm đăng nhập
  void _login() async {
    final profile = await _authService.login();
    if (profile != null) {
      setState(() {
        _isLoggedIn = true;
        _profile = profile;
      });
    }
  }
  void signup() async {
    final navigator = Navigator.of(context);
    await AuthService.instance.signup();
    navigator.pop();
    navigator.pushReplacement(MaterialPageRoute(
        builder: (context) =>
        const HomePage()));
  }
  void logout() async {
    final navigator = Navigator.of(context);
    await AuthService.instance.logout();
    navigator.pop();
    navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }


  // Hàm chuyển trang khi nhấn vào item trong bottom navigation
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Điều hướng trang
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoggedIn ? "Thông tin người dùng" : "Yêu cầu đăng nhập",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: whiteColor,
          ),
        ),
        backgroundColor: pinkColor,
        centerTitle: true,
      ),
      body: _isLoggedIn ? _buildUserProfile() : _buildLoginPrompt(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Giao diện khi người dùng đã đăng nhập
  Widget _buildUserProfile() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Avatar người dùng với hiệu ứng scale và fade
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_profile!.pictureUrl.toString() ?? ''),
                backgroundColor: Colors.grey,
              )
                  .animate()
                  .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms)
                  .fadeIn(duration: 500.ms),
            ),
            const SizedBox(height: 20),

            // Tên người dùng với hiệu ứng fadeIn
            Center(
              child: Text(
                ' ${_profile!.name ?? 'Chưa có tên'}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms),
            ),
            const SizedBox(height: 5),

            // Email với hiệu ứng fadeIn
            Center(
              child: Text(
                ' ${_profile!.email ?? 'Chưa có email'}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ).animate().fadeIn(duration: 500.ms),
            ),
            const SizedBox(height: 20),

            const Divider(),
            Text(
              "Thông tin cá nhân",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87,
              ),
            )
                .animate()
                .slide(
                begin: const Offset(-1, 0),
                end: const Offset(0, 0),
                duration: 500.ms)
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 10),

            _buildInfoTile(Icons.phone, "Số điện thoại",'SĐT: ${_profile!.phoneNumber ?? 'Chưa có email'}'),
            _buildInfoTile(Icons.location_on, "Địa chỉ",'ĐC: ${_profile!.address?? 'Không có địa chỉ'}'),
            _buildInfoTile(Icons.calendar_today, "Ngày sinh", 'Date: ${_profile!.birthdate ?? 'Chưa cập nhật ngày sinh'}'),

            const Divider(),
            Text(
              "Cài đặt",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87,
              ),
            )
                .animate()
                .slide(
                begin: const Offset(-1, 0),
                end: const Offset(0, 0),
                duration: 500.ms)
                .fadeIn(duration: 500.ms),
            const SizedBox(height: 10),

            _buildSettingTile(Icons.monetization_on, "Lịch sử thanh toán", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  TransactionHistoryPage()),
              );
            }),
            _buildSettingTile(Icons.exit_to_app, "Đăng xuất", logout),
          ],
        ),
      ),
    );
  }

  // Giao diện yêu cầu đăng nhập
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
            ),
            child: Text(
              "Đăng nhập",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16), // Khoảng cách giữa 2 nút
          ElevatedButton(
            onPressed: signup, // Hàm xử lý đăng ký
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Màu sắc của nút đăng ký
            ),
            child: Text(
              "Đăng ký",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Tile thông tin người dùng
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: pinkColor),
      title: Text(title),
      subtitle: Text(subtitle),
    )
        .animate()
        .slide(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
        duration: 500.ms)
        .fadeIn(duration: 500.ms);
  }

  // Tile cài đặt
  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: pinkColor),
      title: Text(title),
      onTap: onTap,
    )
        .animate()
        .slide(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
        duration: 500.ms)
        .fadeIn(duration: 500.ms);
  }
}
