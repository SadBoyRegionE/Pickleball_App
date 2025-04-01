import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color pinkColor = const Color(0xFFF4B5A4);
Color whiteColor = const Color(0xFFFFFFFF);
Color blackColor = const Color(0xFF363130);
Color insideColorIconOnColor = const Color(0xFFCC7861);
Color insideIconInactiveColor = const Color(0xFFDCBEB6);
Color iconSquareColor = const Color(0xFFFAF0E6);
Color darkModeIconSquareColor = const Color(0xFF4B4544);

TextStyle lightTextStyle =
    GoogleFonts.firaSans().copyWith(fontWeight: FontWeight.w300);
TextStyle regularTextStyle =
    GoogleFonts.firaSans().copyWith(fontWeight: FontWeight.w400);
TextStyle mediumTextStyle =
    GoogleFonts.firaSans().copyWith(fontWeight: FontWeight.w500);
TextStyle boldTextStyle =
    GoogleFonts.firaSans().copyWith(fontWeight: FontWeight.w700);

ThemeData appTheme = ThemeData(
  primaryColor: pinkColor,
  colorScheme: ColorScheme.light(
    primary: pinkColor,
    secondary: insideColorIconOnColor,
  ),
  textTheme: TextTheme(
    bodyLarge: regularTextStyle,
    bodyMedium: lightTextStyle,
    displayLarge: boldTextStyle,
    displayMedium: mediumTextStyle,
  ),
  iconTheme: IconThemeData(color: insideIconInactiveColor),
  scaffoldBackgroundColor: whiteColor,
);
