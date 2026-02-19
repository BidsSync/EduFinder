import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double size;
  final Color borderColor;
  final double radius;

  const SocialLoginButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.size = 46,
    this.radius = 10,
    this.borderColor = const Color(0xFFE1E1E1),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: size * 0.55,
            height: size * 0.55,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
