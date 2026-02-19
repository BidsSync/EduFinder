import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 180,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/splashscreenlogo.jpeg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
