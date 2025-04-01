import 'package:flutter/material.dart';
import '/theme.dart';

class ButtonPrimary extends StatelessWidget {
  final String textLogin;
  final String textSignUp;
  final VoidCallback onTapLogin;
  final VoidCallback onTapSignUp;

  const ButtonPrimary({
    super.key,
    required this.textLogin,
    required this.textSignUp,
    required this.onTapLogin,
    required this.onTapSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onTapLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: pinkColor, // Nền nút Login.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            fixedSize: Size(MediaQuery.of(context).size.width - 100, 50),
          ),
          child: Text(
            textLogin,
            style: mediumTextStyle.copyWith(
              color: insideColorIconOnColor, // Màu chữ Login.
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onTapSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: iconSquareColor, // Nền nút Sign Up.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            fixedSize: Size(MediaQuery.of(context).size.width - 100, 50),
          ),
          child: Text(
            textSignUp,
            style: mediumTextStyle.copyWith(
              color: insideIconInactiveColor, // Màu chữ Sign Up.
            ),
          ),
        ),
      ],
    );
  }
}
