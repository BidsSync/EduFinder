import 'package:flutter/material.dart';
import '../data/mock_schools.dart';
import 'school_detail_screen.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _courseController = TextEditingController();
  final _feeController = TextEditingController();
  String? _selectedType;
  List<School>? _results;
  bool _hasSearched = false;

  final List<String> _schoolTypes = [
    'Primary',
    'Secondary',
    'Boarding',
    'Private',
    'Grammar',
    'Independent',
    'Special Needs',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _courseController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _hasSearched = true;
      _results = _filterSchools();
    });
  }

  List<School> _filterSchools() {
    return mockUkSchools.where((school) {
      // Filter by type
      if (_selectedType != null && _selectedType!.isNotEmpty) {
        if (!school.type.toLowerCase().contains(_selectedType!.toLowerCase())) {
          return false;
        }
      }

      // Filter by address/city
      final address = _addressController.text.trim().toLowerCase();
      if (address.isNotEmpty) {
        if (!school.address.toLowerCase().contains(address) &&
            !school.city.toLowerCase().contains(address)) {
          return false;
        }
      }

      // Filter by course
      final course = _courseController.text.trim().toLowerCase();
      if (course.isNotEmpty) {
        if (!school.course.toLowerCase().contains(course)) {
          return false;
        }
      }

      // Filter by max fee
      final feeText = _feeController.text.trim();
      if (feeText.isNotEmpty) {
        final maxFee = double.tryParse(feeText);
        if (maxFee != null && school.feeRate > maxFee) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearAll() {
    setState(() {
      _selectedType = null;
      _addressController.clear();
      _courseController.clear();
      _feeController.clear();
      _results = null;
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EAEC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Your School',
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_hasSearched)
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'Clear',
                style: TextStyle(color: Color(0xFF729C46)),
              ),
            ),
        ],
      ),
      body: _hasSearched ? _buildResultsView() : _buildFilterForm(),
    );
  }

  Widget _buildFilterForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero banner
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A7C2F), Color(0xFF98BF32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.travel_explore, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Search UK Schools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tell us what you\'re looking for and we\'ll find the best match.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('School Type'),
            const SizedBox(height: 8),
            _buildDropdown(),
            const SizedBox(height: 20),

            _buildSectionTitle('Location / Address'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _addressController,
              hint: 'Enter city, postcode, or area (e.g. London)',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Course / Curriculum'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _courseController,
              hint: 'e.g., A-Levels, IB, GCSE',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Max Annual Fee (£)'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _feeController,
              hint: 'e.g., 20000  (leave blank for any fee)',
              icon: Icons.currency_pound,
              keyboardType: TextInputType.number,
              required: false,
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: _performSearch,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Search Schools',
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
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    final results = _results ?? [];
    return Column(
      children: [
        // Summary bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF729C46),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${results.length} Schools Found',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(() {
                  _hasSearched = false;
                  _results = null;
                }),
                icon: const Icon(Icons.tune, size: 16, color: Color(0xFF729C46)),
                label: const Text(
                  'Edit Search',
                  style: TextStyle(color: Color(0xFF729C46), fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // Applied filters chips
        if (_selectedType != null ||
            _addressController.text.isNotEmpty ||
            _courseController.text.isNotEmpty ||
            _feeController.text.isNotEmpty)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (_selectedType != null)
                  _filterChip('Type: $_selectedType'),
                if (_addressController.text.isNotEmpty)
                  _filterChip('Area: ${_addressController.text}'),
                if (_courseController.text.isNotEmpty)
                  _filterChip('Course: ${_courseController.text}'),
                if (_feeController.text.isNotEmpty)
                  _filterChip('Max Fee: £${_feeController.text}'),
              ],
            ),
          ),

        const SizedBox(height: 8),

        // Results
        Expanded(
          child: results.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: results.length,
                  itemBuilder: (context, i) => _SchoolResultCard(school: results[i]),
                ),
        ),
      ],
    );
  }

  Widget _filterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF729C46).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF729C46).withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF4A7C2F),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No schools match your criteria',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try broadening your search filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() {
              _hasSearched = false;
              _results = null;
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF729C46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Modify Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D2D2D),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          hint: const Text(
            'Select School Type (optional)',
            style: TextStyle(color: Color(0xFF9AA0A6)),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF729C46)),
          items: _schoolTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedType = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9AA0A6)),
          icon: Icon(icon, color: const Color(0xFF729C46), size: 20),
        ),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              }
            : null,
      ),
    );
  }
}

// School result card widget
class _SchoolResultCard extends StatelessWidget {
  final School school;
  const _SchoolResultCard({required this.school});

  static const Map<String, Color> _typeColors = {
    'Boarding': Color(0xFFE63946),
    'Secondary': Color(0xFF457B9D),
    'Private': Color(0xFF6A4C93),
    'Grammar': Color(0xFF2A9D8F),
    'Independent': Color(0xFFE76F51),
    'Primary': Color(0xFFFFB703),
  };

  Color get _typeColor => _typeColors[school.type] ?? const Color(0xFF729C46);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SchoolDetailScreen(school: school)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
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
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.school, color: _typeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        school.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${school.city} · ${school.address}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF9AA0A6)),
              ],
            ),
            const SizedBox(height: 12),
            // Info row
            Row(
              children: [
                _chip(Icons.star, school.rating.toStringAsFixed(1), const Color(0xFFFFB703)),
                const SizedBox(width: 8),
                _chip(Icons.category_outlined, school.type, _typeColor),
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
            const SizedBox(height: 10),
            // Courses
            Text(
              '📚 ${school.course}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
