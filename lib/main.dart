import 'package:flutter/material.dart';
import 'page/splass_screen.dart';
import 'page/home_page.dart';
import 'page/user_profile_page.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash to Login',
      theme: ThemeData(
        primaryColor: pinkColor,
        appBarTheme: AppBarTheme(
          backgroundColor: pinkColor,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=> const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/user': (context) => const UserProfilePage(),
      },
    );
  }
}
