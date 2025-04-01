import 'package:flutter/material.dart';

class GeneralLogoSpace extends StatelessWidget {
  final Widget? child;

  const GeneralLogoSpace(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.asset(
            "assets/pages/logo2.png",
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 20),
          child ?? const SizedBox(),
        ],
      ),
    );
  }
}
