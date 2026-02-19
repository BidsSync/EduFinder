import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OnboardingTemplate(
      imagePath: 'assets/images/onb1.png',
      title: 'Discover Top Schools Easily',
      subtitle: 'Search schools by location, rating,\nand type.',
    );
  }
}

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OnboardingTemplate(
      imagePath: 'assets/images/onb2.png',
      title: 'Compare Schools',
      subtitle: 'Make informed decisions with\nOfsted data.',
    );
  }
}

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OnboardingTemplate(
      imagePath: 'assets/images/onb3.png',
      title: 'Explore Schools Nearby',
      subtitle: 'Use the map to find the best\noptions close to you.',
    );
  }
}

class _OnboardingTemplate extends StatelessWidget {
  const _OnboardingTemplate({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 430,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 430,
                  color: const Color(0xFFF3F4F6),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 72,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF48688A),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF7B7B7B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
