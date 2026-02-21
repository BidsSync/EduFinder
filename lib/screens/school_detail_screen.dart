import 'package:flutter/material.dart';
import '../data/mock_schools.dart';

class SchoolDetailScreen extends StatelessWidget {
  final School school;

  const SchoolDetailScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EAEC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF729C46),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A7C2F), Color(0xFF98BF32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        school.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating + Type badges
                  Row(
                    children: [
                      _badge(
                        icon: Icons.star,
                        label: school.rating.toStringAsFixed(1),
                        color: const Color(0xFFFFB703),
                      ),
                      const SizedBox(width: 10),
                      _badge(
                        icon: Icons.category_outlined,
                        label: school.type,
                        color: const Color(0xFF729C46),
                      ),
                      const SizedBox(width: 10),
                      _badge(
                        icon: Icons.location_city,
                        label: school.city,
                        color: const Color(0xFF5D8BB5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Description
                  _infoCard(
                    title: 'About',
                    child: Text(
                      school.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address
                  _infoCard(
                    title: 'Address',
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF729C46), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            school.address,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Course
                  _infoCard(
                    title: 'Courses Offered',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: school.course.split(',').map((c) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF729C46).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF729C46).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            c.trim(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4A7C2F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fee Rate
                  _infoCard(
                    title: 'Annual Fee',
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: school.feeRate == 0
                                ? Colors.green.withOpacity(0.1)
                                : const Color(0xFF729C46).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            school.feeRate == 0
                                ? Icons.check_circle_outline
                                : Icons.currency_pound,
                            color: school.feeRate == 0
                                ? Colors.green
                                : const Color(0xFF729C46),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              school.feeRate == 0
                                  ? 'Free (State School)'
                                  : '£${school.feeRate.toStringAsFixed(0)} / year',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: school.feeRate == 0
                                    ? Colors.green[700]
                                    : const Color(0xFF2D2D2D),
                              ),
                            ),
                            if (school.feeRate > 0)
                              Text(
                                '≈ £${(school.feeRate / 12).toStringAsFixed(0)} per month',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9AA0A6),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Contact / Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Apply to ${school.name} - feature coming soon!'),
                            backgroundColor: const Color(0xFF729C46),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        'Apply / Enquire',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF729C46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9AA0A6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
