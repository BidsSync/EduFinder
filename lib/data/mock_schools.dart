class School {
  final String id;
  final String name;
  final String type; // e.g., Primary, Secondary, Boarding
  final String address;
  final String course;
  final double feeRate; // Annual fee in GBP
  final double lat;
  final double lng;
  final double rating;

  const School({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.course,
    required this.feeRate,
    required this.lat,
    required this.lng,
    required this.rating,
  });
}

const List<School> mockUkSchools = [
  School(
    id: '1',
    name: 'Eton College',
    type: 'Boarding',
    address: 'Windsor, Berkshire, SL4 6DW',
    course: 'A-Levels, GCSE',
    feeRate: 46000,
    lat: 51.492,
    lng: -0.608,
    rating: 4.8,
  ),
  School(
    id: '2',
    name: 'Harrow School',
    type: 'Boarding',
    address: '5 High St, Harrow HA1 3HP',
    course: 'A-Levels, GCSE',
    feeRate: 45000,
    lat: 51.572,
    lng: -0.333,
    rating: 4.7,
  ),
  School(
    id: '3',
    name: 'St Paul\'s School',
    type: 'Secondary',
    address: 'Lonsdale Rd, London SW13 9JT',
    course: 'IB, A-Levels',
    feeRate: 30000,
    lat: 51.488,
    lng: -0.239,
    rating: 4.9,
  ),
  School(
    id: '4',
    name: 'Westminster School',
    type: 'Private',
    address: '17 Dean\'s Yard, London SW1P 3PB',
    course: 'A-Levels',
    feeRate: 34000,
    lat: 51.499,
    lng: -0.128,
    rating: 4.8,
  ),
  School(
    id: '5',
    name: 'Manchester Grammar',
    type: 'Grammar',
    address: 'Old Hall Ln, Manchester M13 0XT',
    course: 'GCSE, A-Levels',
    feeRate: 14000,
    lat: 53.447,
    lng: -2.217,
    rating: 4.6,
  ),
];
