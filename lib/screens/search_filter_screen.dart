import 'package:flutter/material.dart';

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

  final List<String> _schoolTypes = [
    'Primary',
    'Secondary',
    'Boarding',
    'Private',
    'Grammar',
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
    // In a real app, you would filter the list or api call here.
    // For now, we just pop back with the filter criteria or show a message.
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Search...')),
      );
      Navigator.pop(context, {
        'type': _selectedType,
        'address': _addressController.text,
        'course': _courseController.text,
        'fee': _feeController.text,
      });
    }
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('School Type'),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 20),
              
              _buildSectionTitle('Location / Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _addressController,
                hint: 'Enter city, postcode, or area',
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
                hint: 'e.g., 15000',
                icon: Icons.currency_pound,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _performSearch,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF729C46), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Search Schools',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
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
            'Select School Type',
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}
