import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/mock_schools.dart';
import 'school_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  School? _selectedSchool;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // UK centre
  static const LatLng _ukCenter = LatLng(54.5, -3.5);

  List<School> get _filteredSchools {
    if (_searchQuery.isEmpty) return mockUkSchools;
    final q = _searchQuery.toLowerCase();
    return mockUkSchools.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.city.toLowerCase().contains(q) ||
          s.type.toLowerCase().contains(q) ||
          s.course.toLowerCase().contains(q);
    }).toList();
  }

  static const Map<String, Color> _typeColors = {
    'Boarding': Color(0xFFE63946),
    'Secondary': Color(0xFF457B9D),
    'Private': Color(0xFF6A4C93),
    'Grammar': Color(0xFF2A9D8F),
    'Independent': Color(0xFFE76F51),
    'Primary': Color(0xFFFFB703),
  };

  Color _typeColor(String type) =>
      _typeColors[type] ?? const Color(0xFF729C46);

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _flyToSchool(School school) {
    _mapController.move(LatLng(school.lat, school.lng), 12.0);
    setState(() => _selectedSchool = school);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EAEC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EAEC),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: Color(0xFF9AA0A6), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search city, type, course...',
                                hintStyle: TextStyle(
                                    color: Color(0xFF9AA0A6), fontSize: 14),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(Icons.close,
                                  size: 16, color: Color(0xFF9AA0A6)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Map ───────────────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _ukCenter,
                      initialZoom: 5.8,
                      minZoom: 4,
                      maxZoom: 18,
                    ),
                    children: [
                      // OpenStreetMap tile layer — completely free, no API key
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.edufindr',
                      ),

                      // School markers
                      MarkerLayer(
                        markers: _filteredSchools.map((school) {
                          final isSelected = _selectedSchool?.id == school.id;
                          final color = _typeColor(school.type);
                          return Marker(
                            point: LatLng(school.lat, school.lng),
                            width: isSelected ? 180 : 36,
                            height: isSelected ? 56 : 36,
                            child: GestureDetector(
                              onTap: () => _flyToSchool(school),
                              child: isSelected
                                  ? _SelectedMarker(school: school, color: color)
                                  : _PinMarker(color: color),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // School count badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF729C46),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6)
                        ],
                      ),
                      child: Text(
                        '${_filteredSchools.length} Schools',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Legend
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('School Types',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A4A4A))),
                          const SizedBox(height: 6),
                          ..._typeColors.entries.map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: e.value,
                                          shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(e.key,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF4A4A4A))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),

                  // Attribution (required by OpenStreetMap terms)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      color: Colors.white70,
                      child: const Text(
                        '© OpenStreetMap contributors',
                        style: TextStyle(fontSize: 9, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom panel ─────────────────────────────────────────────
            if (_selectedSchool != null)
              _buildSelectedCard(_selectedSchool!)
            else
              _buildSchoolList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCard(School school) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _typeColor(school.type).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.school,
                    color: _typeColor(school.type), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(school.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D))),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: Color(0xFF9AA0A6)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(school.address,
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF9AA0A6)),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close,
                    size: 18, color: Color(0xFF9AA0A6)),
                onPressed: () => setState(() => _selectedSchool = null),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _chip(Icons.star, school.rating.toStringAsFixed(1),
                  const Color(0xFFFFB703)),
              const SizedBox(width: 8),
              _chip(Icons.category_outlined, school.type,
                  _typeColor(school.type)),
              const SizedBox(width: 8),
              _chip(
                Icons.currency_pound,
                school.feeRate == 0
                    ? 'Free'
                    : '£${(school.feeRate / 1000).toStringAsFixed(0)}k/yr',
                const Color(0xFF5D8BB5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SchoolDetailScreen(school: school)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF729C46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('View Full Details',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSchoolList() {
    final schools = _filteredSchools;
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(maxHeight: 210),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Text(
              'Tap a pin on the map or browse below',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: schools.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 56),
              itemBuilder: (context, i) {
                final s = schools[i];
                return ListTile(
                  dense: true,
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: _typeColor(s.type).withOpacity(0.15),
                        shape: BoxShape.circle),
                    child: Icon(Icons.school,
                        size: 18, color: _typeColor(s.type)),
                  ),
                  title: Text(s.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${s.city} · ${s.type} · ${s.feeRate == 0 ? 'Free' : '£${(s.feeRate / 1000).toStringAsFixed(0)}k/yr'}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9AA0A6)),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 12, color: Color(0xFF9AA0A6)),
                  onTap: () => _flyToSchool(s),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Marker widgets ─────────────────────────────────────────────────────────

class _PinMarker extends StatelessWidget {
  final Color color;
  const _PinMarker({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: const Icon(Icons.school, color: Colors.white, size: 14),
        ),
        // Pin tail
        CustomPaint(
          size: const Size(10, 6),
          painter: _PinTailPainter(color: color),
        ),
      ],
    );
  }
}

class _SelectedMarker extends StatelessWidget {
  final School school;
  final Color color;
  const _SelectedMarker({required this.school, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school, color: Colors.white, size: 14),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  school.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(10, 6),
          painter: _PinTailPainter(color: color),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color;
}
